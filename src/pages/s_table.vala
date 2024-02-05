/* atbash.vala
 *
 * Copyright 2023 Alexander Svobodov
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

using Encryption;
using Encryption.Magma;

[GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/s_table.ui")]
public class GCiphers.STable : Adw.Bin {

    [GtkChild]
    private unowned UI.TextView text_view;

    [GtkCallback]
    private void on_encrypt_click (Gtk.Button self) {
        var win = (GCiphers.Window) this.get_root ();
        try {
            var text = text_view.get_text_buffer ();
            if (win.prettify.get_state ()) {
                validate (text.text);
                var buffer = convert_to_uint8 (text.text, 4);
                string result = "";
                for (int i = 0; i <= buffer.length - 4; i += 4) {
                    var buffer_4 = buffer[i : i + 4];
                    var encoded = t (buffer_4);
                    var hex = bytes_to_hex (encoded);
                    result = @"$result$hex";
                }
                text.set_text (result);
            }
            else {
                validate_hex (text.text);
                var data = hex_to_bytes (text.text);
                var buffer = t (data);
                text.set_text (bytes_to_hex (buffer));
            }
        }
        catch (Error ex) {
            win.toaster (ex.message);
        }
    }

    [GtkCallback]
    private void on_decrypt_click (Gtk.Button self) {
        var win = (GCiphers.Window) this.get_root ();
        try {
            var text = text_view.get_text_buffer ();
            if (win.prettify.get_state ()) {
                validate_hex (text.text, false);
                var buffer = hex_to_bytes (text.text);
                for (int i = 0; i <= buffer.length - 4; i += 4) {
                    var buffer_4 = buffer[i : i + 4];
                    var decoded = t_reverse (buffer_4);
                    for (int j = i; j < i + 4; j++) {
                        buffer[j] = decoded[j - i];
                    }
                }
                text.set_text (convert_to_string (buffer));
            }
            else {
                validate_hex (text.text);
                var data = hex_to_bytes (text.text);
                var buffer = t_reverse (data);
                text.set_text (bytes_to_hex (buffer));
            }
        }
        catch (Error ex) {
            win.toaster (ex.message);
        }
    }
}
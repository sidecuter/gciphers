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
using Encryption.Atbash;

[GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/atbash.ui")]
public class GCiphers.Atbash : Adw.Bin {

    [GtkChild]
    private unowned UI.TextView text_view;

    [GtkCallback]
    private void on_encrypt_click (Gtk.Button self) {
        var win = (GCiphers.Window) this.get_root ();
        try {
            var text = text_view.get_text_buffer ();
            string letters = win.encode_text (text.text);
            validate (letters);
            text.set_text (encrypt (letters));
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
            string letters = text.text.down ().replace (" ", "");
            validate (letters);
            text.set_text (win.decode_text (encrypt (letters)));
        }
        catch (Error ex) {
            win.toaster (ex.message);
        }
    }
}

/* vigenereii.vala
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
using Encryption.VigenereII;

namespace GCiphers {
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/vigenereii.ui")]
    public class Vigenereii : Adw.Bin {

        [GtkChild]
        private unowned UI.TextView text_view;

        [GtkChild]
        private unowned UI.Entry key;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            var win = (GCiphers.Window) this.get_root ();
            try {
                var text = text_view.get_text_buffer ();
                string letters = win.encode_text (text.text);
                string key = key.get_buffer ().get_text ().down ();
                Alphabet alphabet = new Alphabet ();
                validate (letters, key);
                text.set_text (encrypt (alphabet, letters, key));
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
                string key = key.get_buffer ().get_text ().down ();
                Alphabet alphabet = new Alphabet ();
                validate (letters, key);
                text.set_text (win.decode_text (decrypt (alphabet, letters, key)));
            }
            catch (Error ex) {
                win.toaster (ex.message);
            }
        }
    }
}

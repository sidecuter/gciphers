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

namespace GCiphers {
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/atbash.ui")]
    public class Atbash : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        [GtkChild]
        private unowned UI.TextView text_view;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                var text = text_view.get_text_buffer ();
                string letters = text.text.down ()
                    .replace (" ", "")
                    //.replace (" ", "прб")
                    .replace (".", "тчк")
                    .replace (",", "зпт")
                    .replace ("-", "тире");
                Alphabet alphabet = new Alphabet ();
                Validate(alphabet, letters);
                text.set_text (Encryption.Atbash.encrypt (alphabet, letters));
            }
            catch (OOBError ex) {
                toast_spawner(ex.message);
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        [GtkCallback]
        private void on_decrypt_click (Gtk.Button self) {
            try {
                var text = text_view.get_text_buffer ();
                string letters = text.text.down ().replace (" ", "");
                Alphabet alphabet = new Alphabet ();
                Validate(alphabet, letters);
                text.set_text (Encryption.Atbash.encrypt (alphabet, letters)
                    .replace ("тчк", ".")
                    .replace ("зпт", ",")
                    .replace ("тире", "-")
                    .replace ("прб", " ")
                );
            }
            catch (OOBError ex) {
                toast_spawner(ex.message);
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        public Atbash (spawn_toast toaster) {
            toast_spawner = toaster;
        }

        private void Validate (Alphabet alphabet, string text) throws Errors.ValidateError {
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            Errors.validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    }
}

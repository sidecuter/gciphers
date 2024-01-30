/* caesar.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/caesar.ui")]
    public class Caesar : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        private unowned get_alphabet alphabet_getter;

        [GtkChild]
        private unowned UI.TextView text_view;

        [GtkChild]
        private unowned UI.Entry key;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                var text = text_view.get_text_buffer ();
                string letters = text.text.down ()
                    .replace (" ", "прб")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");
                string key = key.get_buffer ().get_text ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate(alphabet, letters, key);
                text.set_text (Encryption.Caesar.encrypt (alphabet, letters, int.parse (key)));
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
                string key = key.get_buffer ().get_text ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate(alphabet, letters, key);
                text.set_text (Encryption.Caesar.decrypt (alphabet, letters, int.parse (key))
                .replace ("тчк", ".")
                .replace ("зпт", ",")
                .replace ("тире", "-")
                .replace ("прб", " "));
            }
            catch (OOBError ex) {
                toast_spawner(ex.message);
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        public Caesar (spawn_toast toaster, get_alphabet alphabet_get) {
            toast_spawner = toaster;
            alphabet_getter = alphabet_get;
        }

        private void Validate (Alphabet alphabet, string text, string key) throws Errors.ValidateError {
            int num;
            if (key.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Key is empty"));
            if (!int.try_parse (key, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("Key is not a valid number"));
            if (num < 1) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("Number is below zero"));
            if (num + 1> alphabet.length) throw new Errors.ValidateError.INCORRECT_NUMBER (_("Number is bigger, than alphabet number"));
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            Errors.validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    }
}

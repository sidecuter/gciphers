/* belazo.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/playfair.ui")]
    public class Playfair : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        [GtkChild]
        private unowned UI.TextView text_view;

        [GtkChild]
        private unowned UI.Entry key;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                var text = text_view.get_text_buffer ();
                string letters = text.text.down ()
                    .replace (" ", "")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");
                string key = key.get_buffer ().get_text ().down ();
                Alphabet alphabet = new Alphabet ();
                Validate(alphabet, letters, key);
                text.set_text (Encryption.Playfair.encrypt (letters, key));
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
                string key = key.get_buffer ().get_text ().down ();
                Alphabet alphabet = new Alphabet ();
                Validate(alphabet, letters, key);
                if (letters.char_count () % 2 != 0) 
                    throw new Errors.ValidateError.WRONG_STRING_LENGTH(_("Length must be divisible by 2"));
                text.set_text (Encryption.Playfair.decrypt (letters, key));
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        public Playfair (spawn_toast toaster) {
            toast_spawner = toaster;
        }

        private void Validate (Alphabet alphabet, string text, string key) throws Errors.ValidateError {
            string playfair_alphabet = "абвгдежзиклмнопрстуфхцчшщъыэюя";
            var p_alphabet = new Alphabet.from_str (playfair_alphabet);
            if (key.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Key is empty"));
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            if (!Encryption.Playfair.validate_key (key))
                    throw new Errors.ValidateError.WRONG_STRING_LENGTH(_("Key must contain only unique letters"));
            Errors.validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
            Errors.validate_string (p_alphabet, text, _("No such letter from key in alphabet"));
        }
    }
}

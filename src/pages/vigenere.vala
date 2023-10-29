/* vigenere.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/vigenere.ui")]
    public class Vigenere : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        private unowned get_alphabet alphabet_getter;

        [GtkChild]
        private unowned Gtk.TextBuffer text;

        [GtkChild]
        private unowned Gtk.Entry key;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                string letters = text.text.down ()
                    .replace (" ", "")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");
                string key = key.get_buffer ().get_text ().down ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate(alphabet, letters, key);
                text.set_text (Encryption.Vigenere.encrypt (alphabet, letters, key));
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
                string letters = text.text.down ().replace (" ", "");
                string key = key.get_buffer ().get_text ().down ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate(alphabet, letters, key);
                text.set_text (Encryption.Vigenere.decrypt (alphabet, letters, key));
            }
            catch (OOBError ex) {
                toast_spawner(ex.message);
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        public Vigenere (spawn_toast toaster, get_alphabet alphabet_get) {
            toast_spawner = toaster;
            alphabet_getter = alphabet_get;
        }

        private void Validate (Alphabet alphabet, string text, string key) throws Errors.ValidateError {
            if (key.char_count () == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Key is empty"));
            if (key.char_count () > 1) throw new Errors.ValidateError.WRONG_STRING_LENGTH (_("Key length is bigger than 1"));
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            try {
                alphabet.get_letter_index (key.get_char (key.index_of_nth_char (0)));
            }
            catch (OOBError ex) {
                throw new Errors.ValidateError.LETTERS_NOT_IN_STRING (_("No such key letter in alphabet"));
            }
            for (long i = 0; i < text.char_count (); i++){
                try {
                    alphabet.get_letter_index (text.get_char (text.index_of_nth_char (i)));
                }
                catch (OOBError ex) {
                    throw new Errors.ValidateError.LETTERS_NOT_IN_STRING (_("No such phrase letter in alphabet"));
                }
            }
        }
    }
}

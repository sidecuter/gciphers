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

        [GtkChild]
        private unowned Gtk.TextBuffer text;

        [GtkChild]
        private unowned Gtk.Entry key;

        [GtkChild]
        private unowned Gtk.Button encrypt;

        [GtkChild]
        private unowned Gtk.Button decrypt;

        private unowned spawn_toast toast_spawner;

        public Caesar (spawn_toast toaster) {
            toast_spawner = toaster;
        }

        construct {
            this.encrypt.clicked.connect (e => {
                try {
                   string letters = text.text.down ()
                        .replace (" ", "")
                        .replace(".", "тчк")
                        .replace(",", "зпт")
                        .replace("-", "тире");;
                    string key = key.get_buffer ().get_text ();
                    Alphabets alphabets = new Alphabets ();
                    Alphabet alphabet = new Alphabet (alphabets.ru);
                    Validate(alphabet, letters, key);
                    text.set_text (Encryption.Caesar.encrypt (alphabet, letters, int.parse (key)));
                }
                catch (OOBError ex) {
                    toast_spawner(ex.message);
                }
                catch (Errors.ValidateError ex) {
                    toast_spawner(ex.message);
                }
            });

            this.decrypt.clicked.connect (e => {
                try {
                    string letters = text.text.down ().replace (" ", "");
                    string key = key.get_buffer ().get_text ();
                    Alphabets alphabets = new Alphabets ();
                    Alphabet alphabet = new Alphabet (alphabets.ru);
                    Validate(alphabet, letters, key);
                    text.set_text (Encryption.Caesar.decrypt (alphabet, letters, int.parse (key)));
                }
                catch (OOBError ex) {
                    toast_spawner(ex.message);
                }
                catch (Errors.ValidateError ex) {
                    toast_spawner(ex.message);
                }
            });
        }

        private void Validate (Alphabet alphabet, string text, string key) throws Errors.ValidateError {
            int num;
            if (key.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Key is empty"));
            if (!int.try_parse (key, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("Key is not a valid number"));
            if (num < 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("Number is below zero"));
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            for (long i = 0; i < text.char_count (); i++){
                try {
                    alphabet.get_letter_index (text.get_char (text.index_of_nth_char (i)));
                }
                catch (OOBError ex) {
                    throw new Errors.ValidateError.LETTERS_NOT_IN_STRING (_("No such letter in alphabet"));
                }
            }
        }
    }
}


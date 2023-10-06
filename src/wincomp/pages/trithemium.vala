/* trithemium.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/trithemium.ui")]
    public class Trithemium : Adw.Bin {

        private unowned Adw.ToastOverlay toast_overlay;

        [GtkChild]
        private unowned Gtk.Entry text;

        [GtkChild]
        private unowned Gtk.Button encrypt;

        [GtkChild]
        private unowned Gtk.Button decrypt;

        public Trithemium (Adw.ToastOverlay toast) {
            this.toast_overlay = toast;
        }

        construct {
            this.encrypt.clicked.connect (e => {
                try {
                    string letters = text.get_buffer ().get_text ().down ();
                    Alphabets alphabets = new Alphabets ();
                    Alphabet alphabet = new Alphabet (alphabets.ru);
                    Validate(alphabet, letters);
                    text.set_text (Encryption.Trithemium.encrypt (alphabet, letters));
                }
                catch (OOBError ex) {
                    Adw.Toast toast = new Adw.Toast (ex.message);
                    toast.set_timeout (timeout);
                    toast_overlay.add_toast (toast);
                }
                catch (Errors.ValidateError ex) {
                    Adw.Toast toast = new Adw.Toast (ex.message);
                    toast.set_timeout (timeout);
                    toast_overlay.add_toast (toast);
                }
            });

            this.decrypt.clicked.connect (e => {
                try {
                    string letters = text.get_buffer ().get_text ().down ();
                    Alphabets alphabets = new Alphabets ();
                    Alphabet alphabet = new Alphabet (alphabets.ru);
                    Validate(alphabet, letters);
                    text.set_text (Encryption.Trithemium.decrypt (alphabet, letters));
                }
                catch (OOBError ex) {
                    Adw.Toast toast = new Adw.Toast (ex.message);
                    toast.set_timeout (timeout);
                    toast_overlay.add_toast (toast);
                }
                catch (Errors.ValidateError ex) {
                    Adw.Toast toast = new Adw.Toast (ex.message);
                    toast.set_timeout (timeout);
                    toast_overlay.add_toast (toast);
                }
            });
        }

        private void Validate (Alphabet alphabet, string text) throws Errors.ValidateError {
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING ("Text field is empty");
            for (long i = 0; i < text.char_count (); i++){
                try {
                    alphabet.get_letter_index (text.get_char (text.index_of_nth_char (i)));
                }
                catch (OOBError ex) {
                    throw new Errors.ValidateError.LETTERS_NOT_IN_STRING ("No such letter in alphabet");
                }
            }
        }
    }
}
  
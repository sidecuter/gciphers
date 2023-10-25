/* shenon.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/shenon.ui")]
    public class Shenon : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        private unowned get_alphabet alphabet_getter;

        [GtkChild]
        private unowned Gtk.TextBuffer text;

        [GtkChild]
        private unowned Gtk.Entry t0;
        
        [GtkChild]
        private unowned Gtk.Entry a;
        
        [GtkChild]
        private unowned Gtk.Entry c;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                string letters = text.text.down ()
                    .replace (" ", "")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");;
                unowned string t0 = t0.get_buffer ().get_text ();
                unowned string a = a.get_buffer ().get_text ();
                unowned string c = c.get_buffer ().get_text ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate (alphabet, letters, t0, a, c);
                text.set_text (Encryption.Shenon.encrypt (alphabet, letters, int.parse (t0), int.parse (a), int.parse (c)));
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
                unowned string t0 = t0.get_buffer ().get_text ();
                unowned string a = a.get_buffer ().get_text ();
                unowned string c = c.get_buffer ().get_text ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate (alphabet, letters, t0, a, c);
                text.set_text (Encryption.Shenon.decrypt (alphabet, letters, int.parse (t0), int.parse (a), int.parse (c)));
            }
            catch (OOBError ex) {
                toast_spawner(ex.message);
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        public Shenon (spawn_toast toaster, get_alphabet alphabet_get) {
            toast_spawner = toaster;
            alphabet_getter = alphabet_get;
        }

        private void Validate (Alphabet alphabet, string text, string t0, string a, string c) throws Errors.ValidateError {
            int num;
            if (t0.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("T0 is empty"));
            if (!int.try_parse (t0, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("T0 is not a valid number"));
            if (num <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("T0 is below or equal zero"));
            if (a.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("A is empty"));
            if (!int.try_parse (a, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("A is not a valid number"));
            if (num <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("A is below or equal zero"));
            if (c.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("C is empty"));
            if (!int.try_parse (c, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("C is not a valid number"));
            if (num <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("C is below or equal zero"));
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


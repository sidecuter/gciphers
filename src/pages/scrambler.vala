/* scrambler.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/scrambler.ui")]
    public class Scrambler : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        private unowned get_alphabet alphabet_getter;

        [GtkChild]
        private unowned Gtk.TextBuffer text;

        [GtkChild]
        private unowned Gtk.Entry scrambler1;

        [GtkChild]
        private unowned Gtk.Entry scrambler2;
        
        [GtkChild]
        private unowned Gtk.Entry key1;

        [GtkChild]
        private unowned Gtk.Entry key2;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                string letters = text.text.down ()
                    .replace (" ", "")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");;
                unowned string scrambler1 = scrambler1.get_buffer ().get_text ();
                unowned string scrambler2 = scrambler2.get_buffer ().get_text ();
                unowned string key1 = key1.get_buffer ().get_text ();
                unowned string key2 = key2.get_buffer ().get_text ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate (alphabet, letters, scrambler1, scrambler2, key1, key2);
                text.set_text (Encryption.Scrambler.encrypt (
                    alphabet,
                    letters,
                    scrambler1,
                    scrambler2,
                    key1,
                    key2
                ));
             }
             catch (OOBError ex) {
                 toast_spawner(ex.message);
             }
             catch (Errors.ValidateError ex) {
                 toast_spawner(ex.message);
             }
        }

        public Scrambler (spawn_toast toaster, get_alphabet alphabet_get) {
            toast_spawner = toaster;
            alphabet_getter = alphabet_get;
        }

        private void Validate_bin (string text, string mes) throws Errors.ValidateError {
            unichar buffer;
            for (int i = 0; i < text.char_count (); i++) {
                buffer = text.get_char (text.index_of_nth_char (i));
                if (buffer != '0' && buffer != '1') throw new Errors.ValidateError.INCORRECT_NUMBER (mes);
            }
        }

        private void Validate (
            Alphabet alphabet,
            string text,
            string scrambler1,
            string scrambler2,
            string key1,
            string key2
        ) throws Errors.ValidateError {
            int num;
            if (scrambler1.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("First scrambler is empty"));
            if (!int.try_parse (scrambler1, out num))
                throw new Errors.ValidateError.NOT_NUMBER (_("First scrambler is not a valid number"));
            Validate_bin (scrambler1, _("First scrambler can contain only 1 or 0"));
            if (scrambler2.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Second scrambler is empty"));
            if (!int.try_parse (scrambler2, out num))
                throw new Errors.ValidateError.NOT_NUMBER (_("Second scrambler is not a valid number"));
            Validate_bin (scrambler2, _("Second scrambler can contain only 1 or 0"));
            if (key1.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("First key is empty"));
            if (!int.try_parse (key1, out num))
                throw new Errors.ValidateError.NOT_NUMBER (_("First key is not a valid number"));
            Validate_bin (key1, _("First key can contain only 1 or 0"));
            if (key2.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Second key is empty"));
            if (!int.try_parse (key2, out num))
                throw new Errors.ValidateError.NOT_NUMBER (_("Second key is not a valid number"));
            Validate_bin (key2, _("Second key can contain only 1 or 0"));
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

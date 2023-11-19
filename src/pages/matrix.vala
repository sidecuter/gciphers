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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/matrix.ui")]
    public class Matrix : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        private unowned get_alphabet alphabet_getter;

        private bool state;

        [GtkChild]
        private unowned Adw.Bin placeholder;

        [GtkChild]
        private unowned Gtk.TextBuffer text;

        [GtkChild]
        private unowned Gtk.Entry n;

        [GtkCallback]
        private void on_get_click (Gtk.Button self) {
            unowned string n = n.get_buffer ().get_text ();
            int parsed_n;
            try {
                parsed_n = Validate_n (n);
                placeholder.set_child (new GCiphers.MatrixGrid (parsed_n, parsed_n));
                state = true;
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                string letters = text.text.down ()
                    .replace (" ", "")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate (alphabet, letters);
                int rows;
                int columns;
                var items = parse_entries (
                    (GCiphers.MatrixGrid) placeholder.child,
                    out rows,
                    out columns
                );
                text.set_text (
                    Encryption.MatrixCipher.encrypt (
                        alphabet,
                        letters,
                        rows,
                        columns,
                        items
                    )
                );
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
                int rows;
                int columns;
                var items = parse_entries (
                    (GCiphers.MatrixGrid) placeholder.child,
                    out rows,
                    out columns
                );
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate_int(letters);
                text.set_text (
                    Encryption.MatrixCipher.decrypt (
                        alphabet,
                        letters,
                        rows,
                        columns,
                        items
                    )
                );
            }
            catch (OOBError ex) {
                toast_spawner(ex.message);
            }
            catch (Errors.ValidateError ex) {
                toast_spawner(ex.message);
            }
        }

        public Matrix (spawn_toast toaster, get_alphabet alphabet_get) {
            toast_spawner = toaster;
            alphabet_getter = alphabet_get;
            state = false;
        }

        private int Validate_n (string n) throws Errors.ValidateError {
            int num;
            if (n.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("n is empty"));
            if (!int.try_parse (n, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("n is not a valid number"));
            if (num <= 1) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("n is below or equal one"));
            return num;
        }

        private int[] parse_entries (GCiphers.MatrixGrid grid, out int rows, out int columns) throws Errors.ValidateError {
            rows = grid.rows;
            columns = grid.columns;
            int[] result = new int[rows * columns];
            int k = 0;
            int num;
            unowned string n;
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < columns; j++) {
                    n = grid.elements.get (k).get_buffer ().get_text ();
                    if (n.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("n is empty"));
                    if (!int.try_parse (n, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("n is not a valid number"));
                    result[i * columns + j] = num;
                    k++;
                }
            }
            return result;
        }

        private void Validate (Alphabet alphabet, string text) throws Errors.ValidateError {
            if (!state) throw new Errors.ValidateError.NOT_STATED (_("Matrix not determined"));
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

        private void Validate_int (string text) throws Errors.ValidateError {
            int num;
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            for (long i = 0; i < text.char_count (); i++){
                if (!int.try_parse (text.get_char(text.index_of_nth_char (i)).to_string (), out num))
                    throw new Errors.ValidateError.NOT_NUMBER (_("Phrase should be only consist of numbers"));
            }
        }
    }
}

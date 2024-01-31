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

        private bool state;

        [GtkChild]
        private unowned Adw.Bin placeholder;

        [GtkChild]
        private unowned UI.TextView text_view;

        [GtkChild]
        private unowned UI.Entry n;

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
                var text = text_view.get_text_buffer ();
                string letters = text.text.down ()
                    .replace (" ", "")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");
                Alphabet alphabet = new Alphabet ();
                Validate (alphabet, letters);
                int rows;
                int columns;
                var items = parse_entries (
                    (GCiphers.MatrixGrid) placeholder.child,
                    out rows,
                    out columns
                );
                text.set_text (
                    Encryption.Matrix.encrypt (
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
                var text = text_view.get_text_buffer ();
                string letters = text.text.down ().replace (" ", "");
                int rows;
                int columns;
                var items = parse_entries (
                    (GCiphers.MatrixGrid) placeholder.child,
                    out rows,
                    out columns
                );
                Alphabet alphabet = new Alphabet ();
                Validate_int(letters);
                text.set_text (
                    Encryption.Matrix.decrypt (
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

        public Matrix (spawn_toast toaster) {
            toast_spawner = toaster;
            state = false;
        }

        private int Validate_n (string n) throws Errors.ValidateError {
            int num;
            if (n.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("n is empty"));
            if (!int.try_parse (n, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("n is not a valid number"));
            if (num <= 1 || num > 10) throw new Errors.ValidateError.INCORRECT_NUMBER (_("n is below or equal one or greater than 10"));
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
            Errors.validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }

        private void Validate_int (string text) throws Errors.ValidateError {
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            Errors.validate_int (text, _("Phrase should be only consist of numbers"));
        }
    }
}

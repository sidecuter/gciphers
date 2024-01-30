/* polibius.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/polybius.ui")]
    public class Polybius : Adw.Bin {

        private unowned spawn_toast toast_spawner;

        private unowned get_alphabet alphabet_getter;

        [GtkChild]
        private unowned UI.TextView text_view;

        [GtkChild]
        private unowned UI.Entry rows;

        [GtkChild]
        private unowned UI.Entry columns;

        [GtkCallback]
        private void on_encrypt_click (Gtk.Button self) {
            try {
                var text = text_view.get_text_buffer ();
                string letters = text.text.down ()
                    //.replace (" ", "прб")
                    .replace(".", "тчк")
                    .replace(",", "зпт")
                    .replace("-", "тире");
                unowned string row = rows.get_buffer ().get_text ();
                unowned string column = columns.get_buffer ().get_text ();
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate_string(alphabet, letters, row, column);
                text.set_text (Encryption.Polybius.encrypt (alphabet, letters, int.parse (row), int.parse (column)));
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
                unowned string row = rows.get_buffer ().get_text ();
                unowned string column = columns.get_buffer ().get_text ();
                int row_int;
                int column_int;
                Alphabet alphabet = new Alphabet (alphabet_getter ());
                Validate_int(letters, row, column, out row_int, out column_int);
                text.set_text (Encryption.Polybius.decrypt (alphabet, letters, row_int, column_int)
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

        public Polybius (spawn_toast toaster, get_alphabet alphabet_get) {
            toast_spawner = toaster;
            alphabet_getter = alphabet_get;
        }

        private void Validate_string (Alphabet alphabet, string text, string rows, string columns) throws Errors.ValidateError {
            int num;
            if (rows.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Rows count is empty"));
            if (!int.try_parse (rows, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("Rows count is not a valid number"));
            if (num <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("Rows count is below or equal zero"));
            if (columns.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Columns count is empty"));
            if (!int.try_parse (columns, out num)) throw new Errors.ValidateError.NOT_NUMBER (_("Columns count is not a valid number"));
            if (num <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("Columns count is below or equal zero"));
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            Errors.validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }

        private void Validate_int (string text, string rows, string columns, out int row, out int column) throws Errors.ValidateError {
            int num;
            if (rows.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Rows count is empty"));
            if (!int.try_parse (rows, out row)) throw new Errors.ValidateError.NOT_NUMBER (_("Rows count is not a valid number"));
            if (row <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("Rows count is below or equal zero"));
            if (columns.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Columns count is empty"));
            if (!int.try_parse (columns, out column)) throw new Errors.ValidateError.NOT_NUMBER (_("Columns count is not a valid number"));
            if (column <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO (_("Columns count is below or equal zero"));
            if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING (_("Text field is empty"));
            int i = 0;
            unichar letter;
            while (text.get_next_char (ref i, out letter)) {
                if (!int.try_parse (letter.to_string (), out num))
                    throw new Errors.ValidateError.NOT_NUMBER (_("Phrase should be only consist of numbers"));
                if (i%2 == 0 && num > row)
                    throw new Errors.ValidateError.INCORRECT_NUMBER (_("Row in string cannot be bigger than table rows count"));
                if (i%2 == 1 && num > column)
                    throw new Errors.ValidateError.INCORRECT_NUMBER (_("Column in string cannot be bigger than table columns count"));
            }
        }
    }
}

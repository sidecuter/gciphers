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

[GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/polybius.ui")]
public class GCiphers.Polybius : Adw.Bin {

    private unowned Adw.ToastOverlay toast_overlay;

    [GtkChild]
    private unowned Gtk.Entry text;

    [GtkChild]
    private unowned Gtk.Entry rows;

    [GtkChild]
    private unowned Gtk.Entry columns;

    [GtkChild]
    private unowned Gtk.Button encrypt;

    [GtkChild]
    private unowned Gtk.Button decrypt;

    public Polybius (Adw.ToastOverlay toast) {
        this.toast_overlay = toast;
    }

    construct {
        this.encrypt.clicked.connect (e => {
            try {
                unowned string letters = text.get_buffer ().get_text ();
                unowned string row = rows.get_buffer ().get_text ();
                unowned string column = columns.get_buffer ().get_text ();
                Alphabets alphabets = new Alphabets ();
                Alphabet alphabet = new Alphabet (alphabets.ru);
                Validate_string(alphabet, letters.down (), row, column);
                text.set_text (Encryption.Polybius.encrypt (alphabet, letters.down (), int.parse (row), int.parse (column)));
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
                unowned string letters = text.get_buffer ().get_text ();
                unowned string row = rows.get_buffer ().get_text ();
                unowned string column = columns.get_buffer ().get_text ();
                int row_int;
                int column_int;
                Alphabets alphabets = new Alphabets ();
                Alphabet alphabet = new Alphabet (alphabets.ru);
                Validate_int(letters, row, column, out row_int, out column_int);
                text.set_text (Encryption.Polybius.decrypt (alphabet, letters, row_int, column_int));
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

    private void Validate_string (Alphabet alphabet, string text, string rows, string columns) throws Errors.ValidateError {
        int num;
        if (rows.length == 0) throw new Errors.ValidateError.EMPTY_STRING ("Rows count is empty");
        if (!int.try_parse (rows, out num)) throw new Errors.ValidateError.NOT_NUMBER ("Rows count is not a valid number");
        if (num <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO ("Rows count is below or equal zero");
        if (columns.length == 0) throw new Errors.ValidateError.EMPTY_STRING ("Columns count is empty");
        if (!int.try_parse (columns, out num)) throw new Errors.ValidateError.NOT_NUMBER ("Columns count is not a valid number");
        if (num <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO ("Columns count is below or equal zero");
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

    private void Validate_int (string text, string rows, string columns, out int row, out int column) throws Errors.ValidateError {
        int num;
        if (rows.length == 0) throw new Errors.ValidateError.EMPTY_STRING ("Rows count is empty");
        if (!int.try_parse (rows, out row)) throw new Errors.ValidateError.NOT_NUMBER ("Rows count is not a valid number");
        if (row <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO ("Rows count is below or equal zero");
        if (columns.length == 0) throw new Errors.ValidateError.EMPTY_STRING ("Columns count is empty");
        if (!int.try_parse (columns, out column)) throw new Errors.ValidateError.NOT_NUMBER ("Columns count is not a valid number");
        if (column <= 0) throw new Errors.ValidateError.NUMBER_BELOW_ZERO ("Columns count is below or equal zero");
        if (text.length == 0) throw new Errors.ValidateError.EMPTY_STRING ("Text field is empty");
        for (long i = 0; i < text.char_count (); i++){
            if (!int.try_parse (text.get_char(text.index_of_nth_char (i)).to_string (), out num))
                throw new Errors.ValidateError.NOT_NUMBER ("Phrase should be only consist of numbers");
            if (i%2 == 0 && num > row)
                throw new Errors.ValidateError.INCORRECT_NUMBER ("Row in string cannot be bigger than table rows count");
            if (i%2 == 1 && num > column)
                throw new Errors.ValidateError.INCORRECT_NUMBER ("Column in string cannot be bigger than table columns count");
        }
    }
}

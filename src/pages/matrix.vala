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
using Encryption.Matrix;

[GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/matrix.ui")]
public class GCiphers.Matrix : Adw.Bin {

    private bool state;

    [GtkChild]
    private unowned Adw.Bin placeholder;

    [GtkChild]
    private unowned UI.TextView text_view;

    [GtkChild]
    private unowned UI.Entry n;

    [GtkCallback]
    private void on_get_click (Gtk.Button self) {
        var win = (GCiphers.Window) this.get_root ();
        unowned string n = n.get_buffer ().get_text ();
        int parsed_n;
        try {
            parsed_n = validate_n (n);
            placeholder.set_child (new MatrixGrid (parsed_n, parsed_n));
            state = true;
        }
        catch (Error ex) {
            win.toaster (ex.message);
        }
    }

    [GtkCallback]
    private void on_encrypt_click (Gtk.Button self) {
        var win = (GCiphers.Window) this.get_root ();
        try {
            var text = text_view.get_text_buffer ();
            string letters = win.encode_text (text.text);
            validate (letters, state);
            int rows;
            int columns;
            var items = parse_entries (
                (MatrixGrid) placeholder.child, out rows, out columns
            );
            text.set_text (encrypt (letters, rows, columns, items));
        }
        catch (Error ex) {
            win.toaster (ex.message);
        }
    }

    [GtkCallback]
    private void on_decrypt_click (Gtk.Button self) {
        var win = (GCiphers.Window) this.get_root ();
        try {
            var text = text_view.get_text_buffer ();
            string letters = text.text.down ().replace (" ", "");
            int rows;
            int columns;
            var items = parse_entries (
                (MatrixGrid) placeholder.child,
                out rows,
                out columns
            );
            Encryption.Matrix.validate_int (letters);
            text.set_text (
                win.decode_text (decrypt (letters, rows, columns, items))
            );
        }
        catch (Error ex) {
            win.toaster (ex.message);
        }
    }

    public Matrix () {
        state = false;
    }

    private int[] parse_entries (GCiphers.MatrixGrid grid, out int rows, out int columns) throws Error {
        rows = grid.rows;
        columns = grid.columns;
        int[] result = new int[rows * columns];
        int k = 0;
        int num;
        unowned string n;
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < columns; j++) {
                n = grid.elements.get (k).get_buffer ().get_text ();
                if (n.length == 0) throw new ValidateError.EMPTY_STRING (_("n is empty"));
                if (!int.try_parse (n, out num)) throw new ValidateError.NOT_NUMBER (_("n is not a valid number"));
                result[i * columns + j] = num;
                k++;
            }
        }
        return result;
    }
}

/* matrix_grid.vala
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
    [GtkTemplate (ui = "/com/github/sidecuter/gciphers/ui/matrix_grid.ui")]
    public class MatrixGrid : Gtk.Grid {

        public int rows { get; construct; }
        public int columns { get; construct; }
        public Gee.ArrayList<unowned UI.Entry> elements;

        public MatrixGrid (int rows, int columns) {
            Object (
                rows: rows,
                columns: columns
            );
            elements = new Gee.ArrayList<unowned UI.Entry> ();
            UI.Entry tmp;
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < columns; j++) {
                    tmp = new UI.Entry ();
                    this.attach (tmp, j, i);
                    elements.add (tmp);
                }
            }
        }
    }
}

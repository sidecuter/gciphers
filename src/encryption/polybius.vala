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

namespace Encryption {
    class PolybiusTable : Object {
        public int rows { get; construct; }
        public int columns { get; construct; }
        public int last_row { get; construct; }
        public int last_column { get; construct; }
        public Encryption.Alphabet alphabet { get; construct; }

        public PolybiusTable (Encryption.Alphabet alphabet_in, int rows_in, int columns_in) throws Encryption.OOBError{
            if (rows_in*columns_in < alphabet_in.length)
                throw new Encryption.OOBError.CODE_OUT ("Columns*Rows must be bigger than length of alphabet");
            int last_r = alphabet_in.length / columns_in == 0 ? alphabet_in.length / columns_in : alphabet_in.length / columns_in + 1;
            int last_c = columns_in - (last_r*columns_in - alphabet_in.length);
            Object (
                rows: rows_in,
                columns: columns_in,
                alphabet: alphabet_in,
                last_row: last_r,
                last_column: last_c
            );
        }

        public PolybiusIndexes get_letter_indexes (unichar letter) throws Encryption.OOBError{
            PolybiusIndexes indexes = new PolybiusIndexes();
            for (int i = 0; i < this.rows; i++) {
                if (i+1 > this.last_row) continue;
                for (int j = 0; j < this.columns; j++) {
                    if (i+1 == this.last_row && j+1 > this.last_column) break;
                    if (this.alphabet.alphabet.get_char(
                            this.alphabet.alphabet.index_of_nth_char (
                                i*this.columns+j
                            )
                        ) == letter
                    ) {
                        indexes.row = i + 1;
                        indexes.column = j + 1;
                        return indexes;
                    }
                }
            }
            throw new Encryption.OOBError.CODE_NOT_FOUND ("No such letter in table");
        }

        public unichar get_letter_by_indexes (PolybiusIndexes indexes) throws Encryption.OOBError {
            if (indexes.row <= 0 || indexes.column <= 0)
                throw new Encryption.OOBError.CODE_OUT ("Indexes must be bigger than 0");
            if (indexes.row > this.rows || indexes.row > this.last_row)
                throw new Encryption.OOBError.CODE_OUT ("Row index is higher than maximum");
            if (indexes.column > this.columns && indexes.row < this.last_row)
                throw new Encryption.OOBError.CODE_OUT ("Column index bigger than maximum");
            if (indexes.column > this.last_column && indexes.row == this.last_row)
                throw new Encryption.OOBError.CODE_OUT ("Column index bigger than maximum for last row");
            return this.alphabet.alphabet.get_char (
                this.alphabet.alphabet.index_of_nth_char(
                    (indexes.row - 1) * this.columns + (indexes.column - 1)
                )
            );
        }
    }

    class PolybiusIndexes : Object {
        public int row { get; set; }
        public int column { get; set; }
    }

    class Polybius : Object {
        public static string encrypt(Encryption.Alphabet alphabet, string phrase, int rows, int columns) throws Encryption.OOBError {
            string result = "";
            PolybiusIndexes indexes;
            PolybiusTable table;
            try {
                table = new PolybiusTable (alphabet, rows, columns);
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
            for (long i = 0; i < phrase.char_count(); i++) {
                try {
                    indexes = table.get_letter_indexes (
                        phrase.get_char(
                            phrase.index_of_nth_char (i)
                        )
                    );
                    result = @"$result$(indexes.row.to_string())$(indexes.column.to_string())";
                }
                catch (Encryption.OOBError ex) {
                    throw ex;
                }
            }
            return result;
        }

        public static string decrypt(Encryption.Alphabet alphabet, string phrase, int rows, int columns) throws Encryption.OOBError {
            if (phrase.char_count () % 2 != 0)
                throw new Encryption.OOBError.CODE_OUT ("Letters count in text for decryption must be a multiple of two");
            string result = "";
            PolybiusIndexes indexes = new PolybiusIndexes ();
            PolybiusTable table;
            string buffer;
            try {
                table = new PolybiusTable (alphabet, rows, columns);
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
            for (long i = 0; i < phrase.char_count(); i = i + 2) {
                try {
                    indexes.row = int.parse(phrase.get_char(phrase.index_of_nth_char (i)).to_string ());
                    indexes.column = int.parse(phrase.get_char(phrase.index_of_nth_char (i+1)).to_string ());
                    buffer = table.get_letter_by_indexes (indexes).to_string ();
                    result = @"$result$buffer";
                }
                catch (Encryption.OOBError ex) {
                    throw ex;
                }
            }
            return result;
        }
    }
}


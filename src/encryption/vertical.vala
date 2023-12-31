/* vertical.vala
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
    class VerticalMethods : Object {
        public static int find(int[] array, int searched_elem) {
            int pos = -1;
            for (int i = 0; i < array.length; i++) {
                if (array[i] == searched_elem) {
                    pos = i;
                    break;
                }
            }
            return pos;
        }

        public static int[] get_order (Encryption.Alphabet alphabet, string key) 
            throws Encryption.OOBError
        {
            int[] buffer_a = new int[key.char_count ()];
            int[] result = new int[key.char_count ()];
            var buffer = new Gee.HashMap<int, unichar>();
            try {
                for (int i = 0; i < key.char_count (); i++) {
                    unichar symb = key.get_char (key.index_of_nth_char (i));
                    buffer_a[i] = alphabet.index_of (symb);
                    buffer.set(buffer_a[i], symb);
                }
                List<int> positions = new List<int>();
                foreach (var buffer_key in buffer.keys) positions.append (buffer_key);
                positions.sort ((a,b) => {return (int) (a > b) - (int) (a < b);});
                int i = 0;
                for (int j = 0; j < positions.length (); j++) {
                    while (find(buffer_a, positions.nth_data(j)) >= 0) {
                        int pos = find(buffer_a, positions.nth_data(j));
                        result[pos] = ++i;
                        buffer_a[pos] = -1;
                    }
                }
                return result;
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }

        public static void get_rows_and_keys(
            Encryption.Alphabet alphabet,
            string phrase, string key, out int[] keys,
            out int row, out int row_o, out int[] rows
        ) 
            throws Encryption.OOBError 
        {
            try {
                keys = get_order (alphabet, key);
                row = phrase.char_count () / keys.length;
                row_o = row;
                rows = new int[keys.length];
                if (phrase.char_count () % keys.length != 0) row++;
                for (int i = 0; i < keys.length; i++) {
                    if ((i+1) >= row_o) rows[i] = row_o;
                    else rows[i] = row;
                }
            }
            catch (OOBError ex) {
                throw ex;
            }
        }

        public static string get_result (Alphabet alphabet, int row, int[] keys, int[,] result_array)
            throws Encryption.OOBError
        {
            try {
                string result = "";
                for (int i = 0; i < row; i++) {
                    for (int j = 0; j < keys.length; j++)
                        if (result_array[i, j] != -1) {
                            result = @"$result$(alphabet[result_array[i, j]])";
                        }
                }
                return result;
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }

        public static int[,] get_buffer (Alphabet alphabet, string phrase, int row, int length) 
            throws Encryption.OOBError
        {
            try {
                int[,] buffer = new int[row, length];
                int k = 0;
                unichar symb;
                for (int i = 0; i < row; i++) {
                    for (int j = 0; j < length; j++) {
                        if (k < phrase.length) {
                            phrase.get_next_char (ref k, out symb);
                            buffer[i, j] = alphabet.index_of (symb);
                        }
                        else buffer[i, j] = -1;
                    }
                }
                return buffer;
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }
    }

    class Vertical : Object {
        private static string proto_crypt (Encryption.Alphabet alphabet, string phrase, string key, bool enc = true)
            throws Encryption.OOBError
        {
            try {
                int row, row_other;
                int[] keys, rows;
                VerticalMethods.get_rows_and_keys (
                    alphabet, phrase, key,
                    out keys, out row,
                    out row_other, out rows);
                int[,] buffer = VerticalMethods.get_buffer (
                    alphabet, phrase, row, keys.length
                );
                int[,] result_array = new int[row, keys.length];
                for (int j = 0; j < keys.length; j++) {
                    for (int i = 0; i < row; i++) {
                        if (enc) result_array[i, keys[j] - 1] = buffer[i, j];
                        else result_array[i, j] = buffer[i, keys[j] - 1]; 
                    }
                }
                return VerticalMethods.get_result (alphabet, row, keys, result_array);
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }

        public static string encrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            try {
                return proto_crypt (alphabet, phrase, key);
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }

        public static string decrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            try {
                return proto_crypt (alphabet, phrase, key, false);
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }
    }
}

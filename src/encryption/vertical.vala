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

 namespace Encryption.Vertical {
    class Methods : Object {
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

        public static int[] get_order (Alphabet alphabet, string key) 
            throws OOBError
        {
            int[] buffer_a = new int[key.char_count ()];
            int[] result = new int[key.char_count ()];
            try {
                for (int i = 0; i < key.char_count (); i++) {
                    unichar symb = key.get_char (key.index_of_nth_char (i));
                    buffer_a[i] = alphabet.index_of (symb);
                }
                List<int> positions = new List<int>();
                foreach (var buffer_key in buffer_a) positions.append (buffer_key);
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
            catch (OOBError ex) {
                throw ex;
            }
        }

        public static void get_rows_and_keys(
            Alphabet alphabet,
            string phrase, string key, out int[] keys,
            out int row, out int row_o, out int[] rows
        ) 
            throws OOBError 
        {
            try {
                keys = get_order (alphabet, key);
                row = phrase.char_count () / keys.length;
                row_o = row;
                rows = new int[keys.length];
                if (phrase.char_count () % keys.length != 0) row++;
                int last_row = keys.length - (row * keys.length - phrase.char_count ());
                for (int i = 0; i < keys.length; i++) {
                    if (i >= last_row) rows[i] = row_o;
                    else rows[i] = row;
                }
            }
            catch (OOBError ex) {
                throw ex;
            }
        }

        public static int[] get_dec (int[] keys, int last_row) {
            int[] dec = new int[last_row];
            int temp;
            for (int i = 0; i < last_row; i++) {
                dec[i] = keys[keys.length - 1 - i];
            }
            for (int i = 0; i < last_row - 1; i++) 
                for (int j = 0; j < last_row - i - 1; j++) 
                    if (dec[j] > dec[j + 1]) {
                        temp = dec[j];
                        dec[j] = dec[j + 1];
                        dec[j + 1] = temp;
                    }
            return dec;
        }

        public static string get_result (Alphabet alphabet, int row, int[] keys, int[,] result_array)
            throws OOBError
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
            catch (OOBError ex) {
                throw ex;
            }
        }
    }

    string proto_crypt (Alphabet alphabet, string phrase, string key, bool enc = true)
        throws OOBError
    {
        try {
            int row, row_other;
            int[] keys, rows;
            Methods.get_rows_and_keys (
                alphabet, phrase, key,
                out keys, out row,
                out row_other, out rows);
            int[,] buffer = new int[row, keys.length];
            int k = 0, u = 0;
            int[] dec;
            bool flag = phrase.char_count () % keys.length != 0;
            if (flag && !enc) dec =  Methods.get_dec (
                keys, row * keys.length - phrase.char_count ());
            else dec = new int[0];
            unichar symb;
            for (int i = 0; i < row; i++) {
                for (int j = 0; j < keys.length; j++) {
                    if (enc) {
                        if (k < phrase.length) {
                            phrase.get_next_char (ref k, out symb);
                            buffer[i, j] = alphabet.index_of (symb);
                        }
                        else buffer[i, j] = -1;
                    }
                    else {
                        if (!flag) {
                            phrase.get_next_char (ref k, out symb);
                            buffer[i, j] = alphabet.index_of (symb);
                        } else {
                            if (i + 1 == row && u < dec.length && dec[u] - 1 == j) {
                                buffer[i, j] = -1;
                                u++;
                            }
                            else {
                                phrase.get_next_char (ref k, out symb);
                                buffer[i, j] = alphabet.index_of (symb);
                            }
                        }
                    }
                }
            }
            int[,] result_array = new int[row, keys.length];
            for (int j = 0; j < keys.length; j++) {
                for (int i = 0; i < row; i++) {
                    if (enc) result_array[i, keys[j] - 1] = buffer[i, j];
                    else result_array[i, j] = buffer[i, keys[j] - 1]; 
                }
            }
            return Methods.get_result (alphabet, row, keys, result_array);
        }
        catch (OOBError ex) {
            throw ex;
        }
    }

    string encrypt (Alphabet alphabet, string phrase, string key) throws OOBError {
        return proto_crypt (alphabet, phrase, key);
    }

    string decrypt (Alphabet alphabet, string phrase, string key) throws OOBError {
        return proto_crypt (alphabet, phrase, key, false);
    }
}

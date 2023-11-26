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
                    buffer.set(
                        alphabet.get_letter_index (
                            key.get_char (key.index_of_nth_char (i))
                        ),
                        key.get_char (key.index_of_nth_char (i))
                    );
                    buffer_a[i] = alphabet.get_letter_index (
                        key.get_char (key.index_of_nth_char (i))
                    );
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
    }

    class Vertical : Object {
        public static string encrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            try {
                //string result = Encryption.MultiAlphabetic.encrypt(alphabet, phrase, alphabet.alphabet);
                return "result";
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }

        public static string decrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            try {
                //string result = Encryption.MultiAlphabetic.decrypt(alphabet, phrase, alphabet.alphabet);
                return "result";
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }
    }
}

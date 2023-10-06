/* vigenere.vala
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
    class Vigenere : Object {
        public static string encrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            try {
                string key_phrase = @"$key$phrase";
                string result = Encryption.MultiAlphabetic.encrypt(alphabet, phrase, key_phrase);
                return result;
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }

        public static string decrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            try {
                string result = "";
                unichar buffer = key.get_char (key.index_of_nth_char (0));
                for (long i = 0; i < phrase.char_count (); i++) {
                    buffer = alphabet.get_letter_by_index (
                        get_index (
                            alphabet.get_letter_index (
                                phrase.get_char (phrase.index_of_nth_char (i))
                            ),
                            -alphabet.get_letter_index (buffer),
                            alphabet.length
                        )
                    );
                    result = @"$result$(buffer.to_string ())";
                }
                return result;
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }

        private static int get_index (int index, int shift, int length) {
            int result = index;
            result += shift;
            if ( result >= length ) result -= length;
            if ( result < 0 ) result += length;
            return result;
        }
    }
}


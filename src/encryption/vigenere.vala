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
            return Encryption.MultiAlphabetic.encrypt(alphabet, phrase, @"$key$phrase");
        }

        public static string decrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            string result = "";
            int i = 0, k = 0;
            unichar buffer, letter;
            key.get_next_char (ref k, out buffer);
            while (phrase.get_next_char (ref i, out letter)) {
                buffer = alphabet[
                    Encryption.get_index (
                        alphabet.index_of (letter),
                        -alphabet.index_of (buffer),
                        alphabet.length
                    )
                ];
                result = @"$result$(buffer.to_string ())";
            }
            return result;
        }
    }
}

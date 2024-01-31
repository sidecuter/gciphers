/* multi_alphabetic.vala
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

namespace Encryption.MultiAlphabetic {
    string proto_crypt (
        Alphabet alphabet, string phrase, string key, bool reverse = false
    ) throws OOBError {
        string result = "";
        unichar buffer, letter;
        int k = 0, i = 0;
        while (phrase.get_next_char (ref i, out letter)) {
            if (key.length == k) k %= key.length;
            key.get_next_char (ref k, out buffer);
            try {
                letter = alphabet[
                    mod (
                        alphabet.index_of (letter) 
                        + alphabet.index_of(buffer) * (reverse ? -1 : 1),
                        alphabet.length
                    )
                ];
                result = @"$result$(letter.to_string())";
            }
            catch (OOBError ex) {
                throw ex;
            }
        }
        return result;
    }

    string encrypt (Alphabet alphabet, string phrase, string key) 
        throws OOBError
    {
        return proto_crypt (alphabet, phrase, key);
    }

    string decrypt (Alphabet alphabet, string phrase, string key)
        throws OOBError
    {
        return proto_crypt (alphabet, phrase, key, true);
    }
}

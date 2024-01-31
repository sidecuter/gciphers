/* vigenereii.vala
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

namespace Encryption.VigenereII {
    string encrypt (string phrase, string key) throws Error {
        Alphabet alphabet = new Alphabet ();
        string result = "";
        int i = 0, k = 0;
        unichar buffer, letter;
        key.get_next_char (ref k, out buffer);
        while (phrase.get_next_char (ref i, out letter)) {
            buffer = alphabet[
                mod (
                    alphabet.index_of (letter) + alphabet.index_of (buffer),
                    alphabet.length
                )
            ];
            result = @"$result$(buffer.to_string ())";
        }
        return result;
    }

    string decrypt (string phrase, string key) throws Error {
        Alphabet alphabet = new Alphabet ();
        string result = "";
        unichar buffer = key.get_char (key.index_of_nth_char (0));
        for (long i = 0; i < phrase.char_count (); i++) {
            buffer = alphabet[
                mod (
                    alphabet.index_of (
                        phrase.get_char (phrase.index_of_nth_char (i))
                    ) - alphabet.index_of (buffer),
                    alphabet.length
                )
            ];
            result = @"$result$(buffer.to_string ())";
            buffer = phrase.get_char (phrase.index_of_nth_char (i));
        }
        return result;
    }
}

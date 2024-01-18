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

namespace Encryption {
    class Generator : Object {
        private int state { get; set; }
        private int a { get; set; }
        private int c { get; set; }
        private int mod { get; set; }

        public Generator (int t0, int aa, int cc, int modd) {
            this.state = t0;
            this.a = aa;
            this.c = cc;
            this.mod = modd;
        }

        public int step () {
            state = (a * state + c) % mod;
            return state;
        }
    }

    class Shenon : Object {
        public static string encrypt (Encryption.Alphabet alphabet, string phrase, int t0, int a, int c) throws Encryption.OOBError {
            Generator generator = new Generator (t0, a, c, alphabet.length);
            string result = "";
            int pos = 0, i = 0;
            unichar letter;
            while (phrase.get_next_char (ref i, out letter)) {
                pos = (generator.step () + alphabet.index_of (letter)) % alphabet.length;
                result = @"$result$(alphabet[pos].to_string ())";
            }
            return result;
        }

        public static string decrypt (Encryption.Alphabet alphabet, string phrase, int t0, int a, int c) throws Encryption.OOBError {
            Generator generator = new Generator (t0, a, c, alphabet.length);
            string result = "";
            int pos = 0, i = 0;
            unichar letter;
            while (phrase.get_next_char (ref i, out letter)) {
                pos = alphabet.index_of (letter) - generator.step ();
                if (pos < 0) pos += alphabet.length;
                result = @"$result$(alphabet[pos].to_string ())";
            }
            return result;
        }
    }
}

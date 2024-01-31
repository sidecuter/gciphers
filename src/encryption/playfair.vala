/* playfair.vala
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
    namespace Playfair {
        bool validate_key (string key) {
            var dup = new Gee.HashMap<string, int> ();
            int i = 0;
            unichar buf;
            while (key.get_next_char (ref i, out buf)) {
                if (dup.has_key (buf.to_string ())) {
                    dup.set(buf.to_string (), dup.get(buf.to_string ()) + 1);
                }
                else {
                    dup.set(buf.to_string (), 1);
                }
            }
            foreach (var entry in dup) {
                if (entry.value > 1) return false;
            }
            return true;
        }

        void find_letter (
            string [,] table,
            string letter,
            ref int i,
            ref int j
        ) {
            string l = letter.replace("ё", "e")
                .replace("й", "и")
                .replace("ь", "ъ");
            for (i = 0; i < 5; i++) {
                for (j = 0; j < 6; j++) {
                    if (table[i, j] == l) return;                
                }
            }
        }

        int mod (int num, int del) {
            if (num >= 0) return num % del;
            else return del - (-num) % del;
        }

        string get_letter_pair(string[,] table, string letter1, string letter2, bool rev) {
            string r = "";
            int dir = rev ? -1 : 1;
            int i1 = 0, i2 = 0, j1 = 0, j2 = 0;
            find_letter (table, letter1, ref i1, ref j1);
            find_letter (table, letter2, ref i2, ref j2);
            if (i1 == i2) {
                j1 = mod(j1 + dir, 6);
                j2 = mod(j2 + dir, 6);
                r = @"$(table[i1,j1])$(table[i2,j2])";
            }
            else if (j1 == j2) {
                i1 = mod(i1 + dir, 5);
                i2 = mod(i2 + dir, 5);
                r = @"$(table[i1,j1])$(table[i2,j2])";
            }
            else {
                r = @"$(table[i1,j2])$(table[i2,j1])";
            }
            return r;
        }

        string[,] get_table (string key) {
            string playfair_alphabet = "абвгдежзиклмнопрстуфхцчшщъыэюя";
            var table = new string[5,6];
            int k = 0, l = 0;
            unichar symb;
            for (int i = 0; i < 5; i++) {
                for (int j = 0; j < 6; j++) {
                    if (k < key.length) {
                        key.get_next_char (ref k, out symb);
                        table[i, j] = symb.to_string ();
                        playfair_alphabet = playfair_alphabet.replace (
                            table[i,j], "");
                    }
                    else {
                        playfair_alphabet.get_next_char (ref l, out symb);
                        table[i, j] = symb.to_string ();
                    }
                }
            }
            return table;
        }

        string process_letters(string[,] table, string phrase, bool rev = false) {
            string r = "";
            int i = 0;
            string buffer;
            unichar letter1, letter2;
            while (phrase.get_next_char (ref i, out letter1)) {
                if (!phrase.get_next_char (ref i, out letter2)) letter2 = 1072;
                if (letter1 == letter2) {
                    buffer = get_letter_pair(
                        table,
                        letter1.to_string (),
                        "ф",
                        rev
                    );
                    r = @"$r$buffer";
                    if (!phrase.get_next_char (ref i, out letter1)) letter1 = 1072;
                    buffer = get_letter_pair(
                        table,
                        letter2.to_string (),
                        letter1.to_string (),
                        rev
                    );
                    r = @"$r$buffer";
                }
                else {
                    buffer = get_letter_pair(
                        table,
                        letter1.to_string (),
                        letter2.to_string (),
                        rev
                    );
                    r = @"$r$buffer";
                }
            }
            return r;
        }

        string encrypt (string phrase, string key) {
            var playfair_table = get_table(key);
            return process_letters (playfair_table, phrase);
        }

        string decrypt (string phrase, string key) {
            var playfair_table = get_table(key);
            return process_letters (playfair_table, phrase, true);
        }
    }
}

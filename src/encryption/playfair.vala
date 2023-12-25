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
    class Playfair : Object {
        public static bool validate_key (string key) {
            var dup = new Gee.HashMap<string, int> ();
            string letter;
            for (int i = 0; i < key.char_count (); i++) {
                letter = key.get_char (key.index_of_nth_char (i)).to_string ();
                if (dup.has_key (letter)) {
                    dup.set(letter, dup.get(letter) + 1);
                }
                else {
                    dup.set(letter, 1);
                }
            }
            foreach (var entry in dup) {
                if (entry.value > 1) return false;
            }
            return true;
        }
    }
}

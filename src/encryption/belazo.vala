/* belazo.vala
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
    class Belazo : Object {
        public static string encrypt (Encryption.Alphabet alphabet, string phrase, string key)
            throws Encryption.OOBError
        {
            try {
                string result = Encryption.MultiAlphabetic.encrypt(alphabet, phrase, key);
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
                string result = Encryption.MultiAlphabetic.decrypt(alphabet, phrase, key);
                return result;
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
        }
    }
}


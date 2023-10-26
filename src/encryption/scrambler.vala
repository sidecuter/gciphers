/* scrambler.vala
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

    class Register : Object {
        public int size { get; construct; }
        public string scrambler { get; construct; }
        public string value_start { get; construct; }
        public string value { get; private set; }

        public static char xor (char bit1, char bit2) {
            if (bit1 == bit2) return '0';
            else return '1';
        }

        public static List<char> convert_to_bits(string phrase, Alphabet alphabet) throws OOBError {
            List<char> bits = new List<char> ();
            int index;
            for (int i = 0; i < phrase.char_count (); i++) {
                index = alphabet.get_letter_index (
                    phrase.get_char (
                        phrase.index_of_nth_char (i)
                    )
                ) + 1;
                for (int j = 0; j < 6; j++) {
                    if ((index & 32) == 32) bits.append ('1');
                    else bits.append ('0');
                    index <<= 1;
                }
            }
            return bits;
        }

        public static string convert_to_letters(List<char> bits, Alphabet alphabet) throws OOBError {
            int count = 0;
            int index = 0;
            string result = "";
            string buffer = "";
            foreach (char bit in bits) {
                count++;
                index = (index << 1) | (bit == '0' ? 0 : 1);
                if (count == 6) {
                    index--;
                    if (index < 0) index += alphabet.length;
                    index %= alphabet.length;
                    buffer = alphabet.get_letter_by_index(index).to_string();
                    result = @"$result$buffer";
                    index = 0;
                    count = 0;
                }
            }
            return result;
        }

        public Register (string scrambl, string key) {
            Object (
                scrambler: scrambl,
                value_start: key,
                size: scrambl.length
            );
            this.value = key;
        }

        public char shift() {
            char param = value[value.length - 1];
            char ret_value = param;
            for (int i = size - 2; i >= 0; i--) {
                if (scrambler[i] == '1') param = xor(param, value[i]);
            }
            value = @"$param$(value[0:size-1])";
            return ret_value;
        }
    }

    class Scrambler : Object {
        public static string encrypt (
            Encryption.Alphabet alphabet,
            string phrase,
            string scrambler1,
            string scrambler2,
            string key1,
            string key2
        ) throws Encryption.OOBError {
            Register reg1 = new Register (scrambler1, key1);
            Register reg2 = new Register (scrambler2, key2);
            List<char> out_bits = new List<char> ();
            string result = "";
            bool flag = false;
            char out1 = '0', out2 = '0';
            try {
                List<char> bits = Register.convert_to_bits (phrase, alphabet);
                foreach (char bit in bits) {
                    if (
                        flag && reg1.value == reg1.value_start &&
                        reg2.value == reg2.value_start
                    ) throw new OOBError.CODE_OUT ("End of cycle before end of phrase");
                    flag = true;
                    out1 = reg1.shift ();
                    out2 = reg2.shift ();
                    out_bits.append (Register.xor(Register.xor(out1, out2), bit));
                }
                result = Register.convert_to_letters(out_bits, alphabet);
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
            return result;
        }
    }
 }
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
        public uint8 size { get; construct; }
        public uint8 scrambler { get; construct; }
        public uint8 value_start { get; construct; }
        public uint8 value { get; private set; }

        public Register (uint8 size1, string scrambler, string value) {
            int pos_s = 0, pos_v = 0;
            uint8 value_buffer = 0, scrambler_buffer = 0;
            unichar symbol;
            for (int i = 0; i < size1; i++) {
                scrambler.get_next_char (ref pos_s, out symbol);
                scrambler_buffer |= (uint8) int.parse(symbol.to_string ());
                value.get_next_char (ref pos_v, out symbol);
                value_buffer |= (uint8) int.parse(symbol.to_string ());
                if (i != size1 - 1) {
                    scrambler_buffer <<= 1;
                    value_buffer <<= 1;
                }
            }
            Object (
                size: size1,
                scrambler: scrambler_buffer,
                value_start: value_buffer
            );
            this.value = value_buffer;
        }

        public uint8 shift () {
            uint8 and_unit = 1;
            uint8 new_value = 0;
            uint8 exit_value = 0;
            new_value = exit_value = this.value & and_unit;
            for (int i = 0; i < size - 1; i++) {
                new_value <<= 1;
                and_unit <<= 1;
                if ((this.scrambler & and_unit) > 0) {
                    new_value ^= this.value;
                    new_value &= and_unit;
                }
            }
            this.value >>= 1;
            this.value |= new_value;
            return exit_value;
        }
    }

    class ScramblerSystem : Object {
        public Register reg1 { private get; construct; }
        public Register reg2 { private get; construct; }

        public ScramblerSystem (Register reg_1, Register reg_2) {
            Object (
                reg1: reg_1,
                reg2: reg_2
            );
        }

        public uint8 process (uint8 letter_pos, uint8 size)
            throws OOBError
        {
            uint8 reg1 = 0, reg2 = 0, result;
            for (uint8 i = 0; i < 6; i++) {
                reg1 |= this.reg1.shift ();
                reg2 |= this.reg2.shift ();
                if (i != 5) {
                    reg1 <<= 1;
                    reg2 <<= 1;
                }
                if (this.reg1.value == this.reg1.value_start &&
                    this.reg2.value == this.reg2.value_start)
                    throw new OOBError.CODE_OUT (_("End of cycle before end of phrase"));
            }
            result = (reg1 ^ reg2) ^ letter_pos;
            return (uint8) Encryption.mod ((int) result, size);
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
            string result = "";
            int pos = 0;
            var scr = new ScramblerSystem (
                new Register ((uint8) scrambler1.char_count (), scrambler1, key1),
                new Register ((uint8) scrambler2.char_count (), scrambler2, key2)
            );
            int i = 0;
            unichar letter;
            while (phrase.get_next_char (ref i, out letter)) {
                pos = (int) scr.process (
                    (uint8) (alphabet.index_of (letter) + 1),
                    (uint8) alphabet.length
                );
                result = @"$result$(alphabet[mod (pos-1, alphabet.length)])";
            }
            return result;
        }
    }
}

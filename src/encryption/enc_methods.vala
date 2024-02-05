/* enc_methods.vala
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
    /*
     * Функция mod, вычисляет модуль числа по основанию
     * Входные параметры:
     * - value - исходное число
     * - modd - основание
     * Возвращаемое значение: число по модулю 
     */
    int mod (int value, int modd) {
        if ( value >= modd ) value %= modd;
        if ( value < 0 ) value = modd - (-value) % modd;
        return value;
    }

    uint8[] hex_to_bytes (string text) throws Error {
        if (text.char_count() % 2 == 1) throw new ValidateError.INCORRECT_NUMBER(_(""));
        var validator = new Alphabet.from_str ("0123456789abcdef");
        uint8[] result = new uint8[text.char_count () / 2];
        unichar letter1, letter2;
        uint8 num1, num2;
        for (int i = 0; i < text.char_count () / 2; i++) {
            letter1 = text.get_char (text.index_of_nth_char (i * 2));
            letter2 = text.get_char (text.index_of_nth_char (i * 2 + 1));
            if (letter1 in validator && letter2 in validator) {
                num1 = (uint8) validator.index_of (letter1);
                num2 = (uint8) validator.index_of (letter2);
                result[i] = (num1 << 4) | num2;
            }
            else throw new ValidateError.INCORRECT_NUMBER(_(""));
        }
        return result;
    }

    string bytes_to_hex (uint8[] bytes) throws Error {
        string result = "";
        uint8 num1, num2;
        unichar letter1, letter2;
        var validator = new Alphabet.from_str ("0123456789abcdef");
        for (int i = 0; i < bytes.length; i++) {
            num1 = (bytes[i] & 0xf0) >> 4;
            num2 = bytes[i] & 0x0f;
            letter1 = validator[num1];
            letter2 = validator[num2];
            result = @"$(result)$(letter1.to_string())$(letter2.to_string())";
        }
        return result;
    }

    uint8[] convert_to_uint8 (string phrase, int border) {
        var buffer = phrase.data;
        var length = buffer.length;
        if (buffer.length % border != 0) {
            length += border - buffer.length % border;
        }
        var result = new uint8[length];
        for (int i = 0; i < length; i++) {
            if (i < buffer.length) result[i] = buffer[i];
            else result[i] = 0;
        }
        return result;
    }

    string convert_to_string (uint8[] data) {
        char[] buffer = new char[data.length];
        for (int i = 0; i < data.length; i++) buffer[i] = (char) data[i];
        StringBuilder s = new StringBuilder.from_buffer(buffer);
        return s.free_and_steal ();
    }
}

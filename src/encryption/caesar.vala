/* caesar.vala
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

namespace Encryption.Caesar {
    /*
     * Метод proto_crypt зашифровывает/расшифровывает исходное сообщение используя шифр Цезаря
     * Входные параметры:
     * - alphabet - алфавит шифрования
     * - phrase - фраза для зашифровки
     * - shift - сдвиг
     * - reverse - флаг, управляющий поведением функции
     * Возвращаемое значение: зашифрованная/расшифрованная фраза
     */
    string proto_crypt (string phrase, int shift, bool reverse = false) throws Error {
        Alphabet alphabet = new Alphabet ();
        string result = "";
        unichar letter;
        int i = 0;
        while (phrase.get_next_char (ref i, out letter)) {
            // Получает букву, согласно сдвигу
            letter = alphabet[
                mod (
                    alphabet.index_of (letter) + (reverse ? -shift : shift),
                    alphabet.length
                )
            ];
            result = @"$result$(letter.to_string())";
        }
        return result;
    }

    string encrypt (string phrase, int shift) throws Error {
        return proto_crypt (phrase, shift);
    }

    string decrypt (string phrase, int shift) throws Error {
        return proto_crypt (phrase, shift, true);
    }
}

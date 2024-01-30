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

namespace Encryption {
    class Caesar : Object {
        /**
         * Метод proto_crypt зашифровывает/расшифровывает исходное сообщение используя шифр Цезаря
         * Входные параметры:
         * alphabet - алфавит шифрования
         * phrase - фраза для зашифровки
         * shift - сдвиг
         * reverse - флаг, управляющий поведением функции
         * Возвращаемое значение: зашифрованная/расшифрованная фраза
         */
        private static string proto_crypt (
            Encryption.Alphabet alphabet, string phrase,
            int shift, bool reverse = false
        ) throws Encryption.OOBError {
            string result = "";
            unichar letter;
            int i = 0;
            while (phrase.get_next_char (ref i, out letter)) {
                try {
                    // Получает букву, согласно сдвигу
                    letter = alphabet[
                        mod (
                            alphabet.index_of (letter) + (reverse ? -shift : shift),
                            alphabet.length
                        )
                    ];
                    result = @"$result$(letter.to_string())";
                }
                catch (Encryption.OOBError ex) {
                    throw ex;
                }
            }
            return result;
        }

        public static string encrypt (
            Encryption.Alphabet alphabet, string phrase, int shift
        ) throws Encryption.OOBError {
            return proto_crypt (alphabet, phrase, shift);
        }

        public static string decrypt (
            Encryption.Alphabet alphabet, string phrase, int shift
        ) throws Encryption.OOBError {
            return proto_crypt (alphabet, phrase, shift, true);
        }
    }
}

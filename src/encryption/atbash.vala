/* atbash.vala
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

namespace Encryption.Atbash {
    /*
     * Метод encrypt зашифровывает исходное сообщение используя шифр АТБАШ
     * Входные параметры:
     * - alphabet - алфавит шифрования
     * - phrase - фраза для зашифровки
     * Возвращаемое значение: зашифрованная фраза
     * Тк шифр атбаш имеет одинаковый шифр для зашифровки и расшифровки, то
     * реализовали только эту функцию
     */
    string encrypt (Alphabet alphabet, string phrase) throws OOBError {
        string result = "";
        unichar letter;
        int i = 0;
        // Цикл выполняется пока не будет достигнут конец строки
        while (phrase.get_next_char (ref i, out letter)) {
            try {
                //Получение буквы с конца алфавита со сдвигом, равным индексу текущей буквы
                letter = alphabet[alphabet.length - 1 - alphabet.index_of (letter)];
                // Конкатенируем полученную букву с результирующей строкой
                result = @"$result$(letter.to_string())";
            }
            catch (OOBError ex) {
                throw ex;
            }
        }
        return result;
    }
}

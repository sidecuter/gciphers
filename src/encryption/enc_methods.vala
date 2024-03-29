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
}

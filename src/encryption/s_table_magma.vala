/* magma.vala
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

namespace Encryption.Magma {
    const uint8[,] Pi = {
        {1,7,14,13,0,5,8,3,4,15,10,6,9,12,11,2},
        {8,14,2,5,6,9,1,12,15,4,11,0,13,10,3,7},
        {5,13,15,6,9,2,12,10,11,7,8,1,4,3,14,0},
        {7,15,5,10,8,1,6,13,0,9,3,14,11,4,2,12},
        {12,8,2,1,13,4,15,6,7,0,10,5,3,14,9,11},
        {11,3,5,8,2,15,10,13,14,1,7,4,12,9,6,0},
        {6,8,2,3,9,10,5,12,1,14,4,7,11,13,0,15},
        {12,4,6,2,10,5,11,9,14,8,13,7,0,3,15,1}
    };
    uint8[] t (uint8[] in_data) {
        uint8 first_part_byte, sec_part_byte;
        uint8[] result = new uint8[4];
        int i = 0;
        foreach (var x in in_data) {
            first_part_byte = (x & 0xf0) >> 4;
            sec_part_byte = (x & 0x0f);
            first_part_byte = Pi[i * 2, first_part_byte];
            sec_part_byte = Pi[i * 2 + 1, sec_part_byte];
            result[i] = (first_part_byte << 4) | sec_part_byte;
            i++;
        }
        return result;
    }

    uint8 find_index (uint8 elem, int row) {
        for (uint8 i = 0; i < 16; i++) {
            if (elem == Pi[row, i]) return i;
        }
        return 0;
    }

    uint8[] t_reverse (uint8[] in_data) {
        uint8 first_part_byte, sec_part_byte;
        uint8[] result = new uint8[4];
        int i = 0;
        foreach (var x in in_data) {
            first_part_byte = (x & 0xf0) >> 4;
            sec_part_byte = (x & 0x0f);
            first_part_byte = find_index (first_part_byte, i * 2);
            sec_part_byte = find_index (sec_part_byte, i * 2 + 1);
            // first_part_byte = Pi[i * 2, first_part_byte];
            // sec_part_byte = Pi[i * 2 + 1, sec_part_byte];
            result[i] = (first_part_byte << 4) | sec_part_byte;
            i++;
        }
        return result;
    }
}
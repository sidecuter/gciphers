/* pages_errors.vala
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

namespace Errors {
    errordomain ValidateError {
        LETTERS_NOT_IN_STRING,
        NOT_NUMBER,
        NUMBER_BELOW_ZERO,
        EMPTY_STRING,
        INCORRECT_NUMBER,
        WRONG_STRING_LENGTH,
        NOT_STATED,
    }

    void validate_string (Encryption.Alphabet alphabet, string text, string message)
        throws ValidateError
    {
        int i = 0;
        unichar letter;
        while (text.get_next_char (ref i, out letter)){
            if (!(letter in alphabet))
                throw new Errors.ValidateError.LETTERS_NOT_IN_STRING (message);
        }
    }

    void validate_int (string text, string message)
        throws ValidateError
    {
        int i = 0, num;
        unichar letter;
        while (text.get_next_char (ref i, out letter)){
            if (!int.try_parse (letter.to_string (), out num))
                throw new Errors.ValidateError.NOT_NUMBER (message);
        }
    }
}

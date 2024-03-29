/* alphabet.vala
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

errordomain Encryption.OOBError {
    CODE_OUT,
    CODE_NOT_FOUND,
    CODE_PASSTHROUGH,
}

errordomain Encryption.ValidateError {
    LETTERS_NOT_IN_STRING,
    NOT_NUMBER,
    NUMBER_BELOW_ZERO,
    EMPTY_STRING,
    INCORRECT_NUMBER,
    WRONG_STRING_LENGTH,
    NOT_STATED,
}

/*
 * Класс Alphabet
 * Содержит методы поиска позиции буквы в алфавите,
 * а так же поиска буквы по позиции
 */
class Encryption.Alphabet : Object {
    public string alphabet { get; private set; }
    public int length { get; construct; }

    public Alphabet () {
        string alphabet = "абвгдежзийклмнопрстуфхцчшщъыьэюя";
        Object (
            length: alphabet.char_count ()
        );
        this.alphabet = alphabet;
    }

    public Alphabet.from_str (string alphabet) {
        this.alphabet = alphabet;
    }

    /*
     * Метод contains проверяет, содержится ли буква в алфавите
     * Входные параметры:
     * - letter - искомый символ в кодировке юникод
     * Возвращаемое значение: true/false в зависимости от наличия буквы в алфавите
     */
    public bool contains (unichar letter) {
        return letter.to_string() in alphabet;
    }

    /*
     * Метод get возвращает букву по индексу
     * Входные параметры:
     * - index - индекс буквы в алфавите
     * Возвращаемое значение: буква алфавита
     */
    public new unichar get (int index) throws Error {
        if (index > alphabet.char_count ())
            throw new OOBError.CODE_OUT (_("Index bigger than string size"));
        if (index < 0) throw new OOBError.CODE_OUT (_("Index can't be negative"));
        unichar result = alphabet.get_char (alphabet.index_of_nth_char (index));
        return result;
    }

    /*
     * Метод index_of возвращает индекс буквы в алфавите
     * Входные параметры:
     * - letter - буква в алфавите
     * Возвращаемое значение: индекс буквы в алфавите
     */
    public int index_of (unichar letter) throws Error {
        if (!(letter in this)) throw new OOBError.CODE_NOT_FOUND (_("Index not found"));
        int result = alphabet.index_of_char(letter);
        result = alphabet.char_count () != alphabet.length ? result / 2 : result;
        return result;
    }
}

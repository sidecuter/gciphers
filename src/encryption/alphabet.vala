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
    CODE_NOT_FOUND
}

class Encryption.Alphabets : Object {
    public string ru { get; construct; }
    public string ru_full { get; construct; }
    public string en { get; construct; }

    public Alphabets() {
        Object (
            ru: "абвгдежзийклмнопрстуфхцчшщъыьэюя",
            ru_full: "абвгдеёжзийклмнопрстуфхцчшщъыьэюя"
        );
    }
}

class Encryption.Alphabet : Object {
    public string alphabet { get; construct; }
    public int length { get; construct; }

    public Alphabet(string alphabet) {
        Object (
            alphabet: alphabet,
            length: alphabet.char_count ()
        );
    }

    public unichar get_letter_by_index (int index) throws Encryption.OOBError {
        if (index > alphabet.char_count ()) throw new Encryption.OOBError.CODE_OUT ("Index bigger then string size");
        for (int i = 0; i < alphabet.char_count (); i++) {
            if ( index == i) return alphabet.get_char (alphabet.index_of_nth_char (i));
        }
        throw new Encryption.OOBError.CODE_NOT_FOUND ("Index not found");
    }

    public int get_letter_index (unichar letter) throws Encryption.OOBError {
        for (int i = 0; i < alphabet.char_count (); i++) {
            if ( alphabet.get_char (alphabet.index_of_nth_char (i)) == letter) return i;
        }
        throw new Encryption.OOBError.CODE_NOT_FOUND ("Index not found");
    }
}


/* validation.vala
 *
 * Copyright 2024 Alexander Svobodov
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
    void validate_string (Alphabet alphabet, string text, string message) throws ValidateError {
        int i = 0;
        unichar letter;
        while (text.get_next_char (ref i, out letter)){
            if (!(letter in alphabet))
                throw new ValidateError.LETTERS_NOT_IN_STRING (message);
        }
    }

    void validate_int (string text, string message) throws ValidateError {
        int i = 0, num;
        unichar letter;
        while (text.get_next_char (ref i, out letter)){
            if (!int.try_parse (letter.to_string (), out num))
                throw new ValidateError.NOT_NUMBER (message);
        }
    }

    namespace Atbash {
        void validate (string text) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    }
    
    namespace Belazo {
        void validate (string text, string key) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (key.length == 0) throw new ValidateError.EMPTY_STRING (_("Key is empty"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
            validate_string (alphabet, text, _("No such letter from key in alphabet"));
        }
    }
    
    namespace Caesar {
        void validate (string text, string key) throws ValidateError {
            int num;
            Alphabet alphabet = new Alphabet ();
            if (key.length == 0) throw new ValidateError.EMPTY_STRING (_("Key is empty"));
            if (!int.try_parse (key, out num)) throw new ValidateError.NOT_NUMBER (_("Key is not a valid number"));
            if (num < 1) throw new ValidateError.NUMBER_BELOW_ZERO (_("Number is below zero"));
            if (num >= alphabet.length) throw new ValidateError.INCORRECT_NUMBER (_("Number is bigger, than alphabet length"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    }
    
    namespace Matrix {
        int validate_n (string n) throws ValidateError {
            int num;
            if (n.length == 0) throw new ValidateError.EMPTY_STRING (_("n is empty"));
            if (!int.try_parse (n, out num)) throw new ValidateError.NOT_NUMBER (_("n is not a valid number"));
            if (num <= 1 || num > 10) throw new ValidateError.INCORRECT_NUMBER (_("n is below or equal one or greater than 10"));
            return num;
        }
    
        void validate (string text, bool state) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (!state) throw new ValidateError.NOT_STATED (_("Matrix not determined"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    
        void validate_int (string text) throws ValidateError {
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            Encryption.validate_int (text, _("Phrase should be only consist of numbers"));
        }
    }
    
    namespace Playfair {
        void validate (string text, string key) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            string playfair_alphabet = "абвгдежзиклмнопрстуфхцчшщъыэюя";
            var p_alphabet = new Alphabet.from_str (playfair_alphabet);
            if (key.length == 0) throw new ValidateError.EMPTY_STRING (_("Key is empty"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            if (!validate_key (key))
                    throw new ValidateError.WRONG_STRING_LENGTH(_("Key must contain only unique letters"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
            validate_string (p_alphabet, text, _("No such letter from key in alphabet"));
        }
    }
    
    namespace Polybius {
        void validate_string (
            string text, string rows, string columns, out int row, out int column
        ) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (rows.length == 0) throw new ValidateError.EMPTY_STRING (_("Rows count is empty"));
            if (!int.try_parse (rows, out row)) throw new ValidateError.NOT_NUMBER (_("Rows count is not a valid number"));
            if (row <= 0) throw new ValidateError.NUMBER_BELOW_ZERO (_("Rows count is below or equal zero"));
            if (columns.length == 0) throw new ValidateError.EMPTY_STRING (_("Columns count is empty"));
            if (!int.try_parse (columns, out column)) throw new ValidateError.NOT_NUMBER (_("Columns count is not a valid number"));
            if (column <= 0) throw new ValidateError.NUMBER_BELOW_ZERO (_("Columns count is below or equal zero"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            Encryption.validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    
        void validate_int (
            string text, string rows, string columns, out int row, out int column
        ) throws ValidateError {
            int num;
            if (rows.length == 0) throw new ValidateError.EMPTY_STRING (_("Rows count is empty"));
            if (!int.try_parse (rows, out row)) throw new ValidateError.NOT_NUMBER (_("Rows count is not a valid number"));
            if (row <= 0) throw new ValidateError.NUMBER_BELOW_ZERO (_("Rows count is below or equal zero"));
            if (columns.length == 0) throw new ValidateError.EMPTY_STRING (_("Columns count is empty"));
            if (!int.try_parse (columns, out column)) throw new ValidateError.NOT_NUMBER (_("Columns count is not a valid number"));
            if (column <= 0) throw new ValidateError.NUMBER_BELOW_ZERO (_("Columns count is below or equal zero"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            int i = 0;
            unichar letter;
            while (text.get_next_char (ref i, out letter)) {
                if (!int.try_parse (letter.to_string (), out num))
                    throw new ValidateError.NOT_NUMBER (_("Phrase should be only consist of numbers"));
                if (i%2 == 0 && num > row)
                    throw new ValidateError.INCORRECT_NUMBER (_("Row in string cannot be bigger than table rows count"));
                if (i%2 == 1 && num > column)
                    throw new ValidateError.INCORRECT_NUMBER (_("Column in string cannot be bigger than table columns count"));
            }
        }
    }
    
    namespace Scrambler {
        void validate_bin (string text, string mes) throws ValidateError {
            unichar buffer;
            for (int i = 0; i < text.char_count (); i++) {
                buffer = text.get_char (text.index_of_nth_char (i));
                if (buffer != '0' && buffer != '1') throw new ValidateError.INCORRECT_NUMBER (mes);
            }
        }
    
        void validate (string text, string scrambler1, string scrambler2, string key1, string key2) 
            throws ValidateError 
        {
            int num;
            Alphabet alphabet = new Alphabet ();
            if (scrambler1.length == 0) throw new ValidateError.EMPTY_STRING (_("First scrambler is empty"));
            if (!int.try_parse (scrambler1, out num))
                throw new ValidateError.NOT_NUMBER (_("First scrambler is not a valid number"));
            validate_bin (scrambler1, _("First scrambler can contain only 1 or 0"));
            if (scrambler2.length == 0) throw new ValidateError.EMPTY_STRING (_("Second scrambler is empty"));
            if (!int.try_parse (scrambler2, out num))
                throw new ValidateError.NOT_NUMBER (_("Second scrambler is not a valid number"));
            validate_bin (scrambler2, _("Second scrambler can contain only 1 or 0"));
            if (key1.length == 0) throw new ValidateError.EMPTY_STRING (_("First key is empty"));
            if (!int.try_parse (key1, out num))
                throw new ValidateError.NOT_NUMBER (_("First key is not a valid number"));
            validate_bin (key1, _("First key can contain only 1 or 0"));
            if (key2.length == 0) throw new ValidateError.EMPTY_STRING (_("Second key is empty"));
            if (!int.try_parse (key2, out num))
                throw new ValidateError.NOT_NUMBER (_("Second key is not a valid number"));
            validate_bin (key2, _("Second key can contain only 1 or 0"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    }
    
    namespace Shenon {
        void validate (string text, string t0, string a, string c) throws ValidateError {
            int num;
            Alphabet alphabet = new Alphabet ();
            if (t0.length == 0) throw new ValidateError.EMPTY_STRING (_("T0 is empty"));
            if (!int.try_parse (t0, out num)) throw new ValidateError.NOT_NUMBER (_("T0 is not a valid number"));
            if (num <= 0) throw new ValidateError.NUMBER_BELOW_ZERO (_("T0 is below or equal zero"));
            if (num > alphabet.length) throw new ValidateError.INCORRECT_NUMBER (_("T0 is bigger than alphabet length"));
            if (a.length == 0) throw new ValidateError.EMPTY_STRING (_("A is empty"));
            if (!int.try_parse (a, out num)) throw new ValidateError.NOT_NUMBER (_("A is not a valid number"));
            if (num <= 0) throw new ValidateError.NUMBER_BELOW_ZERO (_("A is below or equal zero"));
            if (num % 4 != 1) throw new ValidateError.INCORRECT_NUMBER (_("The remainder of A divided by 4 is not equal to 1"));
            if (c.length == 0) throw new ValidateError.EMPTY_STRING (_("C is empty"));
            if (!int.try_parse (c, out num)) throw new ValidateError.NOT_NUMBER (_("C is not a valid number"));
            if (num <= 0) throw new ValidateError.NUMBER_BELOW_ZERO (_("C is below or equal zero"));
            if (num % 2 == 0) throw new ValidateError.INCORRECT_NUMBER (_("C is not odd"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    }
    
    namespace Trithemium {
        void validate (string text) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
        }
    }

    namespace Vertical {
        void validate (string text, string key) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (key.length == 0) throw new ValidateError.EMPTY_STRING (_("Key is empty"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
            validate_string (alphabet, text, _("No such letter from key in alphabet"));
        }
    }

    namespace Vigenere {
        void validate (string text, string key) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (key.char_count () == 0) throw new ValidateError.EMPTY_STRING (_("Key is empty"));
            if (key.char_count () > 1) throw new ValidateError.WRONG_STRING_LENGTH (_("Key length is bigger than 1"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
            validate_string (alphabet, text, _("No such letter from key in alphabet"));
        }
    }

    namespace VigenereII {
        void validate (string text, string key) throws ValidateError {
            Alphabet alphabet = new Alphabet ();
            if (key.char_count () == 0) throw new ValidateError.EMPTY_STRING (_("Key is empty"));
            if (key.char_count () > 1) throw new ValidateError.WRONG_STRING_LENGTH (_("Key length is bigger than 1"));
            if (text.length == 0) throw new ValidateError.EMPTY_STRING (_("Text field is empty"));
            validate_string (alphabet, text, _("No such letter from phrase in alphabet"));
            validate_string (alphabet, text, _("No such letter from key in alphabet"));
        }
    }
}

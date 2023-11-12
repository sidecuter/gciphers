/* matrix.vala
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
    errordomain MatrixError {
        CODE_SIZE_NOT_MATCH,
        CODE_IS_NOT_N_X_N,
        CODE_ALL_ELEMENTS_IS_ZERO,
        CODE_ZERO_DETERMINANT
    }

    class Matrix : Object {
        public int rows { get; construct; }
        public int columns { get; construct; }
        public double[,] elements { get; private set; }

        public Matrix (int rows, int columns, double[,] elems) {
            Object (
                rows: rows,
                columns: columns
            );
            elements = elems.copy ();
        }

        public Matrix.from_int (int rows, int columns, int[,] elems) {
            Object (
                rows: rows,
                columns: columns
            );
            elements = new double[rows, columns];
            for (int i = 0; i < rows; i++) {
                for (int j = 0; j < columns; j++) {
                    elements[i, j] = (double) elems[i, j];
                }
            }
        }

        public double det () throws MatrixError {
            if (this.rows != this.columns)
                throw new MatrixError.CODE_IS_NOT_N_X_N ("This matrix is not square");
            if (this.rows == 1) return this.elements[0, 0];
            Matrix self = new Matrix(this.rows, this.columns, this.elements);
            double mnoj;
            double p = 1.0;
            bool isNull = false;
            if (self.elements[0, 0] == 0) {
                try {
                    self.swap_zero ();
                    p *= -1;
                }
                catch (MatrixError err) {
                    isNull = true;
                }
            }
            if (!isNull) {
                for (int i = 1; i < self.rows; i++) {
                    if (self.elements[i, 0] != 0) {
                        mnoj = self.elements[i, 0] / self.elements[0, 0];
                        for (int j = 0; j < self.columns; j++) 
                            self.elements[i, j] -= self.elements[0, j] * mnoj;
                    }
                }
                p *= self.elements[0, 0] * self.get_minor (0, 0).det ();
            }
            else p = 0;
            return p;
        }

        public Matrix trasnp () throws MatrixError {
            if (this.rows != this.columns)
                throw new MatrixError.CODE_IS_NOT_N_X_N ("This matrix is not square");
            double tmp;
            for (int i = 0; i < this.rows; i++)
            {
                for (int j = 0; j < i; j++)
                {
                    tmp = this.elements[i, j];
                    this.elements[i, j] = this.elements[j, i];
                    this.elements[j, i] = tmp;
                }
            }
            return this;
        }

        public Matrix get_minor (int iski, int iskj) throws MatrixError {
            if (this.rows != this.columns)
                throw new MatrixError.CODE_IS_NOT_N_X_N ("This matrix is not square");
            int r = this.rows - 1;
            int c = this.columns - 1;
            double[,] elems = new double[r,c];
            int k;
            int l = 0;
            for (int i = 0; i < this.rows; i++) {
                if (i != iski) {
                    k = 0;
                    for (int j = 0; j < this.columns; j++) {
                        if (j != iskj) {
                            elems[l, k] = this.elements[i, j];
                            k++;
                        }
                    }
                    l++;
                }
            }
            return new Matrix (r, c, elems);
        }

        public void swap_zero () throws MatrixError {
            bool flag = false;
            double tmp;
            for (int i = 0; i < this.rows; i++) {
                if (this.elements[i, 0] == 0 && !flag) {
                    for (int j = 0; j < this.columns; j++) {
                        tmp = elements[0, j];
                        elements[0, j] = elements[i , j];
                        elements[i, j] = tmp;
                    }
                    flag = true;
                }
            }
            if (!flag) throw new MatrixError.CODE_ALL_ELEMENTS_IS_ZERO ("");
        }

        public Matrix reverse () throws MatrixError {
            if (this.rows != this.columns)
                throw new MatrixError.CODE_IS_NOT_N_X_N ("This matrix is not square");
            double det = this.det ();
            if (det == 0) 
                throw new MatrixError.CODE_ZERO_DETERMINANT ("Determinant is zero");
            int r = this.rows;
            int c = this.columns;
            double[,] elems = new double[r, c];
            double mnoj = 1.0;
            for (int i = 0; i < this.rows; i++) {
                for (int j = 0; j < this.columns; j++) {
                    elems[i, j] = mnoj / det * this.get_minor (i, j).det ();
                    mnoj *= -1.0;
                }
                if (this.rows % 2 == 0) mnoj *= -1.0;
            }
            Matrix result = new Matrix (r, c, elems);
            return result.trasnp ();
        }

        public Matrix mult (Matrix m) throws MatrixError.CODE_SIZE_NOT_MATCH {
            if (this.columns != m.rows) 
                throw new MatrixError.CODE_SIZE_NOT_MATCH ("m1 != n2");
            double sum;
            double[,] elems = new double[this.rows, m.columns];
            for (int i = 0; i < this.rows; i++) {
                for (int j = 0; j < m.columns; j++) {
                    sum = 0.0;
                    for (int k = 0; k < this.columns; k++) {
                        sum += this.elements[i, k] * m.elements[k, j];
                    }
                    elems[i, j] = sum;
                }
            }
            return new Matrix (this.rows, m.columns, elems);
        }

        public double max () {
            double max = -double.MAX;
            for (int i = 0; i < this.rows; i++) {
                for (int j = 0; j < this.columns; j++) {
                    if (max < elements[i , j]) max = elements[i , j];
                }
            }
            return max;
        }
    }

    class MatrixCipher : Object {
        private static int count_digits (int number) {
            return number.to_string ().length;
        }

        private static bool check_det (Matrix matr) throws MatrixError {
            if (matr.det () == 0) return false;
            else return true;
        }

        private static List<Matrix> get_letters (Alphabet alphabet, string letters, int n) 
        throws Encryption.OOBError {
            int char_count = letters.char_count ();
            int count;
            if (char_count % 3 == 0) count = char_count / 3;
            else count = char_count / 3 + 1;
            List<Matrix> result = new List<Matrix> ();
            int[,] buffer = new int [n, 1];
            for (int i = 0; i < count; i++) {
                for (int j = 0; j < n; j++) {
                    if (i == count - 1 && i * n + j >= char_count) buffer[j, 0] = 1;
                    else buffer[j, 0] = alphabet.get_letter_index (
                        letters.get_char (
                            letters.index_of_nth_char (i * n + j)
                        )
                    ) + 1;
                }
                result.append (new Matrix.from_int (n, 1, buffer));
            }
            return result;
        }

        private static List<Matrix> get_numbers (
            string phrase,
            int avg_length,
            int n
        ) throws OOBError {
            string buffer;
            int[,] matr_buffer = new int[n, 1];
            List<Matrix> result = new List<Matrix> ();
            if ((phrase.char_count () / avg_length) % n != 0)
                throw new OOBError.CODE_OUT ("Not a valid phrase");
            for (int i = 0; i < phrase.char_count () / avg_length; i++) {
                buffer = "";
                for (int j = 0; j < avg_length; j++) {
                    buffer = string.join("", 
                        buffer,
                        phrase.get_char (
                            phrase.index_of_nth_char (i * avg_length + j)
                        ).to_string ()
                    );
                }
                matr_buffer[i % n, 0] = int.parse (buffer);
                if ((i + 1) % n == 0)
                    result.append (new Matrix.from_int (n, 1, matr_buffer));
            }
            /*  for (int i = 0; i < phrase.char_count () / n / avg_length; i++) {
                for (int j = 0; j < n; j++) {
                    buffer = "";
                    for (int k = 0; k < avg_length; k++) {
                        buffer = string.join("", 
                            buffer,
                            phrase.get_char (
                                phrase.index_of_nth_char (i * n + j * avg_length + k)
                            ).to_string ()
                        );
                    }
                    matr_buffer[j, 0] = int.parse (buffer);
                }
                result.append (new Matrix.from_int (n, 1, matr_buffer));
            }  */
            return result;
        }

        public static string encrypt (
            Encryption.Alphabet alphabet,
            string phrase,
            int r,
            int c,
            int[,] elems
        ) throws Encryption.OOBError {
            Matrix matr = new Matrix.from_int (r, c, elems);
            List<Matrix> result_m = new List<Matrix> ();
            string result = "";
            string buffer = "";
            try {
                if (!MatrixCipher.check_det (matr)) throw new OOBError.CODE_PASSTHROUGH ("Determinant is zero");
                List<Matrix> letters = MatrixCipher.get_letters (alphabet, phrase, matr.rows);
                foreach (var letter_m in letters) {
                    result_m.append (matr.mult (letter_m));
                }
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
            catch (MatrixError ex) {
                throw new OOBError.CODE_PASSTHROUGH (ex.message);
            }
            int count = MatrixCipher.count_digits (
                (int) matr.max () * (int) Math.round ((1 + alphabet.length) / 2) * matr.rows
            );
            string format = @"%0$(count)i";
            foreach (var letter_m in result_m) {
                for (int i = 0; i < letter_m.rows; i++) {
                    buffer = ((int)letter_m.elements[i, 0]).to_string (format);
                    result = @"$result$buffer";
                }
            }
            return result;
        }

        public static string decrypt (
            Encryption.Alphabet alphabet,
            string phrase,
            int r,
            int c,
            int[,] elems
        ) throws Encryption.OOBError {
            Matrix matr = new Matrix.from_int (r, c, elems);
            string result = "";
            string buffer = "";
            double temp;
            try {
                if (!check_det (matr)) throw new OOBError.CODE_PASSTHROUGH ("Determinant is zero");
                int count = MatrixCipher.count_digits (
                    (int) matr.max () * (int) Math.round ((1 + alphabet.length) / 2) * matr.rows
                );
                List<Matrix> numbers = MatrixCipher.get_numbers (phrase, count, matr.rows);
                matr = matr.reverse ();
                Matrix buff;
                foreach (var number_m in numbers) {
                    buff = matr.mult (number_m);
                    //buff = buff.round ();
                    for (int i = 0; i < buff.rows; i++) {
                        temp = Math.round (buff.elements[i, 0] * 100) / 100;
                        if ((double) ((int) temp) != temp)
                            throw new Encryption.OOBError.CODE_PASSTHROUGH ("Phrase contains wrong encrypted components");
                        buffer = alphabet.get_letter_by_index (((int) temp) - 1).to_string ();
                        result = @"$result$buffer";
                    }
                }
            }
            catch (Encryption.OOBError ex) {
                throw ex;
            }
            catch (MatrixError ex) {
                throw new OOBError.CODE_PASSTHROUGH (ex.message);
            }
            return result;
        }
    }
}

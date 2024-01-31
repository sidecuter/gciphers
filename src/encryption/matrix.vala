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

    namespace Matrix {
        class Matrix : Object {
            public int rows { get; construct; }
            public int columns { get; construct; }
            public Gee.ArrayList<double?> elements { get; private set; }
    
            public Matrix (int rows, int columns, double?[] elems) {
                Object (
                    rows: rows,
                    columns: columns
                );
                elements = new Gee.ArrayList<double?> ();
                elements.add_all_array (elems);
            }
    
            public Matrix.from_int (int rows, int columns, int[] elems) {
                Object (
                    rows: rows,
                    columns: columns
                );
                elements = new Gee.ArrayList<double?> ();
                foreach (var elem in elems) {
                    elements.add (elem);
                }
            }
    
            public Matrix.from_GeeArrayList (int rows, int columns, Gee.ArrayList<double?> elems) {
                Object (
                    rows: rows,
                    columns: columns
                );
                elements = new Gee.ArrayList<double?> ();
                foreach (var elem in elems) {
                    elements.add (elem);
                }
            }
    
            public double det () throws MatrixError {
                if (this.rows != this.columns)
                    throw new MatrixError.CODE_IS_NOT_N_X_N (_("This matrix is not square"));
                if (this.rows == 1) return this.elements.get(0);
                Matrix self = new Matrix.from_GeeArrayList (
                    this.rows,
                    this.columns,
                    this.elements
                );
                double mnoj;
                double p = 1.0;
                if (self.elements.get(0) == 0) {
                    try {
                        self.swap_zero ();
                        p *= -1;
                    }
                    catch (MatrixError err) {
                        return 0;
                    }
                }
                for (int i = 1; i < self.rows; i++) {
                    if (self.elements.get(i * self.columns) != 0) {
                        mnoj = self.elements.get(i * self.columns) / self.elements.get(0);
                        for (int j = 0; j < self.columns; j++) {
                            self.elements.set (
                                i * self.columns + j,
                                self.elements.get (i * self.columns + j) -
                                    self.elements.get(j) * mnoj
                            );
                        }
                    }
                }
                p *= self.elements.get(0) * self.get_minor (0, 0).det ();
                return p;
            }
    
            public Matrix trasnp () throws MatrixError {
                if (this.rows != this.columns)
                    throw new MatrixError.CODE_IS_NOT_N_X_N (_("This matrix is not square"));
                double tmp;
                for (int i = 0; i < this.rows; i++)
                {
                    for (int j = 0; j < i; j++)
                    {
                        tmp = this.elements.get(i * this.columns + j);
                        this.elements.set (
                            i * this.columns + j,
                            this.elements.get(j * this.columns + i)
                        );
                        this.elements.set (
                            j * this.columns + i,
                            tmp
                        );
                    }
                }
                return this;
            }
    
            public Matrix get_minor (int iski, int iskj) throws MatrixError {
                if (this.rows != this.columns)
                    throw new MatrixError.CODE_IS_NOT_N_X_N (_("This matrix is not square"));
                int r = this.rows - 1;
                int c = this.columns - 1;
                double?[] elems = new double?[r * c];
                int k;
                int l = 0;
                for (int i = 0; i < this.rows; i++) {
                    if (i != iski) {
                        k = 0;
                        for (int j = 0; j < this.columns; j++) {
                            if (j != iskj) {
                                elems[l * c + k] = this.elements.get(i * this.columns + j);
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
                    if (this.elements.get(i * this.columns) == 0 && !flag) {
                        for (int j = 0; j < this.columns; j++) {
                            tmp = elements.get(j);
                            elements.set(
                                j,
                                elements.get(i * this.columns + j)
                            );
                            elements.set(
                                i * this.columns + j,
                                tmp
                            );
                        }
                        flag = true;
                    }
                }
                if (!flag) throw new MatrixError.CODE_ALL_ELEMENTS_IS_ZERO ("");
            }
    
            public Matrix reverse () throws MatrixError {
                if (this.rows != this.columns)
                    throw new MatrixError.CODE_IS_NOT_N_X_N (_("This matrix is not square"));
                double det = this.det ();
                if (det == 0) 
                    throw new MatrixError.CODE_ZERO_DETERMINANT (_("Determinant is zero"));
                int r = this.rows;
                int c = this.columns;
                double?[] elems = new double?[r * c];
                double mnoj = 1.0;
                for (int i = 0; i < this.rows; i++) {
                    for (int j = 0; j < this.columns; j++) {
                        elems[i * c + j] = mnoj / det * this.get_minor (i, j).det ();
                        mnoj *= -1.0;
                    }
                    if (this.rows % 2 == 0) mnoj *= -1.0;
                }
                Matrix result = new Matrix (r, c, elems);
                return result.trasnp ();
            }
    
            public Matrix mult (Matrix m) throws MatrixError.CODE_SIZE_NOT_MATCH {
                if (this.columns != m.rows) 
                    throw new MatrixError.CODE_SIZE_NOT_MATCH (_("m1 != n2"));
                double sum;
                double?[] elems = new double?[this.rows * m.columns];
                for (int i = 0; i < this.rows; i++) {
                    for (int j = 0; j < m.columns; j++) {
                        sum = 0.0;
                        for (int k = 0; k < this.columns; k++) {
                            sum += this.elements.get(i * this.columns + k) *
                                m.elements.get(k * m.columns + j);
                        }
                        elems[i * m.columns + j] = sum;
                    }
                }
                return new Matrix (this.rows, m.columns, elems);
            }
    
            public double max () {
                double max = -double.MAX;
                for (int i = 0; i < this.rows; i++) {
                    for (int j = 0; j < this.columns; j++) {
                        if (max < elements.get(i * this.columns + j))
                            max = elements.get(i * this.columns + j);
                    }
                }
                return max;
            }
        }

        int count_digits (int number) {
            return number.to_string ().length;
        }

        bool check_det (Matrix matr) throws MatrixError {
            if (matr.det () == 0) return false;
            else return true;
        }

        List<Matrix> get_letters (Alphabet alphabet, string letters, int n) 
        throws Encryption.OOBError {
            unichar letter;
            int count, k = 0, char_count = letters.char_count ();
            if (char_count % 3 == 0) count = char_count / 3;
            else count = char_count / 3 + 1;
            List<Matrix> result = new List<Matrix> ();
            int[] buffer = new int [n];
            for (int i = 0; i < count; i++) {
                for (int j = 0; j < n; j++) {
                    if (!letters.get_next_char (ref k, out letter)) buffer[j] = 1;
                    else buffer[j] = alphabet.index_of (letter) + 1;
                }
                result.append (new Matrix.from_int (n, 1, buffer));
            }
            return result;
        }

        List<Matrix> get_numbers (
            string phrase,
            int avg_length,
            int n
        ) throws OOBError {
            string buffer;
            int[] matr_buffer = new int[n];
            List<Matrix> result = new List<Matrix> ();
            if ((phrase.char_count () / avg_length) % n != 0)
                throw new OOBError.CODE_OUT (_("Not a valid phrase"));
            for (int i = 0; i < phrase.char_count () / avg_length; i++) {
                buffer = "";
                for (int j = 0; j < avg_length; j++) {
                    buffer = string.join("", 
                        buffer,
                        phrase[i * avg_length + j].to_string ()
                    );
                }
                matr_buffer[i % n] = int.parse (buffer);
                if ((i + 1) % n == 0)
                    result.append (new Matrix.from_int (n, 1, matr_buffer));
            }
            return result;
        }

        string encrypt (
            Encryption.Alphabet alphabet,
            string phrase,
            int r,
            int c,
            int[] elems
        ) throws Encryption.OOBError {
            Matrix matr = new Matrix.from_int (r, c, elems);
            List<Matrix> result_m = new List<Matrix> ();
            string result = "";
            string buffer = "";
            try {
                if (!check_det (matr)) throw new OOBError.CODE_PASSTHROUGH (_("Determinant is zero"));
                List<Matrix> letters = get_letters (alphabet, phrase, matr.rows);
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
            int count = count_digits (
                (int) matr.max () * (int) Math.round ((1 + alphabet.length) / 2) * matr.rows
            );
            string format = @"%0$(count)i";
            foreach (var letter_m in result_m) {
                for (int i = 0; i < letter_m.rows; i++) {
                    buffer = ((int)letter_m.elements.get(i)).to_string (format);
                    result = @"$result$buffer";
                }
            }
            return result;
        }

        string decrypt (
            Encryption.Alphabet alphabet,
            string phrase,
            int r,
            int c,
            int[] elems
        ) throws Encryption.OOBError {
            Matrix matr = new Matrix.from_int (r, c, elems);
            string result = "";
            string buffer = "";
            double temp;
            try {
                if (!check_det (matr)) throw new OOBError.CODE_PASSTHROUGH (_("Determinant is zero"));
                int count = count_digits (
                    (int) matr.max () * (int) Math.round ((1 + alphabet.length) / 2) * matr.rows
                );
                List<Matrix> numbers = get_numbers (phrase, count, matr.rows);
                matr = matr.reverse ();
                Matrix buff;
                foreach (var number_m in numbers) {
                    buff = matr.mult (number_m);
                    for (int i = 0; i < buff.rows; i++) {
                        temp = Math.round (buff.elements.get(i) * 100) / 100;
                        if ((double) ((int) temp) != temp)
                            throw new Encryption.OOBError.CODE_PASSTHROUGH (_("Phrase contains wrong encrypted components"));
                        buffer = alphabet[((int) temp) - 1].to_string ();
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

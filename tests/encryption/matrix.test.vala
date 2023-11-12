using Encryption;

public void test_matrix_max () {
    int[,] elems = {
        {2, 4},
        {4, 3}
    };
    Encryption.Matrix matr = new Encryption.Matrix.from_int (
        2,
        2,
        elems
    );
    assert_cmpfloat (4, GLib.CompareOperator.EQ, matr.max ());
}

public void test_matrix_det () {
    try {
        int[,] elems = {
            {2, 4},
            {4, 3}
        };
        Encryption.Matrix matr = new Encryption.Matrix.from_int (
            2,
            2,
            elems
        );
        assert_cmpfloat (-10, GLib.CompareOperator.EQ, matr.det ());
    }
    catch (Encryption.MatrixError ex) {
        assert_true (false);
    }
}

public void test_matrix_reverse () {
    try {
        int[,] elems = {
            {2, 4},
            {4, 3}
        };
        int[,] elems_E = {
            {1, 0},
            {0, 1}
        };
        
        Encryption.Matrix matr = new Encryption.Matrix.from_int (
            2,
            2,
            elems
        );
        Encryption.Matrix matr_E = new Encryption.Matrix.from_int (
            2,
            2,
            elems_E
        );
        Encryption.Matrix matr_r_mult_matr = matr.reverse ().mult (matr);
        for (int i = 0; i < matr_r_mult_matr.rows; i++) {
            for (int j = 0; j < matr_r_mult_matr.columns; j++) {
                assert_cmpfloat (
                    matr_E.elements[i, j],
                    GLib.CompareOperator.EQ,
                    matr_r_mult_matr.elements[i, j]
                );
            }
        }
    }
    catch (Encryption.MatrixError ex) {
        assert_true (false);
    }
}

public void test_matrix_ru_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        int[,] elems = {
            {2, 5, 6},
            {4, 3, 2},
            {7, 1, 5},
        };
        assert_cmpstr (
            "215147199170092124179093123259159242172096131275125203154074101045053093276136205129073076045043077091089122146060108224170212",
            GLib.CompareOperator.EQ,
            Encryption.MatrixCipher.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                3,
                3,
                elems
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_matrix_ru_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        int[,] elems = {
            {2, 5, 6},
            {4, 3, 2},
            {7, 1, 5},
        };
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.MatrixCipher.decrypt (
                alphabet,
                "215147199170092124179093123259159242172096131275125203154074101045053093276136205129073076045043077091089122146060108224170212",
                3,
                3,
                elems
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/matrix_enc", test_matrix_ru_enc);
    Test.add_func ("/encryption/matrix_dec", test_matrix_ru_dec);
    Test.add_func ("/encryption/matrix_max", test_matrix_max);
    Test.add_func ("/encryption/matrix_det", test_matrix_det);
    Test.add_func ("/encryption/matrix_reverse", test_matrix_reverse);
    return Test.run ();
}

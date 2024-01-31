using Encryption;
using Encryption.Matrix;

public void test_matrix_max () {
    int[] elems = {
        2, 4,
        4, 3
    };
    Matr matr = new Matr.from_int (
        2,
        2,
        elems
    );
    assert_cmpfloat (4, CompareOperator.EQ, matr.max ());
}

public void test_matrix_det () {
    try {
        int[] elems = {
            2, 4,
            4, 3
        };
        Matr matr = new Matr.from_int (
            2,
            2,
            elems
        );
        assert_cmpfloat (-10, CompareOperator.EQ, matr.det ());
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_matrix_reverse () {
    try {
        int[] elems = {
            2, 4,
            4, 3
        };
        int[] elems_E = {
            1, 0,
            0, 1
        };
        
        Matr matr = new Matr.from_int (
            2,
            2,
            elems
        );
        Matr matr_E = new Matr.from_int (
            2,
            2,
            elems_E
        );
        Matr matr_r_mult_matr = matr.reverse ().mult (matr);
        for (int i = 0; i < matr_r_mult_matr.rows; i++) {
            for (int j = 0; j < matr_r_mult_matr.columns; j++) {
                assert_cmpfloat (
                    matr_E.elements.get(i * matr_E.columns + j),
                    CompareOperator.EQ,
                    matr_r_mult_matr.elements.get(i * matr_r_mult_matr.columns + j)
                );
            }
        }
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_matrix_enc () {
    try {
        int[] elems = {
            2, 5, 6,
            4, 3, 2,
            7, 1, 5,
        };
        assert_cmpstr (
            "215147199170092124179093123259159242172096131275125203154074101045053093276136205129073076045043077091089122146060108224170212",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                3,
                3,
                elems
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_matrix_dec () {
    try {
        int[] elems = {
            2, 5, 6,
            4, 3, 2,
            7, 1, 5,
        };
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt (
                "215147199170092124179093123259159242172096131275125203154074101045053093276136205129073076045043077091089122146060108224170212",
                3,
                3,
                elems
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/matrix_enc", test_matrix_enc);
    Test.add_func ("/encryption/matrix_dec", test_matrix_dec);
    Test.add_func ("/encryption/matrix_max", test_matrix_max);
    Test.add_func ("/encryption/matrix_det", test_matrix_det);
    Test.add_func ("/encryption/matrix_reverse", test_matrix_reverse);
    return Test.run ();
}

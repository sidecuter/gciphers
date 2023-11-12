using Encryption;

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
    return Test.run ();
}

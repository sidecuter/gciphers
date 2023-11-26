using Encryption;

public void test_caesar_ru_shift_3_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "схсзрсжстсуъирсжсвдоснгеифяесккгжрлегиххън",
            GLib.CompareOperator.EQ,
            Encryption.Caesar.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                3
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_4_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "тцтистзтутфыйстзтгептоджйхажтллдзсмждйццыо",
            GLib.CompareOperator.EQ,
            Encryption.Caesar.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                4
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_3_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.Caesar.decrypt(
                alphabet,
                "схсзрсжстсуъирсжсвдоснгеифяесккгжрлегиххън",
                3
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_4_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.Caesar.decrypt(
                alphabet,
                "тцтистзтутфыйстзтгептоджйхажтллдзсмждйццыо",
                4
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/caesar_3_enc", test_caesar_ru_shift_3_enc);
    Test.add_func ("/encryption/caesar_4_enc", test_caesar_ru_shift_4_enc);
    Test.add_func ("/encryption/caesar_3_dec", test_caesar_ru_shift_3_dec);
    Test.add_func ("/encryption/caesar_4_dec", test_caesar_ru_shift_4_dec);
    return Test.run ();
}

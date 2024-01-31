using Encryption;

public void test_caesar_ru_shift_3_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "схсзрсжстсуъирсжсвдоснгеифяесккгжрлегиххън",
            GLib.CompareOperator.EQ,
            Caesar.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                3
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_4_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "тцтистзтутфыйстзтгептоджйхажтллдзсмждйццыо",
            GLib.CompareOperator.EQ,
            Caesar.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                4
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_3_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Caesar.decrypt(
                alphabet,
                "схсзрсжстсуъирсжсвдоснгеифяесккгжрлегиххън",
                3
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_4_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Caesar.decrypt(
                alphabet,
                "тцтистзтутфыйстзтгептоджйхажтллдзсмждйццыо",
                4
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/caesar_3_enc", test_caesar_ru_shift_3_enc);
    Test.add_func ("/encryption/caesar_4_enc", test_caesar_ru_shift_4_enc);
    Test.add_func ("/encryption/caesar_3_dec", test_caesar_ru_shift_3_dec);
    Test.add_func ("/encryption/caesar_4_dec", test_caesar_ru_shift_4_dec);
    return Test.run ();
}

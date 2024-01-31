using Encryption;
using Encryption.Caesar;

public void test_caesar_ru_shift_3_enc () {
    try {
        assert_cmpstr (
            "схсзрсжстсуъирсжсвдоснгеифяесккгжрлегиххън",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                3
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_4_enc () {
    try {
        assert_cmpstr (
            "тцтистзтутфыйстзтгептоджйхажтллдзсмждйццыо",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                4
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_3_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt(
                "схсзрсжстсуъирсжсвдоснгеифяесккгжрлегиххън",
                3
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_caesar_ru_shift_4_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt(
                "тцтистзтутфыйстзтгептоджйхажтллдзсмждйццыо",
                4
            )
        );
    }
    catch (Error ex) {
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

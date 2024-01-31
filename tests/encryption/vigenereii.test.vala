using Encryption.VigenereII;

public void test_vigenereii_enc () {
    try {
        assert_cmpstr (
            "тдтцгсфвсяпжлшжйчцчвръъьбторюеммпьджжлэпжр",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "д"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_vigenereii_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt (
                "тдтцгсфвсяпжлшжйчцчвръъьбторюеммпьджжлэпжр",
                "д"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/vigenereii_enc", test_vigenereii_enc);
    Test.add_func ("/encryption/vigenereii_dec", test_vigenereii_dec);
    return Test.run ();
}

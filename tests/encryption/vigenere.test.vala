using Encryption;
using Encryption.Vigenere;

public void test_vigenere_enc () {
    try {
        assert_cmpstr (
            "маатсыссээюзьтысснамщшквзцнюрхозгрхквечдйб",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "ю"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_vigenere_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt (
                "маатсыссээюзьтысснамщшквзцнюрхозгрхквечдйб",
                "ю"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/vigenere_enc", test_vigenere_enc);
    Test.add_func ("/encryption/vigenere_dec", test_vigenere_dec);
    return Test.run ();
}

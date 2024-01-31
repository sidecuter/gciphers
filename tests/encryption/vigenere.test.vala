using Encryption;

public void test_vigenere_enc () {
    Alphabet alphabet = new Alphabet();
    try {
        assert_cmpstr (
            "маатсыссээюзьтысснамщшквзцнюрхозгрхквечдйб",
            GLib.CompareOperator.EQ,
            Encryption.Vigenere.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "ю"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_vigenere_dec () {
    Alphabet alphabet = new Alphabet();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.Vigenere.decrypt (
                alphabet,
                "маатсыссээюзьтысснамщшквзцнюрхозгрхквечдйб",
                "ю"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/vigenere_enc", test_vigenere_enc);
    Test.add_func ("/encryption/vigenere_dec", test_vigenere_dec);
    return Test.run ();
}

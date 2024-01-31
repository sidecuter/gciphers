using Encryption;

public void test_vigenere_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "маатсыссээюзьтысснамщшквзцнюрхозгрхквечдйб",
            GLib.CompareOperator.EQ,
            Vigenere.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "ю"
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_vigenere_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Vigenere.decrypt (
                alphabet,
                "маатсыссээюзьтысснамщшквзцнюрхозгрхквечдйб",
                "ю"
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/vigenere_enc", test_vigenere_enc);
    Test.add_func ("/encryption/vigenere_dec", test_vigenere_dec);
    return Test.run ();
}

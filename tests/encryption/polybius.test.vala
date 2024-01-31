using Encryption;

public void test_polybius_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "334133153233143334333546163233143362122633251113163655133322221114322313111641414625",
            GLib.CompareOperator.EQ,
            Polybius.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                6,
                6
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_polybius_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Polybius.decrypt (
                alphabet,
                "334133153233143334333546163233143362122633251113163655133322221114322313111641414625",
                6,
                6
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/polybius_enc", test_polybius_enc);
    Test.add_func ("/encryption/polybius_dec", test_polybius_dec);
    return Test.run ();
}

using Encryption;

public void test_polybius_ru_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "334133153233143334333546163233143362122633251113163655133322221114322313111641414625",
            GLib.CompareOperator.EQ,
            Encryption.Polybius.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                6,
                6
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_polybius_ru_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.Polybius.decrypt (
                alphabet,
                "334133153233143334333546163233143362122633251113163655133322221114322313111641414625",
                6,
                6
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/polybius_enc", test_polybius_ru_enc);
    Test.add_func ("/encryption/polybius_dec", test_polybius_ru_dec);
    return Test.run ();
}
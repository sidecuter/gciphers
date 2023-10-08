using Encryption;

public void test_vigenereii_ru_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "тдтцгсфвсяпжлшжйчцчвръъьбторюеммпьджжлэпжр",
            GLib.CompareOperator.EQ,
            Encryption.VigenereII.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "д"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_vigenereii_ru_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.VigenereII.decrypt (
                alphabet,
                "тдтцгсфвсяпжлшжйчцчвръъьбторюеммпьджжлэпжр",
                "д"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/vigenereii_enc", test_vigenereii_ru_enc);
    Test.add_func ("/encryption/vigenereii_dec", test_vigenereii_ru_dec);
    return Test.run ();
}
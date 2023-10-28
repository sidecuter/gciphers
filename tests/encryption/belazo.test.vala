using Encryption;

public void test_belazo_ru_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
            GLib.CompareOperator.EQ,
            Encryption.Belazo.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "арбуз"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_belazo_ru_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.Belazo.decrypt (
                alphabet,
                "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
                "арбуз"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/belazo_enc", test_belazo_ru_enc);
    Test.add_func ("/encryption/belazo_dec", test_belazo_ru_dec);
    return Test.run ();
}

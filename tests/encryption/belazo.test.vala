using Encryption;

public void test_belazo_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
            GLib.CompareOperator.EQ,
            Belazo.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "арбуз"
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_belazo_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Belazo.decrypt (
                alphabet,
                "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
                "арбуз"
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/belazo_enc", test_belazo_enc);
    Test.add_func ("/encryption/belazo_dec", test_belazo_dec);
    return Test.run ();
}

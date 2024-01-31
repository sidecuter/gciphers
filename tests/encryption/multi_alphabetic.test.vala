using Encryption;

public void test_multi_alphabetic_enc () {
    Alphabet alphabet = new Alphabet();
    try {
        assert_cmpstr (
            "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
            GLib.CompareOperator.EQ,
            Encryption.MultiAlphabetic.encrypt(
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

public void test_multi_alphabetic_dec () {
    Alphabet alphabet = new Alphabet();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.MultiAlphabetic.decrypt (
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
    Test.add_func ("/encryption/multi_alphabetic_enc", test_multi_alphabetic_enc);
    Test.add_func ("/encryption/multi_alphabetic_dec", test_multi_alphabetic_dec);
    return Test.run ();
}

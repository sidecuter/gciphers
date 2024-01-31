using Encryption;

public void test_multi_alphabetic_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
            GLib.CompareOperator.EQ,
            MultiAlphabetic.encrypt(
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

public void test_multi_alphabetic_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            MultiAlphabetic.decrypt (
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
    Test.add_func ("/encryption/multi_alphabetic_enc", test_multi_alphabetic_enc);
    Test.add_func ("/encryption/multi_alphabetic_dec", test_multi_alphabetic_dec);
    return Test.run ();
}

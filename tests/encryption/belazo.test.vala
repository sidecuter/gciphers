using Encryption;

public void test_belazo_enc () {
    try {
        assert_cmpstr (
            "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
            CompareOperator.EQ,
            Belazo.encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "арбуз"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_belazo_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            Belazo.decrypt (
                "овпчфоупвхрзжахгюафтоъбхмсмгбозрдапвржещчъ",
                "арбуз"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/belazo_enc", test_belazo_enc);
    Test.add_func ("/encryption/belazo_dec", test_belazo_dec);
    return Test.run ();
}

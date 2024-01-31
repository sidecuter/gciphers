using Encryption;

public void test_shenon_enc () {
    Alphabet alphabet = new Alphabet();
    try {
        assert_cmpstr (
            "очалсчщщчыкжсюмцюфгввгжээожбкихггтъйдоиэяч",
            GLib.CompareOperator.EQ,
            Encryption.Shenon.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                3, 
                9, 
                5
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_shenon_dec () {
    Alphabet alphabet = new Alphabet();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.Shenon.decrypt (
                alphabet,
                "очалсчщщчыкжсюмцюфгввгжээожбкихггтъйдоиэяч",
                3,
                9,
                5
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/shenon_enc", test_shenon_enc);
    Test.add_func ("/encryption/shenon_dec", test_shenon_dec);
    return Test.run ();
}

using Encryption;
using Encryption.Shenon;

public void test_shenon_enc () {
    try {
        assert_cmpstr (
            "очалсчщщчыкжсюмцюфгввгжээожбкихггтъйдоиэяч",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                3, 
                9, 
                5
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_shenon_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt (
                "очалсчщщчыкжсюмцюфгввгжээожбкихггтъйдоиэяч",
                3,
                9,
                5
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/shenon_enc", test_shenon_enc);
    Test.add_func ("/encryption/shenon_dec", test_shenon_dec);
    return Test.run ();
}

using Encryption;
using Encryption.Trithemium;

public void test_trithemium_enc () {
    try {
        assert_cmpstr (
            "оурзсуйхччъвсъьтюруювяцщэкцэкдеягокедкшщяу",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_trithemium_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt (
                "оурзсуйхччъвсъьтюруювяцщэкцэкдеягокедкшщяу"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/trithemium_enc", test_trithemium_enc);
    Test.add_func ("/encryption/trithemium_dec", test_trithemium_dec);
    return Test.run ();
}

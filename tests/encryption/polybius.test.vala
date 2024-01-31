using Encryption;
using Encryption.Polybius;

public void test_polybius_enc () {
    try {
        assert_cmpstr (
            "334133153233143334333546163233143362122633251113163655133322221114322313111641414625",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                6,
                6
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_polybius_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt (
                "334133153233143334333546163233143362122633251113163655133322221114322313111641414625",
                6,
                6
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/polybius_enc", test_polybius_enc);
    Test.add_func ("/encryption/polybius_dec", test_polybius_dec);
    return Test.run ();
}

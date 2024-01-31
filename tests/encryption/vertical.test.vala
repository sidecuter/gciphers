using Encryption;
using Encryption.Vertical;

public void test_vertical_methods_get_order () {
    Alphabet alphabet = new Alphabet ();
    try {
        string key = "супчик";
        int[] positions = {4, 5, 3, 6, 1, 2};
        int[] res_pos = Methods.get_order (alphabet, key);
        assert_cmpint (
            key.char_count (),
            CompareOperator.EQ,
            res_pos.length
        );
        assert_cmpint (
            positions.length,
            CompareOperator.EQ,
            res_pos.length
        );
        for (int i = 0; i < res_pos.length; i++) {
            assert_cmpint (
                positions[i],
                CompareOperator.EQ,
                res_pos[i]
            );
        }
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_vertical_enc () {
    try {
        assert_cmpstr (
            "нооотдрчпгооояоенгавоблкозьесвивгзанчктает",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "супчик"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_vertical_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            decrypt (
                "нооотдрчпгооояоенгавоблкозьесвивгзанчктает",
                "супчик"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/vertical_enc", test_vertical_enc);
    Test.add_func ("/encryption/vertical_dec", test_vertical_dec);
    Test.add_func ("/encryption/vertical_methods_get_order", test_vertical_methods_get_order);
    return Test.run ();
}

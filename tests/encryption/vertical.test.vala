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
            GLib.CompareOperator.EQ,
            res_pos.length
        );
        assert_cmpint (
            positions.length,
            GLib.CompareOperator.EQ,
            res_pos.length
        );
        for (int i = 0; i < res_pos.length; i++) {
            assert_cmpint (
                positions[i],
                GLib.CompareOperator.EQ,
                res_pos[i]
            );
        }
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_vertical_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "нооотдрчпгооояоенгавоблкозьесвивгзанчктает",
            GLib.CompareOperator.EQ,
            encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "супчик"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_vertical_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            decrypt (
                alphabet,
                "нооотдрчпгооояоенгавоблкозьесвивгзанчктает",
                "супчик"
            )
        );
    }
    catch (OOBError ex) {
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

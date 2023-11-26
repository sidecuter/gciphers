using Encryption;

public void test_vertical_methods_get_order () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        string key = "супчик";
        int[] positions = {4, 5, 3, 6, 1, 2};
        int[] res_pos = VerticalMethods.get_order (alphabet, key);
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
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_vertical_ru_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "нооотдрчпгооояоенгавоблкозьесвивгзанчктает",
            GLib.CompareOperator.EQ,
            Encryption.Vertical.encrypt(
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

/*  public void test_vertical_ru_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "тцтистзтутфыйстзтгептоджйхажтллдзсмждйццыо",
            GLib.CompareOperator.EQ,
            Encryption.Vertical.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                4
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}  */

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/vertical_ru_enc", test_vertical_ru_enc);
    /*  Test.add_func ("/encryption/vertical_ru_dec", test_vertical_ru_dec);  */
    Test.add_func ("/encryption/vertical_methods_get_order", test_vertical_methods_get_order);
    return Test.run ();
}

using Encryption;

public void test_alphabet_ru () {
    Alphabet alphabet = new Alphabet();
    try {
        assert_cmpint (
            32,
            GLib.CompareOperator.EQ,
            alphabet.length
        );
        assert_cmpstr (
            "а",
            GLib.CompareOperator.EQ,
            alphabet[0].to_string ()
        );
        string letter = "я";
        assert_cmpint (
            31,
            GLib.CompareOperator.EQ,
            alphabet.index_of (letter.get_char (0))
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/alphabet_ru", test_alphabet_ru);
    return Test.run ();
}

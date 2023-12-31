using Encryption;

public void test_alphabet_ru () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
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

public void test_alphabet_ru_full () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru_full);
    try {
        assert_cmpint (
            33,
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
            32,
            GLib.CompareOperator.EQ,
            alphabet.index_of (letter.get_char (0))
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_alphabet_en () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.en);
    try {
        assert_cmpint (
            26,
            GLib.CompareOperator.EQ,
            alphabet.length
        );
        assert_cmpstr (
            "a",
            GLib.CompareOperator.EQ,
            alphabet[0].to_string ()
        );
        string letter = "z";
        assert_cmpint (
            25,
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
    Test.add_func ("/encryption/alphabet_ru_full", test_alphabet_ru_full);
    Test.add_func ("/encryption/alphabet_en", test_alphabet_en);
    return Test.run ();
}

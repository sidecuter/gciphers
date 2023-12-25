using Encryption;

public void test_playfair_key_validation () {
    string key = "респавн";
    assert_true (Playfair.validate_key (key));
}

/*  public void test_playfair_ru_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {

    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_playfair_ru_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {

    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}  */

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/playfair_key_validation", test_playfair_key_validation);
    //  Test.add_func ("/encryption/playfair_enc", test_playfair_ru_enc);
    //  Test.add_func ("/encryption/playfair_dec", test_playfair_ru_dec);
    return Test.run ();
}

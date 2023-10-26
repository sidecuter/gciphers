using Encryption;

public void test_xor_0 () {
    assert_cmpstr (
        "0",
        GLib.CompareOperator.EQ,
        Register.xor ('1', '1').to_string ()
    );
}

public void test_xor_1 () {
    assert_cmpstr (
        "1",
        GLib.CompareOperator.EQ,
        Register.xor ('1', '0').to_string ()
    );
}

public void test_scrambler_ru_enc () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "яндчшэъплкюхтбсдипхмшшвъиюфзаязуккбдйквшмю",
            GLib.CompareOperator.EQ,
            Encryption.Scrambler.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "10111",
                "1001",
                "10101",
                "1001"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public void test_scrambler_ru_dec () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Encryption.Scrambler.encrypt (
                alphabet,
                "яндчшэъплкюхтбсдипхмшшвъиюфзаязуккбдйквшмю",
                "10111",
                "1001",
                "10101",
                "1001"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/scrambler_enc", test_scrambler_ru_enc);
    Test.add_func ("/encryption/scrambler_dec", test_scrambler_ru_dec);
    Test.add_func ("/encryption/scrambler_register_xor_0", test_xor_0);
    Test.add_func ("/encryption/scrambler_register_xor_1", test_xor_1);
    return Test.run ();
}
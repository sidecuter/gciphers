using Encryption;

public void test_xor_0 () {
    assert_cmpstr (
        "0",
        GLib.CompareOperator.EQ,
        Register.xor ('0', '0').to_string ()
    );
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
        Register.xor ('0', '1').to_string ()
    );
    assert_cmpstr (
        "1",
        GLib.CompareOperator.EQ,
        Register.xor ('1', '0').to_string ()
    );
}

public void test_register_shift () {
    Encryption.Register reg = new Encryption.Register ("10111", "10101");
    assert_cmpint (5, GLib.CompareOperator.EQ, reg.size);
    char shift = reg.shift ();
    assert_cmpint (shift, GLib.CompareOperator.EQ, '1');
    shift = reg.shift ();
    assert_cmpstr ("01101", GLib.CompareOperator.EQ, reg.value);
    assert_cmpint (shift, GLib.CompareOperator.EQ, '0');
}

public void test_register_convert () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        List<char> bits = Encryption.Register.convert_to_bits ("ая", alphabet);
        string res_bits = "000001100000";
        for (int i = 0; i < bits.length (); i++) {
            assert_true (bits.nth (i).data == res_bits[i]);
        }
        string res = Encryption.Register.convert_to_letters (bits, alphabet);
        assert_cmpstr ("ая", GLib.CompareOperator.EQ, res);
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
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
    Test.add_func ("/encryption/scrambler_register_shift", test_register_shift);
    Test.add_func ("/encryption/scrambler_register_convert", test_register_convert);
    return Test.run ();
}

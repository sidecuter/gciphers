using Encryption;

public void test_register_shift () {
    Encryption.Scrambler.Register reg = new Encryption.Scrambler.Register (5, "10111", "10101");
    assert_cmpint (5, GLib.CompareOperator.EQ, reg.size);
    uint8 shift = reg.shift ();
    assert_cmpint (shift, GLib.CompareOperator.EQ, 1);
    shift = reg.shift ();
    assert_cmpint (13, GLib.CompareOperator.EQ, reg.value);
    assert_cmpint (shift, GLib.CompareOperator.EQ, 0);
}

public void test_scrambler_enc () {
    Alphabet alphabet = new Alphabet();
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

public void test_scrambler_dec () {
    Alphabet alphabet = new Alphabet();
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
    Test.add_func ("/encryption/scrambler_enc", test_scrambler_enc);
    Test.add_func ("/encryption/scrambler_dec", test_scrambler_dec);
    Test.add_func ("/encryption/scrambler_register_shift", test_register_shift);
    return Test.run ();
}

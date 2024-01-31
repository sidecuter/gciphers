using Encryption;
using Encryption.Scrambler;

public void test_register_shift () {
    Register reg = new Register (5, "10111", "10101");
    assert_cmpint (5, CompareOperator.EQ, reg.size);
    uint8 shift = reg.shift ();
    assert_cmpint (shift, CompareOperator.EQ, 1);
    shift = reg.shift ();
    assert_cmpint (13, CompareOperator.EQ, reg.value);
    assert_cmpint (shift, CompareOperator.EQ, 0);
}

public void test_scrambler_enc () {
    try {
        assert_cmpstr (
            "яндчшэъплкюхтбсдипхмшшвъиюфзаязуккбдйквшмю",
            CompareOperator.EQ,
            encrypt(
                "отодногопорченогояблокавесьвоззагниваеттчк",
                "10111",
                "1001",
                "10101",
                "1001"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

public void test_scrambler_dec () {
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            CompareOperator.EQ,
            encrypt (
                "яндчшэъплкюхтбсдипхмшшвъиюфзаязуккбдйквшмю",
                "10111",
                "1001",
                "10101",
                "1001"
            )
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/scrambler_enc", test_scrambler_enc);
    Test.add_func ("/encryption/scrambler_dec", test_scrambler_dec);
    Test.add_func ("/encryption/scrambler_register_shift", test_register_shift);
    return Test.run ();
}

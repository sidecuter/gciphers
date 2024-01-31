using Encryption;
using Encryption.Playfair;

public void test_playfair_key_validation () {
    string key = "респавн";
    assert_true (validate_key (key));
}

public void test_playfair_enc () {
    assert_cmpstr (
        "тимжжижламаурблжтюгктлврспяетжжвдбтрвскшошое",
        CompareOperator.EQ,
        encrypt (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            "респавн"
        )
    );
}

public void test_playfair_dec () {
    assert_cmpstr (
        "отодногопорченогояблокавесъвоззагниваетфтчка",
        CompareOperator.EQ,
        decrypt (
            "тимжжижламаурблжтюгктлврспяетжжвдбтрвскшошое",
            "респавн"
        )
    );
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/playfair_key_validation", test_playfair_key_validation);
    Test.add_func ("/encryption/playfair_enc", test_playfair_enc);
    Test.add_func ("/encryption/playfair_dec", test_playfair_dec);
    return Test.run ();
}

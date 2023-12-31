using Encryption;

public void test_playfair_key_validation () {
    string key = "респавн";
    assert_true (Playfair.validate_key (key));
}

public void test_playfair_ru_enc () {
    assert_cmpstr (
        "тимжжижламаурблжтюгктлврспяетжжвдбтрвскшошое",
        GLib.CompareOperator.EQ,
        Playfair.encrypt (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            "респавн"
        )
    );
}

public void test_playfair_ru_dec () {
    assert_cmpstr (
        "отодногопорченогояблокавесъвоззагниваетфтчка",
        GLib.CompareOperator.EQ,
        Playfair.decrypt (
            "тимжжижламаурблжтюгктлврспяетжжвдбтрвскшошое",
            "респавн"
        )
    );
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/playfair_key_validation", test_playfair_key_validation);
    Test.add_func ("/encryption/playfair_enc", test_playfair_ru_enc);
    Test.add_func ("/encryption/playfair_dec", test_playfair_ru_dec);
    return Test.run ();
}

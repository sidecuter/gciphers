using Encryption;

public void test_trithemium_enc () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "оурзсуйхччъвсъьтюруювяцщэкцэкдеягокедкшщяу",
            GLib.CompareOperator.EQ,
            Trithemium.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк"
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

public void test_trithemium_dec () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "отодногопорченогояблокавесьвоззагниваеттчк",
            GLib.CompareOperator.EQ,
            Trithemium.decrypt (
                alphabet,
                "оурзсуйхччъвсъьтюруювяцщэкцэкдеягокедкшщяу"
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/trithemium_enc", test_trithemium_enc);
    Test.add_func ("/encryption/trithemium_dec", test_trithemium_dec);
    return Test.run ();
}

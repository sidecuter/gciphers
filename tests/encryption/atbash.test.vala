using Encryption;

public void test_atbash_ru () {
    Alphabet alphabet = new Alphabet ();
    try {
        assert_cmpstr (
            "снсытсьсрспиътсьсаюфсхяэъогэсшшяьтчэяънних",
            GLib.CompareOperator.EQ,
            Atbash.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк"
            )
        );
    }
    catch (OOBError ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/atbash", test_atbash_ru);
    return Test.run ();
}

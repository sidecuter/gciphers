using Encryption;

public void test_atbash_ru () {
    Alphabets alphabets = new Alphabets ();
    Alphabet alphabet = new Alphabet (alphabets.ru);
    try {
        assert_cmpstr (
            "снсытсьсрспиътсьсаюфсхяэъогэсшшяьтчэяънних",
            GLib.CompareOperator.EQ,
            Encryption.Atbash.encrypt(
                alphabet,
                "отодногопорченогояблокавесьвоззагниваеттчк"
            )
        );
    }
    catch (Encryption.OOBError ex) {
        assert_true (false);
    }
}

public static int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/atbash", test_atbash_ru);
    return Test.run ();
}

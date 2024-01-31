using Encryption;
using Encryption.Atbash;

public void test_atbash_ru () {
    try {
        assert_cmpstr (
            "снсытсьсрспиътсьсаюфсхяэъогэсшшяьтчэяънних",
            CompareOperator.EQ,
            encrypt("отодногопорченогояблокавесьвоззагниваеттчк")
        );
    }
    catch (Error ex) {
        assert_true (false);
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/atbash", test_atbash_ru);
    return Test.run ();
}

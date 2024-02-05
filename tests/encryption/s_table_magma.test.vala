using Encryption.Magma;

public void test_s_table_magma () {
    uint8[,] data = new uint8[4, 4] {
        { 0xfd, 0xb9, 0x75, 0x31 },
        { 0x2a, 0x19, 0x6f, 0x34 },
        { 0xeb, 0xd9, 0xf0, 0x3a },
        { 0xb0, 0x39, 0xbb, 0x3d }
    };
    uint8[,] validate = new uint8[4, 4] {
        { 0x2a, 0x19, 0x6f, 0x34 },
        { 0xeb, 0xd9, 0xf0, 0x3a },
        { 0xb0, 0x39, 0xbb, 0x3d },
        { 0x68, 0x69, 0x54, 0x33 }
    };
    uint8[] result;
    uint8[] buffer;
    for (int i = 0; i < 4; i++) {
        buffer = new uint8[4];
        for (int j = 0; j < 4; j++) {
            buffer[j] = data[i, j];
        }
        result = t (buffer);
        for (int j = 0; j < 4; j++) {
            assert_cmpint (
                validate[i, j],
                CompareOperator.EQ,
                result[j]
            );
        }
    }
}

int main (string[] args) {
    Test.init (ref args);
    Test.add_func ("/encryption/s_table_magma", test_s_table_magma);
    return Test.run ();
}

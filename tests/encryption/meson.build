unit_tests = {
    'alphabet': files (
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'atbash': files (
        meson.project_source_root() + '/src/encryption/atbash.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'caesar': files (
        meson.project_source_root() + '/src/encryption/caesar.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
        meson.project_source_root() + '/src/encryption/enc_methods.vala',
    ),
    'polybius': files (
        meson.project_source_root() + '/src/encryption/polybius.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'belazo': files (
        meson.project_source_root() + '/src/encryption/belazo.vala',
        meson.project_source_root() + '/src/encryption/multi_alphabetic.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
        meson.project_source_root() + '/src/encryption/enc_methods.vala',
    ),
    'trithemium': files (
        meson.project_source_root() + '/src/encryption/trithemium.vala',
        meson.project_source_root() + '/src/encryption/multi_alphabetic.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
        meson.project_source_root() + '/src/encryption/enc_methods.vala',
    ),
    'vigenere': files (
        meson.project_source_root() + '/src/encryption/vigenere.vala',
        meson.project_source_root() + '/src/encryption/multi_alphabetic.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
        meson.project_source_root() + '/src/encryption/enc_methods.vala',
    ),
    'multi_alphabetic': files (
        meson.project_source_root() + '/src/encryption/multi_alphabetic.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
        meson.project_source_root() + '/src/encryption/enc_methods.vala',
    ),
    'vertical': files (
        meson.project_source_root() + '/src/encryption/vertical.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'vigenereii': files (
        meson.project_source_root() + '/src/encryption/vigenereii.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
        meson.project_source_root() + '/src/encryption/enc_methods.vala',
    ),
    'matrix': files (
        meson.project_source_root() + '/src/encryption/matrix.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'playfair': files (
        meson.project_source_root() + '/src/encryption/playfair.vala',
    ),
    'scrambler': files (
        meson.project_source_root() + '/src/encryption/scrambler.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
        meson.project_source_root() + '/src/encryption/enc_methods.vala',
    ),
    'shenon': files (
        meson.project_source_root() + '/src/encryption/shenon.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
}

foreach name, t_sources : unit_tests
    test(name, executable(name, name + '.test.vala', sources: t_sources, dependencies: gciphers_deps))
endforeach

unit_tests = {
    'atbash': files (
        meson.project_source_root() + '/src/encryption/atbash.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'caesar': files (
        meson.project_source_root() + '/src/encryption/caesar.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'polybius': files (
        meson.project_source_root() + '/src/encryption/polybius.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'belazo': files (
        meson.project_source_root() + '/src/encryption/belazo.vala',
        meson.project_source_root() + '/src/encryption/multi_alphabetic.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'trithemium': files (
        meson.project_source_root() + '/src/encryption/trithemium.vala',
        meson.project_source_root() + '/src/encryption/multi_alphabetic.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'vigenere': files (
        meson.project_source_root() + '/src/encryption/vigenere.vala',
        meson.project_source_root() + '/src/encryption/multi_alphabetic.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
    'vigenereii': files (
        meson.project_source_root() + '/src/encryption/vigenereii.vala',
        meson.project_source_root() + '/src/encryption/alphabet.vala',
    ),
}

foreach name, t_sources : unit_tests
    test(name, executable(name, name + '.test.vala', sources: t_sources, dependencies: gciphers_deps))
endforeach
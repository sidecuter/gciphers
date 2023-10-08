gciphers_sources = files(
  'main.vala',
  'application.vala',
  'window.vala',
  'menu_entry.vala'
)

subdir('encryption')
subdir('pages')

gciphers_sources += encryption_files
gciphers_sources += pages_files
gciphers_sources += gciphers_resources

gciphers_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

executable('gciphers', gciphers_sources,
  dependencies: gciphers_deps,
       install: true,
)

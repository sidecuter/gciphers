gciphers_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

gciphers_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.4'),
]

gciphers_sources += gnome.compile_resources('gciphers-resources',
  'gciphers.gresource.xml',
  c_name: 'gciphers'
)

executable('ciphers', gciphers_sources,
  dependencies: gciphers_deps,
       install: true,
)

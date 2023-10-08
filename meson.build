project('gciphers', ['c', 'vala'],
          version: '0.1.0',
    meson_version: '>= 0.62.0',
  default_options: [ 'warning_level=2', 'werror=false', ],
)

i18n = import('i18n')
gnome = import('gnome')

subdir('data')

gciphers_resources = gnome.compile_resources('gciphers-resources',
  'data/gciphers.gresource.xml',
  source_dir: 'data',
  c_name: 'gciphers'
)

subdir('src')
subdir('po')
subdir('tests')

gnome.post_install(
     glib_compile_schemas: true,
    gtk_update_icon_cache: true,
  update_desktop_database: true,
)

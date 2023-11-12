project('com.github.sidecuter.gciphers', ['c', 'vala'],
          version: '0.1.0',
    meson_version: '>= 0.62.0',
  default_options: [ 'warning_level=2', 'werror=false', ],
)

app_id = 'com.github.sidecuter.gciphers'

conf = configuration_data()
conf.set_quoted('APP_ID', app_id)
conf.set_quoted('APP_NAME', 'GCiphers')
conf.set_quoted('G_LOG_DOMAIN', 'GCiphers')
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))
configure_file(output: 'config.h', configuration: conf)

add_project_arguments(
    '-include', 'config.h',
    '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name()),
    language: 'c'
)

i18n = import('i18n')
gnome = import('gnome')

asresources = gnome.compile_resources('as-resources',
  'data/com.github.sidecuter.gciphers.gresource.xml',
  source_dir: 'data',
  c_name: 'as'
)

gciphers_sources = files (
  'vapi/Config.vapi'
)

subdir('src')

gciphers_deps = [
  dependency('gtk4', version: '>= 4.12'),
  dependency('gio-2.0', version: '>= 2.78'),
  dependency('gee-0.8', version: '>= 0.20'),
  dependency('libadwaita-1', version: '>= 1.4'),
  meson.get_compiler('c').find_library('m', required : false),
]

executable(
  meson.project_name(),
  gciphers_sources,
  asresources,
  dependencies: gciphers_deps,
  install: true,
)

subdir('tests')
subdir('data')
subdir('po')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true,
)

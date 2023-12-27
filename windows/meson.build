custom_target('copy icon',
  input : '@0@.ico'.format(app_id),
  output :  '@0@.ico'.format(app_id),
  command : ['cp', '@INPUT@', '@OUTPUT@'],
  install : false,
  build_by_default : true
)

custom_target('copy post_install.sh',
  input : 'post_install.sh',
  output :  'post_install.sh',
  command : ['cp', '@INPUT@', '@OUTPUT@'],
  install : true,
  install_dir: get_option('prefix'),
  build_by_default : true
)

configure_file(
  input: './gciphers.nsi.in',
  output: 'gciphers.nsi',
  configuration: conf,
  install: true,
  install_dir: get_option('prefix'),
)

configure_file(
  input: './version.rc.in',
  output: 'version.rc',
  configuration: conf,
  install: false,
)

configure_file(
  input: './gciphers.rc.in',
  output: 'gciphers.rc',
  configuration: conf,
  install: false,
)

windows = import('windows')
gciphers_sources += windows.compile_resources(
    join_paths(meson.current_build_dir(), 'gciphers.rc'), 
    join_paths(meson.current_build_dir(), 'version.rc'),
)
#!/bin/sh

BASE_PATH=$(whereis valac | sed 's/valac: //' | sed 's/\/bin\/valac.exe//')

cp $BASE_PATH/bin/libadwaita-1-0.dll bin/libadwaita-1-0.dll
cp $BASE_PATH/bin/libgee-0.8-2.dll bin/libgee-0.8-2.dll
cp $BASE_PATH/bin/libgio-2.0-0.dll bin/libgio-2.0-0.dll
cp $BASE_PATH/bin/libgobject-2.0-0.dll bin/libgobject-2.0-0.dll
cp $BASE_PATH/bin/libintl-8.dll bin/libintl-8.dll
cp $BASE_PATH/bin/libgtk-4-1.dll bin/libgtk-4-1.dll
cp $BASE_PATH/bin/libappstream-5.dll bin/libappstream-5.dll
cp $BASE_PATH/bin/libfribidi-0.dll bin/libfribidi-0.dll
cp $BASE_PATH/bin/libglib-2.0-0.dll bin/libglib-2.0-0.dll
cp $BASE_PATH/bin/libgraphene-1.0-0.dll bin/libgraphene-1.0-0.dll
cp $BASE_PATH/bin/libpango-1.0-0.dll bin/libpango-1.0-0.dll
cp $BASE_PATH/bin/zlib1.dll bin/zlib1.dll
cp $BASE_PATH/bin/libgmodule-2.0-0.dll bin/libgmodule-2.0-0.dll
cp $BASE_PATH/bin/libffi-8.dll bin/libffi-8.dll
cp $BASE_PATH/bin/libiconv-2.dll bin/libiconv-2.dll
cp $BASE_PATH/bin/libcurl-4.dll bin/libcurl-4.dll
cp $BASE_PATH/bin/libxmlb-2.dll bin/libxmlb-2.dll
cp $BASE_PATH/bin/libxml2-2.dll bin/libxml2-2.dll
cp $BASE_PATH/bin/libyaml-0-2.dll bin/libyaml-0-2.dll
cp $BASE_PATH/bin/libzstd.dll bin/libzstd.dll
cp $BASE_PATH/bin/libpcre2-8-0.dll bin/libpcre2-8-0.dll
cp $BASE_PATH/bin/libharfbuzz-0.dll bin/libharfbuzz-0.dll
cp $BASE_PATH/bin/libthai-0.dll bin/libthai-0.dll
cp $BASE_PATH/bin/libgcc_s_seh-1.dll bin/libgcc_s_seh-1.dll
cp $BASE_PATH/bin/libcairo-gobject-2.dll bin/libcairo-gobject-2.dll
cp $BASE_PATH/bin/libcairo-script-interpreter-2.dll bin/libcairo-script-interpreter-2.dll
cp $BASE_PATH/bin/libcairo-2.dll bin/libcairo-2.dll
cp $BASE_PATH/bin/libepoxy-0.dll bin/libepoxy-0.dll
cp $BASE_PATH/bin/libgdk_pixbuf-2.0-0.dll bin/libgdk_pixbuf-2.0-0.dll
cp $BASE_PATH/bin/libjpeg-8.dll bin/libjpeg-8.dll
cp $BASE_PATH/bin/libpangocairo-1.0-0.dll bin/libpangocairo-1.0-0.dll
cp $BASE_PATH/bin/libpangowin32-1.0-0.dll bin/libpangowin32-1.0-0.dll
cp $BASE_PATH/bin/libpng16-16.dll bin/libpng16-16.dll
cp $BASE_PATH/bin/libtiff-6.dll bin/libtiff-6.dll
cp $BASE_PATH/bin/libbrotlidec.dll bin/libbrotlidec.dll
cp $BASE_PATH/bin/libidn2-0.dll bin/libidn2-0.dll
cp $BASE_PATH/bin/libcrypto-3-x64.dll bin/libcrypto-3-x64.dll
cp $BASE_PATH/bin/libnghttp2-14.dll bin/libnghttp2-14.dll
cp $BASE_PATH/bin/libpsl-5.dll bin/libpsl-5.dll
cp $BASE_PATH/bin/libssh2-1.dll bin/libssh2-1.dll
cp $BASE_PATH/bin/libssl-3-x64.dll bin/libssl-3-x64.dll
cp $BASE_PATH/bin/liblzma-5.dll bin/liblzma-5.dll
cp $BASE_PATH/bin/libstdc++-6.dll bin/libstdc++-6.dll
cp $BASE_PATH/bin/libfreetype-6.dll bin/libfreetype-6.dll
cp $BASE_PATH/bin/libgraphite2.dll bin/libgraphite2.dll
cp $BASE_PATH/bin/libdatrie-1.dll bin/libdatrie-1.dll
cp $BASE_PATH/bin/libwinpthread-1.dll bin/libwinpthread-1.dll
cp $BASE_PATH/bin/liblzo2-2.dll bin/liblzo2-2.dll
cp $BASE_PATH/bin/libfontconfig-1.dll bin/libfontconfig-1.dll
cp $BASE_PATH/bin/libpixman-1-0.dll bin/libpixman-1-0.dll
cp $BASE_PATH/bin/libpangoft2-1.0-0.dll bin/libpangoft2-1.0-0.dll
cp $BASE_PATH/bin/libdeflate.dll bin/libdeflate.dll
cp $BASE_PATH/bin/libjbig-0.dll bin/libjbig-0.dll
cp $BASE_PATH/bin/libLerc.dll bin/libLerc.dll
cp $BASE_PATH/bin/libwebp-7.dll bin/libwebp-7.dll
cp $BASE_PATH/bin/libbrotlicommon.dll bin/libbrotlicommon.dll
cp $BASE_PATH/bin/libunistring-5.dll bin/libunistring-5.dll
cp $BASE_PATH/bin/libbz2-1.dll bin/libbz2-1.dll
cp $BASE_PATH/bin/libexpat-1.dll bin/libexpat-1.dll
cp $BASE_PATH/bin/libsharpyuv-0.dll bin/libsharpyuv-0.dll
mkdir lib
cp -r $BASE_PATH/lib/gdk-pixbuf-2.0 lib
git clone https://github.com/B00merang-Project/Windows-10.git share/themes/Windows-10
rm -rf share/themes/Windows-10/.git
mkdir -p etc/gtk-4.0
cat > etc/gtk-4.0/settings.ini << EOL
[Settings]
gtk-theme-name=Windows-10
gtk-font-name=Segoe UI 9
EOL
wget https://download.gnome.org/sources/adwaita-icon-theme/45/adwaita-icon-theme-45.0.tar.xz
tar xf adwaita-icon-theme-45.0.tar.xz
mv adwaita-icon-theme-45.0/Adwaita share/icons/Adwaita
rm -rf adwaita-icon-theme-45.0{,.tar.xz}
cp -r /usr/share/icons/hicolor/* share/icons/hicolor
sed -i 's/\//\\/g' gciphers.nsi
makensis gciphers.nsi

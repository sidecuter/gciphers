#!/bin/sh

cp /mingw64/bin/libadwaita-1-0.dll bin/libadwaita-1-0.dll
cp /mingw64/bin/libgee-0.8-2.dll bin/libgee-0.8-2.dll
cp /mingw64/bin/libgio-2.0-0.dll bin/libgio-2.0-0.dll
cp /mingw64/bin/libgobject-2.0-0.dll bin/libgobject-2.0-0.dll
cp /mingw64/bin/libintl-8.dll bin/libintl-8.dll
cp /mingw64/bin/libgtk-4-1.dll bin/libgtk-4-1.dll
cp /mingw64/bin/libappstream-5.dll bin/libappstream-5.dll
cp /mingw64/bin/libfribidi-0.dll bin/libfribidi-0.dll
cp /mingw64/bin/libglib-2.0-0.dll bin/libglib-2.0-0.dll
cp /mingw64/bin/libgraphene-1.0-0.dll bin/libgraphene-1.0-0.dll
cp /mingw64/bin/libpango-1.0-0.dll bin/libpango-1.0-0.dll
cp /mingw64/bin/zlib1.dll bin/zlib1.dll
cp /mingw64/bin/libgmodule-2.0-0.dll bin/libgmodule-2.0-0.dll
cp /mingw64/bin/libffi-8.dll bin/libffi-8.dll
cp /mingw64/bin/libiconv-2.dll bin/libiconv-2.dll
cp /mingw64/bin/libcurl-4.dll bin/libcurl-4.dll
cp /mingw64/bin/libxmlb-2.dll bin/libxmlb-2.dll
cp /mingw64/bin/libxml2-2.dll bin/libxml2-2.dll
cp /mingw64/bin/libyaml-0-2.dll bin/libyaml-0-2.dll
cp /mingw64/bin/libzstd.dll bin/libzstd.dll
cp /mingw64/bin/libpcre2-8-0.dll bin/libpcre2-8-0.dll
cp /mingw64/bin/libharfbuzz-0.dll bin/libharfbuzz-0.dll
cp /mingw64/bin/libthai-0.dll bin/libthai-0.dll
cp /mingw64/bin/libgcc_s_seh-1.dll bin/libgcc_s_seh-1.dll
cp /mingw64/bin/libcairo-gobject-2.dll bin/libcairo-gobject-2.dll
cp /mingw64/bin/libcairo-script-interpreter-2.dll bin/libcairo-script-interpreter-2.dll
cp /mingw64/bin/libcairo-2.dll bin/libcairo-2.dll
cp /mingw64/bin/libepoxy-0.dll bin/libepoxy-0.dll
cp /mingw64/bin/libgdk_pixbuf-2.0-0.dll bin/libgdk_pixbuf-2.0-0.dll
cp /mingw64/bin/libjpeg-8.dll bin/libjpeg-8.dll
cp /mingw64/bin/libpangocairo-1.0-0.dll bin/libpangocairo-1.0-0.dll
cp /mingw64/bin/libpangowin32-1.0-0.dll bin/libpangowin32-1.0-0.dll
cp /mingw64/bin/libpng16-16.dll bin/libpng16-16.dll
cp /mingw64/bin/libtiff-6.dll bin/libtiff-6.dll
cp /mingw64/bin/libbrotlidec.dll bin/libbrotlidec.dll
cp /mingw64/bin/libidn2-0.dll bin/libidn2-0.dll
cp /mingw64/bin/libcrypto-3-x64.dll bin/libcrypto-3-x64.dll
cp /mingw64/bin/libnghttp2-14.dll bin/libnghttp2-14.dll
cp /mingw64/bin/libpsl-5.dll bin/libpsl-5.dll
cp /mingw64/bin/libssh2-1.dll bin/libssh2-1.dll
cp /mingw64/bin/libssl-3-x64.dll bin/libssl-3-x64.dll
cp /mingw64/bin/liblzma-5.dll bin/liblzma-5.dll
cp /mingw64/bin/libstdc++-6.dll bin/libstdc++-6.dll
cp /mingw64/bin/libfreetype-6.dll bin/libfreetype-6.dll
cp /mingw64/bin/libgraphite2.dll bin/libgraphite2.dll
cp /mingw64/bin/libdatrie-1.dll bin/libdatrie-1.dll
cp /mingw64/bin/libwinpthread-1.dll bin/libwinpthread-1.dll
cp /mingw64/bin/liblzo2-2.dll bin/liblzo2-2.dll
cp /mingw64/bin/libfontconfig-1.dll bin/libfontconfig-1.dll
cp /mingw64/bin/libpixman-1-0.dll bin/libpixman-1-0.dll
cp /mingw64/bin/libpangoft2-1.0-0.dll bin/libpangoft2-1.0-0.dll
cp /mingw64/bin/libdeflate.dll bin/libdeflate.dll
cp /mingw64/bin/libjbig-0.dll bin/libjbig-0.dll
cp /mingw64/bin/libLerc.dll bin/libLerc.dll
cp /mingw64/bin/libwebp-7.dll bin/libwebp-7.dll
cp /mingw64/bin/libbrotlicommon.dll bin/libbrotlicommon.dll
cp /mingw64/bin/libunistring-5.dll bin/libunistring-5.dll
cp /mingw64/bin/libbz2-1.dll bin/libbz2-1.dll
cp /mingw64/bin/libexpat-1.dll bin/libexpat-1.dll
cp /mingw64/bin/libsharpyuv-0.dll bin/libsharpyuv-0.dll
mkdir lib
cp -r /mingw64/lib/gdk-pixbuf-2.0 lib
git clone https://github.com/B00merang-Project/Windows-10.git share/themes/Windows-10
rm -rf share/themes/Windows-10/{cinnamon,gnome-shell,openbox-3,unity,.git,xfce-notify-4.0,xfwm4,metacity-1}
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

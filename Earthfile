VERSION 0.7
FROM ubuntu:23.10
WORKDIR /build

deps:
	RUN apt-get update -y
	RUN apt-get install -y libgtk-4-dev valac meson ninja-build libgee-0.8-dev libadwaita-1-dev gettext desktop-file-utils appstream libxml2-utils wget python3-pip
	RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O /usr/local/bin/appimagetool
    RUN chmod +x /usr/local/bin/appimagetool
    RUN pip install appimage-builder --break-system-packages

build:
	FROM +deps
	COPY . .
	RUN meson setup build --prefix=$(pwd)/install
	RUN meson compile -C build
	RUN meson test -C build
	RUN meson install -C build
	SAVE ARTIFACT build /dist AS LOCAL build
	SAVE ARTIFACT install AS LOCAL install

build-appimage:
	FROM +deps
	COPY . .
	RUN apt-get install squashfs-tools zsync
	RUN appimage-builder --recipe AppImageBuilder.yml --skip-tests
	SAVE ARTIFACT GCiphers-0.1.1-x86_64.AppImage AS LOCAL GCiphers-0.1.1-x86_64.AppImage

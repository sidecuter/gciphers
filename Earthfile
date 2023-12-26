VERSION 0.7
FROM ubuntu:23.10
WORKDIR /build

deps:
	RUN apt-get update -y
	RUN apt-get install -y libgtk-4-dev valac meson ninja-build libgee-0.8-dev libadwaita-1-dev gettext desktop-file-utils appstream libxml2-utils

build:
	FROM +deps
	COPY . .
	RUN meson setup build
	RUN meson compile -C build
	RUN meson test -C build
	SAVE ARTIFACT build /dist AS LOCAL build

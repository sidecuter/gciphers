#!/bin/sh

BASE_PATH=$(whereis valac | sed 's/valac: //' | sed 's/\/bin\/valac.exe//')

clear_input () {
	i1="$(echo $1 | sed 's/[-a-z.0-9]*\.dll[ ]*([0-9a-z]*)//')"
}	

get_deps () {
	if [ $2 -gt 0 ]; then
		echo "$1" | while read -r a
		do
			local RES=$(echo $a | grep 'C:\\Windows')
			if [ "$RES" = "" ]; then
				clear_input $a
				echo $i1
				get_deps "$(ntldd $i1)" $(($2-1))
			fi
		done
	fi
}

find_dep_unix_path () {
	for i in "$@"
	do
		local res=$(find $BASE_PATH/bin -name "$i" 2>/dev/null)
		echo $res
	done
}

copy_libs () {
	for i in "$@"
	do
		cp $i bin
	done	
}

STR=$(ntldd bin/com.github.sidecuter.gciphers.exe)
RESULT=$(get_deps "$STR" 3 | awk '!a[$0]++')
DEP_PATHS=$(find_dep_unix_path $RESULT)
#echo $DEP_PATHS
copy_libs $DEP_PATHS

cp $BASE_PATH/bin/gdbus.exe bin/
mkdir lib
cp -r $BASE_PATH/lib/gdk-pixbuf-2.0 lib
# git clone https://github.com/B00merang-Project/Windows-10.git share/themes/Windows-10
# rm -rf share/themes/Windows-10/.git
# mkdir -p etc/gtk-4.0
# cat > etc/gtk-4.0/settings.ini << EOL
# [Settings]
# gtk-theme-name=Windows-10
# gtk-font-name=Segoe UI 9
# EOL
cp -r $BASE_PATH/share/icons/Adwaita share/icons/Adwaita
cp -r /usr/share/icons/hicolor/* share/icons/hicolor
sed -i 's/\//\\/g' gciphers.nsi
makensis gciphers.nsi

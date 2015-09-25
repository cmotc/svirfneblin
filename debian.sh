#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEBIN=svirfneblin-panel
SOURCESESSION=awesome-svirfneblin.desktop
SOURCELAUNCHER=awesome-svirfneblin.desktop
SOURCEDOC=README.md
DEBFOLDER=svirfneblin-panel

DEBVERSION=$(date +%Y%m%d)

cd $DEBFOLDER

git pull origin master

DEBFOLDERNAME="../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

rm -rf $DEBFOLDERNAME
# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp -R $SOURCEBINPATH/ $DEBFOLDERNAME/
cd $DEBFOLDERNAME

pwd

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig 

mkdir -p debian/tmp/usr
cp -R usr debian/tmp/usr

# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo usr/bin/$SOURCEBIN usr/bin > debian/install 
echo usr/share/applications/$SOURCELAUNCH usr/share/applications >> debian/install 
echo usr/share/xsessions/$SOURCESESSION usr/share/xsessions >> debian/install 
echo etc/xdg/svirfneblin/rc.lua etc/xdg/svirfneblin/rc.lua >> debian/install
echo etc/xdg/svirfneblin/debian/menu.lua etc/xdg/svirfneblin/debian/menu.lua >> debian/install
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: dyngar-m <dyngar-m@dyngar.local>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: <insert the upstream URL, if relevant>
#Vcs-Git: git://anonscm.debian.org/collab-maint/debian-awesome-gnome.git
#Vcs-Browser: http://anonscm.debian.org/?p=collab-maint/debian-awesome-gnome.git;a=summary

Package: $DEBFOLDER
Architecture: all
Depends: lightdm (>= 1.0), lighdm-gtk-greeter, awesome (>= 3.4), \${misc:Depends}
Description: <insert up to 60 chars description>
 <insert long description, indented with spaces>
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name awesome-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc > ../log 

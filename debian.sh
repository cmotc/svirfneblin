#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEBIN=svirfneblin-panel
SOURCEDOC=README.md
DEBFOLDER=svirfneblin-panel

DEBVERSION=$(date +%Y%m%d)

TOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $TOME

git pull origin master

DEBFOLDERNAME="../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

rm -rf $DEBFOLDERNAME
# Create your scripts source dir
mkdir $DEBFOLDERNAME

# Copy your script to the source dir
cp -R $TOME $DEBFOLDERNAME/
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
echo etc/xdg/svirfneblin/rc.lua etc/xdg/svirfneblin >> debian/install
echo etc/xdg/svirfneblin/theme.lua etc/xdg/svirfneblin >> debian/install
echo etc/xdg/svirfneblin/theme-large.lua etc/xdg/svirfneblin >> debian/install
echo etc/xdg/svirfneblin/debian/menu.lua etc/xdg/svirfneblin/debian/ >> debian/install
for f in usr/share/svirfneblin/icons/* ; do
    echo $f usr/share/svirfneblin/icons >> debian/install
done
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: cmotc <cmotc@openmailbox.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/svirfneblin-panel
#Vcs-Git: git@github.com:cmotc/svirfneblin-panel
#Vcs-Browser: https://www.github.com/cmotc/svirvneblin-panel

Package: $DEBFOLDER
Architecture: all
Depends: awesome (>= 3.4), svirfneblin-battery-widget, svirfneblin-network-manager, \${misc:Depends}
Description: A Gnome3-Like configuration for Awesome WM
 I like Gnome3's appearance, but I want tiling and I hate ShellShape, 
 and I don't think I really need  all these graphical configuration 
 tools, and I really don't think I need any more javascript in my life
 than absolutely necessary. Seriously guy's, this is getting out of 
 hand. Maybe it's not my place, but I'm just sayin'. Well technically
 not just sayin'. I'm doin', as in re-implementing this stuff I like
 about Gnome in a language that doesn't make me seasick to look at.
 .
 This package contains the custom configuration, session, and a laucher
 which checks for the correct config without touching the default
 Awesome WM config for Debian, which is treated as a fallback.
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
debuild -us -uc >> ../log

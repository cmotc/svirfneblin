#!/bin/sh
echo "Add the Awesome Session to the X Sessions List"
install -Dm644 usr/share/xsessions/awesome-gnome.desktop /usr/share/xsessions/awesome-gnome.desktop
echo "Add Awesome to the Application.desktop files"
install -Dm644 usr/share/applications/awesome.desktop /usr/share/applications/awesome.desktop
echo "Add the Awesome Session to the Gnome Sessions"
install -Dm644 usr/share/gnome-session/sessions/awesome.session /usr/share/gnome-session/sessions/awesome.session
sudo cp usr/bin/gnome-session-awesome /usr/bin/gnome-session-awesome
sudo chmod a+x /usr/bin/gnome-session-awesome
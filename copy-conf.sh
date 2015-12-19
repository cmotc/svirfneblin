#! /bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="${DIR%x}"
INSTALL="$DIR/copy-conf.sh"
install(){
    if [ -d "$HOME/.bin" ]; then
        if [ ! -f "$HOME/.bin/rc_pkg" ]; then
            ln -s "$INSTALL" "$HOME/.bin/rc_pkg"
        fi
    fi
}
RC_LUA="$HOME/.config/awesome/rc.lua"
PKG_RC_LUA="$DIR/etc/xdg/svirfneblin/rc.lua"
cp "$RC_LUA" "$PKG_RC_LUA"
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local vicious = require("vicious")
-- Overview library
--local revelation = require("calladuran")
local revelation = require("revelation")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Battery library
require("battery.batt")
-- NetworkManager library
require("network.pech")
-- Network Monitor widget
require("netmonitor.boddy")
-- Configure Conky-based Heads Up Display
require("conky.hud")
-- Load Debian menu entries
require("debian.menu")
-- Load Auto-Hiding side-panel
require("goblin.side")
-- Load Toggle-Hiding
-- require("")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
-- Themes define colours, icons, font and wallpapers.
beautiful.init("/etc/xdg/svirfneblin/theme.lua")
-- Initialize Overview plugin
-- calladuran.init("","")

--revelation.init(tag_name = revelation, rule={class="conky"}, is_excluded=true)
revelation.init()
-- This is used later as the default terminal and editor to run.
terminal = "terminator"
editor = "medit --new-window" --os.getenv("EDITOR") or "editor"
editor_cmd = terminal .. " -e " .. editor
packagemanager = "aptitude" --"synaptic"
packager = terminal .. " -e sudo " .. packagemanager
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "Mntr", "Mngr", "Rsrc", "Dvlp", "Comm", "Scrt", "Game", "Systm" }, s, layouts[2])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", "medit --new-window" .. " " .. awesome.conffile },
   { "restart", awesome.restart }
}

mylair = {
   { "Enter Lair", "lair" },
   { "Edit configuration file", "medit --new-window .lairrc" },
   { "Edit default resource file", "medit --new-window .config/lair/default-resources.xml" },
}

mygames = {
   { "Dungeon Crawl", "crawl-tiles", "/usr/share/icons/hicolor/32x32/apps/crawl.png" },
   { "Gearhead", terminal .. " -e gearhead" },
   { "Gearhead2", terminal .. " -e gearhead2" },
   { "Fortune", terminal .. " -e /bin/sh fortune-wrapper" },
   { "LAIR", mylair }
}

uzblmarks = {
   { "None", "uzbl"},
   { "Google", "uzbl google.com"}
}

xombreroconfigs = {
   { "Edit Xombrero Default Config(.xombrero.conf)", "medit --new-window \".xombrero.conf\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Edit Xombrero i2p Config(.xombrero.i2p.conf)", "medit --new-window \".xombrero2p.conf\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Edit Xombrero Insecure Config(.insecure.conf)", "medit --new-window \".insecure.conf\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

xombreromenu = {
   { "Xombrero default Launch(Uses Tor)", "xombrero about:cookiejar https://duckduckgo.com/lite/", "/usr/share/pixmaps/xombrero.xpm"},
   { "Xombrero i2p Launch", "xombrero -f \".xombrero.i2p.conf\"  http://127.0.0.1:7657/home http://127.0.0.1:7658/help/ http://direct.i2p" , "/usr/share/pixmaps/xombrero.xpm"},
   { "Xombrero Detailed Tor Check", "xombrero https://duckduckgo.com/html https://torcheck.xenobite.eu https://check.torproject.org https://panopticlick.eff.org/tracker-nojs", "/usr/share/pixmaps/xombrero.xpm"},
   { "Xombrero insecure Launch(no Tor)", "xombrero -f \".insecure.conf\"  https://duckduckgo.com/html", "/usr/share/pixmaps/xombrero.xpm"},
   { "Edit Xombrero Configs", xombreroconfigs, "/usr/share/pixmaps/xombrero.xpm"},
}

mybrowsers = {
   {"Xombrero", xombreromenu, "/usr/share/pixmaps/xombrero.xpm"},
   {"Lynx-cur", terminal .. " -c Lynx -e torsocks lynx"},
   {"uzbl Bookmarks", uzblmarks},
   {"Tor Browser","torbrowser-launcher","/usr/share/pixmaps/torbrowser32.xpm"}
}

mydocs = {
   { "Abiword", "abiword","/usr/share/pixmaps/abiword.xpm"},
   { "Gnumeric", "gnumeric", "/usr/share/icons/Tango/32x32/mimetypes/gnome-mime-application-x-gnumeric.png"},
   { "Dia", "dia"},
   { "Pinta", "pinta", "/usr/share/icons/hicolor/32x32/apps/pinta.png" },
   { "Gringotts", "/usr/bin/gringotts", "/usr/share/pixmaps/gringotts-32.xpm"}
}

mycomms = {
   { "Mutt", terminal .. " -c Mutt -e mutt_with_tor","/usr/share/pixmaps/mutt.xpm"},
   { "Profanity", terminal .. " -c Profanity -e profanity_with_tor","/usr/share/pixmaps/filled-xterm_32x32.xpm"},
   { "Mumble", "torsocks mumble","/usr/share/pixmaps/mumble.xpm"},
   { "irssi", terminal .. " -c Irssi -e irssi_with_tor","/usr/share/pixmaps/terminal-tango.xpm"},
   { "irssi2p", terminal .. " -c Irssi -e irssi -c \"localhost\" -p \"6668\" &> /dev/null","/usr/share/pixmaps/terminal-tango.xpm"},
   { "toxic", terminal .. " -c Toxic -e toxic","/usr/share/icons/hicolor/16x16/apps/utox.png"},
}

awesomeproj = {
   { "Goblin Panel", "medit --new-window \"Projects/Distro_OS_Projects/packages/svirfneblin-goblin/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Network Management Widget", "medit --new-window \"Projects/Distro_OS_Projects/packages/svirfneblin-network-manager/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Network Monitoring Widget", "medit --new-window \"Projects/Distro_OS_Projects/packages/svirfneblin-netmonitor-widget/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Svirneblin Conky HUD", "medit --new-window \"Projects/Distro_OS_Projects/packages/svirfneblin-conky-hud/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Svirneblin Panel", "medit --new-window \"Projects/Distro_OS_Projects/packages/svirfneblin-panel/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

fireaxeproj = {
   { "apt-git repo generator", "medit --new-window \"Projects/Distro_OS_Projects/packages/apt-git/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "f-droid repo generator", "medit --new-window \"Projects/Distro_OS_Projects/packages/fdroid-git/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

privproj = {
   { "I2P C++ Implementation", "medit --new-window \"Projects/Distro_OS_Projects/packages/i2pd/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Multipoint TLS Verification", "medit --new-window \"Projects/Distro_OS_Projects/packages/multipoint_tls_verification/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Namecoin Core", "medit --new-window \"Projects/Distro_OS_Projects/packages/namecoin-core/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Namecoin Controller", "medit --new-window \"Projects/Distro_OS_Projects/packages/nmcontrol/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Ratox Nightlies", "medit --new-window \"Projects/Distro_OS_Projects/packages/ratox/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Toxcore", "medit --new-window \"Projects/Distro_OS_Projects/packages/toxcore/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Toxic", "medit --new-window \"Projects/Distro_OS_Projects/packages/toxic/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "URCD", "medit --new-window \"Projects/Distro_OS_Projects/packages/urcd/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Vala Tox Bot", "medit --new-window \"Projects/Distro_OS_Projects/packages/tartrazine/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Vala Tox Integration Lib", "medit --new-window \"Projects/Distro_OS_Projects/packages/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Vala Tox Wrapper", "medit --new-window \"Projects/Distro_OS_Projects/packages/tox-vapi/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

armproj = {
   { "Allwinner A33 Debian Kernel", "medit --new-window \"Projects/Distro_OS_Projects/packages/debian_kernel_allwinner_a33/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Allwinner Debootstrapper", "medit --new-window \"Projects/Distro_OS_Projects/packages/bootstrap-sd/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Igor Pekovnic's Libs", "medit --new-window \"Projects/Reverse_Engineering_Projects/lib/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Arch Linux Pi Bootstrapper", "medit --new-window \"Projects/Distro_OS_Projects/packages/pi-arch-live-config/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

secproj = {
   { "Joker Mesh Attack Tools", "medit --new-window \"Projects/Distro_OS_Projects/packages/joker/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "WarSMS", "medit --new-window \"Projects/Distro_OS_Projects/packages/WarSMS/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

openrcproj = {
   { "File System SDK", "medit --new-window \"Projects/Distro_OS_Projects/packages/fskit/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Init Agnostic Stat Library", "medit --new-window \"Projects/Distro_OS_Projects/packages/libpstat/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "NetIFRC Support", "medit --new-window \"Projects/Distro_OS_Projects/packages/netifrc/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "vdev", "medit --new-window \"Projects/Distro_OS_Projects/packages/vdev/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

gameproj = {
   { "LAIR Client", "medit --new-window \"Projects/Distro_OS_Projects/packages/valair/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "LAIR Server", "medit --new-window \"Projects/Distro_OS_Projects/packages/valair-map-server/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "LAIR Data", "medit --new-window \"Projects/Distro_OS_Projects/packages/valair-data/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },   
}

shellproj = {
   { "Which Goddamn Dialog Alias", "medit --new-window \"Projects/Distro_OS_Projects/packages/wgdda/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "**sh Numeric Array Wrapper", "medit --new-window \"Projects/Distro_OS_Projects/packages/xxsh-numeric-array/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
}

distproj = {
   { "Nightlies", "medit --new-window \"Projects/Distro_OS_Projects/packages/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "ARM Architecture Projectss", armproj },
   { "AwesomeWM Customization Projects", awesomeproj },
   { "Game Projects", gameproj },
   { "Hobby Distro Management Projects", fireaxeproj },
   { "Privacy and Sustainability Related Projects", privproj},
   { "Security Testing/Demonstration Projects", secproj },
   { "Shell Hacking Projects", shellproj },
   { "SystemD Resistance Projects", openrcproj },
}

liveproj = {
   { "Buildroot", "medit --new-window \"Projects/Distro_OS_Projects/live/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Fyrix", "medit --new-window \"Projects/Distro_OS_Projects/live/fireaxe/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "notDOS", "medit --new-window \"Projects/Distro_OS_Projects/live/notDOS/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" },
   { "Coreboot Scan Suite", "medit --new-window \"Projects/Distro_OS_Projects/live/hwtestsuite/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png" }
}

andproj = {
   { "Nightlies", "medit --new-window \"Projects/Distro_OS_Projects/AOSP/packages/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
--   { "Nightlies", "medit --new-window \"Projects/Distro_OS_Projects/AOSP/packages/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
}

webproj = {
   { "Webinfo Root", "medit --new-window \"Projects/Blogs_and_Infosites/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
   { "CMOTC Blog", "medit --new-window \"Projects/Blogs_and_Infosites/cmotc.github.io/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
   { "Fireaxe Page", "medit --new-window \"Projects/Blogs_and_Infosites/fyrix.github.io/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
   { "Personal Blog", "medit --new-window \"Projects/Blogs_and_Infosites/personal-blog/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
}

revproj = {
   { " Root", "medit --new-window \"Projects/Reverse_Engineering_Projects/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
   { "Coreboot x11m", "medit --new-window \"Projects/Reverse_Engineering_Projects/coreboot/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
   { "u-boot A33", "medit --new-window \"Projects/Reverse_Engineering_Projects/u-boot/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
   { "ANTM Revo", "medit --new-window \"Projects/Reverse_Engineering_Projects/android_product_antm_revo/README.md\"","/usr/share/icons/hicolor/48x48/apps/medit.png"},
}

myproj = {
   { "edit config", "medit --new-window" .. " " .. awesome.conffile, beautiful.awesome_icon },
   { "edit .bash_aliases", "medit --new-window" .. " .bash_aliases", beautiful.awesome_icon },
   { "edit .profile", "medit --new-window" .. " .profile", beautiful.awesome_icon },
   { "Distro Packages", distproj},
   { "Distro Live Configuration", liveproj},
   { "Android Distro Packages", andproj},   
   { "Reverse Engineering Projects, Bootloaders", revproj},
   { "Web Info Projects", webproj}
}

mytraf = {
   { "traffic monitor(ETH)", terminal .. " -c htop -e sudo iftop -i eth0","/usr/share/pixmaps/terminal-tango.xpm"},
   { "traffic monitor(WIFI)", terminal .. " -c htop -e sudo iftop -i wlan0","/usr/share/pixmaps/terminal-tango.xpm"}
}

mysys = {
   { "awesome", myawesomemenu, beautiful.awesome_icon },
   { "process monitor", terminal .. " -c htop -e htop","/usr/share/pixmaps/icedove.xpm"},
   { "network monitor", terminal .. " -c htop -e sudo iptraf","/usr/share/pixmaps/terminal-tango.xpm"},
   { "traffic monitor", mytraf },
   { "tor monitor", terminal .. " -c torarm -e sudo -u debian-tor arm","/usr/share/pixmaps/terminal-tango.xpm"},
   { "package manager", packager ,"/usr/share/pixmaps/terminal-tango.xpm"},
--   { "tor-arm", terminal .. " -c torarm -e sudo -u debian-tor arm","/usr/share/pixmaps/terminal-tango.xpm"},
--   { "tor-arm", terminal .. " -c torarm -e sudo -u debian-tor arm","/usr/share/pixmaps/terminal-tango.xpm"},
}

mypowermanagement = {
   { "shutdown", "xterm" .. " -e sudo sd" },
   { "restart", "xterm" .. " -e sudo rs" },
   { "logout", awesome.quit }
--   { "shutdown", terminal .. " -e sudo shutdown now" }
}

mymanager = {
--   { "uTox", "utox", "/usr/share/doc/tox-vapi-20150923/utox.png" },
   { "rtorrent", terminal .. " -c rtorrent -e rtorrent"},
   { "Wifite", terminal .. " -c Wifite -e sudo wifite"},
   { "=============",""},
   { "open terminal", terminal },
   { "kill screensaver", "killall xscreensaver" },
   { "logout", awesome.quit, beautiful.awesome_icon },
   { "restart awm", awesome.restart },
   { "Lock Screen", "/usr/bin/xscreensaver-command -lock"},
   { "=============",""},
   { "power", mypowermanagement }
}

fyrix = {
   { "Bootstrap an SD card for an Allwinner Tablet", terminal .. " --working-directory \"Projects/Distro_OS_Projects/packages/bootstrap-sd/\"" }
}

mymanagermenu = awful.menu({ items = mymanager })

mymanagerlauncher = awful.widget.launcher({ image = beautiful.user_icon,
                                     menu = mymanagermenu })

mymainmenu = awful.menu({ items = { { "System", mysys },
									{ "File Browser", "pcmanfm" },
                                    { "Text Editor", "medit" },
                                    { "=============", ""},
                                    { "Browsers", mybrowsers },
                                    { "Documents", mydocs },
                                    { "Communication", mycomms },
                                    { "Games", mygames },
                                    { "Projects", myproj },
                                    { "Debian", debian.menu.Debian_menu.Debian },
                                    { "Fireaxe", fyrix },
                                    { "=============", ""},
                                    { "open terminal", terminal },
                                  }
                        })
--mymainmenu.set_font("mono 7")
mylauncher = awful.widget.launcher({ image = beautiful.awesome_menu_32,
                                     menu = mymainmenu,
			})
--mylauncher:set_text("MENU")

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox

-- create a battery widget
mybatterywidget = wibox.widget.textbox()
mybatterywidget:set_align("right")

bat_clo = battery.batclosure("BAT1")
mybatterywidget:set_text(bat_clo())

battimer = timer({ timeout = 15 })
battimer:connect_signal("timeout", function() 
        mybatterywidget:set_text(bat_clo()) 
    end)
battimer:start()

-- create a network menu widget
function mynetworkmenu()
    networkmenu = awful.menu({	items = netmgr.generate_network_menu()	  })
    return networkmenu
end
mynetworklauncher = awful.widget.launcher({ image = beautiful.network_icon, menu = awful.menu({ items = { { "s" , "s" }, { "s" , "s" }, } }) })
function updatenetworkmenu()
	mynetworklauncher = awful.widget.launcher({ image = beautiful.network_icon,
												menu = mynetworkmenu()})
	return mynetworklauncher
end
--updatenetworkmenu()
vicious.register(mynetworklauncher, awful.widget.launcher, updatenetworkmenu(), 30 )

-- create a network map widget
function mynetworkmap()
    networkmonitor = awful.menu({	items = netmntr.generate_widget_map()	  })
    return networkmonitor
end
mynetworkmapwidget = awful.widget.launcher({ image = beautiful.network_icon, menu = awful.menu({ items = { { "s" , "s" }, { "s" , "s" }, } }) })
function updatenetworkmap()
	mynetworkmapwidget = awful.widget.launcher({ image = beautiful.monitoring_icon,
	                                            menu = mynetworkmap()})
	return mynetworkmapwidget
end
--updatenetworkmap()
vicious.register(mynetworkmapwidget, awful.widget.launcher, updatenetworkmap(), 1440 )

-- Create a weather widget
myweatherwidget = wibox.widget.textbox()
weathertooltip = awful.tooltip({ objects = { myweatherwidget },})

vicious.register(myweatherwidget, vicious.widgets.weather, 
				function(widget, args)
					weathertooltip:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. "km/h " .. args["{wind}"] .. "\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
                    return args["{tempc}"] .. "C"
                end, 1800, "KEKN")

-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Create a wibox for each screen and add it
mywibox = {}
myshortcutbox = {}
function hideshortcutbox()
    myshortcutbox[mouse.screen].visible = not myshortcutbox[mouse.screen].visible
    if myshortcutbox[mouse.screen].visible then
        revelation({rule={class="conky"}, is_excluded=true})
    else
        cleanup_revelation_tag()
    end
end
myquicklaunchtoggle = awful.widget.button({ image=beautiful.awesome_icon })
myquicklaunchtoggle:buttons(awful.button({}, 1, function () 
    hideshortcutbox() 
    end
))
sbtimer = timer({timeout = 8})
sbtimer:connect_signal("timeout", function()
        if myshortcutbox[mouse.screen].visible then
            hideshortcutbox()
            cleanup_revelation_tag()
        end
    end)
sbtimer:start()
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)
    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)
    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(myquicklaunchtoggle)
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
	right_layout:add(myweatherwidget)
    right_layout:add(mynetworkmapwidget)
    right_layout:add(mynetworklauncher)
    right_layout:add(mylayoutbox[s])
    right_layout:add(mybatterywidget)
    right_layout:add(mytextclock)
    right_layout:add(mymanagerlauncher)
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)
    -- create the sidebar shortcut launcher wibox
    myshortcutbox[s] = awful.wibox({ position = "bottom", align = "left", screen = s    })
    myshortcutbox[s].height=24
	myshortcutbox[s].width=goblin.button_list_count_members()*myshortcutbox[s].height
    --myshortcutbox[s].y = (768/2)-(myshortcutbox[s].height/2)
    myshortcutbox[s]:set_widget(goblin.button_layout_menu())
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", function () hideshortcutbox() end),
    awful.key({}, "Pause", function() toggle_conky() end),
   -- bind PrintScrn to capture a screen
    awful.key({}, "Print", function() awful.util.spawn("capscr",false) end),
    awful.key({ modkey,			  }, "Print", function() 
		hideshortcutbox()
		awful.util.spawn("capscr 2",false) 
	end
	),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({}, "`", 
	function () 
	    if mymainmenu.visible == true then
	        mymainmenu:show() 
	    end
	end),
--    awful.key({}, "Tab", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}


geom = screen[mouse.screen].workarea
kb_geoh = 335
kb_geow = 1306
kb_geox = geom.width - kb_geow
kb_geoy = geom.height - kb_geoh
kb_dummy_geox = geom.width - 134
kb_dummy_geoy = geom.height - 134
--scalex=33.5
--scaley=33.5
-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "Conky" },
      properties = {
      floating = true,
      sticky = true,
      ontop = false,
      focusable = false,
    }, callback = function(c) c:geometry({x=700, y=16}) end },
    { rule = { class = "Florence" },
      properties = {
      floating = true,
      sticky = true,
    }, callback = function(c) 
           for key, value in pairs(c.geometry(c)) do
               if c.geometry(c).y < 400 then
                   c:geometry({x=kb_dummy_geox, y=kb_dummy_geoy, height=134, width=134})
               end
           end
       end },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Pcmanfm" }, properties = { tag = tags[1][1] } },
    { rule = { class = "Terminator" }, properties = { tag = tags[1][2] }, switchtotag = true },
    { rule = { class = "htop" }, properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class = "ntop" }, properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class = "torarm" }, properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class = "rtorrent" }, properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class = "Wifite" }, properties = { tag = tags[1][2], switchtotag = true } },
    { rule = { class = "Iceweasel" }, properties = { tag = tags[1][3] } },
    { rule = { class = "Dillo" }, properties = { tag = tags[1][3] } },
    { rule = { class = "Xombrero" }, properties = { tag = tags[1][3] } },
    { rule = { class = "Tor Browser" }, properties = { tag = tags[1][3] } },
    { rule = { class = "Uzbl-core" }, properties = { tag = tags[1][3] } },
    { rule = { class = "Lynx" }, properties = { tag = tags[1][3] } },
    { rule = { class = "Medit" }, properties = { tag = tags[1][4] } },
	{ rule = { class = "medit" }, properties = { tag = tags[1][4] } },
    { rule = { class = "Anjuta" }, properties = { tag = tags[1][4] } },
    { rule = { class = "Icedove" }, properties = { tag = tags[1][5] } },
    { rule = { class = "Abiword" }, properties = { tag = tags[1][6] } },
    { rule = { class = "Dia" }, properties = { tag = tags[1][6] } },
    { rule = { class = "Gnumeric" }, properties = { tag = tags[1][6] } },
    { rule = { class = "Pinta" }, properties = { tag = tags[1][6] } },
    { rule = { class = "Gringotts" }, properties = { tag = tags[1][6] }, callback = function(c) awful.titlebar.show(c, { modkey = modkey, height = 16, font = "mono 7"}) end },
    { rule = { class = "XCalc" }, properties = { tag = tags[1][6] }, callback = function(c) awful.titlebar.show(c, { modkey = modkey, height = 16, font = "mono 7"}) end },
    { rule = { class = "tiles" }, properties = { tag = tags[1][7] }, callback = function(c) awful.titlebar.show(c, { modkey = modkey, height = 16, font = "mono 7"}) end },
    { rule = { class = "Bleachbit" }, properties = { tag = tags[1][8] } },
    { rule = { class = "Synaptic" }, properties = { tag = tags[1][8] } }
}
-- }}} 

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count change
        awful.placement.no_offscreen(c)
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.util.spawn_with_shell("run_once /usr/bin/xscreensaver")
awful.util.spawn_with_shell("run_once compton")
awful.util.spawn_with_shell("run_once conky")
-- Start the on-screen keyboard
--awful.util.spawn_with_shell("run_once user-florence")

-- }}}

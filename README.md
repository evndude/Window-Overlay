## Window Overlay
This is an AutoHotKey script that turns a window into an overlay by making it always on top of other windows. Options include mouse click-through, transparency, and maintaining the overlay's size and position.

There are two configurable hotkeys: one for showing/hiding the overlay and one for changing the overlay window.

Open the Settings from the tray menu and read the tooltips for more information about each option.

To enable multiple overlay windows, run a copy of the script in another directory and with different hotkeys.

There is also a tool to show or hide any window (including hidden) if something ever goes wrong.

Hosted on GitHub: http://github.com/evndude/Window-Overlay
Released under MIT license. Copyright (c) 2014 Evan Casey.


## Change Log
```
Version    Date          Notes
-------    ----------    --------------
1.1        2014-08-05    Added hotkey for changing windows
1.0        2014-07-08    Initial release
```


## Screen Shots
![Settings](https://raw.githubusercontent.com/evndude/evndude.github.io/master/Windows-Overlay_files/Settings.png)

![Toggle Window Visibility](https://raw.githubusercontent.com/evndude/evndude.github.io/master/Windows-Overlay_files/ToggleWindowVisibility.png)


#### EXE Command Examples:
EXE commands may need to be enclosed in quotes to work. Read the program's documentation to find out what (if any) command line switches are available, and how to format them.

EXE commands enclosed in `'single'` or `"double"` quotation marks are saved to the INI file with the quotes substituted with `<single>` or `<<double>>` angle brackets because AutoHotKey automatically removes them when reading variables from an INI file.

**Windows Explorer:**
```
Start:  the folder's path (e.g. C:\Users\Evan\Documents)
Show:   [left blank]
Hide:   [left blank]
```

**Foobar2000:**
```
Required components:
 - Run Command (foo_runcmd): for enabling command line switches
 - Popup Panels(foo_popup_panels): for more popup window options
 
Install the Run Command component, and then on the menu bar open
	File -> Run Command...
to discover the available commands.

Install Popup Panels component, and then on the menu bar open
	View -> Popup Panels -> New Panel
and choose a panel to create a new popup panel.

The window name is "Lyrics" for the following example command.
The quotes are necessary for these commands to work.

Start: 	[left blank]
Show: 	"/runcmd=View/Popup panels/Show/Lyrics"
Hide: 	"/runcmd=View/Popup panels/Show/Lyrics"
```

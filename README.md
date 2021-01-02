*This is a work in progress!*

#  Yvim

Yvim uses macOS accessibility APIs to add Vim-inspired keyboard commands to Xcode.

![Control mode](screenshot_control.png)
![Visual mode](screenshot_visual.png)
![Insert mode](screenshot_insert.png)

## How to install

* Copy `Yvim.app` to the `/Applications` folder.
* Launch `Yvim.app` before or after starting Xcode.
* You will be requested to give `Yvim` the "Accessibility" and "Input monitoring" permissions in System Preferences.

It is recommended to change to a block cursor style in Xcode in Preferences in the Themes tab.

To always automatically run `Yvim` , add it under the Users preference pane in System Preferences. It will not affect any apps other than Xcode.

## Compatibility

Yvim has been tested to work under macOS Big Sur and Catalina. It should work independently of the version of Xcode, and has been tested on Xcode 12.3.

## Features

Yvim adds three modes to the source code editor in Xcode. The current mode is displayed in the top right of the menu bar.

For now, Yvim supports the following features:

In `-- COMMAND --` mode:

* Navigate the cursor using the `h`, `l`, `j` and `k` keys.
* Insert text before the cursor using `i` or after the cursor with `a`.
* Navigate words using the `w` and `b` keys.
* Move to the beginning or end of a line using `0` and `$`.
* Enter visual mode using `v`.
* Paste text from the internal register.

When in `-- INSERT --` mode, use the escape key to go back to command mode. Any other key or key combination is sent through to Xcode.

In `-- VISUAL --` mode, the same navigation controls as in the command mode are supported. In addition, use `d` to delete the selection or `y` to yank it to the internal register.

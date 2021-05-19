#  Yvim

Yvim uses macOS accessibility APIs to add Vim-inspired keyboard commands to Xcode. It is an alternative to Xvim2 that does not require code injection.

![Command mode](screenshot.png)

### Commands

* Insert text before `i` or after the cursor `a`, finish with `esc`.

* Enter visual mode `v`.

* Paste text that was deleted or yanked `p`.

* Undo the previous action `u`.

* Repeat the previous action `.`.

### Operations

Operations take a motion, text object or visual mode selection.

* Delete `d`, yank `y` or change text `c`.

### Motions

* Move the cursor one step `h`, `l`, `j`, `k`.

* Jump to the beginning `0` or end `$` of a line, or to the first non-space character `^`.

* Find a character after the cursor `f` + `{char}`, or move forward upto a character `t` + `{char}`, or in reverse `F` + `{char}`, `T` + `{char}`.

* Perform any motion multiple steps at once `{n}` + `{motion}`.

### Text objects

* Inner word without whitespaces `i` + `w`.

## How to run

* Change to a block cursor style in Xcode in Preferences in the Themes tab.
* Launch Yvim.
* Give Yvim the "Accessibility" and "Input monitoring" permissions in System Preferences.

Yvim does not affect any apps other than Xcode.

## Compatibility

Yvim has been tested to work with macOS Big Sur and Xcode 12.

#  Yvim

Yvim uses macOS accessibility APIs to add Vim-inspired keyboard commands to Xcode. It is an alternative to Xvim2 that does not require code injection.

### Showcase

![Repeat](demo_repeat.gif)

Repeating a command

![Visual](demo_visual.gif)

Visual mode

![Move lines](demo_move_lines.gif)

Moving lines down

### Example commands

* Change the current line `cc`.

* Delete from the cursor upto the first opening bracket `dt(`.

* Yank three lines `y3y`.

* Change the word under the cursor `ciw`.

### Simple operations

* Insert text before `i` or after the cursor `a`.

* Undo the previous action `u`.

* Repeat the previous action `.`.

* Enter visual mode `v`.

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

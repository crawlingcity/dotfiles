# EurKEY for macOS

This directory backs up the exact EurKEY v1.2 layout currently used on this
Mac.

The layout is based on
[EurKEY-Mac](https://gitlab.com/lbschenkel/EurKEY-Mac), which is licensed
under GPLv3. The icon is credited by that project to Alpak/Iconspedia.

## Install

After cloning the dotfiles repository:

```zsh
./eurkey/install.sh
```

The installer copies the layout and icon into the current user's
`~/Library/Keyboard Layouts` directory. It is safe to run more than once and
does not require administrator privileges.

After the first installation, log out and back in. Then open:

**System Settings → Keyboard → Text Input → Edit → +**

Search for **EurKEY v1.2**, add it, and select it as the active input source.

macOS stores the selected input-source state separately from the layout files,
so that final selection remains a one-time manual step on a new Mac.

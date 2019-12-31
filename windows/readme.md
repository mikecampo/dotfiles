# Windows Setup

* Turn off hibernation
  * Open admin cmd prompt: `powercfg.exe /hibernate off`

* Install Windows Defender

* Enable clear text

* Setup a symbol server:
    * Right-click My Computer -> Properties -> Advanced Tab -> Environment Variables
    * Add a new System Variable called `_NT_SYMBOL_PATH`
    * Set the value to `SRV*c:\symbols*http://msdl.microsoft.com/download/symbols`, replacing the
      first path to where you want the symbols to live.

* Configure crash dump storage location for projects via the registry.

## Enable security updates

If you don't have an antivirus program, or you do but it's not verified by Microsoft, then you will
not receive security updates unless you set a key in the registry. Note that Windows Defender counts
as a valid antivirus program.

Add the following registry key:
Key="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat"
Value="cadca5fe-87d3-4b96-b7fb-a231484277cc" Type="REG_DWORD”
Data="0x00000000”

## Disable Win 7 Fault Tolerant Heap
*Might be in Win 10+ too?*
* I don't see why you want to spend large amounts of CPU time to hide application instability.
* https://docs.microsoft.com/en-us/windows/desktop/Win7AppQual/fault-tolerant-heap
  * Disable on system via regedit: set the REG_DWORD value **HKLM\\Software\\Microsoft\\FTH\\Enabled** to **0**.

## Setup up Unix-like Shell
* Install [MSYS2 w/ MinGW-w64](http://www.msys2.org/) to `C:\msys64`
  * Open `C:\msys64\mingw64.exe`
  * Run `pacman -Syu`, then restart the terminal and run `pacman -Su`.
  * Run `pacman -S base-devel mingw-w64-x86_64-toolchain git bc`
  * Use `C:\Users\<user>` as the terminal $HOME by editting `C:\msys64\etc\nsswitch.conf` and
    changing the `db_home` value to `windows`.
* You may need to work around an issue with envsubst.exe - you'll know there's a bug if git
  displays `not a valid identifier line 89: export: dashless` or rebase complains about `new_count`.
  * To patch, cd into `/mingw64/bin` and run `mv envsubst.exe envsubst.exe_backup`. Now run `pacman -S gettext`
    and verify that `which envsubst` reports back `/usr/bin/envsubst`.
  * Bug report is at https://github.com/Alexpux/MSYS2-packages/issues/735
* Map caps to left-ctrl using https://sharpkeys.codeplex.com/
* Setup git completions for bash:
  * `curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash`

* Use symlink command `cmd //c 'mklink .name-of-dotfile drive:\path\to\file'`.
* Symlink `~/.private-files` to the root directory containing `dev/`.
* Symlink `~/.dev` to `~/.private-files/path/to/dev`.
* Symlink `~/.dotfiles` to `~/.dev/path/to/dotfiles`.
* Create `~/bin`.
* Symlink `$HOME/bin/sym` to `$HOME/.dotfiles/bin/symbolic-link`. You can now use this to
  do symlinks.
* Symlink files in the dotfiles windows folder.
* Symlink appropriate files in the root dotfiles directory.
  * Ignore all zsh files.
  * Don't symlink .vim folder because Plugged will fail to install the plugins. Just make a copy.
* Setup private dotfiles. Once done, you should now have `~/bin` and `~/.dotfiles/bin` in your path.

## Configure Private dotfiles
* The most important task is to setup the `c-dev-x64` shortcut for launching a msys shell with appropriate dev environment.
  * Add this to your taskbar and use this for launching a shell.

## Setting up dev tools

* Download the Windows 2003 Resource Kit in order to get tools like `list.exe` (command line hex
  editor)
  * URL: https://www.microsoft.com/en-us/download/details.aspx?id=17657
  * Installer will display a compatibility warning. Ignore it.
  * Full list of tools can be found here
    https://www.technlg.net/windows/download-windows-resource-kit-tools/

## Setting up Visual Studio

* Use the backed up VS2015 ISO or download it from https://go.microsoft.com/fwlink/?LinkId=615448&clcid=0x409
* Pick a custom install directory, e.g. `/x/programs/Visual Studio 15`
* Select a custom install and check off the C++ language support.
* Once installed, open Visual Studio and go to `Tools` -> `Options`. Open `Debugging` -> `Symbols` and add the path to the cached symbols directory that you set up above under `Setup a symbol server`.

## Setting up Vim

### Compiling on Windows (optional)

* Open the shell with `C:\msys64\msys2_shell.cmd` -- If you don't do this then vim will not compile.
* Run `pacman -S --needed base-devel msys2-devel gawk perl python2 python3 ruby libiconv ncurses-devel libcrypt-devel`
* Clone MSYS2 packages: `https://github.com/msys2/MSYS2-packages`
* cd into the vim package
* Edit `PKGBUILD` and change the version number to the one you want to build. You can see the available versions at `https://github.com/vim/vim`
* Run `makepkg`
* If checksums fail then generate new ones: `makepkg -g -f -p PKGBUILD`, copy the output, edit `PKGBUILD` and replace the checksums array with the new values.
    * Run `makepkg` again
    * If it fails to apply a patch then you'll need to make the fixes yourself:
        * Clone vim (`https://github.com/vim/vim`), cd into `vim/src`.
        * Modify the file(s) that they failed patch was changing and make the correct fixes.
        * Commit the change.
        * Generate a patch file with `git diff commitid1 commitid2 > newpatch.patch`
        * Copy the patch to `MSYS2-packages/vim` and use the same name as the original patch that failed.
        * Regen the pkg checksums and add them to `PKGBUILD`.
        * Run `makepkg` again.
* Once built, install it with `pacman -U ${package-name}*.pkg.tar.xz`

### Configuring

1. Open Vim and run `:PlugInstall` to fetch all plugins.
2. Create tmp folder for swap files. See `set directory` and `set backupdir` paths in `vimrc`.

### Setting up Custom Search

* First install Rusto. See `Setting up Rust` below.
* Setup `ripgrep`:
  * Open an `msvc x64` shell and run `cargo install ripgrep`.
  * Verify it works by running `rg` in a shell.

### Setting up ctags

* Install the latest Universal ctags build: https://github.com/universal-ctags/ctags-win32/releases
* Place it in `~/bin`.

## Setting up Cygwin

* Can create symlinks to dotfiles using the git bash shell. The cygwin home directory
  is likely going to be `C:\cygwin\home\<username>`.
* Build [rlwrap](https://github.com/hanslub42/rlwrap)

## Setting up Rust

* Install `rustup`: https://win.rustup.rs/

## Setting up Go

* Installer: https://golang.org/doc/install

## Setting up Clojure

* Install Lein: https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein.bat

## Setting up Xbox stuff

* Install the xbox controller drivers
* Turn off stats collection
  * cmd-r, msconfig.exe, startup tab, uncheck `Microsoft Xbox 360 Accessories`.

## Turn off various startup processes
* cmd-r -> msconfig.exe -> startup tab

## Software

* Install `tree`: `pacman -S tree`

* Install Desktop Restore (http://www.midiox.com/index.htm?http://midiox.com/desktoprestore.htm)

* Install Android platform tools to get adb.exe:
  * Download Android commandline tools https://developer.android.com/studio/#downloads
  * Unzip to some location.
  * Inside the sdk dir, run `$ tools/bin/sdkmanager.bat platform-tools`.
  * You can now add the platform-tools dir to your path if you want, or just symlink `adb` to `~/bin`.

### Youtube-DL

* In order to combine audio and video files you need ffmpeg. Download from https://ffmpeg.zeranoe.com/builds/
and place the exe's in `~/bin`.

### Firefox
* If you see jaggy fonts then about `about:config` and check the value of
  `gfx.font_rendering.cleartype_params.rendering_mode`. Mine was -1 by default. Setting it to 5
  removed the bad font rendering.


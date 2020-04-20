# Windows Setup

* Turn off hibernation
  * Open admin cmd prompt: `powercfg.exe /hibernate off`

* Map caps to left-ctrl using sharpkeys

* Run photo_viewer.reg from this folder to restore access to the Windows Photo Viewer app.
  The default Win10 photos app is fucking awful.
    * You'll need to change the default app for the various image extensions. Don't change gif types
      though because photo viewer doesn't support animations.
    * Now run disable-are-you-sure-you-want-to-open-with-the-default-program-dialog.reg to stop it
      from occasionally asking if you still want to use photo viewer.

* Add custom hosts file
    * Run notepad as administrator
    * Open C:/Windows/System32/Drivers/etc/hosts
    * Add contents of the hosts file from this directory
    * Restart PC

* Disable the WinSAT task which is used to figure out your Windows performance score. It eats up
processor time and is generally useless.
    * Open task scheduler.
        * **note** If you see an error about a selected task {0} no longer existing then you'll need
          to repair the task scheduler. See
          https://www.thewindowsclub.com/the-selected-task-0-no-longer-exists-error-in-task-scheduler
    * Go to `Local` -> `Microsoft` -> `Maintenance` and disable the WinSAT task.

* Setup a symbol server:
    * Right-click My Computer -> Properties -> Advanced Tab -> Environment Variables
    * Add a new System Variable called `_NT_SYMBOL_PATH`
    * Set the value to `SRV*c:\symbols*http://msdl.microsoft.com/download/symbols`, replacing the
      first path to where you want the symbols to live.

* Configure crash dump storage location for projects via the registry.

* Enable security updates
    *this may no longer be an issue*
    * If you don't have an antivirus program, or you do but it's not verified by Microsoft, then you
      will not receive security updates unless you set a key in the registry. Note that Windows
      Defender counts as a valid antivirus program.
    * Add the following registry key:

        Key="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat"
        Value="cadca5fe-87d3-4b96-b7fb-a231484277cc" Type="REG_DWORD”
        Data="0x00000000”

* Increase TDR setting for GPU Driver
    * TDR determines the length of time that a GPU can hang on a computation until the OS restarts
      the driver. By default this is set to a few seconds so you can experience app crashes when
      using GPU intensive software, like 3D modeling or texturing. To increase the duration, follow
      this guide: https://web.archive.org/web/20191107173337/https://docs.substance3d.com/spdoc/gpu-drivers-crash-with-long-computations-128745489.html

## Windows 7 Stuff

* Enable clear text
* Disable Win 7 Fault Tolerant Heap
    * I don't see why you want to spend large amounts of CPU time to hide application instability.
    * https://docs.microsoft.com/en-us/windows/desktop/Win7AppQual/fault-tolerant-heap
      * Disable on system via regedit: set the REG_DWORD value `HKLM\\Software\\Microsoft\\FTH\\Enabled` to `0`.

## Windows 10 Stuff

* Disable the Windows Customer Experience Improvement program via group policy
  https://www.ghacks.net/2016/10/26/turn-off-the-windows-customer-experience-program/
* Install the Windows SDK https://developer.microsoft.com/en-us/windows/downloads/windows-10-sdk

## Setting up Visual Studio

* Use an install path with no spaces in it `/x/programs/vs15`
* Select custom install and check off the C++ language support.
* Once installed, open Visual Studio and go to `Tools` -> `Options`. Open `Debugging` -> `Symbols`
  and add the path to the cached symbols directory that you set up above under `Setup a symbol server`.
* Open the `Visual Studio Layout` folder in this directory and copy the file to `%LOCALAPPDATA%/Microsoft/VisualStudio/{VisualStudioInstanceID}`.
  You can now apply the custom layout in VS: `Window -> Apply Window Layout -> Campo`

## Setup up Unix-like Shell
* Install [MSYS2 w/ MinGW-w64](http://www.msys2.org/) to `C:\msys64`
  * Open `C:\msys64\mingw64.exe`
  * Run `pacman -Syu`, then restart the terminal and run `pacman -Su`.
  * Run `pacman -S base-devel mingw-w64-x86_64-toolchain git bc`
  * Use `C:\Users\<user>` as the terminal $HOME by editing `C:\msys64\etc\nsswitch.conf` and
    changing the `db_home` value to `windows`.
* You may need to work around an issue with envsubst.exe - you'll know there's a bug if git
  displays `not a valid identifier line 89: export: dashless` or rebase complains about `new_count`.
  * To patch, cd into `/mingw64/bin` and run `mv envsubst.exe envsubst.exe_backup`. Now run `pacman -S gettext`
    and verify that `which envsubst` reports back `/usr/bin/envsubst`.
  * Bug report is at https://github.com/Alexpux/MSYS2-packages/issues/735
* Switch to the shell `C:\msys64\msys2.exe` going forward.
  * You can also load the shell with a batch file. This allows you to do some setup work, like run `vcvarsall.bat`, eg.
    ```batch
    REM saved as shell-64.bat
    @echo off

    REM For VS2015:
    call "drive:\path-to-vs2015\VC\vcvarsall.bat" x64

    REM For VS2017:
    REM call "drive:\path-to-vs2017\VC\Auxiliary\Build\vcvarsall.bat" x64

    REM For VS2019:
    REM call "drive:\path-to-vs2019\VC\Auxiliary\Build\vcvarsall.bat" x64

    REM Disable CRT heap debug stuff. See https://preshing.com/20110717/the-windows-heap-is-slow-when-launched-from-the-debugger/
    set _NO_DEBUG_HEAP=1

    call C:\msys64\msys2_shell.cmd -mingw64 -use-full-path
    exit
    ```
    * This will launch a 64-bit env. If you need 32-bit then replace x64 above with x86.
    * Now you can make a system32 cmd line shortcut that will be used to launch the batch file. e.g.
      * `target:` `%windir%\System32\cmd.exe /k drive:\path-to-bat-file\shell-64.bat`
      * `start in:` `drive:\some-path`
* Setup git completions for bash:
  * `curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash`

### 32-bit dev tools
* Load a 32-bit shell
* Install toolchain: `pacman -S mingw-w64-i686-toolchain`

## Setting up dev tools

* Download the Windows 2003 Resource Kit in order to get tools like `list.exe` (command line hex
  editor)
  * URL: https://www.microsoft.com/en-us/download/details.aspx?id=17657
  * Installer will display a compatibility warning. Ignore it.
  * Full list of tools can be found here
    https://www.technlg.net/windows/download-windows-resource-kit-tools/

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
2. Create a tmp folder for swap files (i.e. `set directory` and `set backupdir`). Place these
   at `~/.vimrc.private` so that the main vimrc file can source it. We do it this way so that you
   can have a tmp folder path that is specific to your setup.

### Setting up Custom Search

* First install Rusto. See `Setting up Rust` below.
* Setup `ripgrep`:
  * Open an `msvc x64` shell and run `cargo install ripgrep`. **Note** the last time I did this
  I got linker errors saying that it was trying to link an x86 exe in a 64-bit env. I had to run
  the `msvc x86` shell instead.
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

## Setting up Wacom tablet

* Install the shitty Wacom driver.
* Preemptively deal with future issues in Photoshop by saving the `PSUserConfig.txt` file
  in this directory to `%APPDATA%\Adobe\Adobe Photoshop XX\Adobe Photoshop XX Settings` (should take you to AppData/Roaming)
* In Wacom tablet settings disable anything having to do with Windows Ink.
* These steps are from [FlippedNormals - Fixing All Issues with Your Wacom Tablet and Photoshop](https://www.youtube.com/watch?v=sGi47EWEkuY)

## Software

* Install `tree`: `pacman -S tree`

* Install [Desktop Restore](http://www.midiox.com/index.htm?http://midiox.com/desktoprestore.htm)

* Install Android platform tools to get adb.exe:
  * Download [Android commandline tools](https://developer.android.com/studio/#downloads)
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

### Spotify
* If you install an older version then you'll need to block the auto updater:
    * Go to `%APPDATA%\Spotify` and create `Spotify_new.exe` and `Spotify_new.exe.sig`
    * Set both as read-only. I did this by denying all permissions to the active user account.
* Spotify caches song data in `C:\Users\<user>\AppData\Local\Spotify\Data` and this path cannot be
  modified within the app settings. This is an issue if your main drive is an SSD, as you want to
  limit the amount of writes to it and you may not have a lot of free space. The simplest way I
  found to stop this is to change the `Data` folder's permissions (under the Security tab) and deny
  all properties for the user account.


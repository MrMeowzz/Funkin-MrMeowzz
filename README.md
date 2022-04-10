# Mr Meowzz's FNF

Mr Meowzz's FNF is basically my version of [Kade Engine](https://github.com/KadeDev/Kade-Engine) but it has extra songs and stuff. (KADE ENGINE IS BETTER, THIS CODE IS A MESS)

**also i dont really care what you do with this project,**

**if you want to fork it go ahead but all i ask is give credit :)**

**and credit to the assets in this too from [here](https://github.com/MrMeowzz/Funkin-MrMeowzz/wiki/credits)**

## Links

[Credits](https://github.com/MrMeowzz/Funkin-MrMeowzz/wiki/credits)

[Play Mr Meowzz's FNF in your browser!](https://mrmeowzz.github.io/Funkin-MrMeowzz/web)

[Play a prerelease version of Mr Meowzz's FNF in your browser when available!](https://mrmeowzz.github.io/Funkin-MrMeowzz/webprerelease)

[Original by ninjamuffin99.](https://github.com/ninjamuffin99/Funkin)

[Wiki](https://github.com/MrMeowzz/Funkin-MrMeowzz/wiki)

## Build instructions

**THESE INTRUCTIONS ARE A BIT DIFFERENT FROM THE ORIGINAL GAME BECAUSE OF THE WEEK 7 CUTSCENES! ONLY WORKS FOR WINDOWS CURRENTLY!**

THESE INSTRUCTIONS ARE FOR COMPILING THE GAME'S SOURCE CODE!!!

IF YOU WANT TO JUST DOWNLOAD AND INSTALL AND PLAY THE GAME NORMALLY, CLICK [HERE](https://github.com/MrMeowzz/Funkin-MrMeowzz/releases/latest/download/Funkin.zip) TO DOWNLOAD THE LATEST RELEASE FOR WINDOWS!! (MAC AND LINUX SUPPORT LATER)

IF YOU WANT TO COMPILE THE GAME YOURSELF, CONTINUE READING!!!

### Installing the Required Programs

First you need to install Haxe and HaxeFlixel. I'm too lazy to write and keep updated with that setup (which is pretty simple). 
1. [Install Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) (Download 4.1.5 instead of 4.2.0 because 4.2.0 is broken and is not working with gits properly...)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

Other installations you'd need is the additional libraries, Currently, these are all of the things you need to install:
```
flixel
flixel-addons
flixel-ui
hscript
newgrounds
actuate
```
So for each of those type `haxelib install [library]` so shit like `haxelib install newgrounds`

You'll also need to install a couple things that involve Gits. To do this, you need to do a few things first.
1. Download [git-scm](https://git-scm.com/downloads)
2. Follow instructions to install the application properly.
3. Run `haxelib git polymod https://github.com/larsiusprime/polymod.git` to install Polymod.
4. Run `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` to install Discord RPC.
5. Run `haxelib git extension-webm https://github.com/MrMeowzz/extension-webm` to install the extension-webm fork (for week 7 cutscenes).

You should have everything ready for compiling the game! Follow the guide below to continue!

At the moment, you can optionally fix the transition bug in songs with zoomed out cameras.
- Run `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` in the terminal/command-prompt.

### Compiling game

Once you have all those installed, it's pretty easy to compile the game. You just need to run the `compile html` bat file in the root of the project to build and run the HTML5 version. The html files will be located under `export\release\html5\bin`

To compile the exe version of the game, you need to install Visual Studio Community 2019. While installing VSC, don't click on any of the options to install workloads. Instead, go to the individual components tab and choose the following:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)
* C++ Profiling tools
* C++ CMake tools for windows
* C++ ATL for v142 build tools (x86 & x64)
* C++ MFC for v142 build tools (x86 & x64)
* C++/CLI support for v142 build tools (14.21)
* C++ Modules for v142 build tools (x64/x86)
* Clang Compiler for Windows
* Windows 10 SDK (10.0.17134.0)
* Windows 10 SDK (10.0.16299.0)
* MSVC v141 - VS 2017 C++ x64/x86 build tools
* MSVC v140 - VS 2015 C++ build tools (v14.00)

This will install about 22GB of crap, but once that is done you can run the `compile exe` bat file in the root of the project. Once that finishes (it takes forever even on a higher end PC), the .exe file will be located under `export\release\windows\bin`

### Additional guides

- [Command line basics](https://ninjamuffin99.newgrounds.com/news/post/1090480)
- [Debug Mode Info](https://haxeflixel.com/documentation/debugger)

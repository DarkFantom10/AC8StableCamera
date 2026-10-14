AC8 Stable Camera v1.0
======================

Removes the roll-driven motion from ACE COMBAT 8's third-person chase camera, for players
who get motion sick from the stock camera:
  - the camera's pendulum swing
  - the sideways slide and extra tilt while rolling (with Standard controls the stock camera
    slides about 8 m sideways and tilts 15 degrees on every roll)

Applies to camera A and B and to Standard and Expert controls (tested with both camera modes).
Cockpit and first-person views are unchanged.


REQUIREMENTS
  ACE COMBAT 8 on Steam (Windows). UE4SS, the mod loader, is included.


IMPORTANT - OFFLINE ONLY, DO NOT USE ONLINE
  UE4SS cannot run while EasyAntiCheat is active, so this mod starts the game without EAC,
  using the same command as Bandai Namco's own internal "ACE COMBAT 8 No EAC" Steam launch
  option (Game\Binaries\Win64\AceCombat8.exe -SaveToUserDir). It replaces Steam's launch
  target, start_protected_game.exe, with a small launcher. The game executable is never modified.
  Online play is not available while the mod is installed.


INSTALL
  1. Extract this archive into your ACE COMBAT 8 folder
     (for example C:\Program Files (x86)\Steam\steamapps\common\ACE COMBAT 8)
     and overwrite start_protected_game.exe when asked.
  2. Launch the game from Steam as usual. No EAC splash screen means it worked.


USAGE
  Ctrl+F5 toggles the camera fix on/off in flight, to compare with the stock camera.
  Options are at the top of Game\Binaries\Win64\ue4ss\Mods\AC8StableCamera\Scripts\main.lua.


UNINSTALL / BEFORE PLAYING ONLINE
  1. Run Steam's "Verify integrity of game files" (game Properties > Installed Files).
     This restores the original start_protected_game.exe and EAC.
  2. Delete Game\Binaries\Win64\dwmapi.dll and the Game\Binaries\Win64\ue4ss folder.
     Verify does NOT remove these. Never launch the game with EAC while dwmapi.dll is there.
     If you forget, EAC blocks it with "Untrusted system file (...dwmapi.dll)" and the game
     shows error 0xc000007b - just delete dwmapi.dll and launch again.


AFTER GAME UPDATES
  If the EAC splash screen comes back, the update restored Steam's launcher: extract the
  archive again.


ALREADY USE UE4SS?
  Copy start_protected_game.exe and Game\Binaries\Win64\ue4ss\Mods\AC8StableCamera (it has an
  enabled.txt) into your install. AC8 needs a recent UE4SS experimental build.


BUILD THE LAUNCHER YOURSELF
  start_protected_game.exe is built from AC8StableCamera\source\AC8NoEacLauncher.cs with the C#
  compiler that ships with Windows (.NET Framework 4). In Command Prompt, from that source folder:

    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe -nologo -target:winexe -optimize+ -r:System.Windows.Forms.dll -r:System.Core.dll -out:start_protected_game.exe AC8NoEacLauncher.cs

  Every build has a slightly different hash (the compiler stamps a unique build ID into it), so
  compare the source code, not the hash. SHA-256 of the shipped build:
    23854f027412b4919778a923f17bba77be3689735f6754a5ddf868c7c7d50d7f  start_protected_game.exe


THIRD-PARTY FILES (UE4SS, MIT license)
  These files are unmodified copies from the official UE4SS release
  UE4SS_v3.0.1-1165-g12ec45a0.zip:
    Download:  https://github.com/UE4SS-RE/RE-UE4SS/releases/download/experimental/UE4SS_v3.0.1-1165-g12ec45a0.zip
    Release:   https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental
    Source:    https://github.com/UE4SS-RE/RE-UE4SS/commit/12ec45a0dadcfc43ba88eaf75e0a67d34038a3cd
    Zip SHA-256: d51512869bde8c32a1ebd6732a01fbb1343e6b3e0fb9cd0d8a9b1841b68cba97

  SHA-256                                                           File
  3f11fad958a959dd7ab78ab0b42be90e33f8ef8e152fbdc3c8e4278cb590e6cc  Game\Binaries\Win64\dwmapi.dll
  87b494191b7bc9bcfd938f54190c09e9aaa01dc354f6927ba661b0a18bad13ee  Game\Binaries\Win64\ue4ss\UE4SS.dll
  58614ee7b13464c1f5ae0804a35682443c9c3bdc570fe54940e899ae6139b695  Game\Binaries\Win64\ue4ss\UE4SS-settings.ini
  99e1d8f8b7cb68e8b2313380ae3b0c8115e39dfbc443fcf21fd67ab74ce1d57e  Game\Binaries\Win64\ue4ss\LICENSE
  6b8c1725ff59a318b812d5952f63107778b4ceb22b882b297a3666ee9e06c8ff  Game\Binaries\Win64\ue4ss\UE4SS_SDK_Backends\UE4SS.json
  7476f02eef0c87bfeab169f2ffe2e704363faeaae4bf9f1bda574b1e34f4a0e9  Game\Binaries\Win64\ue4ss\Mods\shared\UEHelpers\UEHelpers.lua

  Everything else is this mod's own: start_protected_game.exe (source above), the AC8StableCamera
  mod folder, and Mods\mods.txt / mods.json (which only enable this mod).

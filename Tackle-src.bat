@echo off
set "currentver=2.0.0"
TITLE Tackle Debug Console
echo checking version
curl -sL -o C:\Users\Public\Downloads\ver.txt https://raw.githubusercontent.com/uncreativeCultist/TackleModManager/refs/heads/main/Storage/ver.txt >nul
set /p ver=<C:\Users\Public\Downloads\ver.txt
del /q C:\Users\Public\Downloads\ver.txt

if %ver%==%currentver% (
  goto checklocation
) else (
  echo DEBUG: uh oh, outdated version.
  powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('You are running an outdated version of Tackle! You are running %currentver% while the latest version is %ver%! Please check the Github Repo for an updated version!', 'Tackle Mod Manager v%currentver% - @uncreativecultist', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
  goto checklocation
)

:checklocation
if exist "C:\Program Files (x86)\Steam\steamapps\common\WEBFISHING\" (
  mklink /j "C:\Users\Public\Downloads\WEBFISHINGLINK" "C:\Program Files (x86)\Steam\steamapps\common\WEBFISHING"
  echo DEBUG: creasting symlink because tar is stupid and can't handle spaces apparently
  set "WFDIR=C:\Users\Public\Downloads\WEBFISHINGLINK"
  goto main
) else (
  goto setup
)

:setup
echo DEBUG: webfishing isn't in the default steamapps folder
echo DEBUG: checking if we have a different spot saved...
if exist "C:\Users\Public\Downloads\bait.txt" (
  echo DEBUG: yup, we do. using that
  set /p WFDIR=<C:\Users\Public\Downloads\bait.txt
  goto verifypath
) else (
  ::cls
  echo DEBUG: nope, we don't. ask em for a location please
  powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Please enter your WEBFISHING path! Please make sure it starts with the drive letter, does NOT end with \', 'Tackle Mod Manager v%currentver% - @uncreativecultist')}" > C:\Users\Public\Downloads\bait.txt
  ::set /p WFDIR=
  echo DEBUG: cool, save that location for later please
  set /p WFDIR=<C:\Users\Public\Downloads\bait.txt
  ::echo Tackle couldn't find WEBFISHING installed on your computer!
  ::echo Please enter your WEBFISHING path! 
  ::set /p WFDIR=
  ::>C:\Users\Public\Downloads\bait.txt echo %WFDIR%
  goto verifypath
)

:verifypath
if exist "%WFDIR%\webfishing.exe" (
  goto verifyweave
) else (
  ::cls
  echo DEBUG: hmm, cant find webfishing here.
  goto manualsetup
)

:verifyweave
::leaving this here for now
::https://github.com/NotNite/GDWeave/releases/latest/download/GDWeave.zip
if exist "%WFDIR%\GDWeave\" (
  goto main
) else (

  powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('It looks like you are missing GDWeave! Tackle will now automatically download and install GDWeave!', 'Tackle Mod Manager v%currentver% - @uncreativecultist', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
  echo DEBUG: downloading GDWeave...
  curl -sL https://github.com/NotNite/GDWeave/releases/latest/download/GDWeave.zip -o C:\Users\Public\Downloads\GDWeave.zip
  echo DEBUG: GDWeave downloaded, time to install
  tar -xf "C:\Users\Public\Downloads\GDWeave.zip" -C %WFDIR%\
  echo DEBUG: GDWeave has been installed, continue on with your day
  powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('GDWeave has been successfully installed! Press OK to continue with mod installation.', 'Tackle Mod Manager v%currentver% - @uncreativecultist', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
  echo DEBUG: cleanup time
  del /q C:\Users\Public\Downloads\GDWeave.zip
  goto verifyweave
)
  ::cls
  ::echo It looks like you don't have GDWeave installed!
  ::echo Currently, Tackle doesn't have the functionality to automatically install GDWeave :(
  ::echo Please follow the instructions on the Github page!
  ::timeout /t 5
  ::start https://github.com/NotNite/GDWeave?tab=readme-ov-file#installation
  ::exit


:manualsetup
::echo Please enter your WEBFISHING path! 
::echo Please make sure it starts with the drive letter, does NOT end with \
powershell -Command "& {Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.Interaction]::InputBox('Please enter your WEBFISHING path! Please make sure it starts with the drive letter, does NOT end with \', 'Tackle Mod Manager v%currentver% - @uncreativecultist')}" > C:\Users\Public\Downloads\bait.txt
::set /p WFDIR=
set /p WFDIR=<C:\Users\Public\Downloads\bait.txt
goto verifypath

:main
::cls
IF [%1] EQU [] Goto:error

if exist "%WFDIR%\GDWeave\mods" (
  goto pass
) else (
md "%WFDIR%\GDWeave\mods"
goto pass
)
:pass
echo DEBUG: Installing mod...
cd "%WFDIR%\GDWeave\mods\"
tar -xf "%~1" -C %WFDIR%\GDWeave\mods
echo DEBUG: Mod has been installed
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Tackle Mod Manager v%currentver% - @uncreativecultist', 'Mod has been installed!', [System.Windows.Forms.ToolTipIcon]::None)}"
::timeout /t 5
exit

:error
echo DEBUG: Incorrect usage, whoopsie daisy!
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Please drag and drop a mod file onto the bat file to continue!', 'Tackle Mod Manager v%currentver% - @uncreativecultist', 'OK', [System.Windows.Forms.MessageBoxIcon]::Information);}"
::timeout /t 5
@Echo off
setlocal enabledelayedexpansion
mode con cols=20 lines=1

::	* * * * * * * * * * * * * *  ::
::	*   Add  to Self  Radio   *  ::
::  *           1.9           *  ::
::	*           By            *  ::
::	*   RainBawZ / kukpappa   *  ::
::  *        aka. Tam         *  ::
::  *                         *  ::
::  *        DISCORD:         *  ::
::  *      @Inwayn#1590       *  ::
::  *                         *  ::
::  *       SocialClub:       *  ::
::  *        kukpappa         *  ::
::  *                         *  ::
::  *         Steam:          *  ::
::  *      /id/kukpappa       *  ::
::	* * * * * * * * * * * * * *  ::


::  - - - - - - - - - - - - - - - - - -  ::
::         EXPERIMENTAL UPDATES          ::
::             0 = DISABLED              ::
::             1 = ENABLED               ::
::                                       ::
     SET ENABLE_EXPERIMENTAL_UPDATES=0
::                                       ::
::  - - - - - - - - - - - - - - - - - -  ::

set version=1.9.0
set subver=%~z0
set numset=1234567890
set sID=!random!!random!
set debug=0
set UIinit=0
set UI_disable=0
color F0
title Add To Self Radio v!version!
REM -----> Get current code page
for /f "tokens=4" %%A in ('chcp') do (
	set forcedCodePage=%%A
)
REM -----> Determine which code page to use
if "%~1"=="_LAUNCHPARAMETER" (
	set _LAUNCHPARAMETER=%~2
	if "%~2"=="EXPORT" (
		goto playlist.export
	)
	if "%~2"=="MOVEEXPORT" (
		goto moveexport
	)
	if /i not "%~2"=="DEBUG" (
		set preferredCodePage=%~2
		chcp %~2 > nul
		shift /1
		shift /1
	) else (
		@Echo on
		prompt A2SR_DEBUG$G$G$S
		set debug=1
		mode con cols=120 lines=33
		shift /1
		shift /1
	)
) else (
	for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "CodePage" 2^>nul') do (
		if not !errorlevel!==1 (
			if not "!preferredCodePage!"=="" (
				set preferredCodePage=%%B
				chcp %%B > nul
			) else (
				set preferredCodePage=!forcedCodePage!
			)
		) else (
			if "!preferredCodePage!"=="" (
				set preferredCodePage=!forcedCodePage!
			)
		)
	)
)
REM -----> Prepare required paths
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal" 2^>nul') do (
	set userDir=%%B
)
set musicDir=Rockstar Games\GTA V\User Music
set inactiveDir=Rockstar Games\GTA V\InactiveMusic
if not exist "!userDir!\!inactiveDir!" (
	mkdir "!userDir!\!inactiveDir!" > nul
)
if "!_LAUNCHPARAMETER!"=="RESTORE" (
	goto playlist.restore
)

:: REMOVE 'REM' FROM LINE BELOW TO DISABLE MUSIC DIRECTORY CHECKING. (ONLY FOR TESTING PURPOSES. DO NOT USE UNLESS YOU KNOW WHAT YOU'RE DOING.)
REM GOTO :SKIP_MUSICDIR_CHECK

REM -----> Check if the usermusic directory is correct
if not exist "!userDir!\!musicDir!" (
	Echo x=msgbox^("Unable to find the music directory." ^& vbcrlf ^& "Assumed path: !userDir!\!musicDir!" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	start "" "%temp%\a2sr_!sID!msg.vbs"
	endlocal
	exit /b 1
)
:SKIP_MUSICDIR_CHECK
cd /d "%~dp0"
for /f "tokens=1,2 delims=#" %%A in ('"prompt #$H#$E# & echo on & for %%B in (1) do rem"') do (
	set "DEL=%%A"
)
reg query "HKCU\Software\FoddEx\Add to Self Radio" >nul 2>&1
if !errorlevel!==0 (
	for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "Version" 2^>nul') do (
		for /f "tokens=1,2,3,4 delims=." %%C in ("%%B") do (
			for /f "tokens=1,2,3,4 delims=." %%G in ("!version!.%~z0") do (
				if %%C LSS %%G (
					Echo x=msgbox^("Detected an older version."^& vbcrlf ^&"Please uninstall it before installing this one.",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
					start "" "%temp%\a2sr_!sID!msg.vbs"
					endlocal
					exit /b 1
				)
				if %%D LSS %%H (
					Echo x=msgbox^("Detected an older version."^& vbcrlf ^&"Please uninstall it before installing this one.",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
					start "" "%temp%\a2sr_!sID!msg.vbs"
					endlocal
					exit /b 1
				)
				if %%E LSS %%I (
					Echo x=msgbox^("Detected an older version."^& vbcrlf ^&"Please uninstall it before installing this one.",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
					start "" "%temp%\a2sr_!sID!msg.vbs"
					endlocal
					exit /b 1
				)
			)
		)
	)
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Version" /d "!version!.%~z0" >>"%temp%\stderr.txt" 2>&1
)
REM -----> Query the registry for the default .mp3 player
for /f "skip=2 tokens=3*" %%A in ('reg query HKCR\.mp3 /ve 2^>nul') do (
	set val=%%A
	REM -----> Check if Add to Self Radio is already installed
	reg query "HKCR\!val!\shell\Add to Self Radio\command" /ve > nul 2>&1
	if !errorlevel!==1 (
		if !UIinit!==0 call :UI_initialize 120 34 150 34
		set action=_
		if !debug!==0 cls
		Echo.
		Echo   NOTE: If you've previously used an older version of
		Echo         this software, you should run the uninstaller
		Echo         from that version before continuing.
		Echo.
		Echo   Would you like to add a shortcut to the Context Menu?
		Echo.
		set /p action="Y/N >> "
		if !action!==_ (
			goto :end
		)
		if /i !action!==y (
			REM chcp !forcedCodePage! > nul
			REM -----> Check for older versions
			reg query "HKCU\Software\FoddEx\Add to Self Radio" > nul 2>&1
			if !errorlevel!==0 (
				Echo x=msgbox^("Detected an older version."^& vbcrlf ^&"Please uninstall it before installing this one.",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
				start "" "%temp%\a2sr_!sID!msg.vbs"
				endlocal
				exit /b 1
			)
			REM -----> Add registry keys
			reg add "HKCR\!val!\shell\Add to Self Radio\command" /f /ve /d "\"%~f0\" \"%%1\"" >>"%temp%\stderr.txt" 2>&1
			reg add "HKCR\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs\shell\Add to Self Radio\command" /f /ve /d "\"%~f0\" \"%%1\"" >>"%temp%\stderr.txt" 2>&1
			if !errorlevel!==1 (
				Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
				start "" "%temp%\a2sr_!sID!msg.vbs"
				endlocal
				exit /b 1
			)
			reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Playlists" /d "\"Default\"" >>"%temp%\stderr.txt" 2>&1
			reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "ActivePlaylist" /d "\"None\"" >>"%temp%\stderr.txt" 2>&1
			call :setup.defaultPlaylist
			reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "CodePage" /d "!preferredCodePage!" >>"%temp%\stderr.txt" 2>&1
			reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Version" /d "!version!.%~z0" >>"%temp%\stderr.txt" 2>&1
			reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "1Timenotif" /d "0" >> "%temp%\stderr.txt" 2>&1
			reg add "HKCU\Software\FoddEx\Add to Self Radio\Restore" /f >>"%temp%\stderr.txt" 2>&1
			set ret=1
			REM -----> Create uninstallation script
			call :writeUninstall
			(
				Echo.
				Echo Windows Registry Editor Version 5.00
				Echo [-HKEY_CLASSES_ROOT\!val!\shell\Add to Self Radio]
				Echo [-HKEY_CLASSES_ROOT\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs\shell\Add to Self Radio]
				Echo [-HKEY_CURRENT_USER\Software\FoddEx\Add to Self Radio]
			)>>Uninstall.bat
			RUNDLL32.exe USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
			echo x=msgbox^("Added registry entry"^& vbcrlf ^&"You can now right click on any .mp3 file and choose"^& vbcrlf ^&"Add to Self Radio"^&vbcrlf^&vbcrlf^&"Please run the program to complete setup." ,64, "Success"^)>"%temp%\a2sr_!sID!msg.vbs"
			start "" "%temp%\a2sr_!sID!msg.vbs"
			goto :menu
		) else (
			Echo x=msgbox^("Keys not added. Choose 'Y'." ,48, "Warning"^)>"%temp%\a2sr_!sID!msg.vbs"
			start "" "%temp%\a2sr_!sID!msg.vbs"
			goto :end
		)
	)
	REM -----> Set default code page (CURRENTLY DISABLED. REMOVE 'REM ----->' TO ENABLE)
	REM -----> chcp !forcedCodePage! > nul
	REM -----> Read the data in the Add to Self Radio command key
	for /f "skip=2 tokens=3*" %%B in ('reg query "HKCR\!val!\shell\Add to Self Radio\command" /ve 2^>nul') do (
		if not "%~1"=="" (
			goto :cnt
		)
		set regPath=%%~B
		REM -----> Check if the path is unchanged
		if not "!regPath!"=="%~f0" (
			if !UIinit!==0 call :UI_initialize 120 34 150 34
			set action=_
			if !debug!==0 cls
			Echo.
			Echo   Detected changes in program path.
			Echo.
			Echo   NOTE: If you've previously used an older version of
			Echo         this software, you should close this program
			Echo         and run the uninstaller from that version
			Echo         before continuing.
			Echo.
			Echo   Refresh registry entry?
			set /p action="  Y/N >> "
			if !action!==_ (
				goto :end
			)
			if /i !action!==y (
				REM -----> Renew the registry entry
				reg add "HKCR\!val!\shell\Add to Self Radio\command" /f /ve /d "\"%~f0\" \"%%1\"" >>"%temp%\stderr.txt" 2>&1
				reg add "HKCR\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs\shell\Add to Self Radio\command" /f /ve /d "\"%~f0\" \"%%1\"" >>"%temp%\stderr.txt" 2>&1
				if !errorlevel!==1 (
					Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
					start "" "%temp%\a2sr_!sID!msg.vbs"
					endlocal
					exit /b 1
				)
				reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "CodePage" /d "!preferredCodePage!" > nul
				reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "Playlists" > nul
				if !errorlevel!==1 (
					REM -----> Create new uninstallation script
					call :writeUninstall
					(
						Echo.
						Echo Windows Registry Editor Version 5.00
						Echo [-HKEY_CLASSES_ROOT\!val!\shell\Add to Self Radio]
						Echo [-HKEY_CLASSES_ROOT\AppXqj98qxeaynz6dv4459ayz6bnqxbyaqcs\shell\Add to Self Radio]
						Echo [-HKEY_CURRENT_USER\Software\FoddEx\Add to Self Radio]
					)>>Uninstall.bat
					RUNDLL32.exe USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
					echo x=msgbox^("Updated registry entry" ,64, "Success"^)>"%temp%\a2sr_!sID!msg.vbs"
					start "" "%temp%\a2sr_!sID!msg.vbs"
					endlocal
					exit /b 0
				)
			)
		) else (
			call :expUpdate
		)
	)
	REM -----> Look for MODE value
	reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "Mode" >nul 2>&1
	if !errorlevel!==1 (
		if !UIinit!==0 call :UI_initialize 120 34 150 34
		if !debug!==0 cls
		Echo.
		Echo   NOTE: If you've previously used an older version of
		Echo         this software, you should close the program
		Echo         and run the uninstaller from the older version
		Echo.
		Echo.
		Echo   No mode is specified. Add mode now?
		Echo.
		set add=0
		set /p add="  Y/N>> "
		if /i !add!==N (
			goto end
		)
		if /i !add!==Y (
			goto menu
		) else (
			goto end
		)
		goto end
	)
)
REM -----> Go to menu if no file to process is specified
:cnt
if "%~1"=="" (
	goto menu
)
set UI_disable=1
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "Mode" 2^>nul') do (
	if "%%A"=="SHORTCUT" (
		goto :shortcut
	)
	if "%%A"=="COPY" (
		goto :copy
	)
	if "%%A"=="MOVE" (
		goto :move
	)
	Echo x=msgbox^("The registry query for MODE returned an invalid value."^& vbcrlf ^&"Please launch the program and change the Mode setting."^& vbcrlf ^&"Information:"^& vbcrlf ^&"VALUEDATA:%%A" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	start "" "%temp%\a2sr_!sID!msg.vbs"
	endlocal
	exit /b 1
)
:: ---------------------------------------------------------------------------------------

:: ----------------------------------------------------------------------- ADD-SUBROUTINES
:copy
chcp !preferredCodePage! > nul
REM -----> Check if the file is an mp3 file
if /i not "%~x1"==".mp3" (
	Echo x=msgbox^("Couldn't add %~nx1"^& vbcrlf ^&"The file has an incorrect extension (%~x1)" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
title Add to Self Radio v!version! - Adding %~nx1...
REM -----> Check if the file already exists
if exist "!userDir!\!musicDIR!\%~nx1" (
	Echo x=msgbox^("A file called %~nx1 already exists." ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
REM -----> Copy the file
xcopy "%~1" "!userDir!\!musicDir!" > nul
REM -----> Check if the file was copied
if not exist "!userDir!\!musicDir!\%~nx1" (
	Echo x=msgbox^("Failed to add %~nx1"^& vbcrlf ^&"If this issue persists, you can post this information at the mod page:"^& vbcrlf ^&"FILE:%~1\\PATH:!userDir!\!musicDir!" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
REM -----> Display success message
echo x=msgbox^("%~1 has been added." ,64, "Success"^)>"%temp%\a2sr_!sID!msg.vbs"
"%temp%\a2sr_!sID!msg.vbs"
call :onetimenotif
goto :end
:shortcut
chcp !preferredCodePage! > nul
REM -----> Check if the file is an mp3 file
if /i not "%~x1"==".mp3" (
	Echo x=msgbox^("Couldn't add %~nx1"^& vbcrlf ^&"The file has an incorrect extension (%~x1)" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
title Add to Self Radio v!version! - Adding %~nx1...
REM -----> Check if the link already exists
if exist "!userDir!\!musicDir!\%~n1.lnk" (
	Echo x=msgbox^("A shortcut called %~n1.lnk already exists." ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
REM -----> Create VBSscript file for shortcut creation.
set SCRIPT="%TEMP%\SelfRadioShortcut.vbs"
(
	echo Set oWS = WScript.CreateObject^("WScript.Shell"^)
	echo sLinkFile = "!userDir!\!musicDir!\%~n1.lnk"
	echo Set oLink = oWS.CreateShortcut^(sLinkFile^)
	echo oLink.TargetPath = "%~f1"
	echo oLink.Save
)>!SCRIPT!
REM -----> Run the script file
cscript /nologo !SCRIPT!
del /q !SCRIPT! > nul
if not exist "!userDir!\!musicDir!\%~n1.lnk" (
	Echo x=msgbox^("Failed to add a shortcut for %~nx1"^& vbcrlf ^&"If this issue persists, you can post this information at the mod page:"^& vbcrlf ^&"FILE:%~f1\\PATH:!userDir!\!musicDir!" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
REM -----> Display success message
echo x=msgbox^("A shortcut to %~nx1 has been added." ,64, "Success"^)>"%temp%\a2sr_!sID!msg.vbs"
"%temp%\a2sr_!sID!msg.vbs"
call :onetimenotif
goto :end
:move
chcp !preferredCodePage! > nul
REM -----> Check if the file is an mp3 file
if /i not "%~x1"==".mp3" (
	Echo x=msgbox^("Couldn't add %~nx1"^& vbcrlf ^&"The file has an incorrect extension (%~x1)" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
title Add to Self Radio v!version! - Adding %~nx1...
REM -----> Check if the file already exists
if exist "!userDir!\!musicDIR!\%~nx1" (
	Echo x=msgbox^("A file called %~nx1 already exists." ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
REM -----> Move the file
move "%~1" "!userDir!\!musicDir!" > nul
REM -----> Check if the file was Moved
if not exist "!userDir!\!musicDir!\%~nx1" (
	Echo x=msgbox^("Failed to add %~nx1"^& vbcrlf ^&"If this issue persists, you can post this information at the mod page:"^& vbcrlf ^&"FILE:%~1\\PATH:!userDir!\!musicDir!" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	"%temp%\a2sr_!sID!msg.vbs"
	call :onetimenotif
	endlocal
	exit /b 1
)
REM -----> Display success message
set "regFilename=%~n1"
set regFilename=!regFilename: =_!
reg add "HKCU\Software\FoddEx\Add to Self Radio\restore" /v "!regFilename!" /d "\"%~f1\"" >>"%temp%\stderr.txt" 2>&1
echo x=msgbox^("%~1 has been added." ,64, "Success"^)>"%temp%\a2sr_!sID!msg.vbs"
"%temp%\a2sr_!sID!msg.vbs"
call :onetimenotif
goto :end
:: ----------------------------------------------------------------------------------------------------

:: ----------------------------------------------------------------------- UI INITALIZATION SUBROUTINES
:UI_getBufferSize
if !debug!==0 cls
call :colortext CF "                                                   Initializing UI...                                                   " n
for /f "skip=4 tokens=2 delims=:" %%A in ('mode con') do (
	set horizontalBufferSize=%%A
	set horizontalBufferSize=!horizontalBufferSize: =!
	for /l %%B in (1,1,%%A) do (
		set /a DEBUG_UIbufferCount+=1
		set "UI_clearline= !UI_clearline!"
		set UI_dashline=-!UI_dashline!
		set UI_usline=_!UI_usline!
	)
	goto :eof
)
:UI_initialize
if !debug!==1 goto :eof
if !UIinit!==1 goto :eof
if !UI_disable!==1 goto :eof
<nul > X set /p ".=."
mode con cols=%~1 lines=%~2
call :UI_getBufferSize
powershell -command "&{$H=get-host;$W=$H.ui.rawui;$B=$W.buffersize;$B.width=%~3;$B.height=%~4;$W.buffersize=$B;}"
set UIinit=1
goto :eof
:: ----------------------------------------------------------------------------

:: ----------------------------------------------------------------------- MENU
:menu
if !UIinit!==0 call :UI_initialize 120 34 150 34
REM -----> Read settings from registry
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "Mode" 2^>nul') do (
	set currMode=%%A
)
if "!currMode!"=="" (
	set currMode=UNDEFINED
)
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "Ignore" 2^>nul') do (
	set currIgnore=%%A
)
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "CodePage" 2^>nul') do (
	set preferredCodePage=%%A
)
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "ActivePlaylist" 2^>nul') do (
	set activePlaylist=%%~B
)
if !ENABLE_EXPERIMENTAL_UPDATES!==1 (
	set expUd=^(EXP. UPDATES ENABLED^)
) else (
	set expUd=
)
if "!currIgnore!"=="" (
	set currIgnore=UNDEFINED
)
if !currIgnore!==0 (
	set currIgnore=ON
)
if !currIgnore!==1 (
	set currIgnore=OFF
)
if !debug!==0 cls
color 70
Echo   Settings can be changed at any time by running the program.
call :colortext 72 "!UI_clearline!" n
call :colortext 27 "  Current mode:        !currMode!                                                                                                       " n
call :colortext 27 "  Update checking:     !currIgnore!                                                                                                       " n
call :colortext 27 "  Preferred code page: !preferredCodePage!                                                                                                       " n
call :colortext 27 "  Active playlist:     !activePlaylist!                                                                                                " n
call :colortext 27 "________________________________________________________________________________________________________________________" n
call :colortext 8F "!UI_clearline!" n
call :colortext 8F "  Mode settings                                                                                                          " n
call :colortext 8F "!UI_clearline!" n
call :colortext 1F "  1 --> Change mode                                                                                                      " n
call :colortext 80 "________________________________________________________________________________________________________________________" n
call :colortext 8F "!UI_clearline!" n
call :colortext 8F "  Update settings  !expUd!                                                                                                        " n
call :colortext 8F "!UI_clearline!" n
call :colortext 1F "  2 --> Change update settings                                                                                             " n
call :colortext 80 "________________________________________________________________________________________________________________________" n
call :colortext 8F "!UI_clearline!" n
call :colortext 8F "  Code page settings                                                                                                       " n
call :colortext 8F "!UI_clearline!" n
call :colortext 1F "  3 --> Change preferred code page                                                                                                       " n
call :colortext 80 "________________________________________________________________________________________________________________________" n
call :colortext 8F "!UI_clearline!" n
call :colortext 8F "  Playlist settings                                                                                                       " n
call :colortext 8F "!UI_clearline!" n
call :colortext 1F "  4 --> Enter the playlist menu                                                                                                       " n
call :colortext 80 "________________________________________________________________________________________________________________________" n
call :colortext 8F "!UI_clearline!" n
call :colortext 8F "  File restoration                                                                                                        " n
call :colortext 8F "!UI_clearline!" n
call :colortext 1F "  5 --> Restore moved songs                                                                                               " n
call :colortext 8F "!UI_clearline!" n
rem call :colortext 8F "!UI_clearline!" n
choice /c 123450 /n > nul 2>&1
if %errorlevel%==1 (
	goto :menu.toggleModes
)
if %errorlevel%==2 (
	goto :menu.updates
)
if %errorlevel%==3 (
	goto :menu.codepage
)
if %errorlevel%==4 (
	call :playlist
	goto :menu
)
if %errorlevel%==5 (
	goto menu.restore
)
goto :menu
:menu.toggleModes
if !currMode!==UNDEFINED (
	set mode=COPY
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Mode" /d "!mode!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
if !currMode!==COPY (
	set mode=SHORTCUT
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Mode" /d "!mode!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
if !currMode!==SHORTCUT (
	set mode=MOVE
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Mode" /d "!mode!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
if !currMode!==MOVE (
	set mode=COPY
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Mode" /d "!mode!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
goto :menu
:menu.updates
if !currIgnore!==UNDEFINED (
	set ignore=0
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Ignore" /d "!ignore!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
if !currIgnore!==ON (
	set ignore=1
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Ignore" /d "!ignore!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
if !currIgnore!==OFF (
	set ignore=0
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Ignore" /d "!ignore!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
goto :menu
:menu.codepage
set /p newCodePage="New code page: "
if not "!newCodePage!"=="" (
	set preferredCodePage=!newCodePage!
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "CodePage" /d "!newCodePage!" >>"%temp%\stderr.txt" 2>&1
	if !errorlevel!==1 (
		Echo x=msgbox^("An error occurred. Try running as administrator."^& vbcrlf ^&" "^& vbcrlf ^&"Information:"^& vbcrlf ^&"Access denied" ,48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		endlocal
		exit /b 1
	)
)
goto :menu
:playlist
set playlist_cho=_
if !debug!==0 cls
::call :colortext 33 "!UI_clearline!" & echo.
::call :colortext 3F "Playlist settings!UI_text_playlistSettings_suffix!" & echo.
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "ActivePlaylist"') do (
	set activePlaylist=%%~B
)
call :colortext 3F "  Playlist settings                                                                                                     " n
call :colortext FC "________________________________________________________________________________________________________________________" n
Echo.
Echo   Active playlist: !activePlaylist!
Echo.
Echo   Available playlists:
Echo.
set _itemIndex=5
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v Playlists 2^>nul') do (
	for %%C in (%%B) do (
		if "%%~C"=="!activePlaylist!" (
			call :colortext F2 "      !_itemIndex! --> %%~C     (ACTIVE)" n
		) else (
			call :colortext F8 "      !_itemIndex! --> %%~C" n
		)
		set /a _itemIndex+=1
	)
)
Echo.
Echo   0 --^> Return
Echo   1 --^> Create playlist
Echo   2 --^> Edit active playlist
Echo   3 --^> Delete active playlist
Echo   4 --^> Export playlist data
Echo.
set /p playlist_cho="  >> "
if !playlist_cho!==0 (
	goto :eof
)
if !playlist_cho!==1 (
	call :playlist.create
)
if !playlist_cho!==2 (
	call :playlist.edit "!activePlaylist!"
)
if !playlist_cho!==3 (
	goto playlist.delete
)
if !playlist_cho!==4 (
	goto playlist.export
) else (
	if not !playlist_cho!==-1 (
		goto playlist.change
	)
)
goto playlist
:playlist.change
Echo.
Echo Changing playlist...
set enablePlaylist=!playlist_cho!
if !enablePlaylist!==-1 (
	set activePlaylist=None
	goto playlist.change.break
)
set _itemIndexCounter=5
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v Playlists 2^>nul') do (
	for %%C in (%%B) do (
		if !_itemIndexCounter!==!enablePlaylist! (
			if "%%~C"=="!activePlaylist!" (
				set activePlaylist=None
			) else (
				set activePlaylist=%%~C
			)
			reg add "HKCU\Software\FoddEx\Add To Self Radio" /f /v "ActivePlaylist" /d "\"!activePlaylist!\"" > nul
			goto playlist.change.break
		) else (
			set /a _itemIndexCounter+=1
		)
	)
)
:playlist.change.break
set "disableFiles="
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "ActivePlaylist" 2^>nul') do (
	for /f "skip=2 tokens=2*" %%C in ('reg query "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /v "%%B" 2^>nul') do (
		for /f "tokens=*" %%E in ('dir /b "!userDir!\!musicDir!\*.mp3" /a:-d 2^>nul') do (
			set inPlaylist=0
			for %%F in (%%D) do (
				if !inPlaylist!==0 (
					if /i "%%F"=="%%E" (
						set inPlaylist=1
					)
				)
			)
			if !inPlaylist!==0 (
				set disableFiles="%%E",!disableFiles!
			)
		)
		for %%G in (!disableFiles!) do (
			move "!userDir!\!musicDir!\%%G" "!userDir!\!inactiveDir!\" > nul
		)
		for %%H in (%%D) do (
			if not exist "!userDir!\!musicDir!\%%H" (
				if not exist "!userDir!\!inactiveDir!\%%H" (
					Echo x=msgbox^("Song '%%H' in playlist '%%D' could not be found. Ignoring.",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
					start "" "%temp%\a2sr_!sID!msg.vbs"
				) else (
					move "!userDir!\!inactiveDir!\%%H" "!userdir!\!musicDir!\" > nul
				)
			)
		)
	)
)
goto playlist
:playlist.create
set playlist_newPlaylist=
set /p playlist_newPlaylist="  New playlist: "
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v Playlists 2^>nul') do (
	for %%C in (%%B) do (
		if /i "%%~C"=="!playlist_newPlaylist!" (
			Echo x=msgbox^("Playlist '!playList_newPlaylist!' already exists.", 48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
			start "" "%temp%\a2sr_!sID!msg.vbs"
			goto playlist.create
		)
	)
	set playlist_allPlaylists="!playList_newPlaylist!",%%B
)
set playlist_allPlaylists=!playList_allPlaylists:"=\"!
reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Playlists" /d "!playList_allPlaylists!"
reg add "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /f /v "\"!playlist_newPlaylist!\"" /d ""
set playList_allPlaylists=
call :playlist.edit "!playlist_newPlaylist!" create
goto :eof
:playlist.edit
if !activePlaylist!==None (
	if not "%~2"=="create" (
		Echo x=msgbox^("No active playlist.", 48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		goto playlist
	)
)
cls
set playlist_editplaylist=%~1
Echo   Editing playlist: !playlist_editPlaylist!
Echo.
Echo   Available songs:
for /f "tokens=*" %%A in ('dir /a:-d /b "!userDir!\!musicDir!\*.mp3" 2^>nul') do (
	echo     %%~nxA
)
for /f "tokens=*" %%A in ('dir /a:-d /b "!userDir!\!inactiveDir!\*.mp3" 2^>nul') do (
	echo     %%~nxA
)
echo   -------------------------------------
echo   Songs in playlist:
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /v "\"!playlist_editPlaylist!\"" 2^>nul') do (
	for %%C in (%%B) do (
		echo     %%~C
	)
)
echo.
set "playlist_edit_songName="
Echo   Enter song name to add/remove:
Echo   Enter blank to return.
set /p playlist_edit_songName="  >> "
if "!playlist_edit_songName!"=="" (
	goto :eof
)
if not exist "!userDir!\!musicDir!\!playlist_edit_songName!" (
	if not exist "!userDir!\!inactiveDir!\!playlist_edit_songName!" (
		Echo x=msgbox^("Song '!playlist_edit_songName!' could not be found in any valid location. Ignoring.",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		goto playlist.edit
	)
)
for /f "skip=2 tokens=2,*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /v "\"!playlist_editPlaylist!\"" 2^>nul') do (
	set playlist_edit_allsongs=%%B
)
set playlist_edit_inPlaylist=0
for %%A in (!playlist_edit_allsongs!) do (
	if /i "%%A"=="!playlist_edit_songName!" (
		set playlist_edit_inPlaylist=1
	)
)
if !playlist_edit_inPlaylist!==1 (
	for %%A in (!playlist_edit_allsongs!) do (
		if not "%%~A"=="!playlist_edit_songName!" (
			set playlist_edit_allsongs=\"%%~A\",!playlist_edit_allsongs!
		)
	)
) else (
	set playlist_edit_allsongs=!playlist_edit_allsongs!,\"!playlist_edit_songName!\"
)
reg add "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /f /v "\"!playlist_editPlaylist!\"" /d "!playlist_edit_allsongs!"
goto :playlist.edit
:playlist.delete
if !activePlaylist!==None (
	Echo x=msgbox^("No active playlist.", 48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	start "" "%temp%\a2sr_!sID!msg.vbs"
	goto playlist
)
Echo.
Echo   Delete active playlist? [Y/N]
set /p playlist_delete_confirmation=">> "
if /i "!playlist_delete_confirmation!"=="Y" (
	for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "Playlists"') do (
		set playlist_delete_allPlaylists=%%B
	)
	set playlist_delete_allPlaylists=!playlist_delete_allPlaylists:""%activePlaylist%"",=!
	set playlist_delete_allPlaylists=!playlist_delete_allPlaylists:""%activePlaylist%""=!
	rem set playlist_delete_allPlaylists=!playlist_delete_allPlaylists:"=\"!
	reg delete "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /f /v "!activePlaylist!"
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "Playlists" /d "!playlist_delete_allPlaylists!"
	reg add "HKCU\Software\FoddEx\Add to Self Radio" /f /v "ActivePlaylist" /d "\"None\""
)
goto playlist
:playlist.export
set dt=!date:.=!
if not "!_LAUNCHPARAMETER!"=="EXPORT" (
	reg export "HKCU\Software\FoddEx\Add to Self Radio\Playlists" "_Playlist_data_!dt!.reg" /y
	type "_Playlist_data_!dt!.reg">"Playlist_data_!dt!.reg"
	del /q "_Playlist_data_!dt!.reg" > nul 2>&1
	for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "Playlists"') do (
		set allPlaylists=%%B
	)
	set allPlaylists=!allPlaylists:"=\"!
	(
		echo [HKEY_CURRENT_USER\Software\FoddEx\Add to Self Radio]
		echo "ActivePlaylist"="\"None\""
		echo "Playlists"="!allPlaylists!"
	)>>Playlist_data_!dt!.reg
) else (
	reg export "HKCU\Software\FoddEx\Add to Self Radio\Playlists" "_ExportData_!dt!.reg" /y
	type "_ExportData_!dt!.reg">"ExportData_!dt!.reg"
	del /q "_ExportData_!dt!.reg" > nul 2>&1
	for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "Playlists"') do (
		set allPlaylists=%%B
	)
	set allPlaylists=!allPlaylists:"=\"!
	(
		echo [HKEY_CURRENT_USER\Software\FoddEx\Add to Self Radio]
		echo "ActivePlaylist"="\"None\""
		echo "Playlists"="!allPlaylists!"
	)>>ExportData_!dt!.reg
	exit
)
goto playlist
:playlist.restore
:: SUBROUTINE CAN ONLY BE ACCESSED USING PARAMETER _LAUNCHPARAMETER RESTORE
for /f "tokens=*" %%A in ('dir /b /a:-d "!userDir!\!inactiveDir!\*.mp3"') do (
	move "%%~fA" "!userDir!\!musicDir!\"
)
rmdir /s /q "!userDir!\!inactiveDir!" > nul
exit
:setup.defaultPlaylist
for /f "tokens=*" %%A in ('dir /B /S /A:-D "!userDir!\!musicDir!\*.mp3"') do (
	set setup_defaultPlaylist_songPath=%%A
	set setup_defaultPlaylist_song=!setup_defaultPlaylist_songPath:%userDir%\%musicDir%\=!
	set setup_defaultPlaylist=\"!setup_defaultPlaylist_song!\",!setup_defaultPlaylist!
)
reg add "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /f /v "Default" /d "!setup_defaultPlaylist!" > nul
reg add "HKCU\Software\FoddEx\Add to Self Radio\Playlists" /f /v "None" /d "" > nul
goto :eof
:menu.restore
cls
set index=1
for /f "skip=2 tokens=1,2,*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio\Restore"') do (
	if not "%%~nxC"=="" (
		Echo !index! --^> %%~nxC
		set "regindex!index!=%%A"
		set "restoreIndex!index!=%%~C"
		set /a index+=1
	)
)
set /p select="Song number [0 to return]: "
if "!select!"=="0" (
	goto :menu
)
if "!restoreIndex%select%!"=="" (
	Echo x=msgbox^("No file to restore was specified.",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	start "" "%temp%\a2sr_!sID!msg.vbs"
) else (
	call :menu.restore1 "!restoreIndex%select%!"
)
goto :menu.restore
:menu.restore1
set restorefile=%~nx1
set restorepath=%~dp1
if not exist "!userDir!\!musicDir!\!restorefile!" (
	Echo x=msgbox^("Couldn't find file '!restorefile!'",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
	start "" "%temp%\a2sr_!sID!msg.vbs"
) else (
	move "!userDir!\!musicDir!\!restorefile!" "!restorepath!"
	if not exist "!restorepath!\!restorefile!" (
		Echo x=msgbox^("Failed to restore file '!restorefile!'",48, "Error"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
	) else (
		Echo x=msgbox^("File '!restorefile!' has been restored to its original location." ^& vbcrlf ^& "^(!restorepath!^)",64, "Success"^)>"%temp%\a2sr_!sID!msg.vbs"
		start "" "%temp%\a2sr_!sID!msg.vbs"
		reg delete "HKCU\Software\FoddEx\Add to Self Radio\Restore" /f /v "!regindex%select%!" > nul 2>&1
	)
)
goto :eof
:expUpdate
chcp !forcedCodePage! > nul
REM -----> Check if updates should be ignored or not
if not !ENABLE_EXPERIMENTAL_UPDATES!==1 (
	call :checkUpdate "%~1"
)
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "Ignore" 2^>nul') do (
	set ignoreUpdates=%%A
)
if !ignoreUpdates!==0 (
	if !UI_disable!==0 (
		if !UIinit!==0 call :UI_initialize 120 34 150 34
		cls
		Echo.
		Echo Looking for updates...
	)
	REM -----> Check internet connection
	ping google.com -n 1 -w 500 > nul
	if !errorlevel!==1 (
		goto :eof
	)
	REM -----> Download version info
	powershell -Command "& {Invoke-WebRequest "http://wearegoth.altervista.org/kaspercoding/a2sr/Expversion.txt" -OutFile "%temp%\a2srEVersion.txt";}">nul
	for /f "tokens=1-4 delims=." %%A in (%temp%\a2srEVersion.txt) do (
		set newVersion=%%A.%%B.%%C
		set newSubver=%%D
		REM -----> Match downloaded version info with local version info
		for /f "tokens=1-3 delims=." %%E in ("!version!") do (
			if %%A GTR %%E (
				goto expUpdate1
			) else (
				if %%B GTR %%F (
					goto expUpdate1
				) else (
					if %%C GTR %%G (
						goto expUpdate1
					) else (
						if %%D GTR !subver! (
							goto :expUpdate1
						)
					)
				)
			)
			call :checkUpdate "%~1"
		)
	)
)
goto :eof
:expUpdate1
REM -----> Download patch notes and parse into a VBScript message
powershell -Command "& {Invoke-WebRequest "http://wearegoth.altervista.org/kaspercoding/a2sr/Expnotes.txt" -OutFile "%temp%\a2srENotes.txt";}">nul
set vbMessage=x=msgbox^("An experimental update is available."^& vbcrlf ^&" "^& vbcrlf ^&"Your version: v!version!, BETA !subver!"^& vbcrlf ^&"New version: v!newVersion!, BETA !newSubver!"^& vbcrlf ^&" "^& vbcrlf ^&"Key features:"
for /f "tokens=*" %%A in (%temp%\a2srENotes.txt) do (
	set input=%%A
	set input=!input:"='!
	set vbMessage=!vbMessage!^& vbcrlf ^&" "^& vbcrlf ^&"%%A"
)
set vbMessage=!vbMessage!^& vbcrlf ^& vbcrlf ^&"Click 'Yes' to start the download",vbYesNo + vbInformation,"Add to Self Radio"^)
REM -----> Create VBScript notification
(
	echo Set objShell = CreateObject^("Wscript.Shell"^)
	echo !vbMessage!
	echo If x = vbYes Then
	echo     objShell.Run^("http://wearegoth.altervista.org/kaspercoding/a2sr/SelfRadioAdd.exp.bat"^)
	echo Else
	echo     Wscript.Quit
	echo End If
)>"%temp%\a2sr_!sID!msg.vbs"
start "" "%temp%\a2sr_!sID!msg.vbs"
goto :checkUpdate
:end
goto expUpdate
:checkUpdate
chcp !forcedCodePage! > nul
REM -----> Check if updates should be ignored or not
for /f "skip=2 tokens=3*" %%A in ('reg query "HKCU\Software\FoddEx\Add To Self Radio" /v "Ignore" 2^>nul') do (
	set ignoreUpdates=%%A
)
if not "!ignoreUpdates!"=="1" (
	if not !ENABLE_EXPERIMENTAL_UPDATES!==1 (
		if !UI_disable!==0 (
			if !UIinit!==0 call :UI_initialize 120 34 150 34
			cls
			Echo.
			Echo Looking for updates...
		)
	)
	REM -----> Check internet connection
	ping google.com -n 1 -w 500 > nul
	if !errorlevel!==1 (
		goto :eof
	)
	REM -----> Download version info
	powershell -Command "& {Invoke-WebRequest "http://wearegoth.altervista.org/kaspercoding/a2sr/version.txt" -OutFile "%temp%\a2srVersion.txt";}">nul
	for /f "tokens=1-3 delims=." %%A in (%temp%\a2srVersion.txt) do (
		set newVersion=%%A.%%B.%%C
		REM -----> Match downloaded version info with local version info
		for /f "tokens=1-3 delims=." %%D in ("!version!") do (
			if %%A GTR %%D (
				goto :checkUpdate1
			) else (
				if %%B GTR %%E (
					goto :checkUpdate1
				) else (
					if %%C GTR %%E (
						goto checkUpdate1
					)
				)
			)
			goto :eof
		)
	)
)
goto :eof
:checkUpdate1
REM -----> Download patch notes and parse into a VBScript message
powershell -Command "& {Invoke-WebRequest "http://wearegoth.altervista.org/kaspercoding/a2sr/notes.txt" -OutFile "%temp%\a2srNotes.txt";}">nul
set vbMessage=x=msgbox^("An update is available."^& vbcrlf ^&" "^& vbcrlf ^&"Your version: v!version!"^& vbcrlf ^&"New version: v!newVersion!"^& vbcrlf ^&" "^& vbcrlf ^&"Key features:" ^& vbcrlf
for /f "tokens=*" %%A in (%temp%\a2srNotes.txt) do (
	set input=%%A
	set input=!input:"='!
	set vbMessage=!vbMessage!^& vbcrlf ^& vbcrlf ^&"!input!"
)
set vbMessage=!vbMessage!^& vbcrlf ^&" "^& vbcrlf ^&"Click 'Yes' to go to the GTA5-Mods.com download page",vbYesNo + vbInformation,"Add to Self Radio"^)
REM -----> Create VBScript notification
(
	echo Set objShell = CreateObject^("Wscript.Shell"^)
	echo !vbMessage!
	echo If x = vbYes Then
	echo     objShell.Run^("https://www.gta5-mods.com/tools/add-to-self-radio"^)
	echo Else
	echo     Wscript.Quit
	echo End If
)>"%temp%\a2sr_!sID!msg.vbs"
start "" "%temp%\a2sr_!sID!msg.vbs"
goto :eof
:end0
REM -----> Delete temporary files generated by the program
del /q "%temp%\a2srNotes.txt" 2> nul
del /q "%temp%\a2srVersion.txt" 2> nul
del /q "%temp%\a2sr_!sID!msg.vbs" 2> nul
del /q X 2> nul
REM -----> Line below commented out for debugging purposes. Remove  "::" to enable deletion of error log (Will add an option in the settings in a future update)
REM -----> del /q "%temp%\stderr.txt" > nul
REM -----> Exit
endlocal
exit
:writeUninstall
(
	echo @Echo off
	echo cd /d "%%~dp0"
	echo title Uninstall - Add to Self Radio
	echo color F0
	echo :main
	echo Echo    This will uninstall the selected components of Add to Self Radio.
	echo Echo    Components may be selected after continuing.
	echo Echo.
	echo Echo    Your Self Radio music will not be affected.
	echo Echo.
	echo Echo    Continue? ^^^(Y/N^^^)
	echo choice /c yn /n
	echo if %%errorlevel%%==1 ^(
	echo     goto :uninstall
	echo ^) else ^(
	echo     goto exit
	echo ^)
	echo :uninstall
	echo echo.
	echo Echo.
	echo Echo     1 -^^^> Uninstall registry entries ^^^(For installing a new version^^^)
	echo Echo     2 -^^^> Uninstall everything ^^^(All related files + registry entries^^^)
	echo choice /c 12 /n
	echo if %%errorlevel%%==1 ^(
	echo 	set uninstall=0
	echo ^)
	echo if %%errorlevel%%==2 ^(
	echo 	set uninstall=1
	echo ^)
	echo Echo     Extracting A2SR registry info...
	echo for /f "eol=; skip=67 tokens=*" %%%%A in ^(%%~f0^) do ^(
	echo     Echo %%%%A^>^>a2srUninstall.reg
	echo     Echo         %%%%A
	echo ^)
	echo if not %%uninstall%%==1 ^(
	echo 	Echo     Exporting playlist data...
	echo 	start /min /w "" SelfRadioAdd _LAUNCHPARAMETER EXPORT
	echo 	Echo     Exporting restoration data...
	echo 	start /min /w "" SelfRadioAdd _LAUNCHPARAMETER MOVEEXPORT
	echo ^)
	echo Echo     Un-toggling playlists...
	echo start /min /w "" SelfRadioAdd _LAUNCHPARAMETER RESTORE
	echo Echo     Uninstalling registry entries...
	echo a2srUninstall.reg
	echo Echo     Deleting files...
	echo Echo         FILE: a2srUninstall.reg
	echo del /q a2srUninstall.reg
	echo if exist X ^(
	echo 	Echo         FILE: X
	echo 	del /q X
	echo ^)
	echo if %%uninstall%%==1 ^(
	echo 	Echo         DIR:  Tools
	echo 	rmdir /s /q Tools
	echo 	Echo         FILE: Readme.txt
	echo 	del /q Readme.txt
	echo 	Echo         FILE: SelfRadioAdd.bat
	echo 	del /q SelfRadioAdd.bat
	echo ^)
	echo Echo     Uninstallation completed.
	echo Echo     Press any key to exit uninstaller...
	echo Echo     ^^^(The uninstaller will delete itself upon exit^^^)
	echo pause ^> nul
	echo cmd /c "timeout /t 1 /nobreak & del /q Uninstall.bat" ^> nul
	echo exit
	echo.
	echo ; REGISTRY ENTRIES
)>Uninstall.bat
goto :eof
:onetimenotif
for /f "skip=2 tokens=2*" %%A in ('reg query "HKCU\Software\FoddEx\Add to Self Radio" /v "1Timenotif" 2^>nul') do (
	if "%%B"=="0" (
		set vbMessage="Your feedback is very valuable to the further developent" ^& vbcrlf ^& "of this program." ^& vbcrlf  ^& "Would you like to leave a comment/rating on gta5-mods.com?" ^& vbcrlf ^& vbcrlf ^&"(This message will only appear once)" ^& vbcrlf,vbYesNo + vbQuestion,"A2SR -- First time notification"
		(
			echo Set objShell = CreateObject^("Wscript.Shell"^)
			echo X=MsgBox^(!vbMessage!^)
			echo objShell.RegWrite "HKCU\Software\FoddEx\Add to Self Radio\1Timenotif", "1", "REG_SZ"
			echo If x = vbYes Then
			echo     objShell.Run^("https://www.gta5-mods.com/tools/add-to-self-radio"^)
			echo Else
			echo     Wscript.Quit
			echo End If
		)>"%temp%\a2sr_1timemsg.vbs"
		start "" "%temp%\a2sr_1timemsg.vbs"
	)
)
goto :eof
:moveexport
if !_LAUNCHPARAMETER!==MOVEEXPORT (
	set dt=!date:.=!
	reg export "HKCU\Software\FoddEx\Add to Self Radio\Restore" "_RestoreData!dt!.reg" /y
	for /f "skip=1 tokens=*" %%A in (_RestoreData!dt!.reg) do (
		set "str=%%A"
		set str=!str:"=\"!
		echo.!str!>>ExportData_!dt!.reg
	)
	del /q "_RestoreData!dt!.reg"
	exit
)
goto :eof
:colortext
set "param=^%~2" !
set "param=!param:"=\"!"
findstr /p /A:%1 "." "!param!\..\X" nul
<nul set /p ".=%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%%DEL%"
if /i "%~3"=="n" echo.
goto :eof
:strlen
setlocal
set input=%1
set input=%input:"=%
set "myString=%input%
call :_strlen result myString
set strlen_length=!result!
goto :eof
:_strlen
(   
    setlocal
    set "s=!%~2!#"
    set "len=0"
    for %%P in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
        if "!s:~%%P,1!" NEQ "" ( 
            set /a "len+=%%P"
            set "s=!s:~%%P!"
        )
    )
)
( 
    endlocal
    set "%~1=%len%"
    exit /b
)

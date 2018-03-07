# Add to Self Radio



Add to Self Radio. Version 1.9
By RainBawZ / kukpappa

:::::::::::::::::::::::
Table of contents:
1:
   1a: About the program
   1b: Modes explained
   1c: Using the playlist functionality

2:
   2a: Installation/setup
   2b: Uninstallation

3:
   3: Known issues

4:
   4: Disclaimer, terms and conditions

5:
   5: Change log

6:
   6: Credits
:::::::::::::::::::::::

***************************************************************************************************
1a - About the program:

This is a small batch script that adds songs to Self Radio by creating a context menu option which copies or creates shortcuts to the Self Radio folder of Grand Theft Auto V.
Feel free to ask for help should a problem arise, you can also come with suggestions for future features, or just simply leave a comment about what you think . 

***************************************************************************************************
1b - Modes explained:

COPY:
Copies the target file into the GTA V Self Radio folder.
Leaves you with the original file remaining in its original location, while having a copy in the Self Radio folder.

SHORTCUT:
Creates a shortcut to the target file and places it in the GTA V Self Radio folder.
Leaves you with the original file remaining in its original location, with just a shortcut pointing to it placed in the Self Radio folder.

MOVE:
Moves the target file to the GTA V Self Radio folder.
Original file will be in the Self Radio folder. To undo the move, use the "Restore moved songs" option in the program.
From 1.9 and up, you will be able to restore files across different versions.

***************************************************************************************************
1c - Using the playlist functionality:

The menu can be accessed by pressing '4' in the main menu.
In the menu, you have five main choices:
0 - Return
This option returns to the main menu.

1 - Create playlist
This option creates a new playlist. After entering a name you will be passed directly to the "Edit playlist" menu.

2 - Edit active playlist

This option edits the active playlist. Available songs and songs already in the playlist are displayed. Entering a song will add it to the playlist
unless it is already added. If that is the case then the song will be removed from the playlist.

3 - Delete active playlist
Deletes the active playlist. Playlist data cannot be recovered. Songs that are in the playlist can be found in either the User Music folder,
or in the InactiveMusic folder within the GTA V "My Documents" path.

4 - Export playlist data
This creates a .reg file containing all playlist data. Useful for backing up playlist information before installing updates or other changes.
The uninstaller will automatically export playlist data if the "Uninstall registry entries" option is selected.

After these main choices you have all of your available playlist listed with a number corresponding to each playlist.
Enter this number to make that playlist the active playlist. By default only one playlist is present, which is the "Default" playlist containing all
the Self Radio music. Once you have an active playlist set up, you can use the options that require an active playlist to work.

***************************************************************************************************
2a - Installation/setup:

1: Extract "SelfRadioAdd.bat" to any location on your computer, preferably in a dedicated folder.

2: Run the program once and say yes (Y) to add the context menu entry.
   NOTE #1: You will need administrator level permisson to create it, as the default media player options lies in the HKCR registry which requires elevated permissions.

   NOTE #2: If the program fails to find the User Music path, try launching with the Launcher found in "Tools" and select a code page.

3: Choose the settings that suit you

4: You should now have the option to right click any .mp3 file and choose "Add to Self Radio", which will add it depending on the mode you've chosen in the settings.

5: ???

6: PROFIT!!

NOTE: Some users might have to reboot their computer for the changes to take effect.

***************************************************************************************************
2b - Uninstallation:
(1.8 AND NEWER)
- When the program is run for the first time and its setup has been completed, it will create a file called "Uninstall.bat" (Run it).
  The file is located in the same location as the main script (SelfRadioAdd.bat).

  NOTE: (ONLY IN 1.8) All data regarding songs added to Self Radio using the MOVE setting will be lost. Meaning A2SR will not be able to restore them in the future.
	In 1.9 and newer, the data will be saved unless you choose to do a full uninstall.

(1.6.5 AND OLER)
- When the program is run for the first time and its setup has been completed, it will create a file called "Uninstall_AddtoSelfRadio.reg" (Run it).
  The file is located in the same location as the main script (SelfRadioAdd.bat).
- Manually delete all files related to Add to Self Radio (SelfRadioAdd.bat, Readme.txt, Tools folder, Uninstall_AddtoSelfRadio.reg, and X (if present)).


NOTE: You might have to reboot your computer for the changes to take effect.

***************************************************************************************************
2c - Upgrading

- When upgrading to a newer version, run the uninstaller script ("Uninstall.bat") in the A2SR root folder.
- In the uninstaller, choose "Uninstall registry entries". The uninstaller should export your playlist data and moved songs list for later use in the new version.
- Wait for the uninstaller to complete.
- Run the new version of A2SR, and set it up.
- You may now import your playlist data. To do so, simply run the .reg file containing the exported playlist. (named "Export_data_[date].reg")

***************************************************************************************************
3 - Known issues:
- Cannot add songs with names containing exclamation marks (!) (No solution as of now, might be unfixable)
- Playlist names cannot contain spaces. For now I've included an error message for it, but I hope I'll be able to fix this soon.
- Song names containing ampersand characters (&) can't be restored if added with the MOVE option.
  To be completely sure it'll be able to restore moved songs, just make sure there are no special characters in the file name.
- Resizing the window completely f*cks up the UI (don't do that). I don't know if I'm going to be able to fix this or not.

***************************************************************************************************
4 - DISCLAIMER, TERMS AND CONDITIONS:
By downloading this file you agree to the following:
1: I (RainBawZ) am not to blame if you damage your system or files through improper use and/or modification of this program.
2: You may modify this program as you wish, at your own risk, however if you're uploading it or distributing it in any way, please credit me, but DO NOT upload or distribute by my name (RainBawZ).
3: You may not sell or distribute this file for any kind of payment.

***************************************************************************************************
5 - Change log:

Note: Add to Self Radio will hereby be referred to as A2SR.
Note: Changes tagged with [TODO] are not yet implemented.
      Changes tagged with [IN PROGRESS] are implemented but are not fully functional just yet.
      Changes without tags are completed features.

v1.9.0
- Fully added playlist feature.
- Added playlist export feature.
- Program now redirects to the menu after completing the setup instead of the user having to re-run the program to complete setup.
- Text improvements in uninstaller.
- Fixed bug causing the UI to initialize when looking for updates while adding a song.
- Uninstaller can now also export the data containing restoration information for songs added using the MOVE option.
- Updated uninstaller to work with the playlist feature
      - Automatic playlist data exporting. You can use the exported playlist data to reinstall your playlists at a later time.
      - Playlist un-toggling

v1.8.1
- Improved update notes parsing.
- Removed debug text and related pauses.
- Improved update checking.

v1.8
- New input method in the menus. Went from using SET /P to CHOICE. You shouldn't have to hit enter after entering your choice in the menu.
- Added option to enable experimental updating. You can now get a notification whenever there's an experimental version available. To enable it, edit SelfRadioAdd.bat and change ENABLE_EXPERIMENTAL_UPDATES to 1.
      NOTE: Be careful not to add any additional data to the script as it will trigger the version checker and prompt you to reinstall the program.
      NOTE: Be aware that this function does not download the new update from gta5-mods.com and the files will not be approved by them.
- Added another "add" option. You can now choose to MOVE the file to the Self Radio folder in addition to making a shortcut or copying.
- Added option to restore moved files.
- Added improved uninstaller. It will delete all registry entries and files related to A2SR (Music files already added will not be touched). The uninstaller is created when the program setup is completed.
- Made the program install the context menu keys into Windows Groove regardless of the default media player. This hopefully fixes all context-menu related issues.
- Fixed a bug that caused the menu to not show up for users with spaces in their username. (Thanks to 'DeadSonRIsingxD' for reporting this issue)
- Fixed small bug where the program would look for updates twice when setting up for the first time.
- Fixed a bug that caused message popups to fail displaying if the home path contained spaces.
- Improved the way the program works when adding multiple files. It will no longer display the exact same message when adding multiple songs.
- Improved version checking. As of now it is very "strict", meaning that editing the script will trigger a message prompting you to uninstall the old version before continuing.
      NOTE: It triggers only if the file size has changed, if you edit but don't add or remove any characters you should be good to go.
- New UI. Less mess, easier to read, now also with colouring. Sadly I had to sacrifice some UI draw speed for good looks, but it's nothing significant.
- Reduced window size when UI is not needed.

v1.6.5
- Removed the active code page addition from 1.6.3
- Added a fix for people that are unable to use the progrem due to special characters in their user path (Run Launch.bat located in the Tools folder). More detailed information is in the "Code Pages.txt" file located in the Tools folder
- The program now checks if the file actually is an mp3 file before adding, so that no files are put into the self radio folder by accident
- Added update checking in the Settings program
- Added option to change the preferred code page in the settings

v1.6.3
- Changed the active code page to 1252 to hopefully fix the program not working with special characters in usernames. Let me know if you are experiencing issues.
- Removed duplicate :end labels, causing trouble when exiting the program.

v1.6.2
- Fixed an issue where the program would assume an incorrect path when the username contained a space.

v1.6.1
- Found a better way of finding the path to "My documents", the issues where it would try looking in the incorrect location should now be gone.
- Troubleshooter now also collects user profile paths and the path to the "My documents" folder.
- Made the program clean up temporary files generated while running.

v1.6
- Added troubleshooter (Located in the Tools folder): Gathers information about the registry and computer environment into a file that can be sent to my email [rainbawz@derpymail.org].
- Added update checker: Matches a version number on an online server with the one defined in the program and notifies the user if an update is available.
- Added some more logic to optimize execution and prevent errors
- Temporarily fixed issue where users with special characters in the username would be unable to change settings
- Fixed minor issues with the registry keys for Groove and Windows Media Player

v1.5.3
- Fixed the WMP/Groove issue
- Small "under the hood" improvements

v1.5.1
- Added current mode displaying
- Added title display when adding files
- Added some more code comments
- Fixed typo "run the run the uninstaller" in error message "The registry query for MODE returned an invalid value."

v1.5
- Cleaned up the display
- Added Shortcut mode
- Added possibility to switch modes, the action does not require administrator permissions.
- Added notifications about uninstalling old versions
- Added warning which will display upon installation for people using Windows Media Player/Groove (I can't seem to find the source if the issue where the option won't display)
- Added code comments for those of you that like to read through the source code.
Note: The WMP/Groove issue is still present

v1.3.33
- Fixed an issue where the program would crash without displaying error messages

v1.3.32
- Fixed an issue causing the program to fail with custom user profile paths
- Created a temporary fix for people with special characters in the username. The issue was causing the program to prompt the user about path changes on every launch
- The program should now apply the registry changes automatically.
- Added more information to more error messages.

v1.3.03
- Fixed an issue with the program failing to refresh the registry
- Added more information to some error messages 

v1.3
- Added file checking, now checks is the file is successfully added.
- Fixed the issues with file name displaying, file names containing spaces and special characters.
- Added error information to some error messages, feel free to post it over at the gta5-mods.com page for the mod.

v1.2
- Fixed some minor issues involving display size and file name recognition.

v1.1
- Made the program easier to uninstall. (See the Readme for more details)

v1.0
- Initial release


***************************************************************************************************
6 - Credits
Thanks to my testers and buddies who helped make sure everything was in working order before the release of this version:

- Stutt
- Tiny Tim / TechnicianTim
- Dahlia / HimeSamaRoso
- MitchCrank / SpookyHotdog
- HannahDeeerp
- Evan
- Miia / MiiaTheLamia
- Enomis
***************************************************************************************************
@echo off
setlocal EnableDelayedExpansion
color a
title Structure Clone (v1.0)

:: BatchGotAdmin
>nul 2>&1 net session || (
    powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList '%*' -Verb RunAs"
    exit /b
)

if "%~1"=="" exit /b

set "DEST=%USERPROFILE%\Desktop\FolderStructureBackup"
mkdir "%DEST%" >nul 2>&1
cls

for %%F in (%*) do (
    echo.
    echo Copying: %%~fF
    if /I "%%~fF"=="%~f0" (
        echo [Self-detected] Copying the script itself with xcopy...
        echo F| xcopy "%%~fF" "%DEST%\%%~nxF" /I /Y /F
    ) else (
        rem -- Build full destination path preserving folder structure --
        set "drive=%%~dF"              
        set "path=%%~pF"               
        set "name=%%~nxF"              
        set "driveSafe=!drive:~0,1!"   
        if "!path:~0,1!"=="\" set "path=!path:~1!"  

        if exist "%%~fF\*" (
            rem -- Selected item is a folder --
            set "destFolder=%DEST%\!driveSafe!\!path!!name!"
            echo Destination: !destFolder!
            robocopy "%%~fF" "!destFolder!" /E /MT:8 /R:3 /W:5 /ETA /V
        ) else (
            rem -- Selected item is a file --
            rem Destination folder is the parent path (without the file name)
            set "destFolder=%DEST%\!driveSafe!\!path!"
            rem Remove trailing backslash if present.
            if "!destFolder:~-1!"=="\" set "destFolder=!destFolder:~0,-1!"
            echo Destination for file: !destFolder!
            if not exist "!destFolder!" mkdir "!destFolder!"
            robocopy "%%~dpF." "!destFolder!" "%%~nxF" /S /MT:8 /R:3 /W:5 /ETA /V
        )
    )
)

echo.
echo Files copied to: %DEST%
pause

:: ---------------------------------------------------------------
:: Structure Clone Script Explanation
::
:: @echo off
::    - Disables command echoing for cleaner output.
::
:: setlocal EnableDelayedExpansion
::    - Enables delayed variable expansion, allowing dynamic updates within loops.
::
:: color a
::    - Sets the console text color (green).
::
:: title Structure Clone
::    - Sets the title of the command prompt window.
::
:: :: BatchGotAdmin
::    - Section to ensure the script runs with administrative privileges.
::
:: if "%~1"=="" exit /b
::    - Exits if no arguments are passed (i.e., the script wasn't invoked via context menu).
::
:: >nul 2>&1 net session || (
::    - Tries to execute 'net session' to test for admin rights; if it fails, then:
::      powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -ArgumentList '%*' -Verb RunAs"
::         - Relaunches the script with admin privileges using PowerShell.
::      exit /b
:: )
::
:: set "DEST=%USERPROFILE%\Desktop\FolderStructureBackup"
::    - Sets the destination folder (on the Desktop) where backups will be stored.
::
:: mkdir "%DEST%" >nul 2>&1
::    - Creates the destination folder if it doesn't exist, suppressing any output.
::
:: cls
::    - Clears the console screen.
::
:: for %%F in (%*) do (
::    - Loops through each file/folder passed as an argument.
::
::    echo.
::    echo Copying: %%~fF
::       - Displays the full path of the current item being processed.
::
::    if /I "%%~fF"=="%~f0" (
::       - Checks if the current item is the script itself (case-insensitive).
::
::       echo [Self-detected] Copying the script itself with xcopy...
::       echo F| xcopy "%%~fF" "%DEST%\%%~nxF" /I /Y /F
::          - Uses xcopy to copy the script file, auto-selecting "File" mode (F) without prompting.
::
::    ) else (
::       rem -- Build full destination path preserving folder structure --
::       set "drive=%%~dF"
::          - Extracts the drive letter (e.g., "C:").
::
::       set "path=%%~pF"
::          - Extracts the path (e.g., "\PCSX2\memcards\").
::
::       set "name=%%~nxF"
::          - Extracts the name and extension of the item (e.g., "Mcd002.ps2").
::
::       set "driveSafe=!drive:~0,1!"
::          - Keeps only the drive letter (e.g., "C") by removing the colon.
::
::       if "!path:~0,1!"=="\" set "path=!path:~1!"
::          - Removes the leading backslash from the path.
::
::       if exist "%%~fF\*" (
::          - Checks if the current item is a folder (i.e., if it contains sub-items).
::
::          set "destFolder=%DEST%\!driveSafe!\!path!!name!"
::             - Constructs the destination path by appending the folder's name to its path.
::
::          echo Destination: !destFolder!
::             - Displays the constructed destination path.
::
::          robocopy "%%~fF" "!destFolder!" /E /MT:8 /R:3 /W:5 /ETA /V
::             - Copies the folder and all its contents recursively using robocopy.
::
::       ) else (
::          rem -- Selected item is a file --
::          set "destFolder=%DEST%\!driveSafe!\!path!"
::             - Constructs the destination folder path as the file’s parent directory.
::
::          if "!destFolder:~-1!"=="\" set "destFolder=!destFolder:~0,-1!"
::             - Removes any trailing backslash from the destination folder.
::
::          echo Destination for file: !destFolder!
::             - Displays the destination folder for the file.
::
::          if not exist "!destFolder!" mkdir "!destFolder!"
::             - Creates the destination folder if it doesn't exist.
::
::          robocopy "%%~dpF." "!destFolder!" %%~nxF /S /MT:8 /R:3 /W:5 /ETA /V
::             - Copies the file from its parent directory to the destination folder.
::               (The dot after %%~dpF ensures the source is treated as a directory.)
::
::       )
::    )
:: )
::
:: echo.
:: echo Files copied to: %DEST%
::    - Displays the final backup destination.
::
:: pause
::    - Pauses the script, allowing the user to review the output before the window closes.
:: ---------------------------------------------------------------

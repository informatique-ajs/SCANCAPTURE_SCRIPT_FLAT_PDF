@echo off
setlocal enabledelayedexpansion

REM Spécifiez le dossier contenant les fichiers PDF
set "PDF_DIR=C:\Users\tbury\Desktop\Input"

REM Spécifiez le dossier de destination pour les fichiers PostScript
set "OUTPUT_DIR=C:\Users\tbury\Desktop\Output"

REM Créez le dossier de destination s'il n'existe pas
if not exist "!OUTPUT_DIR!" mkdir "!OUTPUT_DIR!"

REM Parcourez tous les fichiers PDF dans le dossier
for %%f in ("%PDF_DIR%\*.pdf") do (
    echo Traitement de %%f...

    REM Get the full path and name of the input PDF
    set "INPUT_FILE_FULLPATH=%%f"
    
    REM Get the drive and path of the input PDF
    set "INPUT_FILE_DRIVE_PATH=%%~dpf"
    
    REM Get the base name of the input PDF without extension
    set "BASE_NAME=%%~nf"

    REM Define the expected output file name that Sanitize-PDF.bat generates
    REM It generates 'flattened_postscript.pdf' in the *same directory as the input PDF*
    set "GENERATED_OUTPUT_FILENAME=flat.pdf"

    REM Construct the full expected path to the generated output file
    REM Note: We are expecting it to be in the *same folder as the original PDF* initially
    set "EXPECTED_GENERATED_FILE=!INPUT_FILE_DRIVE_PATH!!GENERATED_OUTPUT_FILENAME!"

    REM Call the Sanitize-PDF script for each file.
    REM It needs the full path to the input PDF.
    call Sanitize-PDF.bat "!INPUT_FILE_FULLPATH!"
    
    REM Check if the flattened_postscript.pdf has been generated at the expected location
    if exist "!EXPECTED_GENERATED_FILE!" (
        echo Déplacement du fichier !GENERATED_OUTPUT_FILENAME! vers !OUTPUT_DIR!...
        REM Rename the file before moving it to include the original PDF's base name
        ren "!EXPECTED_GENERATED_FILE!" "!BASE_NAME!_!GENERATED_OUTPUT_FILENAME!"
        move /Y "!INPUT_FILE_DRIVE_PATH!!BASE_NAME!_!GENERATED_OUTPUT_FILENAME!" "!OUTPUT_DIR!\"
        
        REM Suppression du fichier PDF original
        echo Suppression du fichier PDF original : !INPUT_FILE_FULLPATH!
        del "!INPUT_FILE_FULLPATH!"
    ) else (
        echo Aucune sortie !GENERATED_OUTPUT_FILENAME! générée pour !INPUT_FILE_FULLPATH!.
    )
)

echo Traitement terminé.
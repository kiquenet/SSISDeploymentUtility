@echo off

SET /P SOURCEFOLDER= Enter the Source Folder where the Packages are located:
SET /P DESTSERVER= Enter the Destination Server:
SET /P DESTLOCATION= Enter Destination Folder (Leave blank for root):

IF NOT EXIST "%SOURCEFOLDER%\*.dtsx" GOTO NOFILES

dtutil /SourceS %DESTSERVER% /FE SQL;%DESTLOCATION%
IF %ERRORLEVEL% EQU 6 (
ECHO.
ECHO Please verify the server name is correct.
ECHO %DESTSERVER%
ECHO.
GOTO END
) 
IF %ERRORLEVEL% GTR 0 GOTO NOFOLDER

:MAIN
ECHO.
ECHO Ready to load the packages
PAUSE
FOR /F "usebackq delims==" %%i in (`dir /b "%SOURCEFOLDER%\*.dtsx"`) do (
ECHO.
ECHO ^>^>^>^>^>^> Copying %%i to %DESTSERVER%\MSDB\%DESTLOCATION% ^<^<^<^<^<^<^<
ECHO.
dtutil /FILE "%SOURCEFOLDER%\%%i" /DESTSERVER %DESTSERVER% /COPY SQL;"%DESTLOCATION%\%%~ni" /QUIET
IF %ERRORLEVEL% GTR 0 GOTO Error_%ERRORLEVEL%
ECHO.
)
GOTO:COMPLETE

:NOFILES
ECHO.
ECHO *** No SSIS Packages were found.  Please verify the folder location:
ECHO %SOURCEFOLDER%
ECHO.
GOTO END

:NOFOLDER
ECHO.
ECHO *** The folder location on the server does not exist.
SET /P RESP=Would you like to create it now (y/n)?
IF %RESP%==y GOTO FOLDERCREATE
ECHO.
GOTO END

:FOLDERCREATE
SET /P PARENT=Enter the Parent Folder ONLY (\ for root):
SET /P NEWFOLDER=Enter the New Folder Location:
ECHO.
ECHO Now creating the new folder on %DESTSERVER%
dtutil /SourceS %DESTSERVER% /FC SQL;%PARENT%;%NEWFOLDER%
IF %ERRORLEVEL% EQU 0 GOTO MAIN
ECHO.
ECHO Something happened, try again.
ECHO.
GOTO FOLDERCREATE

:Error_1
ECHO.
ECHO The utility failed
ECHO Please verify your parameters
ECHO.
GOTO END

:Error_4
ECHO.
ECHO The utility cannot locate the requested package
ECHO Please verify your parameters
ECHO.
GOTO END

:Error_5
ECHO.
ECHO The utility cannot load the requested package
ECHO Please verify your parameters
ECHO.
GOTO END

:Error_6
ECHO.
ECHO The utility cannot resolve the command line because it contains either syntactic or semantic errors
ECHO Please verify your parameters
ECHO.
GOTO END
 

:COMPLETE
ECHO.
ECHO All Packages have been Processed.
ECHO Please verify that no Error Messages or Warnings were returned.
ECHO.
GOTO END

:END
PAUSE


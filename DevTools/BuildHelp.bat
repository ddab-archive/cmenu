@rem ---------------------------------------------------------------------------
@rem Script used to create help file for Colour Popup Menu Component.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 16 Aug 2008 - First version.
@rem
@rem Requires the DELPHI7 environment variable to store the Delphi 7 install
@rem directory.
@rem ---------------------------------------------------------------------------


@echo off

setlocal

set HelpDir=..\Help

rem Check that required files exist

set ErrorMsg=

rem Build help file
%DELPHI7%\Help\Tools\HCRTF.exe -x %HelpDir%\PJColourPopupMenu.hlp
if errorlevel 1 set ErrorMsg=Compilation failed
if not "%ErrorMsg%"=="" goto error
goto success

:error
rem Display error message
echo *** ERROR: %ErrorMsg%
goto end

:success
echo Succeeded

:end
rem All done

endlocal

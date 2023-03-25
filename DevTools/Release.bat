@rem ---------------------------------------------------------------------------
@rem Script used to create zip file containing s Colour Popup Menu Component
@rem release.
@rem
@rem Copyright (C) Peter Johnson (www.delphidabbler.com), 2008
@rem
@rem v1.0 of 17 Aug 2008 - First version.
@rem ---------------------------------------------------------------------------


@echo off

setlocal

cd .\..

set OutFile=Releases\dd-cmenu.zip
set DocsDir=Docs
set HelpDir=Help

if exist %OutFile% del %OutFile%

zip -j -9 %OutFile% PJColourPopupMenu.pas
zip -j -9 %OutFile% PJColourPopupMenu.dcr
zip -j -9 %OutFile% PJColourPopupMenuEd.pas
zip -j -9 %OutFile% PJColourPopupMenuEd.dfm

zip -j -9 %OutFile% %HelpDir%\PJColourPopupMenu.hlp
zip -j -9 %OutFile% %HelpDir%\PJColourPopupMenu.als

zip -j -9 %OutFile% %DocsDir%\ChangeLog.txt
zip -j -9 %OutFile% %DocsDir%\MPL.txt
zip -j -9 %OutFile% %DocsDir%\ReadMe.htm

zip %OutFile% -r -9 Demo\*.*

endlocal

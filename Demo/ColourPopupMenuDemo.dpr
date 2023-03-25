{
 * ColourPopupMenuDemo.dpr
 *
 * Project file for Colour Popup Menu Component demo program.
 *
 * v1.0 of 10 Sep 2003  - Original version.
 * v1.1 of 16 Aug 2008  - Renamed FmColourPopupMenuDemo as FmDemo.
 *                      - Shortened application title to
 *                        "TPJColourPopupMenu Component Demo".
 *
 *
 * This file is copyright (C) P D Johnson (www.delphidabbler.com), 2003-2008.
 * It may be used without restriction,
}


program ColourPopupMenuDemo;


uses
  Forms,
  FmDemo in 'FmDemo.pas' {DemoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TPJColourPopupMenu Component Demo';
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.


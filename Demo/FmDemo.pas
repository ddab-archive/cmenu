{
 * FmDemo.pas
 *
 * Main form for Colour Popup Menu Component demo program.
 *
 * Originally named FmColourPopupMenuDemo.pas. Renamed as FmDemo.pas at v1.1.
 *
 * v1.0 of 10 Sep 2003  - Original version named FmColourPopupMenuDemo.pas.
 * v1.1 of 16 Aug 2008  - Fixed owner draw bug adding spurious "&" characters in
 *                        in menu names on Delphi 7 on Windows Vista.
 *                      - "Show colours as round" and "Display colour
 *                        identifiers" check boxes are now displayed if they
 *                        don't apply to selected display style.
 *                      - Renamed as FmDemo.pas
 *
 *
 * This file is copyright (C) P D Johnson (www.delphidabbler.com), 2003-2008.
 * It may be used without restriction,
}


unit FmDemo;


interface


uses
  // Delphi
  Menus, StdCtrls, ComCtrls, Controls, Buttons, ExtCtrls, Classes, Forms,
  Windows, Graphics,
  // PJSoft
  PJColourPopupMenu;


type

  {TDemoForm:
    The demo project main window.
  }
  TDemoForm = class(TForm)
    btnClose: TButton;
    btnTest: TSpeedButton;
    chkCheckColour: TCheckBox;
    chkColourIDs: TCheckBox;
    chkRoundColours: TCheckBox;
    cmbDisplayStyle: TComboBox;
    cmbMenuCols: TComboBox;
    edBmpHeight: TEdit;
    edBmpWidth: TEdit;
    gbCustom: TGroupBox;
    gbProperties: TGroupBox;
    lblBmpHeight: TLabel;
    lblBmpWidth: TLabel;
    lblDisplayStyle: TLabel;
    lblMenuCols: TLabel;
    lblTestBtn: TLabel;
    pnlTest: TPanel;
    udBmpHeight: TUpDown;
    udBmpWidth: TUpDown;
    mnuTest: TPJColourPopupMenu;
    procedure btnCloseClick(Sender: TObject);
    procedure btnTestMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkCheckColourClick(Sender: TObject);
    procedure cmbDisplayStyleChange(Sender: TObject);
    procedure cmbMenuColsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuTestCreateMenuItem(Sender: TObject; MenuItem: TMenuItem;
      Colour: TColor);
    procedure mnuTestDrawMenuItem(Sender: TObject; MenuItem: TMenuItem;
      ACanvas: TCanvas; ARect: TRect; Selected: Boolean; Colour: TColor);
    procedure mnuTestMeasureMenuItem(Sender: TObject; MenuItem: TMenuItem;
      ACanvas: TCanvas; var Width, Height: Integer; Colour: TColor);
    procedure mnuTestSelectColour(Sender: TObject);
    procedure udBmpHeightClick(Sender: TObject; Button: TUDBtnType);
    procedure udBmpWidthClick(Sender: TObject; Button: TUDBtnType);
  private
    procedure UpdateControls;
      {Updates enabled property of controls that depend on state of others}
    procedure UpdateColour;
      {Updates colour displayed on test button}
  end;

var
  DemoForm: TDemoForm;


implementation

{$R *.DFM}

{
  NOTES:

  The controls in the "Customise Menu" group box can be used to customise the
  menu. This is done by handling the the component's OnCreateMenuItem event.
  This event gets passed a reference to a newly created menu item that you can
  customise (careful: some properties and events are used by the component.

  The examples implemented here show how to:

  + Replace the standard rectangular colour bitmap displayed on the menu when
    both text and a colour are displayed with a circular swatch of colour. This
    is done when "Show colours as round" is checked.

  + Replace the English language captions used when text is displayed with
    alternative captions. In this example we display the Delphi colour constant
    names.

  All this happens in the mnuTestCreateMenuItem method.
}

{ TDemoForm }

procedure TDemoForm.btnCloseClick(Sender: TObject);
  {Close the app}
begin
  Close;
end;

procedure TDemoForm.btnTestMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  {Popup the test menu: demonstrates how to pop-up the menu manually}
var
  PopupPos: TPoint; // where menu is to pop-up
begin
  PopupPos := ClientToScreen(Point(btnTest.Left, btnTest.Top + btnTest.Height));
  mnuTest.Popup(PopupPos.X, PopupPos.Y);
end;

procedure TDemoForm.chkCheckColourClick(Sender: TObject);
  {Update popup menu's CheckSelectedColour property per state of check box}
begin
  mnuTest.CheckSelectedColour := chkCheckColour.Checked;
end;

procedure TDemoForm.cmbDisplayStyleChange(Sender: TObject);
  {Update popup menu's DisplayStyle property according to value selected in
  drop down list. Also update state of controls that depend on value of this
  property}
begin
  mnuTest.DisplayStyle := TPJColourMenuDisplayStyle(cmbDisplayStyle.ItemIndex);
  UpdateControls;
end;

procedure TDemoForm.cmbMenuColsChange(Sender: TObject);
  {Update popup menu's MenuCols property per state of check box}
begin
  mnuTest.MenuColumns := TPJColourMenuColumns(cmbMenuCols.ItemIndex);
end;

procedure TDemoForm.FormCreate(Sender: TObject);
  {Set form's control's to reflect properties of colour menu component}
begin
  // Display application title in window caption
  Caption := Application.Title;
  // Update form's controls to reflect required properties
  cmbDisplayStyle.ItemIndex := Ord(mnuTest.DisplayStyle);
  chkCheckColour.Checked := mnuTest.CheckSelectedColour;
  cmbMenuCols.ItemIndex := Ord(mnuTest.MenuColumns);
  udBmpHeight.Position := mnuTest.BitmapHeight;
  udBmpWidth.Position := mnuTest.BitmapWidth;
  UpdateControls;
  UpdateColour;
end;

procedure TDemoForm.mnuTestCreateMenuItem(Sender: TObject;
  MenuItem: TMenuItem; Colour: TColor);
  {Demo of handling OnCreateMenuItem event: customises colour menu item's
  properties per controls in Customise menu group on main form. See component
  source for explanation of parameters}
var
  Bmp: TBitmap; // used when displaying round bitmaps
begin
  if chkRoundColours.Checked and (mnuTest.DisplayStyle = dsBoth) then
  begin
    // User wants round bitmaps:
    // used only if DisplayStyle = dsBoth
    Bmp := TBitmap.Create;
    try
      Bmp.Width := 12;
      Bmp.Height := 12;
      Bmp.Canvas.Brush.Color := clMenu;
      Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
      Bmp.Canvas.Brush.Color := Colour;
      Bmp.Canvas.Pen.Color := clBtnShadow;
      Bmp.Canvas.Ellipse(0, 0, Bmp.Width - 1, Bmp.Height - 1);
      MenuItem.Bitmap := Bmp;
    finally
      Bmp.Free;
    end;
  end;
  if chkColourIDs.Checked then
  begin
    // User wants to use colour IDs rather than names
    // to translate into another language here you could check the Colour
    // parameter and provide the correct name of the colour in the required
    // language.
    // Here we simply use the names of Delphi's colour constants.
    MenuItem.Caption := ColorToString(Colour);
  end;
end;

procedure TDemoForm.mnuTestDrawMenuItem(Sender: TObject;
  MenuItem: TMenuItem; ACanvas: TCanvas; ARect: TRect; Selected: Boolean;
  Colour: TColor);
  {Demo of handling OnDrawMenuItem event: displays each menu item as text set
  against a background of required colour}
var
  Str: string;        // the menu text
  BrushBmp: TBitmap;  // brush used to highlight selected colour
  ItemRect: TRect;    // rectangle used to display colour and text
  // ---------------------------------------------------------------------------
  function GetTextColour(Colour: TColor): TColor;
    {Returns colour of text to be used over given background colour}
  const
    CColours: array[0..15] of record
      {Table mapping colour names to text colour}
      Colour: TColor;
      TextColour: TColor;
    end = (
      (Colour: clBlack; TextColour: clWhite;),
      (Colour: clMaroon; TextColour: clWhite;),
      (Colour: clGreen; TextColour: clWhite;),
      (Colour: clOlive; TextColour: clWhite;),
      (Colour: clNavy; TextColour: clWhite;),
      (Colour: clPurple; TextColour: clWhite;),
      (Colour: clTeal; TextColour: clWhite;),
      (Colour: clGray; TextColour: clWhite;),
      (Colour: clSilver; TextColour: clBlack;),
      (Colour: clRed; TextColour: clWhite;),
      (Colour: clLime; TextColour: clBlack;),
      (Colour: clYellow; TextColour: clBlack;),
      (Colour: clBlue; TextColour: clWhite;),
      (Colour: clFuchsia; TextColour: clBlack;),
      (Colour: clAqua; TextColour: clBlack;),
      (Colour: clWhite; TextColour: clBlack;)
    );
  var
    Idx: Integer; // loops thru colour table
  begin
    Result := clWhite;
    for Idx := Low(CColours) to High(CColours) do
      if CColours[Idx].Colour = Colour then
      begin
        Result := CColours[Idx].TextColour;
        Break;
      end;
  end;
  // ---------------------------------------------------------------------------
  function CreateBackgroundBmp: TBitmap;
    {Returns a new bitmap object that is used to draw background to checked
    bitmap items}
  var
    X, Y: Integer;      // loop thru X and Y pixels of bitmap
  begin
    // Create bitmap of required brush size
    Result := TBitmap.Create;
    Result.Width := 8;
    Result.Height := 8;
    // Fill background with required colour
    Result.Canvas.Brush.Color := clMenu;
    Result.Canvas.FillRect(Rect(0, 0, 8, 8));
    // Create chequerboard pattern using menu item's colour
    for X := 0 to 7 do
      for Y := 0 to 7 do
        if (Y mod 2) = (X mod 2) then
          Result.Canvas.Pixels[X, Y] := Colour;
  end;
  // ---------------------------------------------------------------------------
begin
  // Assign required brush bitmap
  BrushBmp := nil;        // this object is used to draw background if "checked"
  try
    if (Sender as TPJColourPopupMenu).CheckSelectedColour
      and MenuItem.Checked and not Selected then
    begin
      // menu item is checked and we're flagging as such: use background brush
      BrushBmp := CreateBackgroundBmp;
      ACanvas.Brush.Bitmap := BrushBmp;
    end
    else
    begin
      // menu item not to have checked highlight, set appropriate brush colour
      ACanvas.Brush.Bitmap := nil;
      ACanvas.Brush.Color := clMenu;
    end;
    // actually draw the background
    ACanvas.FillRect(ARect);
  finally
    BrushBmp.Free;
  end;
  // Draw any required highlighting
  if (Sender as TPJColourPopupMenu).CheckSelectedColour
    and MenuItem.Checked then
    DrawEdge(ACanvas.Handle, ARect, BDR_SUNKENOUTER, BF_RECT)
  else if Selected then
    DrawEdge(ACanvas.Handle, ARect, BDR_RAISEDINNER, BF_RECT);
  // Draw menu contents
  // set up rectangle to draw in
  ItemRect := ARect;
  InflateRect(ItemRect, -4, -4);
  // draw an outline
  if clMenu <> clGray then
    ACanvas.Brush.Color := clGray
  else
    ACanvas.Brush.Color := clSilver;
  ACanvas.FillRect(ItemRect);
  // draw the block of colour
  InflateRect(ItemRect, -1, -1);
  ACanvas.Brush.Color := Colour;
  ACanvas.FillRect(ItemRect);                 
  // write out text over colour block
  ACanvas.Font.Color := GetTextColour(Colour);
  Str := MenuItem.Caption;
  // Following line changed from ACanvas.TextOut() since it doesn't work
  // correctly with &prefixes on later Windows OSs and AutoHotKeys=maAutomatic
  // menu property setting
  DrawText(
    ACanvas.Handle,
    PChar(Str),
    -1,
    ItemRect,
    ACanvas.TextFlags or DT_CENTER or DT_VCENTER
  );
end;

procedure TDemoForm.mnuTestMeasureMenuItem(Sender: TObject;
  MenuItem: TMenuItem; ACanvas: TCanvas; var Width, Height: Integer;
  Colour: TColor);
  {Demo of handling OnMeasureMenuItem event: determines required size of menu
  item}
begin
  Height := ACanvas.TextHeight('WwMm') + 12;
  Width := ACanvas.TextWidth(ColorToString(Color)) + 8;
end;

procedure TDemoForm.mnuTestSelectColour(Sender: TObject);
  {Demonstrates OnSelectColour event handling: updates colour displayed on test
  button according to current colour menu selection}
begin
  UpdateColour;
end;

procedure TDemoForm.udBmpHeightClick(Sender: TObject;
  Button: TUDBtnType);
  {Update test menu's BitmapHeight property according to current value of
  up-down control}
begin
  mnuTest.BitmapHeight := udBmpHeight.Position;
end;

procedure TDemoForm.udBmpWidthClick(Sender: TObject;
  Button: TUDBtnType);
  {Update test menu's BitmapWidth property according to current value of
  up-down control}
begin
  mnuTest.BitmapWidth := udBmpWidth.Position;
end;

procedure TDemoForm.UpdateColour;
  {Updates colour displayed on test button: demonstrates use of SelectedColour
  property}
const
  cBtnBmpSize = 14;   // size of bitmap
var
  Bmp: TBitmap;       // the bitmap to be assigned to button
  BmpColour: TColor;  // colour of bitmap to display
  BmpRect: TRect;     // rectangle to display bitmap in
begin
  Bmp := TBitmap.Create;
  try
    // Set bitmap's size
    Bmp.Width := cBtnBmpSize;
    Bmp.Height := cBtnBmpSize;
    // Record required colour and size of bmp
    BmpColour := mnuTest.SelectedColour;
    BmpRect := Rect(0, 0, cBtnBmpSize, cBtnBmpSize);
    // Border used as transparent colour: so make different to bmp colour
    if BmpColour <> clWhite then
      Bmp.Canvas.Brush.Color := clWhite
    else
      Bmp.Canvas.Brush.Color := clBlack;
    // Paint colour to be used as transparent border
    Bmp.Canvas.FillRect(BmpRect);
    // Paint a true border
    InflateRect(BmpRect, -1, -1);
    Bmp.Canvas.Brush.Color := clGray;
    Bmp.Canvas.FillRect(BmpRect);
    // Paint bmp colour inside border
    Bmp.Canvas.Brush.Color := BmpColour;
    InflateRect(BmpRect, -1, -1);
    Bmp.Canvas.FillRect(BmpRect);
    // Finally store the glyph
    btnTest.Glyph.Assign(Bmp);
  finally
    Bmp.Free;
  end;
end;

procedure TDemoForm.UpdateControls;
  {Updates enabled property of controls that depend on state of others}
begin
  if mnuTest.DisplayStyle = dsColourOnly then
  begin
    lblBmpHeight.Enabled := True;
    lblBmpWidth.Enabled := True;
    edBmpHeight.Enabled := True;
    edBmpHeight.Color := cmbDisplayStyle.Color;
    edBmpWidth.Enabled := True;
    edBmpWidth.Color := cmbDisplayStyle.Color;
    udBmpHeight.Enabled := True;
    udBmpWidth.Enabled := True;
  end
  else
  begin
    lblBmpHeight.Enabled := False;
    lblBmpWidth.Enabled := False;
    edBmpHeight.Enabled := False;
    edBmpHeight.ParentColor := True;
    edBmpWidth.Enabled := False;
    edBmpWidth.ParentColor := True;
    udBmpHeight.Enabled := False;
    udBmpWidth.Enabled := False;
  end;
  chkRoundColours.Enabled := mnuTest.DisplayStyle = dsBoth;
  chkColourIDs.Enabled := mnuTest.DisplayStyle <> dsColourOnly;
end;

end.
 
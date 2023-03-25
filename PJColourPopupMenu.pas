{
 * PJColourPopupMenu.pas
 *
 * A component that provides a popup menu that displays menu items for the
 * sixteen common colours in a traditional menu style or as a colour palette.
 *
 * v1.0 of 06 May 2001  - Original version.
 * v1.1 of 10 Sep 2003  - Removed design-time code to make compatible with
 *                        Delphi 6 & 7:
 *                        - Moved registration of component and property
 *                          editors to PJColourPopupMenuEd unit.
 *                        - Moved declaration and implementation of property
 *                          editors to PJColourPopupMenuEd unit.
 *                        - Removed DsgnIntf unit reference.
 * v1.2 of 16 Aug 2008  - Replaced literal colour display names with resource
 *                        strings.
 *                      - Refactored colour mapping table to use TIdentMapEntry.
 *                      - Changed to Mozilla Public license.
 *
 *
 * ***** BEGIN LICENSE BLOCK *****
 *
 * Version: MPL 1.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with the
 * License. You may obtain a copy of the License at http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * The Original Code is PJColourPopupMenu.pas
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2001-2008 Peter
 * Johnson. All Rights Reserved.
 *
 * ***** END LICENSE BLOCK *****
}


unit PJColourPopupMenu;


interface


uses
  // Delphi
  SysUtils, Classes, Windows, Graphics, Menus;


type

  {
  TPJColourMenuDisplayStyle:
    Style of menu to display.
  }
  TPJColourMenuDisplayStyle = (
    dsTextOnly,     // displays text only (as standard menu)
    dsColourOnly,   // displays colours only
    dsBoth,         // displays both text and colour
    dsOwnerDraw     // user takes control over display
  );

  {
  TPJColourMenuColumns:
    Number of menu columns to display.
  }
  TPJColourMenuColumns = (
    mc1,            // one column of sixteen colours
    mc2,            // two columns of eight colours each
    mc4,            // four columns of four colours each
    mc8             // eight columns of two colours each
  );

  {
  TPJMeasureColourMenuItemEvent:
    Type of event handler for TPJColourPopupMenu's OnMeasureMenuItem event.
      @param Sender [in] Reference to component that triggered event.
      @param MenuItem [in] Refers to menu item to be measured (do not change the
        properties of this menu item).
      @param ACanvas [in] Canvas on which the menu item is to be drawn.
      @param Width [in/out] Handler set to required width of menu item.
      @param Height [in/out] Handler set to required height of menu item.
      @param Colour [in] Colour represented by menu item.
  }
  TPJMeasureColourMenuItemEvent = procedure (Sender: TObject;
    MenuItem: TMenuItem; ACanvas: TCanvas; var Width, Height: Integer;
    Colour: TColor) of object;

  {
  TPJDrawColourMenuItemEvent:
    Type of event handler for TPJColourPopupMenu's OnDrawMenuItem event.
      @param Sender [in] Reference to component that triggered event.
      @param MenuItem [in] Refers to the menu item to be drawn (do not change
        the properties of this menu item).
      @param ACanvas [in] Canvas on which the menu item is to be drawn.
      @param ARect [in] Rectangle in which to draw.
      @param Selected [in] Indicates whether menu item is currently selected.
      @param Colour [in] Colour represented by menu item.
  }
  TPJDrawColourMenuItemEvent = procedure (Sender: TObject; MenuItem: TMenuItem;
    ACanvas: TCanvas; ARect: TRect; Selected: Boolean;
    Colour: TColor) of object;


  {
  TPJCreateColourMenuItemEvent:
    Type of event handler for TPJColourOpupMenu's OnCreateMenuItem event.
      @param Sender [in] Reference to component that triggered event.
      @param MenuItem [in] Reference to menu item just created.
      @param Colour [in] Colour represented by menu item.
  }
  TPJCreateColourMenuItemEvent = procedure (Sender: TObject;
    MenuItem: TMenuItem; Colour: TColor) of object;

  {
  EPJColourPopupMenu:
    Type of exception raised by TPJColourPopupMenu component.
  }
  EPJColourPopupMenu = class(Exception);

  {
  TPJColourPopupMenu:
    Popup menu component that displays either a list or a a palette of 16
    standard colours.
  }
  TPJColourPopupMenu = class(TPopupMenu)
  private
    fBitmapHeight: Integer;
      {Value of BitmapHeight property}
    fBitmapWidth: Integer;
      {Value of BitmapWidth property}
    fSelectedColour: TColor;
      {Value of SelectedColour property}
    fMenuColumns: TPJColourMenuColumns;
      {Value of MenuColumns property}
    fDisplayStyle: TPJColourMenuDisplayStyle;
      {Value of DisplayStyle property}
    fCheckSelectedColour: Boolean;
      {Value of CheckSelectedColour property}
    fOnSelectColour: TNotifyEvent;
      {Event handler for OnSelectColour event}
    fOnDrawMenuItem: TPJDrawColourMenuItemEvent;
      {Event handler for OnDrawMenuItem event}
    fOnMeasureMenuItem: TPJMeasureColourMenuItemEvent;
      {Event handler for OnMeasureMenuItem event}
    fOnCreateMenuItem: TPJCreateColourMenuItemEvent;
      {Event handler for OnCreateMenuItem event}
  protected
    procedure SetDisplayStyle(const Value: TPJColourMenuDisplayStyle); virtual;
      {Write access method for DisplayStyle property. Stores new property value
      and also sets inherited OwnerDraw property to required value depending on
      DisplayStyle.
        @param Value [in] New value of DisplayStyle property.
      }
    function GetOwnerDraw: Boolean;
      {Replacement read access method for OwnerDraw property. Uses DisplayStyle
      property to determine value.
        @return True if DisplayStyle is OwnerDraw, False otherwise.
      }
    procedure SetOwnerDraw(const Value: Boolean);
      {Replacement write access method for OwnerDraw property. Sets DisplayStyle
      to dsOwnerDraw if the OwnerDraw property is True.
        @param Value [in] New value of OwnerDraw property.
      }
    function GetItems: TMenuItem;
      {Replacement read access method for Items property. Raises exception at
      run time.
        @return Inherited property at design time. Does not return at run time.
        @except EPJColourPopupMenu if called at run time.
      }
    procedure DoChange(Source: TMenuItem; Rebuild: Boolean); override;
      {Override of method that normally triggers OnChange event. Reimplemented
      to do nothing since this event is not supported.
        @param Source [in] Not used.
        @param Rebuild [in] Not used.
      }
    procedure BuildMenu; virtual;
      {Creates the menu per the component's properties.
      }
    procedure ColourChosen(Sender: TObject); virtual;
      {OnClick event handler for all menu items. Updates SelectedColour property
      and triggers OnSelectColour event.
        @param Sender [in] Reference to menu item that triggered event.
      }
    procedure DrawMenuItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean); virtual;
      {Event handler for menu item's OnDrawItem used when DisplayStyle is
      dsColourOnly. Performs custom drawing of colour-only menu items.
        @param Sender [in] Referfence to menu item that triggered event.
        @param ACanvas [in] Canvas on which menu item is to be drawn.
        @param ARect [in] Rectangle in which menu item to be drawn.
        @param Selected [in] Flag true if menu item is selected, false if not.
      }
    procedure MeasureMenuItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer); virtual;
      {Event handler for menu item's OnMeasureItem used when DisplayStyle is
      dsColourOnly. Calculates size of menu item object to be drawn for
      colour-only menu items.
        @param Sender [in] Referfence to menu item that triggered event.
        @param ACanvas [in] Canvas on which menu item is to be drawn.
        @param Width [in] Set to width of menu item.
        @param Height [in] Set to height of menu item.
      }
    procedure UserDrawMenuItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean); virtual;
      {Handler for a menu item's OnDrawItem event used when DisplayStyle is
      dsOwnerDraw. Triggers component's OnDrawMenuItem event if assigned.
        @param Sender [in] Referfence to menu item that triggered event.
        @param ACanvas [in] Canvas on which menu item is to be drawn.
        @param ARect [in] Rectangle in which menu item to be drawn.
        @param Selected [in] Flag true if menu item is selected, false if not.
      }
    procedure UserMeasureMenuItem(Sender: TObject; ACanvas: TCanvas;
      var Width, Height: Integer); virtual;
      {Handler for a menu item's OnMeasureItem event used when DisplayStyle is
      dsOwnerDraw. Triggers component's OnMeasurerMenuItem event if assigned.
        @param Sender [in] Referfence to menu item that triggered event.
        @param ACanvas [in] Canvas on which menu item is to be drawn.
        @param Width [in] Width of menu item: can be modified by event handler.
        @param Height [in] Height of menu item: can be modified by event
          handler.
      }
  public
    constructor Create(AOwner: TComponent); override;
      {Class constructor. Sets up component and sets default property values.
        @param AOwner [in] Reference to owning component.
      }
    procedure Popup(X, Y: Integer); override;
      {Creates and displays menu.
        @param X [in] X coordinate of top left corner of menu.
        @param Y [in] Y coordinate of top left corner of menu.
      }
  published
    { Re-defined properties }
    property OwnerDraw: Boolean
      read GetOwnerDraw write SetOwnerDraw stored False default False;
      {Changed so that can't be set false when style DisplayStyle is
      dsOwnerDraw. Also changes DisplayStyle to dsOwnerDraw when set true}
    property Items: TMenuItem
      read GetItems;
      {This property is inaccessible in this component: exception is raised if
      any attempt is made to access it}
    { New properties for this component }
    property SelectedColour: TColor
      read fSelectedColour write fSelectedColour default clBlack;
      {Colour last selected on the menu. If no selection has been made, the
      colour is black}
    property DisplayStyle: TPJColourMenuDisplayStyle
      read fDisplayStyle write SetDisplayStyle default dsBoth;
      {The style in which the menu is displayed: text only, colours only, both
      text and colours or owner draw}
    property CheckSelectedColour: Boolean
      read fCheckSelectedColour write fCheckSelectedColour default True;
      {Whether currently selected colour should be checked in the menu. When
      true the last-selected colour on the menu is highlighted or checked}
    property MenuColumns: TPJColourMenuColumns
      read fMenuColumns write fMenuColumns default mc1;
      {Number of columns that are displayed in menu: 1, 2, 4 or 8}
    property BitmapHeight: Integer
      read fBitmapHeight write fBitmapHeight default 9;
      {Height of bitmap that displays the colour in the menu. This property is
      ignored unless DisplayStyle=dsColourOnly}
    property BitmapWidth: Integer
      read fBitmapWidth write fBitmapWidth default 9;
      {Width of bitmap that displays the colour in the menu. This property is
      ignored unless DisplayStyle=dsColourOnly}
    property OnSelectColour: TNotifyEvent
      read fOnSelectColour write fOnSelectColour;
      {Event triggered when user selects a colour on the menu. User can get the
      colour that was chosen by examining the SelectedColour property}
    property OnDrawMenuItem: TPJDrawColourMenuItemEvent
      read fOnDrawMenuItem write fOnDrawMenuItem;
      {Event triggered for each menu item that is to be drawn. User must paint
      the menu item in the event handler. Only triggered when
      DisplayStyle=dsOwnerDraw}
    property OnMeasureMenuItem: TPJMeasureColourMenuItemEvent
      read fOnMeasureMenuItem write fOnMeasureMenuItem;
      {Event triggered for each menu item that is to be drawn. User must return
      size of menu item in the event handler. Only triggered when
      DisplayStyle=dsOwnerDraw}
    property OnCreateMenuItem: TPJCreateColourMenuItemEvent
      read fOnCreateMenuItem write fOnCreateMenuItem;
      {Event triggered when colour menu items are being created. The menu item
      can be cutomised before it is displayed}
  end;


implementation


resourcestring
  // Exception message
  sCantAccessItems = 'Can''t access menu items in TPJColourPopupMenu';
  // Colour names
  sBlack =    'Black';
  sMaroon =   'Maroon';
  sGreen =    'Green';
  sOlive =    'Olive';
  sNavy =     'Navy';
  sPurple =   'Purple';
  sTeal =     'Teal';
  sGrey =     'Grey';
  sSilver =   'Silver';
  sRed =      'Red';
  sLime =     'Lime';
  sYellow =   'Yellow';
  sBlue =     'Blue';
  sFuchsia =  'Fuchsia';
  sAqua =     'Aqua';
  sWhite =    'White';


const
  // Table mapping colour names to colour identifiers
  cColours: array[0..15] of TIdentMapEntry = (
    (Value: clBlack;    Name: sBlack;   ),
    (Value: clMaroon;   Name: sMaroon;  ),
    (Value: clGreen;    Name: sGreen;   ),
    (Value: clOlive;    Name: sOlive;   ),
    (Value: clNavy;     Name: sNavy;    ),
    (Value: clPurple;   Name: sPurple;  ),
    (Value: clTeal;     Name: sTeal;    ),
    (Value: clGray;     Name: sGrey;    ),
    (Value: clSilver;   Name: sSilver;  ),
    (Value: clRed;      Name: sRed;     ),
    (Value: clLime;     Name: sLime;    ),
    (Value: clYellow;   Name: sYellow;  ),
    (Value: clBlue;     Name: sBlue;    ),
    (Value: clFuchsia;  Name: sFuchsia; ),
    (Value: clAqua;     Name: sAqua;    ),
    (Value: clWhite;    Name: sWhite;   )
  );

  // Mapping of TPJColourMenuColumns to actual number of columns
  cMenuCols: array[TPJColourMenuColumns] of Integer = (1, 2, 4, 8);


type

  {
  TColourMenuItem:
    Private custom menu item class for colour menu items: stores colour relating
    to menu item.
  }
  TColourMenuItem = class(TMenuItem)
  private
    fColour: TColor;
      {Value of Colour property}
  public
    property Colour: TColor read fColour write fColour;
      {The colour associated with menu item}
  end;


{ TPJColourPopupMenu }

procedure TPJColourPopupMenu.BuildMenu;
  {Creates the menu per the component's properties.
  }
var
  I: Integer;                 // loops thru all supported colours
  MenuItem: TColourMenuItem;  // new menu item instance being added to menu
  Bmp: TBitmap;               // bitmap instance to be displayed on a menu item
  ColourIdx: Integer;         // index in colours table
  MenuCols: Integer;          // number of columns in menu
  MenuRows: Integer;          // number of rows in menu

  // ---------------------------------------------------------------------------
  function ColourOrder(Idx, Cols, Rows: Integer): Integer;
    {Returns the colour to display at the given column and row to keep colours
    in usual order}
  begin
    Result :=  Cols * (Idx mod Rows) + (Idx div Rows);
  end;
  // ---------------------------------------------------------------------------

begin
  // Do nothing if we're designing
  if csDesigning in ComponentState then
    Exit;
  // Calculate information about number of columns and rows in menu
  MenuCols := cMenuCols[fMenuColumns];
  MenuRows := 16 div MenuCols;
  // Dispose of all previous menu items
  for I := Pred(inherited Items.Count) downto 0 do
    inherited Items[I].Free;
  // Create new menu items
  for I := Low(cColours) to High(cColours) do
  begin
    // Set default property values that can be customised by user
    // calculate index of next colour in colour table
    // (we ensure that colours appear in usual order across columns)
    ColourIdx := ColourOrder(I, MenuCols, MenuRows);
    // create menu item for current colour
    MenuItem := TColourMenuItem.Create(Self);
    if (I mod MenuRows = 0) and (I <> 0) then
      // we're starting a new column
      MenuItem.Break := mbBreak	;
    if fDisplayStyle = dsBoth then
    begin
      // displaying colours with text using default drawing: create bitmap
      Bmp := TBitmap.Create;
      try
        Bmp.Width := 12;   // use hard coded bitmap size: TMenuItem draws this
        Bmp.Height := 12;  // centred in a (hard coded) 16x16 glyph
        Bmp.Canvas.Brush.Color := clMenu;
        Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
        Bmp.Canvas.Brush.Color := cColours[ColourIdx].Value;
        Bmp.Canvas.Pen.Color := clBtnShadow;
        Bmp.Canvas.Rectangle(0, 0, Bmp.Width - 1, Bmp.Height - 1);
        MenuItem.Bitmap := Bmp;
      finally
        Bmp.Free;
      end;
    end;
    if fDisplayStyle in [dsBoth, dsTextOnly, dsOwnerDraw] then
      // displaying colour name using default drawing: store text in caption
      MenuItem.Caption := cColours[ColourIdx].Name;
    if fCheckSelectedColour and
      (cColours[ColourIdx].Value = fSelectedColour) then
      // we're highlighting check marks and this item is checked, so do it
      MenuItem.Checked := True;
    // record help context
    MenuItem.HelpContext := Self.HelpContext;
    // Record colour in menu item's tag
    MenuItem.Colour := cColours[ColourIdx].Value;
    // Allow user to cutomise menu
    if Assigned(fOnCreateMenuItem) then
      fOnCreateMenuItem(Self, MenuItem, MenuItem.Colour);
    // Restore event handlers as required
    // set measure and drawing items if owner draw
    case DisplayStyle of
      dsColourOnly:
      begin
        // component draws colour-only style
        MenuItem.OnDrawItem := DrawMenuItem;
        MenuItem.OnMeasureItem := MeasureMenuItem;
      end;
      dsOwnerDraw:
      begin
        // user draws using events
        MenuItem.OnDrawItem := UserDrawMenuItem;
        MenuItem.OnMeasureItem := UserMeasureMenuItem;
      end;
      else
        // no owner draw events
        MenuItem.OnDrawItem := nil;
        MenuItem.OnMeasureItem := nil;
    end;
    // intercept menu item's OnClick event
    MenuItem.OnClick := ColourChosen;
    // Add new menu item to menu
    inherited Items.Add(MenuItem);
  end;
end;

procedure TPJColourPopupMenu.ColourChosen(Sender: TObject);
  {OnClick event handler for all menu items. Updates SelectedColour property and
  triggers OnSelectColour event.
    @param Sender [in] Reference to menu item that triggered event.
  }
begin
  // Record selected colour and trigger OnSelectColour event
  fSelectedColour := (Sender as TColourMenuItem).Colour;
  if Assigned(fOnSelectColour) then fOnSelectColour(Self);
end;

constructor TPJColourPopupMenu.Create(AOwner: TComponent);
  {Class constructor. Sets up component and sets default property values.
    @param AOwner [in] Reference to owning component.
  }
begin
  inherited Create(AOwner);
  fDisplayStyle := dsBoth;
  fCheckSelectedColour := True;
  fMenuColumns := mc1;
  fBitmapHeight := 9;
  fBitmapWidth := 9;
  fSelectedColour := clBlack;
end;

procedure TPJColourPopupMenu.DoChange(Source: TMenuItem; Rebuild: Boolean);
  {Override of method that normally triggers OnChange event. Reimplemented to do
  nothing since this event is not supported.
    @param Source [in] Not used.
    @param Rebuild [in] Not used.
  }
begin
  // Do nothing
end;

procedure TPJColourPopupMenu.DrawMenuItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
  {Event handler for menu item's OnDrawItem used when DisplayStyle is
  dsColourOnly. Performs custom drawing of colour-only menu items.
    @param Sender [in] Referfence to menu item that triggered event.
    @param ACanvas [in] Canvas on which menu item is to be drawn.
    @param ARect [in] Rectangle in which menu item to be drawn.
    @param Selected [in] Flag true if menu item is selected, false if not.
  }

  // ---------------------------------------------------------------------------
  function CreateBackgroundBmp: TBitmap;
    {Creates a new bitmap object that is used to draw the background of checked
    bitmap items.
      @return Reference to created bitmap.
    }
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
    // Create chequerboard pattern using button highlight colour
    for X := 0 to 7 do
      for Y := 0 to 7 do
        if (Y mod 2) = (X mod 2) then
          Result.Canvas.Pixels[X, Y] := clBtnHighlight;
  end;
  // ---------------------------------------------------------------------------

var
  MenuItem: TColourMenuItem;  // reference to menu item being drawn
  BrushBmp: TBitmap;          // brush bitmap used to highlight checked items
begin
  // Record reference to menu item being drawn, it's text and related colour
  MenuItem := Sender as TColourMenuItem;
  // Adjust size of area to be drawn
  InflateRect(ARect, -1, 0);
  // Draw background to bitmap
  BrushBmp := nil;        // this object is used to draw background if "checked"
  try
    if fCheckSelectedColour and MenuItem.Checked and not Selected then
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
  // Draw the raised edge around the bitmap area as raised or lowered
  if fCheckSelectedColour and MenuItem.Checked then
    DrawEdge(ACanvas.Handle, ARect, BDR_SUNKENOUTER, BF_RECT)
  else if Selected then
    DrawEdge(ACanvas.Handle, ARect, BDR_RAISEDINNER, BF_RECT);
  // Draw actual colour
  // adjust rectangle size for drawing colour
  InflateRect(ARect, -4, -4);
  // now draw it
  ACanvas.Pen.Color := clBtnShadow;
  ACanvas.Brush.Color := MenuItem.Colour;
  ACanvas.Rectangle(ARect.Left, ARect.Top, ARect.Right, ARect.Bottom);
end;

function TPJColourPopupMenu.GetItems: TMenuItem;
  {Replacement read access method for Items property. Raises exception at run
  time.
    @return Inherited property at design time. Does not return at run time.
    @except EPJColourPopupMenu if called at run time.
  }
begin
  if csDesigning in ComponentState then
    Result := inherited Items
  else
    raise EPJColourPopupMenu.Create(sCantAccessItems);
end;

function TPJColourPopupMenu.GetOwnerDraw: Boolean;
  {Replacement read access method for OwnerDraw property. Uses DisplayStyle
  property to determine value.
    @return True if DisplayStyle is OwnerDraw, False otherwise.
  }
begin
  Result := fDisplayStyle = dsOwnerDraw;
end;

procedure TPJColourPopupMenu.MeasureMenuItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
  {Event handler for menu item's OnMeasureItem used when DisplayStyle is
  dsColourOnly. Calculates size of menu item object to be drawn for colour-only
  menu items.
    @param Sender [in] Referfence to menu item that triggered event.
    @param ACanvas [in] Canvas on which menu item is to be drawn.
    @param Width [in] Set to width of menu item.
    @param Height [in] Set to height of menu item.
  }
begin
  Height := fBitmapHeight + 10;     // adjust so that smallest height shows
  Width := fBitmapWidth;
end;

procedure TPJColourPopupMenu.Popup(X, Y: Integer);
  {Creates and displays menu.
    @param X [in] X coordinate of top left corner of menu.
    @param Y [in] Y coordinate of top left corner of menu.
  }
begin
  BuildMenu;
  inherited Popup(X, Y);
end;

procedure TPJColourPopupMenu.SetDisplayStyle(
  const Value: TPJColourMenuDisplayStyle);
  {Write access method for DisplayStyle property. Stores new property value and
  also sets inherited OwnerDraw property to required value depending on
  DisplayStyle.
    @param Value [in] New value of DisplayStyle property.
  }
begin
  if fDisplayStyle = Value then Exit;
  fDisplayStyle := Value;
  inherited OwnerDraw := Value in [dsColourOnly, dsOwnerDraw];
end;

procedure TPJColourPopupMenu.SetOwnerDraw(const Value: Boolean);
  {Replacement write access method for OwnerDraw property. Sets DisplayStyle to
  dsOwnerDraw if the OwnerDraw property is True.
    @param Value [in] New value of OwnerDraw property.
  }
begin
  if Value = True then
    SetDisplayStyle(dsOwnerDraw);
end;

procedure TPJColourPopupMenu.UserDrawMenuItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
  {Handler for a menu item's OnDrawItem event used when DisplayStyle is
  dsOwnerDraw. Triggers component's OnDrawMenuItem event if assigned.
    @param Sender [in] Referfence to menu item that triggered event.
    @param ACanvas [in] Canvas on which menu item is to be drawn.
    @param ARect [in] Rectangle in which menu item to be drawn.
    @param Selected [in] Flag true if menu item is selected, false if not.
  }
begin
  if Assigned(fOnDrawMenuItem) then
    fOnDrawMenuItem(Self, Sender as TMenuItem, ACanvas, ARect, Selected,
      (Sender as TColourMenuItem).Colour);
end;

procedure TPJColourPopupMenu.UserMeasureMenuItem(Sender: TObject;
  ACanvas: TCanvas; var Width, Height: Integer);
  {Handler for a menu item's OnMeasureItem event used when DisplayStyle is
  dsOwnerDraw. Triggers component's OnMeasurerMenuItem event if assigned.
    @param Sender [in] Referfence to menu item that triggered event.
    @param ACanvas [in] Canvas on which menu item is to be drawn.
    @param Width [in] Width of menu item: can be modified by event handler.
    @param Height [in] Height of menu item: can be modified by event handler.
  }
begin
  if Assigned(fOnMeasureMenuItem) then
    fOnMeasureMenuItem(Self, Sender as TMenuItem, ACanvas, Width, Height,
      (Sender as TColourMenuItem).Colour);
end;

end.

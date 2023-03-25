{
 * PJColourPopupMenuEd.pas
 *
 * Component editor and property editors for TPJColourPopupMenu.
 *
 * Requires the DelphiDabbler TPJColourPopupMenu component v1.0 or later
 *
 * v1.0 of 06 May 2001  - Original version.
 * v2.0 of 10 Sep 2003  - Modified so that all design-time code i.e.
 *                        registration code and property and component editors
 *                        are present in this unit:
 *                        - Moved component and property editor registration
 *                          from PJColourPopupMenu unit and changed component
 *                          palette from PJ Stuff to Delphi Dabbler.
 *                        - Moved declaration and implementation of property
 *                          editors from PJColourPopupMenu unit.
 *                        - Added list of supported colour codes in same order
 *                          as colour table in PJColourPopupMenu.
 *                        - Moved localisable string literals to resource
 *                          strings.
 *                        - Conditionally compiled units required for property
 *                          and component editors to allow for differences
 *                          between Delphi 4/5 and 6/7.
 * v2.1 of 16 Aug 2008  - Fixed conditional inclusion of design units to work
 *                        with all version of Delphi from 6 onwards rather than
 *                        just v6 and v7. This would prevent compilation from
 *                        Delphi 2005 onwards.
 *                      - Replaced MouseUp event handler with Click event
 *                        handler for test button.
 *                      - Changed to Mozilla Public license.
 *                      - Fixed bug that was not displaying selected colour in
 *                        test button.
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
 * The Original Code is PJColourPopupMenuEd.pas
 *
 * The Initial Developer of the Original Code is Peter Johnson
 * (http://www.delphidabbler.com/).
 *
 * Portions created by the Initial Developer are Copyright (C) 2001-2008 Peter
 * Johnson. All Rights Reserved.
 *
 * ***** END LICENSE BLOCK *****
}


unit PJColourPopupMenuEd;


interface


// Find if we have a Delphi 6 or higher compiler
// We don't bother with anything below C++ Builder 3 or Delphi 4 since component
// doesn't compile on lower versions
{$DEFINE DELPHI6ANDUP}
{$IFDEF VER110} // C++ Builder 3
  {$UNDEF DELPHI6ANDUP}
{$ENDIF}
{$IFDEF VER120} // Delphi 4
  {$UNDEF DELPHI6ANDUP}
{$ENDIF}
{$IFDEF VER125} // C++ Builder 4
  {$UNDEF DELPHI6ANDUP}
{$ENDIF}
{$IFDEF VER130} // Delphi 5
  {$UNDEF DELPHI6ANDUP}
{$ENDIF}


uses
  // Delphi
  Classes, Controls, StdCtrls, ExtCtrls, Buttons, Forms, ComCtrls,
  // Delphi design units
  {$IFDEF DELPHI6ANDUP}
    DesignIntf, DesignEditors,
  {$ELSE}
    DsgnIntf,
  {$ENDIF}
  // DelphiDabbler library
  PJColourPopupMenu;


type

  {
  TPJColourPopupMenuItemsPE:
    Property editor that prevents menu editor from being displayed for Items
    property of TPJColourPopupMenu component.
  }
  TPJColourPopupMenuItemsPE = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
      {Tell object inspector that this is a read only value and can't be
      changed.
        @return Always returns [paReadOnly].
      }
    function GetValue: string; override;
      {Causes message to be displayed in object inspector informing that value
      is not editable.
        @return Always returns '(not accessible)'.
      }
  end;


  {
  TPJ16ColourPE:
    Property editor permits any of 16 basic colours to be selected, but not any
    others. Does not display colour dlg box.
  }
  TPJ16ColourPE = class(TPropertyEditor)
  public
    function GetAttributes: TPropertyAttributes; override;
      {Called by object inspector to determine what controls to display for a
      property.
        @return Values that inform object inspector that a list of read only
          values should be displayed in a drop down list.
      }
    procedure GetValues(Proc: TGetStrProc); override;
      {Called when a drop down list is activated in object inspector. Provides
      names of all 16 available colour names for display in drop-down list.
        @param Proc [in] Procedure to call once for each item in list.
      }
    procedure SetValue(const Value: string); override;
      {Calculates numeric value represented by a symbolic value. In this case we
      map a colour constant to its ordinal value.
        @param Value [in] String value to be converted.
      }
    function GetValue: string; override;
      {Returns the symbolic name for the currently selected value. Here we map
      current property value to constant names.
        @return Colour name that describes current property value.
      }
  end;


  {
  TPJColourPopupMenuCE:
    Component editor that adds a menu option to TPJColourPopupMenu components to
    display the colour menu designer. Double-clicking the components also brings
    up the menu designer.
  }
  TPJColourPopupMenuCE = class(TComponentEditor)
  protected
    procedure ExecuteEditor;
      {Displays editor dialogue box and performs required updates if user OKs.
      }
  public
    procedure ExecuteVerb(Index: Integer); override;
      {Called when user chooses our new edit menu option. Displays our editor.
        @param Index [in] Must be 0 to display editor.
      }
    function GetVerb(Index: Integer): string; override;
      {Returns caption of menu item added to component's pop-up menu.
        @return Required caption for colour menu designer.
      }
    function GetVerbCount: Integer; override;
      {Returns number of items added to component's pop-up menu.
        @return Always returns 1 since we add 1 menu item.
      }
  end;


  {
  TFmPJColourPopupMenuCE:
    The TPJColourPopupMenu component editor form.
  }
  TFmPJColourPopupMenuCE = class(TForm)
    btnCancel: TButton;
    btnHelp: TButton;
    btnOK: TButton;
    btnTest: TSpeedButton;
    bvlSep: TBevel;
    chkCheckColour: TCheckBox;
    cmbDisplayStyle: TComboBox;
    cmbMenuCols: TComboBox;
    edBmpHeight: TEdit;
    edBmpWidth: TEdit;
    lblBmpHeight: TLabel;
    lblBmpWidth: TLabel;
    lblDisplayStyle: TLabel;
    lblMenuCols: TLabel;
    lblTestBtn: TLabel;
    pnlTest: TPanel;
    udBmpHeight: TUpDown;
    udBmpWidth: TUpDown;
    procedure btnHelpClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure chkCheckColourClick(Sender: TObject);
    procedure cmbDisplayStyleChange(Sender: TObject);
    procedure cmbMenuColsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mnuTestSelectColour(Sender: TObject);
    procedure udBmpHeightClick(Sender: TObject; Button: TUDBtnType);
    procedure udBmpWidthClick(Sender: TObject; Button: TUDBtnType);
    procedure btnTestClick(Sender: TObject);
  private
    mnuTest: TPJColourPopupMenu;
      {Dynamically created component}
    fComponent: TPJColourPopupMenu;
      {Reference to component being edited}
    procedure UpdateControls;
      {Updates enabled property of controls that depend on state of others.
      }
    procedure UpdateColour;
      {Updates colour displayed on test button.
      }
  public
    constructor CreateEx(AOwner: TComponent; Component: TPJColourPopupMenu);
      {Extended constructor. Records a reference to the component being edited.
        @param AOwner [in] Reference to owning component.
        @param Component [in] Reference to component being edited.
      }
    constructor Create(AOwner: TComponent); override;
      {Override of standard contrcutor that reaises exception: it is not
      permitted to construct this form in this manner.
        @param AOwner [in] Not used.
      }
  end;


procedure Register;
  {Registers the component, property editors and component editor with Delphi.
  }


implementation


uses
  // Delphi
  SysUtils, Windows, Menus, Graphics;

{$R *.DFM}


procedure Register;
  {Registers the component, property editors and component editor with Delphi.
  }
begin
  // Register the component
  RegisterComponents('DelphiDabbler', [TPJColourPopupMenu]);
  // Register special menu items do-nothing editor
  RegisterPropertyEditor(
    TypeInfo(TMenuItem),          // editor works with TMenuItem properties
    TPJColourPopupMenu,           // .. only for props in this component
    'Items',                      // .. with this name
    TPJColourPopupMenuItemsPE);   // property editor class
  // Register special colour property editor for 16 colours used on menu
  RegisterPropertyEditor(
    TypeInfo(TColor),             // editor works with TColor properties
    TPJColourPopupMenu,           // .. only for props in this component
    'SelectedColour',             // .. with this name
    TPJ16ColourPE);               // property editor class
  // Register component editor
  RegisterComponentEditor(TPJColourPopupMenu, TPJColourPopupMenuCE);
end;


{ TPJColourPopupMenuItemsPE }

resourcestring
  // String that appears in object inspector
  sNotAccessible = '(Not accessible)';

function TPJColourPopupMenuItemsPE.GetAttributes: TPropertyAttributes;
  {Tell object inspector that this is a read only value and can't be changed.
    @return Always returns [paReadOnly].
  }
begin
  Result := [paReadOnly];
end;

function TPJColourPopupMenuItemsPE.GetValue: string;
  {Causes message to be displayed in object inspector informing that value
  is not editable.
    @return Always returns '(not accessible)'.
  }
begin
  Result := sNotAccessible;
end;


{ TPJ16ColourPE }

function TPJ16ColourPE.GetAttributes: TPropertyAttributes;
  {Called by object inspector to determine what controls to display for a
  property.
    @return Values that inform object inspector that a list of read only values
      should be displayed in a drop down list.
  }
begin
  Result := [paValueList, paReadOnly];
end;

function TPJ16ColourPE.GetValue: string;
  {Returns the symbolic name for the currently selected value. Here we map
  current property value to constant names.
    @return Colour name that describes current property value.
  }
begin
  // Get string representation of colour values
  Result := ColorToString(GetOrdValue);
end;

procedure TPJ16ColourPE.GetValues(Proc: TGetStrProc);
  {Called when a drop down list is activated in object inspector. Provides
  names of all 16 available colour names for display in drop-down list.
    @param Proc [in] Procedure to call once for each item in list.
  }
const
  // List of supported colours to be displayed in property editor:
  // must contain same values as mapping of colours to names in component unit
  cColourList: array[0..15] of TColor = (
    clBlack, clMaroon, clGreen, clOlive, clNavy, clPurple, clTeal, clGray,
    clSilver, clRed, clLime, clYellow, clBlue, clFuchsia, clAqua, clWhite
  );
var
  Idx: Integer; // loops through all supported colours
begin
  for Idx := Low(cColourList) to High(cColourList) do
    Proc(ColorToString(cColourList[Idx]));
end;

procedure TPJ16ColourPE.SetValue(const Value: string);
  {Calculates numeric value represented by a symbolic value. In this case we map
  a colour constant to its ordinal value.
    @param Value [in] String value to be converted.
  }
begin
  // Get colour value from string representation
  SetOrdValue(StringToColor(Value));
end;


{ TPJColourPopupMenuCE }

resourcestring
  // Component editor pop-up menu text
  sCEMenuText = 'Colour menu &designer...';

procedure TPJColourPopupMenuCE.ExecuteEditor;
  {Displays editor dialogue box and performs required updates if user OKs.
  }
var
  Dlg: TFmPJColourPopupMenuCE;  // editor dlg box instance
begin
  // Create dialogue box, passing reference to component
  Dlg := TFmPJColourPopupMenuCE.CreateEx(
    Application,
    Component as TPJColourPopupMenu
  );
  try
    // Display dlg box
    if Dlg.ShowModal = mrOK then
      // User OK'd: tell designer things have changed
      Designer.Modified;
  finally
    Dlg.Free;
  end;
end;

procedure TPJColourPopupMenuCE.ExecuteVerb(Index: Integer);
  {Called when user chooses our new edit menu option. Displays our editor.
    @param Index [in] Must be 0 to display editor.
  }
begin
  if Index = 0 then
    ExecuteEditor;
end;

function TPJColourPopupMenuCE.GetVerb(Index: Integer): string;
  {Returns caption of menu item added to component's pop-up menu.
    @return Required caption for colour menu designer.
  }
begin
  Result := sCEMenuText;
end;

function TPJColourPopupMenuCE.GetVerbCount: Integer;
  {Returns number of items added to component's pop-up menu.
    @return Always returns 1 since we add 1 menu item.
  }
begin
  Result := 1;
end;


{ TFmPJColourPopupMenuCE }

resourcestring
  // Error message
  sCreateError = 'Must use CreateEx constructor for TFmPJColourPopupMenuCE';

procedure TFmPJColourPopupMenuCE.btnHelpClick(Sender: TObject);
  {Help button click handler. Display required help page.
    @param Sender [in] Not used.
  }
var
  Keyword: string;  // Required topic K Keyword
begin
  Keyword := 'Colour menu designer';  // not localisable
  Application.HelpCommand(HELP_KEY, Cardinal(PChar(Keyword)));
end;

procedure TFmPJColourPopupMenuCE.btnOKClick(Sender: TObject);
  {OK button click event handler. Updates component's properties according to
  changes.
    @param Sender [in] Not used.
  }
begin
  fComponent.SelectedColour := mnuTest.SelectedColour;
  fComponent.DisplayStyle := mnuTest.DisplayStyle;
  fComponent.CheckSelectedColour := mnuTest.CheckSelectedColour;
  fComponent.MenuColumns := mnuTest.MenuColumns;
  fComponent.BitmapHeight := mnuTest.BitmapHeight;
  fComponent.BitmapWidth := mnuTest.BitmapWidth;
end;

procedure TFmPJColourPopupMenuCE.btnTestClick(Sender: TObject);
  {Test menu button click event handler. Pops up the menu.
    @param Sender [in] Not used.
  }
var
  PopupPos: TPoint; // where menu is to pop-up
begin
  PopupPos := ClientToScreen(Point(btnTest.Left, btnTest.Top + btnTest.Height));
  mnuTest.Popup(PopupPos.X, PopupPos.Y);
end;

procedure TFmPJColourPopupMenuCE.chkCheckColourClick(Sender: TObject);
  {Click event handler for check selected colour check box. Updates popup menu's
  CheckSelectedColour property per state of check box.
    @param Sender [in] Not used.
  }
begin
  mnuTest.CheckSelectedColour := chkCheckColour.Checked;
end;

procedure TFmPJColourPopupMenuCE.cmbDisplayStyleChange(Sender: TObject);
  {Display style drop down change event handler. Updates popup menu's
  DisplayStyle property according to value selected in drop down list. Also
  updates state of controls that depend on value of this property.
    @param Sender [in] Not used.
  }
begin
  mnuTest.DisplayStyle := TPJColourMenuDisplayStyle(cmbDisplayStyle.ItemIndex);
  UpdateControls;
end;

procedure TFmPJColourPopupMenuCE.cmbMenuColsChange(Sender: TObject);
  {Menu columns drop down change event handler. Updates popup menu's MenuCols
  property per state of check box.
    @param Sender [in] Not used.
  }
begin
  mnuTest.MenuColumns := TPJColourMenuColumns(cmbMenuCols.ItemIndex);
end;

constructor TFmPJColourPopupMenuCE.Create(AOwner: TComponent);
  {Override of standard contrcutor that reaises exception: it is not permitted
  to construct this form in this manner.
    @param AOwner [in] Not used.
  }
begin
  raise Exception.Create(sCreateError);
end;

constructor TFmPJColourPopupMenuCE.CreateEx(AOwner: TComponent;
  Component: TPJColourPopupMenu);
  {Extended constructor. Records a reference to the component being edited.
    @param AOwner [in] Reference to owning component.
    @param Component [in] Reference to component being edited.
  }
begin
  // Record reference to component being edited
  fComponent := Component;
  inherited Create(AOwner);
end;

procedure TFmPJColourPopupMenuCE.FormCreate(Sender: TObject);
  {Form creation event handler. Set form's controls to reflect properties of
  component we're editing.
    @param Sender [in] Not used.
  }
begin
  // Create copy of colour menu component
  // we do this to avoid error reported when installing component
  mnuTest := TPJColourPopupMenu.Create(Self);
  // Copy relevant properties of component to be edited to private component
  mnuTest.SelectedColour := fComponent.SelectedColour;
  mnuTest.DisplayStyle := fComponent.DisplayStyle;
  mnuTest.CheckSelectedColour := fComponent.CheckSelectedColour;
  mnuTest.MenuColumns := fComponent.MenuColumns;
  mnuTest.BitmapHeight := fComponent.BitmapHeight;
  mnuTest.BitmapWidth := fComponent.BitmapWidth;
  mnuTest.OnSelectColour := mnuTestSelectColour;
  // Update form's controls to reflect required properties
  cmbDisplayStyle.ItemIndex := Ord(fComponent.DisplayStyle);
  chkCheckColour.Checked := fComponent.CheckSelectedColour;
  cmbMenuCols.ItemIndex := Ord(fComponent.MenuColumns);
  udBmpHeight.Position := fComponent.BitmapHeight;
  udBmpWidth.Position := fComponent.BitmapWidth;
  UpdateControls;
  UpdateColour;
end;

procedure TFmPJColourPopupMenuCE.FormKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
  {Checks for F1 key and calls help if detected.
    @param Key [in] Code of key pressed.
    @param Shift [in] State of shift keys.
  }
begin
  if (Key = VK_F1) and (Shift = []) then
    btnHelp.Click;
end;

procedure TFmPJColourPopupMenuCE.mnuTestSelectColour(Sender: TObject);
  {Colour choice event handler for test popup menu. Updates colour displayed on
  test button according to current colour menu selection.
    @param Sender [in] Not used.
  }
begin
  UpdateColour;
end;

procedure TFmPJColourPopupMenuCE.udBmpHeightClick(Sender: TObject;
  Button: TUDBtnType);
  {Update test menu's BitmapHeight property according to current value of
  up-down control.
    @param Sender [in] Not used.
    @param Button [in] Not used.
  }
begin
  mnuTest.BitmapHeight := udBmpHeight.Position;
end;

procedure TFmPJColourPopupMenuCE.udBmpWidthClick(Sender: TObject;
  Button: TUDBtnType);
  {Update test menu's BitmapWidth property according to current value of
  up-down control.
    @param Sender [in] Not used.
    @param Button [in] Not used.
  }
begin
  mnuTest.BitmapWidth := udBmpWidth.Position;
end;

procedure TFmPJColourPopupMenuCE.UpdateColour;
  {Updates colour displayed on test button.
  }
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
    // Paint border to be taken as transparent: so not bmp colour
    if BmpColour <> clWhite then
      Bmp.Canvas.Brush.Color := clWhite
    else
      Bmp.Canvas.Brush.Color := clBlack;
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

procedure TFmPJColourPopupMenuCE.UpdateControls;
  {Updates enabled property of controls that depend on state of others.
  }
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
end;

end.


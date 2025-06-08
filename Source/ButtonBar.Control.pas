unit ButtonBar.Control;

{.$DEFINE USE_ITEM_CLICK_WM_MESSAGES}

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, System.Types, System.UITypes, Vcl.ActnList,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Controls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.ImgList, Vcl.Menus
{$IFDEF ALPHASKINS}
  , acPageScroller, sCommonData, sConst, sPanel, sSkinProps, sSpeedButton
{$ENDIF};

{$IFDEF USE_ITEM_CLICK_WM_MESSAGES}
const
  WM_BUTTONBAR_ITEM_CLICK = WM_USER + 123;
{$ENDIF}

type
  TButtonBarPageScroller = class({$IFDEF ALPHASKINS}TsPageScroller{$ELSE}TPageScroller{$ENDIF});
  TButtonBarPanel = class({$IFDEF ALPHASKINS}TsPanel{$ELSE}TPanel{$ENDIF});
  TButtonBarSpeedButton = class({$IFDEF ALPHASKINS}TsSpeedButton{$ELSE}TSpeedButton{$ENDIF});

  TButtonBarItemCounterColors = class(TPersistent)
  strict private
    FOther: TColor;
    FZero: TColor;
  public
    constructor Create;
    procedure Assign(ASource: TPersistent); override;
  published
    property Other: TColor read FOther write FOther default TColors.Green;
    property Zero: TColor read FZero write FZero default TColors.Black;
  end;

  TButtonBarItemCounter = class(TPersistent)
  strict private
    FColors: TButtonBarItemCounterColors;
    FFontSize: Integer;
    FOnChange: TNotifyEvent;
    FValue: Integer;
    FVisible: Boolean;
    procedure DoChange(Sender: TObject);
    procedure SetValue(const AValue: Integer);
    procedure SetVisible(const AValue: Boolean);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
  published
    property Colors: TButtonBarItemCounterColors read FColors write FColors;
    property FontSize: Integer read FFontSize write FFontSize default 8;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Value: Integer read FValue write SetValue default 0;
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

  TButtonBarControlStyle = (csButton, csDropdown, csHorizontalDivider, csVerticalDivider);

  TButtonBarControl = class(TButtonBarSpeedButton)
  private
    FArrowColor: TColor;
    FCounter: TButtonBarItemCounter;
    FDropdownButtonVisible: Boolean;
    FDropdownMenu: TPopupMenu;
    FIgnoreFocus: Boolean;
    FInvisible: Boolean;
    FMainControl: TButtonBarControl;
    FOnBeforeMenuDropdown: TNotifyEvent;
    FOrientation: TPageScrollerOrientation;
    FSkipDropdown: Boolean;
    FStyle: TButtonBarControlStyle;
    function GetArrowColor: TColor;
    function IsMouseOverControl: Boolean;
{$IF NOT DEFINED(ALPHASKINS)}
    function ScaleInt(const ANumber: Integer): Integer; inline;
{$ENDIF}
    procedure SetArrowColor(const AValue: TColor);
    procedure SetDropdownMenu(const AValue: TPopupMenu);
    procedure SetStyle(const AValue: TButtonBarControlStyle);
  protected
    procedure MouseDown(AButton: TMouseButton; AShift: TShiftState; X, Y: Integer); override;
{$IF NOT DEFINED(ALPHASKINS)}
    procedure Paint; override;
{$ENDIF}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ArrowColor: TColor read GetArrowColor write SetArrowColor default TColors.SysWindowText;
    property Counter: TButtonBarItemCounter read FCounter write FCounter;
    property DropdownButtonVisible: Boolean read FDropdownButtonVisible write FDropdownButtonVisible;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property IgnoreFocus: Boolean read FIgnoreFocus write FIgnoreFocus default False;
    property Invisible: Boolean read FInvisible write FInvisible default False;
    property MainControl: TButtonBarControl read FMainControl write FMainControl;
    property OnBeforeMenuDropdown: TNotifyEvent read FOnBeforeMenuDropdown write FOnBeforeMenuDropdown;
    property Orientation: TPageScrollerOrientation read FOrientation write FOrientation;
    property Style: TButtonBarControlStyle read FStyle write SetStyle default csButton;
  end;

  TButtonBarDefaults = class(TPersistent)
  strict private
    FButtonSize: Integer;
    FDividerMargin: Integer;
    FDividerSize: Integer;
    FOnChange: TNotifyEvent;
    FTextMargin: Integer;
{$IF DEFINED(ALPHASKINS)}
    FTextOffset: Integer;
{$ENDIF}
    procedure DoChange(Sender: TObject);
    procedure SetButtonSize(const AValue: Integer);
    procedure SetDividerMargin(const AValue: Integer);
    procedure SetDividerSize(const AValue: Integer);
    procedure SetTextMargin(const AValue: Integer);
{$IF DEFINED(ALPHASKINS)}
    procedure SetTextOffset(const AValue: Integer);
{$ENDIF}
  public
    constructor Create;
    procedure Assign(ASource: TPersistent); override;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property ButtonSize: Integer read FButtonSize write SetButtonSize default 38;
    property DividerMargin: Integer read FDividerMargin write SetDividerMargin default 5;
    property DividerSize: Integer read FDividerSize write SetDividerSize default 8;
    property TextMargin: Integer read FTextMargin write SetTextMargin default 6;
{$IF DEFINED(ALPHASKINS)}
    property TextOffset: Integer read FTextOffset write SetTextOffset default 0;
{$ENDIF}
  end;

  TButtonBarItemDropdown = class(TPersistent)
  strict private
    FButtonWidth: Integer;
    FHint: string;
    FOnChange: TNotifyEvent;
    FVisible: Boolean;
    procedure DoChange(Sender: TObject);
    procedure SetVisible(const AValue: Boolean);
  public
    constructor Create;
    procedure Assign(ASource: TPersistent); override;
  published
    property ButtonWidth: Integer read FButtonWidth write FButtonWidth default 16;
    property Hint: string read FHint write FHint;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

  TButtonBarCollectionItem = class;

  TButtonBarItemActionLink = class(TActionLink)
  protected
    FClient: TButtonBarCollectionItem;
    function IsCaptionLinked: Boolean; override;
    function IsCheckedLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsGroupIndexLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
    procedure AssignClient(AClient: TObject); override;
    procedure SetCaption(const AValue: string); override;
    procedure SetChecked(AValue: Boolean); override;
    procedure SetEnabled(AValue: Boolean); override;
    procedure SetGroupIndex(AValue: Integer); override;
    procedure SetHint(const AValue: string); override;
    procedure SetImageIndex(AValue: Integer); override;
    procedure SetOnExecute(AValue: TNotifyEvent); override;
    procedure SetVisible(AValue: Boolean); override;
  end;

  TButtonBarItemActionLinkClass = class of TButtonBarItemActionLink;

  TSTCounterChangedEvent = procedure(Sender: TButtonBarCollectionItem; const ACounter: Integer; var AImageIndex: System.UITypes.TImageIndex) of object;

  TButtonBarItemStyle = (stButton, stDivider);

  TButtonBarCollectionItem = class(TCollectionItem)
  strict private
    FActionLink: TButtonBarItemActionLink;
    FAllowAllUp: Boolean;
    FButton: TButtonBarControl;
    FButtonPanel: TButtonBarPanel;
    FCaption: string;
    FChecked: Boolean;
    FCounter: TButtonBarItemCounter;
    FCursor: TCursor;
    FDown: Boolean;
    FDropdown: TButtonBarItemDropdown;
    FDropdownButton: TButtonBarControl;
    FDropdownMenu: TPopupMenu;
    FEnabled: Boolean;
    FFlat: Boolean;
    FGroupIndex: Integer;
    FHint: string;
    FImageIndex: System.UITypes.TImageIndex;
    FLayout: TButtonLayout;
    FName: string;
    FOnClick: TNotifyEvent;
    FOnCounterChanged: TSTCounterChangedEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseMove: TMouseMoveEvent;
    FStyle: TButtonBarItemStyle;
    FTag: Integer;
    FVisible: Boolean;
{$IFDEF ALPHASKINS}
    FBlend: Integer;
    FDisabledGlyphKind: TsDisabledGlyphKind;
    FReflected: Boolean;
    FTextOffset: Integer;
{$ENDIF}
    function CanUpdateButton: Boolean;
    function GetAction: TBasicAction;
    procedure DoActionChange(Sender: TObject);
    procedure DoCounterChange(Sender: TObject);
    procedure DoDropdownChange(Sender: TObject);
    procedure SetAction(const AValue: TBasicAction);
    procedure SetAllowAllUp(const AValue: Boolean);
    procedure SetCaption(const AValue: string);
    procedure SetChecked(const AValue: Boolean);
    procedure SetDown(const AValue: Boolean);
    procedure SetEnabled(const AValue: Boolean);
    procedure SetFlat(const AValue: Boolean);
    procedure SetGroupIndex(const AValue: Integer);
    procedure SetHint(const AValue: string);
    procedure SetImageIndex(const AValue: System.UITypes.TImageIndex);
    procedure SetLayout(const AValue: TButtonLayout);
    procedure SetName(const AValue: string);
    procedure SetStyle(const AValue: TButtonBarItemStyle);
    procedure SetVisible(const AValue: Boolean);
    procedure UpdateButton;
    procedure UpdateButtonPositions(const ACheckDesigning: Boolean = True);
{$IFDEF ALPHASKINS}
    procedure SetBlend(const AValue: Integer);
    procedure SetDisabledGlyphKind(const AValue: TsDisabledGlyphKind);
    procedure SetReflected(const AValue: Boolean);
    procedure SetTextOffset(const AValue: Integer);
{$ENDIF}
  protected
    function GetActionLinkClass: TButtonBarItemActionLinkClass;
    function GetDisplayName: string; override;
    procedure ActionChange(Sender: TObject; const ACheckDefaults: Boolean); dynamic;
    procedure SetIndex(AValue: Integer); override;
    property ActionLink: TButtonBarItemActionLink read FActionLink write FActionLink;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    function FormatCaption(const ACaption: string): string;
    procedure Assign(ASource: TPersistent); override;
    procedure InitiateAction; virtual;
    property Button: TButtonBarControl read FButton write FButton;
    property ButtonPanel: TButtonBarPanel read FButtonPanel write FButtonPanel;
    property DropdownButton: TButtonBarControl read FDropdownButton write FDropdownButton;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property Caption: string read FCaption write SetCaption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Counter: TButtonBarItemCounter read FCounter write FCounter;
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property Down: Boolean read FDown write SetDown default False;
    property Dropdown: TButtonBarItemDropdown read FDropdown write FDropdown;
    property DropdownMenu: TPopupMenu read FDropdownMenu write FDropdownMenu;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Flat: Boolean read FFlat write SetFlat default True;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Hint: string read FHint write SetHint;
    property ImageIndex: System.UITypes.TImageIndex read FImageIndex write SetImageIndex default -1;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphTop;
    property Name: string read FName write SetName;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnCounterChanged: TSTCounterChangedEvent read FOnCounterChanged write FOnCounterChanged;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property Style: TButtonBarItemStyle read FStyle write SetStyle default stButton;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
{$IFDEF ALPHASKINS}
    property Blend: Integer read FBlend write SetBlend default 0;
    property DisabledGlyphKind: TsDisabledGlyphKind read FDisabledGlyphKind write SetDisabledGlyphKind default [];
    property Reflected: Boolean read FReflected write SetReflected default False;
    property TextOffset: Integer read FTextOffset write SetTextOffset default 0;
{$ENDIF}
  end;

  TButtonBarCollection = class(TOwnedCollection)
  protected
    function GetItem(const AIndex: Integer): TButtonBarCollectionItem;
    procedure SetItem(const AIndex: Integer; const AValue: TButtonBarCollectionItem);
  public
    function Add: TButtonBarCollectionItem;
    function DoesNameExist(const AName: string): Boolean;
    function Insert(const AIndex: Integer): TButtonBarCollectionItem;
    procedure EndUpdate; override;
    property Item[const AIndex: Integer]: TButtonBarCollectionItem read GetItem write SetItem;
  end;

  TButtonBarPosition = (poHorizontal, poVertical);
  TButtonBarOption = (opFormatCaptions, opIgnoreFocus, opSetFocusOnButtonClick, opShowCaptions, opShowHints);
  TButtonBarOptions = set of TButtonBarOption;

  TButtonBar = class(TButtonBarPageScroller)
  private
    FAutoSize: Boolean;
    FButtonBarPanel: TButtonBarPanel;
    FCanvas: TCanvas;
{$IF CompilerVersion < 35}
    FDrawLockCount: Cardinal;
{$ENDIF}
    FDefaults: TButtonBarDefaults;
    FHeight: Integer;
    FImages: TCustomImageList;
    FItems: TButtonBarCollection;
    FOnBeforeMenuDropdown: TNotifyEvent;
    FOptions: TButtonBarOptions;
    FWidth: Integer;
{$IFDEF ALPHASKINS}
    class constructor Create;
    class destructor Destroy;
{$ENDIF}
    function GetControlByName(const AName: string): TControl;
    function GetItem(const AIndex: Integer): TButtonBarCollectionItem;
    function GetItemByName(const AName: string): TButtonBarCollectionItem;
    function InUpdateBlock: Boolean;
{$IF NOT DEFINED(ALPHASKINS)}
    function ScaleInt(const ANumber: Integer): Integer; inline;
{$ENDIF}
    function ShowNotItemsFound: Boolean;
    procedure AutoSizeButtonBar;
    procedure CMRecreateWnd(var AMessage: TMessage); message CM_RECREATEWND;
    procedure CMVisibleChanged(var AMessage: TMessage); message CM_VISIBLECHANGED;
    procedure CreateButtonBarPanel;
    procedure CreateDropdownButton(var AItem: TButtonBarCollectionItem);
    procedure DoDefaultChange(ASender: TObject);
    procedure DummyClickEvent(ASender: TObject);
    procedure LockPainting;
    procedure SetButtonBarPanelSize;
    procedure SetImages(const AValue: TCustomImageList);
    procedure SetItems(const AValue: TButtonBarCollection);
    procedure SetOptions(const AValue: TButtonBarOptions);
    procedure UnlockPainting;
    procedure UpdateButtonPositions(const ACheckDesigning: Boolean = False);
    procedure UpdateButtons(const AIsLast: Boolean = False);
{$IFDEF USE_ITEM_CLICK_WM_MESSAGES}
    procedure OnButtonClickMessage(var AMessage: TMessage); message WM_BUTTONBAR_ITEM_CLICK;
{$ENDIF}
    procedure WMSize(var AMessage: TWMSize); message WM_SIZE;
  protected
    function FormatCaption(const ACaption: string): string; virtual;
    procedure SetAutoSize(AValue: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function FindItemByName(const AName: string): TButtonBarCollectionItem;
    procedure Assign(ASource: TPersistent); override;
    procedure Clear;
    procedure CreateButton(var AItem: TButtonBarCollectionItem);
    procedure HideButtons(const ANames: array of string);
    procedure Loaded; override;
    procedure Paint; {$IFDEF ALPHASKINS}override;{$ELSE}virtual;{$ENDIF}
    procedure PaintWindow(DC: HDC); override;
    procedure UpdateParentBackground;
    property ControlByName[const AName: string]: TControl read GetControlByName;
    property ItemByName[const AName: string]: TButtonBarCollectionItem read GetItemByName;
    property Item[const AIndex: Integer]: TButtonBarCollectionItem read GetItem;
  published
    property Align default alTop;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Defaults: TButtonBarDefaults read FDefaults write FDefaults;
    property DoubleBuffered default True;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TButtonBarCollection read FItems write SetItems;
    property OnBeforeMenuDropdown: TNotifyEvent read FOnBeforeMenuDropdown write FOnBeforeMenuDropdown;
    property Options: TButtonBarOptions read FOptions write SetOptions default [opShowHints];
    property ParentBackground default True;
    property ParentDoubleBuffered default False;
    property ParentFont default False;
  end;

implementation

uses
  System.RTLConsts, System.StrUtils, Vcl.Themes;

type
  EButtonBarException = class(Exception);

resourcestring
  ButtonBarItemDividerChar = '-';
  ButtonBarItemUnnamed = '(unnamed)';
  ButtonBarNoItemFoundWithName = 'No item found with name "%s"';
  ButtonBarNoItemsFound = ' No items found ';

{ TButtonBarControl }

constructor TButtonBarControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCounter := TButtonBarItemCounter.Create;

  FArrowColor := TColors.SysWindowText;
  FIgnoreFocus := False;
  FInvisible := False;
  FStyle := csButton;

{$IFDEF ALPHASKINS}
  SkinData.SkinSection := s_ToolButton;
  DisabledGlyphKind := [];
  WordWrap := False;
{$ENDIF}
end;

{$IF NOT DEFINED(ALPHASKINS)}
function TButtonBarControl.ScaleInt(const ANumber: Integer): Integer;
begin
  Result := ANumber * CurrentPPI div 96; // MulDiv is not correct for arrow painting
end;
{$ENDIF}

destructor TButtonBarControl.Destroy;
begin
  FreeAndNil(FCounter);

  inherited Destroy;
end;

function TButtonBarControl.GetArrowColor: TColor;
begin
  if Enabled then
    Result := FArrowColor
  else
    Result := clGray;
end;

procedure TButtonBarControl.SetArrowColor(const AValue: TColor);
begin
  if FArrowColor <> AValue then
  begin
    FArrowColor := AValue;

    Repaint;
  end;
end;

procedure TButtonBarControl.SetStyle(const AValue: TButtonBarControlStyle);
begin
  if FStyle <> AValue then
  begin
    FStyle := AValue;

    Repaint;
  end;
end;

function TButtonBarControl.IsMouseOverControl: Boolean;
var
  LPoint: TPoint;
begin
  try
    LPoint := ScreenToClient(Mouse.CursorPos);
  except
    LPoint := Point(0, 0);
  end;

  Result := PtInRect(ClientRect, LPoint);
end;

procedure TButtonBarControl.MouseDown(AButton: TMouseButton; AShift: TShiftState; X, Y: Integer);
var
  LPoint: TPoint;
  LPanel: TButtonBarPanel;
  LControl: TButtonBarControl;
  LLeft: Integer;
begin
  if csDesigning in ComponentState then
    Exit;

  if not IgnoreFocus then
  begin
    LPanel := TButtonBarPanel(Owner);

    if LPanel.CanFocus then
      LPanel.SetFocus;
  end;

  if Enabled and (AButton = mbLeft) and Assigned(FDropdownMenu) and (FDropdownButtonVisible or not Assigned(OnClick)) then
  begin
    if not FSkipDropdown then
    begin
      FSkipDropdown := True;

      DropdownMenu.PopupComponent := Self;

      if Assigned(FMainControl) then
        LControl := FMainControl
      else
        LControl := Self;

      if (Orientation = soVertical) and (CurrentPPI <> 96) then
        LLeft := LControl.Margins.Left
      else
        LLeft := 0;

      LPoint := LControl.ClientToScreen(Point(LLeft, LControl.Height));

      if Assigned(FOnBeforeMenuDropdown) then
        FOnBeforeMenuDropdown(Self);

      DropdownMenu.Popup(LPoint.X, LPoint.Y);

{$IFDEF ALPHASKINS}
      SkinData.FMouseAbove := False;
      SkinData.BGChanged := True;
      Repaint;
{$ENDIF}

      if not IsMouseOverControl then
        FSkipDropdown := False;
    end
    else
      FSkipDropdown := False;
  end
  else
    inherited;
end;

{$IF NOT DEFINED(ALPHASKINS)}
procedure TButtonBarControl.Paint;
var
  LLeft, LTop: Integer;
  LRect: TRect;
  LCanvas: TCanvas;
  LArrowHeight: Integer;
  LArrowWidth: Integer;

  procedure DrawArrow(const X, Y: Integer);
  var
    LArrowPoints: array [0..2] of TPoint;
  begin
    LArrowPoints[0] := Point(X, Y);
    LArrowPoints[1] := Point(X + LArrowWidth - 1, Y); // -1 because zero origin
    LArrowPoints[2] := Point(X + (LArrowWidth - 1) div 2, Y + LArrowHeight - 1);

    LCanvas.Pen.Color := ArrowColor;
    LCanvas.Brush.Color := ArrowColor;
    LCanvas.Brush.Style := bsSolid;
    LCanvas.Polygon(LArrowPoints);
  end;

begin
  LCanvas := TCanvas.Create;
  try
    LCanvas.Handle := Canvas.Handle;

    case FStyle of
      csHorizontalDivider:
        begin
          LRect := ClientRect;

          LRect.Top := LRect.Height div 2 - 1;
          LRect.Left := LRect.Left + Margin;
          LRect.Right := LRect.Right - Margin;

          DrawEdge(LCanvas.Handle, LRect, BDR_SUNKENOUTER, BF_TOP);
        end;
      csVerticalDivider:
        begin
          LRect := ClientRect;

          LRect.Left := LRect.Width div 2;
          LRect.Top := LRect.Top + Margin;
          LRect.Bottom := LRect.Bottom - Margin;

          DrawEdge(LCanvas.Handle, LRect, BDR_SUNKENOUTER, BF_LEFT);
        end;
      csDropdown:
        begin
          inherited;

          if Assigned(FDropdownMenu) and FDropdownButtonVisible then
          begin
            LArrowHeight := ScaleInt(5);
            LArrowWidth := ScaleInt(9);

            with ClientRect do
            begin
              LLeft := Left + (Width - LArrowWidth) div 2 + 1;
              LTop := Top + (Height - LArrowHeight) div 2;
            end;

            DrawArrow(LLeft, LTop);
          end;
        end
      else
        inherited;

      if FCounter.Visible then
      begin
        LCanvas.Font.Size := FCounter.FontSize;
        LCanvas.Brush.Style := bsClear;

        if not Enabled then
          LCanvas.Font.Color := clGray
        else
        if FCounter.Value = 0 then
          LCanvas.Font.Color := FCounter.Colors.Zero
        else
          LCanvas.Font.Color := FCounter.Colors.Other;

        LCanvas.TextOut(2, 0, IntToStr(FCounter.Value));
      end;

      if Invisible then
      begin
        LCanvas.Brush.Color := TColors.Gray;
        LCanvas.Brush.Style := bsFDiagonal;
        LCanvas.Pen.Color := TColors.Gray;
        LCanvas.Rectangle(ClientRect);
      end;

      if Assigned(FDropdownMenu) and FDropdownButtonVisible then
      begin
        LArrowHeight := ScaleInt(5);
        LArrowWidth := ScaleInt(9);

        with ClientRect do
        begin
          if UseRightToLeftAlignment then
             LLeft := ScaleInt(8)
           else
             LLeft := Right - ScaleInt(12);

          LTop := Top + (Height - LArrowHeight) div 2;
        end;

        DrawArrow(LLeft, LTop);
      end;
    end;
  finally
    LCanvas.Handle := 0;
    LCanvas.Free;
  end;
end;
{$ENDIF}

procedure TButtonBarControl.SetDropdownMenu(const AValue: TPopupMenu);
begin
  if AValue <> FDropdownMenu then
  begin
    FDropdownMenu := AValue;

    if Assigned(AValue) then
      AValue.FreeNotification(Self);
  end;
end;

{ TButtonBarItemActionLink }

procedure TButtonBarItemActionLink.AssignClient(AClient: TObject);
begin
  FClient := TButtonBarCollectionItem(AClient);
end;

function TButtonBarItemActionLink.IsCaptionLinked: Boolean;
begin
  Result := inherited IsCaptionLinked and (Action is TCustomAction) and
    SameCaption(FClient.Caption, FClient.FormatCaption(TCustomAction(Action).Caption));
end;

function TButtonBarItemActionLink.IsCheckedLinked: Boolean;
begin
  Result := inherited IsCheckedLinked and (Action is TCustomAction) and
    (FClient.Checked = TCustomAction(Action).Checked);
end;

function TButtonBarItemActionLink.IsEnabledLinked: Boolean;
begin
  Result := inherited IsEnabledLinked and (Action is TCustomAction) and
    (FClient.Enabled = TCustomAction(Action).Enabled);
end;

function TButtonBarItemActionLink.IsGroupIndexLinked: Boolean;
begin
  Result := inherited IsGroupIndexLinked and (Action is TCustomAction) and
    (FClient.GroupIndex = TCustomAction(Action).GroupIndex);
end;

function TButtonBarItemActionLink.IsHintLinked: Boolean;
begin
  Result := inherited IsHintLinked and (Action is TCustomAction) and
    (FClient.Hint = TCustomAction(Action).Hint);
end;

function TButtonBarItemActionLink.IsImageIndexLinked: Boolean;
begin
  Result := inherited IsImageIndexLinked and (Action is TCustomAction) and
    (FClient.ImageIndex = TCustomAction(Action).ImageIndex);
end;

function TButtonBarItemActionLink.IsOnExecuteLinked: Boolean;
begin
  Result := inherited IsOnExecuteLinked and (@FClient.OnClick = @Action.OnExecute);
end;

function TButtonBarItemActionLink.IsVisibleLinked: Boolean;
begin
  Result := inherited IsVisibleLinked and (Action is TCustomAction) and
    (FClient.Visible = TCustomAction(Action).Visible);
end;

procedure TButtonBarItemActionLink.SetCaption(const AValue: string);
begin
  if IsCaptionLinked then
    FClient.Caption := AValue;
end;

procedure TButtonBarItemActionLink.SetChecked(AValue: Boolean);
begin
  if IsCheckedLinked then
    FClient.Checked := AValue;
end;

procedure TButtonBarItemActionLink.SetEnabled(AValue: Boolean);
begin
  if IsEnabledLinked then
    FClient.Enabled := AValue;
end;

procedure TButtonBarItemActionLink.SetGroupIndex(AValue: Integer);
begin
  if IsGroupIndexLinked then
    FClient.GroupIndex := AValue;
end;

procedure TButtonBarItemActionLink.SetHint(const AValue: string);
begin
  if IsHintLinked then
    FClient.Hint := AValue;
end;

procedure TButtonBarItemActionLink.SetImageIndex(AValue: Integer);
begin
  if IsImageIndexLinked then
    FClient.ImageIndex := AValue;
end;

procedure TButtonBarItemActionLink.SetOnExecute(AValue: TNotifyEvent);
begin
  if IsOnExecuteLinked then
    FClient.OnClick := AValue;
end;

procedure TButtonBarItemActionLink.SetVisible(AValue: Boolean);
begin
  if IsVisibleLinked then
    FClient.Visible := AValue;
end;

{ TButtonBarCounterColors }

constructor TButtonBarItemCounterColors.Create;
begin
  inherited;

  FOther := TColors.Green;
  FZero := TColors.Black;
end;

procedure TButtonBarItemCounterColors.Assign(ASource: TPersistent);
begin
  if Assigned(ASource) and (ASource is TButtonBarItemCounterColors) then
  with ASource as TButtonBarItemCounterColors do
  begin
    Self.FOther := FOther;
    Self.FZero := FZero;
  end
  else
    inherited Assign(ASource);
end;

{ TButtonBarCounter }

constructor TButtonBarItemCounter.Create;
begin
  inherited;

  FFontSize := 8;
  FValue := 0;
  FVisible := False;

  FColors := TButtonBarItemCounterColors.Create;
end;

destructor TButtonBarItemCounter.Destroy;
begin
  FreeAndNil(FColors);

  inherited;
end;

procedure TButtonBarItemCounter.Assign(ASource: TPersistent);
begin
  if Assigned(ASource) and (ASource is TButtonBarItemCounter) then
  with ASource as TButtonBarItemCounter do
  begin
    Self.FColors.Assign(FColors);
    Self.FFontSize := FFontSize;
    Self.FValue := FValue;
    Self.FVisible := FVisible;
    Self.DoChange(Self);
  end
  else
    inherited Assign(ASource);
end;

procedure TButtonBarItemCounter.DoChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Sender);
end;

procedure TButtonBarItemCounter.SetValue(const AValue: Integer);
begin
  if AValue <> FValue then
  begin
    FValue := AValue;
    DoChange(Self);
  end;
end;

procedure TButtonBarItemCounter.SetVisible(const AValue: Boolean);
begin
  if AValue <> FVisible then
  begin
    FVisible := AValue;
    DoChange(Self);
  end;
end;

{ TButtonBarDefaults }

constructor TButtonBarDefaults.Create;
begin
  inherited;

  FButtonSize := 38;
  FDividerMargin := 5;
  FDividerSize := 8;
  FTextMargin := 6;
{$IF DEFINED(ALPHASKINS)}
  FTextOffset := 0;
{$ENDIF}
end;

procedure TButtonBarDefaults.Assign(ASource: TPersistent);
begin
  if Assigned(ASource) and (ASource is TButtonBarDefaults) then
  with ASource as TButtonBarDefaults do
  begin
    Self.FButtonSize := FButtonSize;
    Self.FDividerMargin := FDividerMargin;
    Self.FDividerSize := FDividerSize;
    Self.FTextMargin := FTextMargin;
{$IF DEFINED(ALPHASKINS)}
    Self.FTextOffset := FTextOffset;
{$ENDIF}
    Self.DoChange(Self);
  end
  else
    inherited Assign(ASource);
end;

procedure TButtonBarDefaults.DoChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Sender);
end;

procedure TButtonBarDefaults.SetButtonSize(const AValue: Integer);
begin
  if AValue <> FButtonSize then
  begin
    FButtonSize := AValue;
    DoChange(Self);
  end;
end;

procedure TButtonBarDefaults.SetDividerMargin(const AValue: Integer);
begin
  if AValue <> FDividerMargin then
  begin
    FDividerMargin := AValue;
    DoChange(Self);
  end;
end;

procedure TButtonBarDefaults.SetDividerSize(const AValue: Integer);
begin
  if AValue <> FDividerSize then
  begin
    FDividerSize := AValue;
    DoChange(Self);
  end;
end;

procedure TButtonBarDefaults.SetTextMargin(const AValue: Integer);
begin
  if AValue <> FTextMargin then
  begin
    FTextMargin := AValue;
    DoChange(Self);
  end;
end;

{$IF DEFINED(ALPHASKINS)}
procedure TButtonBarDefaults.SetTextOffset(const AValue: Integer);
begin
  if AValue <> FTextOffset then
  begin
    FTextOffset := AValue;
    DoChange(Self);
  end;
end;
{$ENDIF}

{ TButtonBarDropdown }

constructor TButtonBarItemDropdown.Create;
begin
  inherited;

  FButtonWidth := 16;
  FHint := '';
  FVisible := False;
end;

procedure TButtonBarItemDropdown.Assign(ASource: TPersistent);
begin
  if Assigned(ASource) and (ASource is TButtonBarItemDropdown) then
  with ASource as TButtonBarItemDropdown do
  begin
    Self.FButtonWidth := FButtonWidth;
    Self.FHint := FHint;
    Self.FVisible := FVisible;
    Self.DoChange(Self);
  end
  else
    inherited Assign(ASource);
end;

procedure TButtonBarItemDropdown.DoChange(Sender: TObject);
begin
  if Assigned(FOnChange) then
    FOnChange(Sender);
end;

procedure TButtonBarItemDropdown.SetVisible(const AValue: Boolean);
begin
  if AValue <> FVisible then
  begin
    FVisible := AValue;
    DoChange(Self);
  end;
end;

{ TButtonBarCollectionItem }

constructor TButtonBarCollectionItem.Create(ACollection: TCollection);
begin
  inherited Create(ACollection);

  FAllowAllUp := False;
  FChecked := False;
  FCursor := crDefault;
  FDown := False;
  FEnabled := True;
  FFlat := True;
  FGroupIndex := 0;
  FImageIndex := -1;
  FLayout := blGlyphTop;
  FStyle := stButton;
  FTag := 0;
  FVisible := True;
{$IFDEF ALPHASKINS}
  FBlend := 0;
  FDisabledGlyphKind := [];
  FReflected := False;
  FTextOffset := 0;
{$ENDIF}

  FCounter := TButtonBarItemCounter.Create;
  FCounter.OnChange := DoCounterChange;

  FDropdown := TButtonBarItemDropdown.Create;
  FDropdown.OnChange := DoDropdownChange;
end;

destructor TButtonBarCollectionItem.Destroy;
begin
  if Assigned(FActionLink) then
    FreeAndNil(FActionLink);

  FreeAndNil(FCounter);
  FreeAndNil(FDropdown);

  if Assigned(FButton) then
    FreeAndNil(FButton);

  inherited Destroy;
end;

procedure TButtonBarCollectionItem.Assign(ASource: TPersistent);
begin
  if ASource is TButtonBarCollectionItem then
  with ASource as TButtonBarCollectionItem do
  begin
    Self.Action := Action;
    Self.FAllowAllUp := FAllowAllUp;
    Self.FCaption := FCaption;
    Self.FCounter.Assign(FCounter);
    Self.FCursor := FCursor;
    Self.FDown := FDown;
    Self.FDropdown.Assign(FDropdown);
    Self.FDropdownMenu := FDropdownMenu;
    Self.FEnabled := FEnabled;
    Self.FFlat := FFlat;
    Self.FGroupIndex := FGroupIndex;
    Self.FHint := FHint;
    Self.FImageIndex := FImageIndex;
    Self.FLayout := FLayout;
    Self.FName := FName;
    Self.FStyle := FStyle;
    Self.FTag := FTag;
    Self.FVisible := FVisible;
    Self.FOnClick := FOnClick;
    Self.FOnCounterChanged := FOnCounterChanged;
    Self.FOnMouseEnter := FOnMouseEnter;
    Self.FOnMouseLeave := FOnMouseLeave;
    Self.FOnMouseMove := FOnMouseMove;
{$IFDEF ALPHASKINS}
    Self.FBlend := FBlend;
    Self.FDisabledGlyphKind := FDisabledGlyphKind;
    Self.FReflected := FReflected;
    Self.FTextOffset := FTextOffset;
{$ENDIF}
  end
  else
    inherited Assign(ASource);
end;

procedure TButtonBarCollectionItem.InitiateAction;
begin
  if Assigned(FActionLink) then
    FActionLink.Update;
end;

procedure TButtonBarCollectionItem.SetAction(const AValue: TBasicAction);
begin
  if not Assigned(AValue) then
    FreeAndNil(FActionLink)
  else
  begin
    if not Assigned(FActionLink) then
      FActionLink := GetActionLinkClass.Create(Self);

    FActionLink.Action := AValue;
    FActionLink.OnChange := DoActionChange;

    ActionChange(AValue, csLoading in AValue.ComponentState);
  end;
end;

function TButtonBarCollectionItem.CanUpdateButton: Boolean;
begin
  Result := not Assigned(Action) or (csDesigning in TButtonBar(Collection.Owner).ComponentState);
end;

procedure TButtonBarCollectionItem.SetAllowAllUp(const AValue: Boolean);
begin
  if FAllowAllUp <> AValue then
  begin
    FAllowAllUp := AValue;

    UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetCaption(const AValue: string);
begin
  if FCaption <> AValue then
  begin
    FCaption := AValue;

    if CanUpdateButton then
      UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetChecked(const AValue: Boolean);
begin
  if FChecked <> AValue then
  begin
    FChecked := AValue;

    if CanUpdateButton then
      UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetDown(const AValue: Boolean);
begin
  if FDown <> AValue then
  begin
    FDown := AValue;

    UpdateButton;
  end;
end;

{$IFDEF ALPHASKINS}
procedure TButtonBarCollectionItem.SetBlend(const AValue: Integer);
begin
  if FBlend <> AValue then
  begin
    FBlend := AValue;

    UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetDisabledGlyphKind(const AValue: TsDisabledGlyphKind);
begin
  if FDisabledGlyphKind <> AValue then
  begin
    FDisabledGlyphKind := AValue;

    UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetReflected(const AValue: Boolean);
begin
  if FReflected <> AValue then
  begin
    FReflected := AValue;

    UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetTextOffset(const AValue: Integer);
begin
  if FTextOffset <> AValue then
  begin
    FTextOffset := AValue;

    UpdateButton;
  end;
end;
{$ENDIF}

procedure TButtonBarCollectionItem.SetEnabled(const AValue: Boolean);
begin
  if FEnabled <> AValue then
  begin
    FEnabled := AValue;

    if CanUpdateButton then
      UpdateButton;

    if Assigned(FDropdownButton) then
      FDropdownButton.Enabled := AValue;
  end;
end;

procedure TButtonBarCollectionItem.SetFlat(const AValue: Boolean);
begin
  if FFlat <> AValue then
  begin
    FFlat := AValue;

    UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetGroupIndex(const AValue: Integer);
begin
  if FGroupIndex <> AValue then
  begin
    FGroupIndex := AValue;

    if CanUpdateButton then
      UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetHint(const AValue: string);
begin
  if FHint <> AValue then
  begin
    FHint := AValue;

    if CanUpdateButton then
      UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetImageIndex(const AValue: System.UITypes.TImageIndex);
begin
  if FImageIndex <> AValue then
  begin
    FImageIndex := AValue;

    if CanUpdateButton then
      UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetLayout(const AValue: TButtonLayout);
begin
  if FLayout <> AValue then
  begin
    FLayout := AValue;

    UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetStyle(const AValue: TButtonBarItemStyle);
begin
  if FStyle <> AValue then
  begin
    FStyle := AValue;

    UpdateButton;
  end;
end;

procedure TButtonBarCollectionItem.SetVisible(const AValue: Boolean);
begin
  if FVisible <> AValue then
  begin
    FVisible := AValue;

    if CanUpdateButton then
      UpdateButton;

    if Assigned(FDropdownButton) then
      FDropdownButton.Visible := FDropdown.Visible and AValue;

    if Style = stButton then
      UpdateButtonPositions(False);
  end;
end;

function TButtonBarCollectionItem.GetAction: TBasicAction;
begin
  if Assigned(FActionLink) then
    Result := FActionLink.Action
  else
    Result := nil;
end;

function TButtonBarCollectionItem.FormatCaption(const ACaption: string): string;
var
  LButtonBar: TButtonBar;
begin
  Result := ACaption;

  LButtonBar := TButtonBar(Collection.Owner);

  if opFormatCaptions in LButtonBar.Options then
    Result := LButtonBar.FormatCaption(Result);
end;

procedure TButtonBarCollectionItem.UpdateButton;
var
  LButtonBar: TButtonBar;
begin
  LButtonBar := TButtonBar(Collection.Owner);

  LButtonBar.Assign(Self);

  if Assigned(FButton) then
    FButton.Invalidate;
end;

procedure TButtonBarCollectionItem.UpdateButtonPositions(const ACheckDesigning: Boolean = True);
var
  LButtonBar: TButtonBar;
begin
  LButtonBar := TButtonBar(Collection.Owner);
  LButtonBar.UpdateButtonPositions(ACheckDesigning);
end;

procedure TButtonBarCollectionItem.ActionChange(Sender: TObject; const ACheckDefaults: Boolean);
begin
  if Sender is TCustomAction then
  with TCustomAction(Sender) do
  begin
    if not ACheckDefaults or Self.Caption.IsEmpty then
      Self.Caption := Caption;

    if Self.Name.IsEmpty then
      Self.Name := StringReplace(Name, 'Action', '', []);

    if not ACheckDefaults or Self.Enabled then
      Self.Enabled := Enabled;

    if not ACheckDefaults or (Self.GroupIndex = 0) then
      Self.GroupIndex := GroupIndex;

    if not ACheckDefaults or (Self.ImageIndex = -1) then
      Self.ImageIndex := ImageIndex;

    if not ACheckDefaults or Self.Hint.IsEmpty then
      Self.Hint := Hint;

    if not ACheckDefaults or Self.Visible then
      Self.Visible := Visible;

    if not ACheckDefaults or not Assigned(@Self.OnClick) then
      Self.OnClick := OnExecute;
  end;
end;

procedure TButtonBarCollectionItem.SetIndex(AValue: Integer);
begin
  inherited SetIndex(AValue);

  UpdateButtonPositions;
end;

procedure TButtonBarCollectionItem.DoCounterChange(Sender: TObject);
var
  LImageIndex: System.UITypes.TImageIndex;
begin
  if Assigned(FOnCounterChanged) then
  begin
    LImageIndex := ImageIndex;
    FOnCounterChanged(Self, FCounter.Value, LImageIndex);
    ImageIndex := LImageIndex;
  end;

  UpdateButton;
end;

procedure TButtonBarCollectionItem.DoDropdownChange(Sender: TObject);
begin
  UpdateButton;
  UpdateButtonPositions(False);
end;

procedure TButtonBarCollectionItem.DoActionChange(Sender: TObject);
begin
  if Sender = Action then
    ActionChange(Sender, False);
end;

procedure TButtonBarCollectionItem.SetName(const AValue: string);
var
  LValue: string;
begin
  LValue := AValue.Trim;

  if LValue.IsEmpty then
    FName := ''
  else
  if (Style = stButton) and TButtonBarCollection(Collection).DoesNameExist(LValue) then
    raise EButtonBarException.CreateRes(@SDuplicateString)
  else
    FName := LValue
end;

function TButtonBarCollectionItem.GetDisplayName: string;
begin
  if FStyle = stDivider then
    Result := StringOfChar(ButtonBarItemDividerChar[1], 10)
  else
  if FName.IsEmpty then
    Result := ButtonBarItemUnnamed
  else
    Result := FName;
end;

function TButtonBarCollectionItem.GetActionLinkClass: TButtonBarItemActionLinkClass;
begin
  Result := TButtonBarItemActionLink;
end;

{ TButtonBarCollection }

function TButtonBarCollection.GetItem(const AIndex: Integer): TButtonBarCollectionItem;
begin
  Result := TButtonBarCollectionItem(inherited GetItem(AIndex));
end;

procedure TButtonBarCollection.SetItem(const AIndex: Integer; const AValue: TButtonBarCollectionItem);
begin
  inherited SetItem(AIndex, AValue);
end;

function TButtonBarCollection.DoesNameExist(const AName: string): Boolean;
var
  LIndex: Integer;
begin
  Result := True;

  for LIndex := 0 to Count - 1 do
  if CompareText(Item[LIndex].Name, AName) = 0 then
    Exit;

  Result := False;
end;

function TButtonBarCollection.Add: TButtonBarCollectionItem;
begin
  Result := TButtonBarCollectionItem(inherited Add);
end;

function TButtonBarCollection.Insert(const AIndex: Integer): TButtonBarCollectionItem;
begin
  Result := Add;
  Result.Index := AIndex;
end;

procedure TButtonBarCollection.EndUpdate;
begin
  inherited EndUpdate;

  if UpdateCount = 0 then
    if ([csLoading, csDestroying] * TButtonBar(Owner).ComponentState) = [] then
      TButtonBar(Owner).UpdateButtons;
end;

{ TButtonBar }

{$IFDEF ALPHASKINS}
class constructor TButtonBar.Create;
begin
  { No need for TPageScrollerStyleHook }
end;

class destructor TButtonBar.Destroy;
begin
  { No need for TPageScrollerStyleHook }
end;
{$ENDIF}

constructor TButtonBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAutoSize := False;
  Align := alTop;
  ControlState := ControlState + [csCustomPaint];
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csGestures];
  DoubleBuffered := True;
  Font.Size := 7;
  FOptions := [opShowHints];
  Height := 40;
  ParentColor := True;
  ParentBackground := True;
  ParentDoubleBuffered := False;
  ParentFont := False;

  FItems := TButtonBarCollection.Create(Self, TButtonBarCollectionItem);

  FDefaults := TButtonBarDefaults.Create;
  FDefaults.OnChange := DoDefaultChange;

  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  FWidth := Width;
  FHeight := Height;
end;

destructor TButtonBar.Destroy;
begin
  TControlCanvas(FCanvas).Control := nil;

  FreeAndNil(FCanvas);
  FreeAndNil(FDefaults);
  FreeAndNil(FItems);

  inherited Destroy;
end;

procedure TButtonBar.Loaded;
begin
  inherited Loaded;

  UpdateButtons;
end;

procedure TButtonBar.CMRecreateWnd(var AMessage: TMessage);
begin
  inherited;

  UpdateButtons;
end;

procedure TButtonBar.CMVisibleChanged(var AMessage: TMessage);
begin
  inherited;

  { TPageScroller seems to ghost paint over controls in some situations when Visible is set to False.
    This fixes the situation until the problem is resolved. }
  if not (csDestroying in ComponentState) then
  begin
    if Visible then
    begin
      if Orientation = soHorizontal then
        Height := FHeight
      else
        Width := FWidth;
    end
    else
    if Orientation = soHorizontal then
    begin
      FHeight := Height;
      Height := 0
    end
    else
    begin
      FWidth := Width;
      Width := 0;
    end;
  end;
end;

function IsParentTabSheet(const AControl: TWinControl): Boolean;
begin
  if Assigned(AControl) then
  begin
    if AControl is TTabSheet then
      Result := True
    else
      Result := IsParentTabSheet(AControl.Parent);
  end
  else
    Result := False;
end;

procedure TButtonBar.CreateButtonBarPanel;
begin
  if Assigned(FButtonBarPanel) then
    Exit;

  FButtonBarPanel := TButtonBarPanel.Create(Self);
  FButtonBarPanel.ParentBackground := IsParentTabSheet(Self);
  FButtonBarPanel.ParentColor := True;
  FButtonBarPanel.ParentDoubleBuffered := True;
  FButtonBarPanel.BevelOuter := bvNone;
  FButtonBarPanel.Left := 0;
  FButtonBarPanel.Top := 0;
  FButtonBarPanel.Parent := Self;

  Control := FButtonBarPanel;

  FWidth := Width;
  FHeight := Height;
end;

procedure TButtonBar.UpdateParentBackground;
begin
  if Assigned(FButtonBarPanel) then
    FButtonBarPanel.ParentBackground := IsParentTabSheet(Self);
end;

procedure TButtonBar.Clear;
begin
  FItems.Clear;
end;

procedure TButtonBar.CreateButton(var AItem: TButtonBarCollectionItem);
begin
  AItem.Button := TButtonBarControl.Create(FButtonBarPanel);
  AItem.Button.Parent := FButtonBarPanel;
  AItem.Button.Orientation := Orientation;
end;

{$IFDEF ALPHASKINS}
function IsParentRollOutPanel(const AControl: TWinControl): Boolean;
begin
  if Assigned(AControl) then
  begin
    if AControl is TsRollOutPanel then
      Result := True
    else
      Result := IsParentRollOutPanel(AControl.Parent);
  end
  else
    Result := False;
end;
{$ENDIF}

procedure TButtonBar.CreateDropdownButton(var AItem: TButtonBarCollectionItem);
begin
  if Assigned(AItem.DropdownButton) then
    Exit;

  { Button panel }
  AItem.ButtonPanel := TButtonBarPanel.Create(FButtonBarPanel);
  AItem.ButtonPanel.ParentBackground := IsParentTabSheet(Self);
  AItem.ButtonPanel.ParentColor := True;
  AItem.ButtonPanel.ParentDoubleBuffered := True;
  AItem.ButtonPanel.BevelOuter := bvNone;
  AItem.ButtonPanel.Parent := FButtonBarPanel;
  { Button move }
  AItem.Button.Align := alClient;
  AItem.Button.Parent := AItem.ButtonPanel;
  { Dropdown buttons }
  AItem.DropdownButton := TButtonBarControl.Create(FButtonBarPanel);
  AItem.DropdownButton.Align := alRight;
  AItem.DropdownButton.Orientation := Orientation;
  AItem.DropdownButton.Parent := AItem.ButtonPanel;
end;

procedure TButtonBar.LockPainting;
begin
{$IF CompilerVersion < 35}
  if (FDrawLockCount = 0) and HandleAllocated and Visible then
    SendMessage(WindowHandle, WM_SETREDRAW, Ord(False), 0);

  Inc(FDrawLockCount);
{$ELSE}
  LockDrawing;
{$ENDIF}
end;

procedure TButtonBar.UnlockPainting;
begin
{$IF CompilerVersion < 35}
  if FDrawLockCount > 0 then
  begin
    Dec(FDrawLockCount);

    if (FDrawLockCount = 0) and HandleAllocated and Visible then
    begin
      SendMessage(WindowHandle, WM_SETREDRAW, Ord(True), 0);
      RedrawWindow(WindowHandle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
    end;
  end;
{$ELSE}
  UnlockDrawing;
{$ENDIF}
end;

procedure TButtonBar.UpdateButtonPositions(const ACheckDesigning: Boolean = False);
var
  LIndex: Integer;
  LLeft, LTop: Integer;
  LItem: TButtonBarCollectionItem;
  LButtonFound: Boolean;
begin
  if ACheckDesigning and not (csDesigning in ComponentState) then
    Exit;

  LockPainting;
  try
    LLeft := 0;
    LTop := 0;

    LButtonFound := False;

    for LIndex := 0 to FItems.Count - 1 do
    begin
      LItem := FItems.Item[LIndex];

      case LItem.Style of
        stDivider:
          begin
            LItem.Visible := LButtonFound;
            LButtonFound := False;
          end;
        stButton:
          if LItem.Visible then
            LButtonFound := True;
      end;
    end;

    for LIndex := FItems.Count - 1 downto 0 do
    begin
      LItem := FItems.Item[LIndex];

      case LItem.Style of
        stDivider:
          LItem.Visible := False;
        stButton:
          if LItem.Visible then
            Break;
      end;
    end;

    for LIndex := 0 to FItems.Count - 1 do
    begin
      LItem := FItems.Item[LIndex];

      if not LItem.Visible or not Assigned(LItem.Button) then
        Continue;

      if Orientation = soHorizontal then
      begin
        if Assigned(LItem.ButtonPanel) then
        begin
          LItem.ButtonPanel.Left := LLeft;

          Inc(LLeft, LItem.ButtonPanel.Width);
        end
        else
        begin
          LItem.Button.Left := LLeft;

          if LItem.Button.Visible then
            Inc(LLeft, LItem.Button.Width);

          if LItem.Button.AlignWithMargins then
            Inc(LLeft, LItem.Button.Margins.Left + LItem.Button.Margins.Right);
        end;
      end
      else
      if Assigned(LItem.ButtonPanel) then
      begin
        LItem.ButtonPanel.Top := LTop;

        Inc(LTop, LItem.ButtonPanel.Height);
      end
      else
      begin
        LItem.Button.Top := LTop;

        if LItem.Button.Visible then
          Inc(LTop, LItem.Button.Height);

        if LItem.Button.AlignWithMargins then
          Inc(LTop, LItem.Button.Margins.Top + LItem.Button.Margins.Bottom);
      end;
    end;
  finally
    UnlockPainting;
  end;
end;

function TButtonBar.InUpdateBlock: Boolean;
begin
  Result := FItems.UpdateCount > 0;
end;

procedure TButtonBar.SetButtonBarPanelSize;
begin
  if Assigned(Parent) and Assigned(FButtonBarPanel) then
  begin
    if Orientation = soHorizontal then
      FButtonBarPanel.Height := Height
    else
      FButtonBarPanel.Width := Width;
  end;
end;

procedure TButtonBar.SetAutoSize(AValue: Boolean);
begin
  FAutoSize := AValue;

  AutoSizeButtonBar;
end;

{$IF NOT DEFINED(ALPHASKINS)}
function TButtonBar.ScaleInt(const ANumber: Integer): Integer;
begin
  Result := Muldiv(ANumber, CurrentPPI, 96);
end;
{$ENDIF}

procedure TButtonBar.AutoSizeButtonBar;
var
  LHeightMargins, LWidthMargins: Integer;
  LItem: TButtonBarCollectionItem;
  LIndex, LHeight, LWidth, LTextWidth: Integer;
begin
  if (FItems.Count = 0) or (Align <> alNone) then
    Exit;

  LItem := nil;

  for LIndex := FItems.Count - 1 downto 0 do
  if FItems.Item[LIndex].Visible then
  begin
    LItem := FItems.Item[LIndex];
    Break;
  end;

  if not Assigned(LItem) then
    Exit;

  LHeightMargins := 0;
  LWidthMargins := 0;

  if AlignWithMargins then
  begin
    LWidthMargins := Margins.Left + Margins.Right;
    LHeightMargins := Margins.Top + Margins.Bottom;
  end;

  if Orientation = soHorizontal then
  begin
    Height := ScaleInt(FDefaults.ButtonSize) + LHeightMargins;

    if Assigned(LItem.ButtonPanel) then
      Width := LItem.ButtonPanel.Left + LItem.ButtonPanel.Width + LWidthMargins
    else
    if Assigned(LItem.Button) then
      Width := LItem.Button.Left + LItem.Button.Width + LWidthMargins
  end
  else
  begin
    LWidth := 0;
    LHeight := LItem.Button.Top + LItem.Button.Height;

    for LIndex := 0 to FItems.Count - 1 do
    begin
      LItem := FItems.Item[LIndex];

      if Assigned(LItem.Button) and LItem.Visible then
      begin
        LItem.Button.Canvas.Font.Assign(Font);

        LTextWidth := LItem.Button.Canvas.TextWidth(LItem.Button.Caption) + ScaleInt(2 * FDefaults.TextMargin);

        if Assigned(LItem.Button.Images) and (LItem.Button.ImageIndex <> -1) then
          Inc(LTextWidth, LItem.Button.Images.Width);

        if Assigned(LItem.DropdownButton) then
          Inc(LTextWidth, ScaleInt(LItem.Dropdown.ButtonWidth));

        if LTextWidth > LWidth then
          LWidth := LTextWidth;
      end;
    end;

    Height := LHeight + LHeightMargins;
    Width := LWidth + LWidthMargins;
  end;
end;

procedure TButtonBar.UpdateButtons(const AIsLast: Boolean = False);
var
  LIndex: Integer;
begin
  if InUpdateBlock or ([csLoading, csReading] * ComponentState <> []) and
    ([csLoading, csDestroying] * ComponentState <> []) and not HandleAllocated then
    Exit;

  CreateButtonBarPanel;

  if AIsLast or (FItems.Count = 0) then
  begin
    if Assigned(FButtonBarPanel) then
      FreeAndNil(FButtonBarPanel);

    Invalidate;
    Exit;
  end;

  LockPainting;
  try
    FButtonBarPanel.AutoSize := False;
    FButtonBarPanel.Left := 0;
    FButtonBarPanel.Top := 0;

    SetButtonBarPanelSize;

    for LIndex := 0 to FItems.Count - 1 do
      Assign(FItems.Item[LIndex]);

    UpdateButtonPositions;

    FButtonBarPanel.AutoSize := True;
    FButtonBarPanel.AutoSize := Orientation = soHorizontal; { Vertical button bar can be resized }

    if FAutoSize then
      AutoSizeButtonBar;
  finally
    UnlockPainting;
  end;
end;

procedure TButtonBar.DummyClickEvent(ASender: TObject);
begin
  { Dummy click event for enabling button }
end;

function TButtonBar.FormatCaption(const ACaption: string): string;
begin
  Result := ACaption;

  Result := StringReplace(Result, '&', '', [rfReplaceAll]);
  Result := StringReplace(Result, '...', '', [rfReplaceAll]);
end;

procedure TButtonBar.Assign(ASource: TPersistent);
var
  LItem: TButtonBarCollectionItem;
  LTextWidth: Integer;
  LNotifyEvent: TNotifyEvent;
  LCaption: string;
  LShowCaption: Boolean;
begin
  if InUpdateBlock then
    Exit;

  if ASource is TButtonBarCollectionItem then
  begin
    LItem := TButtonBarCollectionItem(ASource);

    if not Assigned(LItem.Button) then
      CreateButton(LItem);

    LItem.Button.Images := FImages;
    LItem.Button.Action := LItem.Action;
    LItem.Button.OnClick := LItem.OnClick;
    LItem.Button.AllowAllUp := LItem.AllowAllUp;
    LItem.Button.Cursor := LItem.Cursor;
    LItem.Button.Down := LItem.Down or LItem.Checked;
    LItem.Button.Enabled := LItem.Enabled;
    LItem.Button.Flat := LItem.Flat;
    LItem.Button.GroupIndex := LItem.GroupIndex;
    LItem.Button.IgnoreFocus := opIgnoreFocus in FOptions;
    LItem.Button.Invisible := (csDesigning in ComponentState) and not LItem.Visible;
    LItem.Button.OnBeforeMenuDropdown := OnBeforeMenuDropdown;
    LItem.Button.OnClick := LItem.OnClick;
    LItem.Button.OnMouseEnter := LItem.OnMouseEnter;
    LItem.Button.OnMouseLeave := LItem.OnMouseLeave;
    LItem.Button.OnMouseMove := LItem.OnMouseMove;
    LItem.Button.Tag := LItem.Tag;

{$IFDEF ALPHASKINS}
    if LItem.TextOffset > 0 then
      LItem.Button.TextOffSet := LItem.TextOffset
    else
      LItem.Button.TextOffSet := FDefaults.TextOffset;

    LItem.Button.ShowCaption := opShowCaptions in FOptions;
{$ENDIF}
    if LItem.Layout = blGlyphLeft then
    begin
      LItem.Button.Margin := ScaleInt(3);
{$IFDEF ALPHASKINS}
      LItem.Button.Alignment := taLeftJustify;
      LItem.Button.TextAlignment := taLeftJustify;
{$ENDIF}
    end
{$IFDEF ALPHASKINS}
    else
    begin
      LItem.Button.Alignment := taCenter;
      LItem.Button.TextAlignment := taCenter;
    end
{$ENDIF};

    if csDesigning in ComponentState then
      LItem.Button.Visible := True
    else
      LItem.Button.Visible := LItem.Visible;

    LShowCaption := opShowCaptions in FOptions;

    if (opShowHints in FOptions) and
      (not LShowCaption or LShowCaption and (LItem.Caption <> LItem.Hint) or
      Assigned(LItem.Action) and (TAction(LItem.Action).ShortCut <> 0)) then
      LItem.Button.Hint := LItem.Hint
    else
      LItem.Button.Hint := '';

    if Assigned(LItem.Counter) then
      LItem.Button.Counter.Assign(LItem.Counter);

    if (LItem.Style = stDivider) or not LShowCaption then
      LItem.Button.Caption := ''
    else
    begin
      LCaption := LItem.Caption;

      if opFormatCaptions in FOptions then
        LCaption := FormatCaption(LCaption);

      LItem.Button.Caption := LCaption;
    end;

    if Orientation = soHorizontal then
      LItem.Button.Align := alLeft
    else
      LItem.Button.Align := alTop;

    if LItem.Style = stDivider then
    begin
      LItem.Button.Margin := ScaleInt(FDefaults.DividerMargin);

      if Orientation = soHorizontal then
      begin
        LItem.Button.Width := ScaleInt(FDefaults.DividerSize);
        LItem.Button.Style := csVerticalDivider;
      end
      else
      begin
        LItem.Button.Height := ScaleInt(FDefaults.DividerSize);
        LItem.Button.Style := csHorizontalDivider;
      end;
{$IFDEF ALPHASKINS}
      LItem.Button.AlignWithMargins := True;
      LItem.Button.Margin := ScaleInt(4);
      LItem.Button.ButtonStyle := tbsDivider;
{$ENDIF}
    end;

    if LItem.Style = stButton then
    begin
      LItem.Button.ImageIndex := LItem.ImageIndex;
      LItem.Button.Glyph := nil;
      LItem.Button.Layout := LItem.Layout;
      LItem.Button.Font.Assign(Font);
      LItem.Button.DropdownMenu := LItem.DropdownMenu;
      LItem.Button.MainControl := nil;
      LItem.Button.Style := csButton;
{$IFDEF ALPHASKINS}
      LItem.Button.Blend := LItem.Blend;
      LItem.Button.DisabledGlyphKind := LItem.DisabledGlyphKind;
      LItem.Button.Reflected := LItem.Reflected;

      if LItem.Button.ShowCaption then
        LItem.Button.ButtonStyle := tbsTextButton
      else
        LItem.Button.ButtonStyle := tbsButton;
{$ENDIF}

      LNotifyEvent := DummyClickEvent;

      if LItem.Visible and LItem.Dropdown.Visible and Assigned(LItem.DropdownMenu) and
        Assigned(LItem.Button.OnClick) and Assigned(LItem.Action) and (@LItem.Action.OnExecute <> @LNotifyEvent) then
        CreateDropdownButton(LItem)
      else
      if Assigned(LItem.DropdownButton) then
        FreeAndNil(LItem.DropdownButton);

      if not (csDesigning in ComponentState) and LItem.Visible and LItem.Dropdown.Visible and
        Assigned(LItem.DropdownMenu) and Assigned(LItem.Action) and not Assigned(LItem.Action.OnExecute) then
        LItem.Action.OnExecute := DummyClickEvent; { Action is disabled without execute event. }

      LItem.Button.DropdownButtonVisible := LItem.Dropdown.Visible and not Assigned(LItem.DropdownButton);

      if Assigned(LItem.DropdownButton) then
      begin
        LItem.DropdownButton.Style := csDropdown;
        LItem.DropdownButton.DropdownButtonVisible := True;
        LItem.DropdownButton.Flat := LItem.Flat;
        LItem.DropdownButton.DropdownMenu := LItem.DropdownMenu;
        LItem.DropdownButton.Width := ScaleInt(LItem.Dropdown.ButtonWidth);
        LItem.DropdownButton.Hint := LItem.Dropdown.Hint;
        LItem.DropdownButton.Visible := LItem.Dropdown.Visible and LItem.Visible;
        LItem.DropdownButton.MainControl := LItem.Button;
{$IFDEF ALPHASKINS}
        LItem.DropdownButton.ButtonStyle := tbsDropDown;
        LItem.DropdownButton.SplitterStyle := dsLine;
{$ENDIF}
      end
{$IFDEF ALPHASKINS}
      else
      if Assigned(LItem.Button.DropdownMenu) then
      begin

        LItem.Button.ButtonStyle := tbsDropDown;
        LItem.Button.SplitterStyle := dsLine;
      end
{$ENDIF};

      LTextWidth := 0;

      if Orientation = soHorizontal then
      begin
        LItem.Button.Width := ScaleInt(FDefaults.ButtonSize);
{$IF NOT DEFINED(ALPHASKINS)}
        if LItem.Button.DropdownButtonVisible and Assigned(LItem.DropdownMenu) then
          LItem.Button.Width := LItem.Button.Width + ScaleInt(LItem.Dropdown.ButtonWidth);
{$ENDIF}
        if opShowCaptions in FOptions then
        begin
          LItem.Button.Canvas.Font.Assign(Font);

          LTextWidth := LItem.Button.Canvas.TextWidth(LItem.Button.Caption) + ScaleInt(2 * FDefaults.TextMargin);

          if LTextWidth > LItem.Button.Width then
            LItem.Button.Width := LTextWidth;
        end;
{$IFDEF ALPHASKINS}
        if LItem.Button.DropdownButtonVisible and Assigned(LItem.DropdownMenu) then
          LItem.Button.Width := LItem.Button.Width + ScaleInt(LItem.Dropdown.ButtonWidth);
{$ENDIF}
      end
      else
        LItem.Button.Height := ScaleInt(FDefaults.ButtonSize);

      if Assigned(LItem.ButtonPanel) then
      begin
        if Orientation = soHorizontal then
        begin
          LItem.ButtonPanel.Align := alLeft;

          if Assigned(LItem.DropdownButton) then
          begin
            if LTextWidth > ScaleInt(FDefaults.ButtonSize) then
              LItem.ButtonPanel.Width := LTextWidth + ScaleInt(LItem.Dropdown.ButtonWidth)
            else
              LItem.ButtonPanel.Width := ScaleInt(FDefaults.ButtonSize) + ScaleInt(LItem.Dropdown.ButtonWidth)
          end;
        end
        else
          LItem.ButtonPanel.Align := alTop;

        LItem.ButtonPanel.Height := LItem.Button.Height;
        LItem.Button.Align := alClient;
      end;
    end;
  end
  else
    inherited;
end;

function TButtonBar.ShowNotItemsFound: Boolean;
begin
  Result := (csDesigning in ComponentState) and (FItems.Count = 0);
end;

{$IFDEF USE_ITEM_CLICK_WM_MESSAGES}
procedure TButtonBar.OnButtonClickMessage(var AMessage: TMessage);
var
  LIndex: Integer;
  LItem: TButtonBarCollectionItem;
  LPoint: TPoint;
begin
  LIndex := AMessage.WParam;

  if (LIndex >= 0) and (LIndex < FItems.Count) then
  begin
    LItem := FItems.Item[LIndex];

    if Assigned(LItem.DropdownMenu) then
    begin
      LPoint := LItem.Button.ClientToScreen(Point(0, LItem.Button.Height));
      LItem.DropdownMenu.Popup(LPoint.X, LPoint.Y);
    end
    else
    if Assigned(LItem.Action) then
      LItem.Action.Execute
    else
      LItem.OnClick(nil);
  end;
end;
{$ENDIF}

procedure TButtonBar.WMSize(var AMessage: TWMSize);
begin
  inherited;

  if csDesigning in ComponentState then
  begin
    if ShowNotItemsFound then
      Invalidate
    else
      UpdateButtons;
  end
  else
    SetButtonBarPanelSize;
end;

procedure TButtonBar.PaintWindow(DC: HDC);
begin
  if Visible or (csDesigning in ComponentState) then
  begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      TControlCanvas(FCanvas).UpdateTextFlags;
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
    end;
  end;
end;

procedure TButtonBar.Paint;
var
  LRect: TRect;
  LTextHeight, LTextWidth: Integer;
  LFlags: Cardinal;
begin
  if ShowNotItemsFound then
  begin
    LRect := ClientRect;

    FCanvas.Brush.Color := TColors.Red;
    FCanvas.Brush.Style := bsFDiagonal;
    FCanvas.Pen.Color := TColors.Red;
    FCanvas.Rectangle(LRect);

    FCanvas.Brush.Color := TColors.Red;
    FCanvas.Brush.Style := bsSolid;

    FCanvas.Font.Color := TColors.White;
    FCanvas.Font.Quality := fqAntialiased;
    FCanvas.Font.Style := [fsBold];
    FCanvas.Font.Height := Font.Height;

    LTextWidth := FCanvas.TextWidth(ButtonBarNoItemsFound);
    LFlags := DT_VCENTER or DT_SINGLELINE;

    if Width < LTextWidth then
    begin
      FCanvas.Font.Orientation := 900;
      LTextHeight := FCanvas.TextHeight(ButtonBarNoItemsFound);
      LRect.Top := LTextWidth;
      LRect.Left := (Width - LTextHeight) div 2;
    end
    else
    begin
      FCanvas.Font.Orientation := 0;
      LFlags := LFlags or DT_CENTER;
    end;

    DrawText(FCanvas.Handle, ButtonBarNoItemsFound, -1, LRect, LFlags);
  end
  else
  begin
    if ParentColor then
      FCanvas.Brush.Style := bsClear
    else
      FCanvas.Brush.Color := Color;

    if StyleServices.Enabled and Assigned(Parent) and (csParentBackground in ControlStyle) then
      StyleServices.DrawParentBackground(Handle, FCanvas.Handle, nil, False)
    else
      FCanvas.FillRect(ClientRect);
  end;
end;

procedure TButtonBar.SetImages(const AValue: TCustomImageList);
var
  LIndex: Integer;
  LItem: TButtonBarCollectionItem;
begin
  FImages := AValue;

  for LIndex := 0 to FItems.Count - 1 do
  begin
    LItem := Item[LIndex];

    if Assigned(LItem.Button) then
      LItem.Button.Images := FImages;
  end;
end;

procedure TButtonBar.SetItems(const AValue: TButtonBarCollection);
begin
  if AValue <> FItems then
    FItems.Assign(AValue);
end;

procedure TButtonBar.SetOptions(const AValue: TButtonBarOptions);
begin
  if FOptions <> AValue then
  begin
    FOptions := AValue;

    UpdateButtons;
  end;
end;

procedure TButtonBar.DoDefaultChange(ASender: TObject);
begin
  UpdateButtons;
end;

function TButtonBar.GetControlByName(const AName: string): TControl;
var
  LItem: TButtonBarCollectionItem;
begin
  LItem := GetItemByName(AName);
  Result := LItem.Button;
end;

function TButtonBar.GetItem(const AIndex: Integer): TButtonBarCollectionItem;
begin
  Result := FItems.Item[AIndex];
end;

function TButtonBar.FindItemByName(const AName: string): TButtonBarCollectionItem;
var
  LIndex: Integer;
  LItem: TButtonBarCollectionItem;
begin
  Result := nil;

  for LIndex := 0 to FItems.Count - 1 do
  begin
    LItem := Item[LIndex];

    if CompareText(LItem.Name, AName) = 0 then
      Exit(LItem);
  end;
end;

function TButtonBar.GetItemByName(const AName: string): TButtonBarCollectionItem;
begin
  Result := FindItemByName(AName);

  if not Assigned(Result) then
    raise EButtonBarException.CreateResFmt(@ButtonBarNoItemFoundWithName, [AName]);
end;

procedure TButtonBar.HideButtons(const ANames: array of string);
var
  LIndex: Integer;
  LItem: TButtonBarCollectionItem;
begin
  FItems.BeginUpdate;

  for LIndex := 0 to FItems.Count - 1 do
  begin
    LItem := Item[LIndex];

    if MatchText(LItem.Name, ANames) then
    begin
      LItem.Action := nil;
      LItem.Visible := False;
    end;
  end;

  FItems.EndUpdate;
end;

end.


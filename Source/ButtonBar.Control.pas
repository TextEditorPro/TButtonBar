unit ButtonBar.Control;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, System.Types, System.UITypes, Vcl.ActnList,
  Vcl.Buttons, Vcl.ComCtrls, Vcl.Controls, Vcl.ExtCtrls, Vcl.Graphics, Vcl.ImgList, Vcl.Menus
{$IFDEF ALPHASKINS}, acPageScroller, sCommonData, sConst, sPanel, sSkinProps, sSpeedButton{$ENDIF};

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
    FArrowBmp: TBitmap;
    FArrowColor: TColor;
    FCounter: TButtonBarItemCounter;
    FDropdownMenu: TPopupMenu;
    FDropdownButtonVisible: Boolean;
    FOnBeforeMenuDropdown: TNotifyEvent;
    FSkipDropdown: Boolean;
    FStyle: TButtonBarControlStyle;
    function IsMouseOverControl: Boolean;
{$IF NOT DEFINED(ALPHASKINS)}
    function ScaleInt(const ANumber: Integer): Integer; inline;
{$ENDIF}
    procedure CreateArrowBmp;
    procedure PaintArrowBmp;
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
    property ArrowColor: TColor read FArrowColor write SetArrowColor default TColors.SysWindowText;
    property Counter: TButtonBarItemCounter read FCounter write FCounter;
    property DropdownMenu: TPopupMenu read FDropdownMenu write SetDropdownMenu;
    property DropdownButtonVisible: Boolean read FDropdownButtonVisible write FDropdownButtonVisible;
    property OnBeforeMenuDropdown: TNotifyEvent read FOnBeforeMenuDropdown write FOnBeforeMenuDropdown;
    property Style: TButtonBarControlStyle read FStyle write SetStyle default csButton;
  end;

  TButtonBarDefaults = class(TPersistent)
  strict private
    FButtonSize: Integer;
    FDividerMargin: Integer;
    FDividerSize: Integer;
    FOnChange: TNotifyEvent;
    procedure DoChange(Sender: TObject);
    procedure SetButtonSize(const AValue: Integer);
    procedure SetDividerMargin(const AValue: Integer);
    procedure SetDividerSize(const AValue: Integer);
  public
    constructor Create;
    procedure Assign(ASource: TPersistent); override;
  published
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property ButtonSize: Integer read FButtonSize write SetButtonSize default 38;
    property DividerMargin: Integer read FDividerMargin write SetDividerMargin default 5;
    property DividerSize: Integer read FDividerSize write SetDividerSize default 8;
  end;

  TButtonBarItemDropdown = class(TPersistent)
  strict private
    FButtonWidth: Integer;
    FHint: string;
    FOnChange: TNotifyEvent;
    FPopupMenu: TPopupMenu;
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
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property Visible: Boolean read FVisible write SetVisible default False;
  end;

  TButtonBarCollectionItem = class;

  TButtonBarItemActionLink = class(TActionLink)
  protected
    FClient: TButtonBarCollectionItem;
    function IsCaptionLinked: Boolean; override;
    function IsEnabledLinked: Boolean; override;
    function IsGroupIndexLinked: Boolean; override;
    function IsHintLinked: Boolean; override;
    function IsImageIndexLinked: Boolean; override;
    function IsOnExecuteLinked: Boolean; override;
    function IsVisibleLinked: Boolean; override;
    procedure AssignClient(AClient: TObject); override;
    procedure SetCaption(const AValue: string); override;
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
    FCaption: string;
    FCounter: TButtonBarItemCounter;
    FCursor: TCursor;
    FDown: Boolean;
    FDropdown: TButtonBarItemDropdown;
    FDropdownButton: TButtonBarControl;
    FEnabled: Boolean;
    FFlat: Boolean;
    FGroupIndex: Integer;
    FHint: string;
    FImageIndex: System.UITypes.TImageIndex;
    FLayout: TButtonLayout;
    FName: string;
    FOnClick: TNotifyEvent;
    FOnCounterChanged: TSTCounterChangedEvent;
    FStyle: TButtonBarItemStyle;
    FTag: Integer;
    FVisible: Boolean;
{$IFDEF ALPHASKINS}
    FBlend: Integer;
    FDisabledGlyphKind: TsDisabledGlyphKind;
    FReflected: Boolean;
{$ENDIF}
    function CanUpdateButton: Boolean;
    function GetAction: TBasicAction;
    procedure DoActionChange(Sender: TObject);
    procedure DoCounterChange(Sender: TObject);
    procedure DoDropdownChange(Sender: TObject);
    procedure SetAction(const AValue: TBasicAction);
    procedure SetAllowAllUp(const AValue: Boolean);
    procedure SetCaption(const AValue: string);
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
    procedure UpdateButtonPositions;
{$IFDEF ALPHASKINS}
    procedure SetBlend(const AValue: Integer);
    procedure SetDisabledGlyphKind(const AValue: TsDisabledGlyphKind);
    procedure SetReflected(const AValue: Boolean);
{$ENDIF}
  protected
    function GetDisplayName: string; override;
    function GetActionLinkClass: TButtonBarItemActionLinkClass;
    procedure ActionChange(Sender: TObject; const ACheckDefaults: Boolean); dynamic;
    procedure SetIndex(AValue: Integer); override;
    property ActionLink: TButtonBarItemActionLink read FActionLink write FActionLink;
  public
    constructor Create(ACollection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure InitiateAction; virtual;
    property Button: TButtonBarControl read FButton write FButton;
    property DropdownButton: TButtonBarControl read FDropdownButton write FDropdownButton;
  published
    property Action: TBasicAction read GetAction write SetAction;
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property Caption: string read FCaption write SetCaption;
    property Counter: TButtonBarItemCounter read FCounter write FCounter;
    property Cursor: TCursor read FCursor write FCursor default crDefault;
    property Down: Boolean read FDown write SetDown default False;
    property Dropdown: TButtonBarItemDropdown read FDropdown write FDropdown;
    property Enabled: Boolean read FEnabled write SetEnabled default True;
    property Flat: Boolean read FFlat write SetFlat default True;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Hint: string read FHint write SetHint;
    property ImageIndex: System.UITypes.TImageIndex read FImageIndex write SetImageIndex default -1;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphTop;
    property Name: string read FName write SetName;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnCounterChanged: TSTCounterChangedEvent read FOnCounterChanged write FOnCounterChanged;
    property Style: TButtonBarItemStyle read FStyle write SetStyle default stButton;
    property Tag: Integer read FTag write FTag default 0;
    property Visible: Boolean read FVisible write SetVisible default True;
{$IFDEF ALPHASKINS}
    property Blend: Integer read FBlend write SetBlend default 0;
    property DisabledGlyphKind: TsDisabledGlyphKind read FDisabledGlyphKind write SetDisabledGlyphKind default [];
    property Reflected: Boolean read FReflected write SetReflected default False;
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
  TButtonBarOption = (opShowCaptions, opShowHints);
  TButtonBarOptions = set of TButtonBarOption;

  TButtonBar = class(TButtonBarPageScroller)
  private
    FButtonPanel: TButtonBarPanel;
    FCanvas: TCanvas;
    FDefaults: TButtonBarDefaults;
    FImages: TCustomImageList;
    FItems: TButtonBarCollection;
    FOnBeforeMenuDropdown: TNotifyEvent;
    FOptions: TButtonBarOptions;
    function GetControlByName(const AName: string): TControl;
    function GetItem(const AIndex: Integer): TButtonBarCollectionItem;
    function GetItemByName(const AName: string): TButtonBarCollectionItem;
    function InUpdateBlock: Boolean;
{$IF NOT DEFINED(ALPHASKINS)}
    function ScaleInt(const ANumber: Integer): Integer; inline;
{$ENDIF}
    function ShowNotItemsFound: Boolean;
    procedure CMRecreateWnd(var AMessage: TMessage); message CM_RECREATEWND;
    procedure CreateButtonPanel;
    procedure CreateDropdownButton(var AItem: TButtonBarCollectionItem);
    procedure DoDefaultChange(ASender: TObject);
    procedure DoResize(Sender: TObject);
    procedure DummyClickEvent(ASender: TObject);
    procedure SetButtonPanelSize;
    procedure SetImages(const AValue: TCustomImageList);
    procedure SetItems(const AValue: TButtonBarCollection);
    procedure SetOptions(const AValue: TButtonBarOptions);
    procedure UpdateButtonPositions(const ACheckDesigning: Boolean = False);
    procedure UpdateButtons(const AIsLast: Boolean = False);
    procedure WMPaint(var AMessage: TWMPaint); message WM_PAINT;
    procedure WMSize(var AMessage: TWMSize); message WM_SIZE;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(ASource: TPersistent); override;
    procedure Clear;
    procedure CreateButton(var AItem: TButtonBarCollectionItem);
    procedure Loaded; override;
    procedure Paint; {$IFDEF ALPHASKINS}override;{$ELSE}virtual;{$ENDIF}
    procedure PaintWindow(DC: HDC); override;
    property ControlByName[const AName: string]: TControl read GetControlByName;
    property Item[const AIndex: Integer]: TButtonBarCollectionItem read GetItem;
    property ItemByName[const AName: string]: TButtonBarCollectionItem read GetItemByName;
  published
    property Align default alTop;
    property ButtonSize default 16;
    property Canvas: TCanvas read FCanvas;
    property Defaults: TButtonBarDefaults read FDefaults write FDefaults;
    property DoubleBuffered default True;
    property Images: TCustomImageList read FImages write SetImages;
    property Items: TButtonBarCollection read FItems write SetItems;
    property OnBeforeMenuDropdown: TNotifyEvent read FOnBeforeMenuDropdown write FOnBeforeMenuDropdown;
    property Options: TButtonBarOptions read FOptions write SetOptions default [];
    property ParentBackground default True;
    property ParentDoubleBuffered default False;
    property ParentFont default False;
  end;

implementation

uses
  System.RTLConsts;

type
  ESTButtonBarException = class(Exception);

resourcestring
  ButtonBarNoItemFoundWithName = 'No item found with name "%s"';
  ButtonBarNoItemsFound = ' No items found ';
  ButtonBarItemDividerChar = '-';
  ButtonBarItemUnnamed = '(unnamed)';

{ TButtonBarControl }

constructor TButtonBarControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCounter := TButtonBarItemCounter.Create;

  FArrowColor := TColors.SysWindowText;
  FStyle := csButton;

{$IFDEF ALPHASKINS}
  SkinData.SkinSection := s_ToolButton;
  DisabledGlyphKind := [];
  WordWrap := False;
{$ENDIF}

  CreateArrowBmp;
  PaintArrowBmp;
end;

{$IF NOT DEFINED(ALPHASKINS)}
function TButtonBarControl.ScaleInt(const ANumber: Integer): Integer;
begin
  Result := Muldiv(ANumber, CurrentPPI, 96);
end;
{$ENDIF}

destructor TButtonBarControl.Destroy;
begin
  FreeAndNil(FArrowBmp);
  FreeAndNil(FCounter);

  inherited Destroy;
end;

procedure TButtonBarControl.CreateArrowBmp;
begin
  FArrowBmp := Vcl.Graphics.TBitmap.Create;
  FArrowBmp.Transparent := True;
  FArrowBmp.TransparentColor := Color;
  FArrowBmp.Width := ScaleInt(7);
  FArrowBmp.Height := ScaleInt(4);
  FArrowBmp.Canvas.Brush.Color := Color;
end;

procedure TButtonBarControl.PaintArrowBmp;
var
  LArrowPoints: array [0..2] of TPoint;
begin
  FArrowBmp.Canvas.FillRect(Rect(0, 0, FArrowBmp.Width, FArrowBmp.Height));

  LArrowPoints[0] := Point(0, 0);
  LArrowPoints[1] := Point(FArrowBmp.Width - 1, 0); // -1 because zero origin
  LArrowPoints[2] := Point((FArrowBmp.Width - 1) div 2, FArrowBmp.Height - 1);

  FArrowBmp.Canvas.Pen.Color := FArrowColor;
  FArrowBmp.Canvas.Brush.Color := FArrowColor;
  FArrowBmp.Canvas.Polygon(LArrowPoints);
end;

procedure TButtonBarControl.SetArrowColor(const AValue: TColor);
begin
  if FArrowColor <> AValue then
  begin
    FArrowColor := AValue;

    PaintArrowBmp;
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
  LPoint := ScreenToClient(Mouse.CursorPos);
  Result := PtInRect(ClientRect, LPoint);
end;

procedure TButtonBarControl.MouseDown(AButton: TMouseButton; AShift: TShiftState; X, Y: Integer);
var
  LPoint: TPoint;
  LPanel: TButtonBarPanel;
begin
  if csDesigning in ComponentState then
    Exit;

  LPanel := TButtonBarPanel(Owner);
  if LPanel.CanFocus then
    LPanel.SetFocus;

  if Enabled and (AButton = mbLeft) and Assigned(FDropdownMenu) and (FDropdownButtonVisible or not Assigned(OnClick)) then
  begin
    if not FSkipDropdown then
    begin
      FSkipDropdown := True;

      DropdownMenu.PopupComponent := Self;

      LPoint := ClientToScreen(Point(0, Height));
      if BiDiMode = bdRightToLeft then
        Inc(LPoint.X, Width);

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
begin
  case FStyle of
    csHorizontalDivider:
      begin
        LRect := ClientRect;

        LRect.Top := LRect.Height div 2 - 1;
        LRect.Left := LRect.Left + Margin;
        LRect.Right := LRect.Right - Margin;

        DrawEdge(Canvas.Handle, LRect, BDR_SUNKENOUTER, BF_TOP);
      end;
    csVerticalDivider:
      begin
        LRect := ClientRect;

        LRect.Left := LRect.Width div 2;
        LRect.Top := LRect.Top + Margin;
        LRect.Bottom := LRect.Bottom - Margin;

        DrawEdge(Canvas.Handle, LRect, BDR_SUNKENOUTER, BF_LEFT);
      end;
    csDropdown:
      begin
        inherited;

        with ClientRect do
        begin
          LLeft := Left + (Width - FArrowBmp.Width) div 2 + 1;
          LTop := Top + (Height - FArrowBmp.Height) div 2;
        end;

        Canvas.Draw(LLeft, LTop, FArrowBmp);
      end;
  else
    inherited;

    if FCounter.Visible then
    begin
      Canvas.Font.Size := ScaleInt(FCounter.FontSize);
      Canvas.Brush.Style := bsClear;

      if not Enabled then
        Canvas.Font.Color := clGray
      else
      if FCounter.Value = 0 then
        Canvas.Font.Color := FCounter.Colors.Zero
      else
        Canvas.Font.Color := FCounter.Colors.Other;

      Canvas.TextOut(2, 0, IntToStr(FCounter.Value));
    end;

    if Assigned(FDropdownMenu) and FDropdownButtonVisible then
    begin
      with ClientRect do
      begin
        if UseRightToLeftAlignment then
           LLeft := ScaleInt(8)
         else
           LLeft := Right - ScaleInt(12);

        LTop := Top + (Height - FArrowBmp.Height) div 2;
      end;

      Canvas.Draw(LLeft, LTop, FArrowBmp);
    end;
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
    SameCaption(FClient.Caption, TCustomAction(Action).Caption);
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
end;

procedure TButtonBarDefaults.Assign(ASource: TPersistent);
begin
  if Assigned(ASource) and (ASource is TButtonBarDefaults) then
  with ASource as TButtonBarDefaults do
  begin
    Self.FButtonSize := FButtonSize;
    Self.FDividerMargin := FDividerMargin;
    Self.FDividerSize := FDividerSize;
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
var
  LButtonBar: TButtonBar;
begin
  inherited Create(ACollection);

  FAllowAllUp := False;
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
{$ENDIF}

  FCounter := TButtonBarItemCounter.Create;
  FCounter.OnChange := DoCounterChange;

  FDropdown := TButtonBarItemDropdown.Create;
  FDropdown.OnChange := DoDropdownChange;

  LButtonBar := TButtonBar(ACollection.Owner);
  LButtonBar.CreateButton(Self);
end;

destructor TButtonBarCollectionItem.Destroy;
begin
  FreeAndNil(FActionLink);
  FreeAndNil(FCounter);
  FreeAndNil(FDropdown);
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
		Self.OnClick := OnClick;
    Self.OnCounterChanged := OnCounterChanged;
{$IFDEF ALPHASKINS}
    Self.FBlend := FBlend;
    Self.FDisabledGlyphKind := FDisabledGlyphKind;
    Self.FReflected := FReflected;
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

  Changed(False);
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
  end;
end;

function TButtonBarCollectionItem.GetAction: TBasicAction;
begin
  if Assigned(FActionLink) then
    Result := FActionLink.Action
  else
    Result := nil;
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

procedure TButtonBarCollectionItem.UpdateButtonPositions;
var
  LButtonBar: TButtonBar;
begin
  LButtonBar := TButtonBar(Collection.Owner);
  LButtonBar.UpdateButtonPositions(True);
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
  UpdateButtonPositions;
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
    raise ESTButtonBarException.CreateRes(@SDuplicateString)
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

  TButtonBar(Owner).UpdateButtons;
end;

{ TButtonBar }

constructor TButtonBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  Align := alTop;
  ButtonSize := 16;
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents, csGestures];
  DoubleBuffered := True;
  Font.Size := 7;
  FOptions := [];
  Height := 40;
  ParentBackground := True;
  ParentDoubleBuffered := False;
  ParentFont := False;

  FItems := TButtonBarCollection.Create(Self, TButtonBarCollectionItem);
  FDefaults := TButtonBarDefaults.Create;
  FDefaults.OnChange := DoDefaultChange;

  if csDesigning in ComponentState then
    OnResize := DoResize;
end;

destructor TButtonBar.Destroy;
begin
  FreeAndNil(FItems);
  FreeAndNil(FDefaults);

  if Assigned(FButtonPanel) then
    FreeAndNil(FButtonPanel);

  FreeAndNil(FCanvas);

  inherited Destroy;
end;

procedure TButtonBar.Loaded;
begin
  inherited Loaded;

  UpdateButtons;
end;

procedure TButtonBar.DoResize;
begin
  Invalidate;
end;

procedure TButtonBar.CMRecreateWnd(var AMessage: TMessage);
begin
  UpdateButtons;
end;

procedure TButtonBar.CreateButtonPanel;
begin
  if Assigned(FButtonPanel) then
    Exit;

  FButtonPanel := TButtonBarPanel.Create(Self);
  FButtonPanel.BevelOuter := bvNone;
  FButtonPanel.Left := 0;
  FButtonPanel.Top := 0;
  FButtonPanel.Parent := Self;

  Control := FButtonPanel;
end;

procedure TButtonBar.Clear;
begin
  FItems.Clear;
end;

procedure TButtonBar.CreateButton(var AItem: TButtonBarCollectionItem);
begin
  CreateButtonPanel;

  AItem.Button := TButtonBarControl.Create(FButtonPanel);
  AItem.Button.Parent := FButtonPanel;

  Assign(AItem);

  UpdateButtonPositions(True);
end;

procedure TButtonBar.CreateDropdownButton(var AItem: TButtonBarCollectionItem);
begin
  if Assigned(AItem.DropdownButton) then
    Exit;

  AItem.DropdownButton := TButtonBarControl.Create(FButtonPanel);
  AItem.DropdownButton.Parent := FButtonPanel;
end;

procedure TButtonBar.UpdateButtonPositions(const ACheckDesigning: Boolean = False);
var
  LIndex: Integer;
  LLeft, LTop: Integer;
  LItem: TButtonBarCollectionItem;
begin
  if ACheckDesigning and not (csDesigning in ComponentState) then
    Exit;

  LockDrawing;
  try
    LLeft := 0;
    LTop := 0;

    for LIndex := 0 to FItems.Count - 1 do
    begin
      LItem := FItems.Item[LIndex];

      if not Assigned(LItem.Button) then
        Continue;

      if Orientation = soHorizontal then
      begin
        LItem.Button.Left := LLeft;

        if LItem.Button.Visible then
          Inc(LLeft, LItem.Button.Width);

        if LItem.Button.AlignWithMargins then
          Inc(LLeft, LItem.Button.Margins.Left + LItem.Button.Margins.Right);

        if Assigned(LItem.DropdownButton) then
        begin
          LItem.DropdownButton.Left := LLeft;

          if LItem.DropdownButton.Visible then
            Inc(LLeft, LItem.DropdownButton.Width);

          if LItem.DropdownButton.AlignWithMargins then
            Inc(LLeft, LItem.DropdownButton.Margins.Left + LItem.DropdownButton.Margins.Right);
        end;
      end
      else
      begin
        LItem.Button.Top := LTop;

        if LItem.Button.Visible then
          Inc(LTop, LItem.Button.Height);

        if LItem.Button.AlignWithMargins then
          Inc(LTop, LItem.Button.Margins.Top + LItem.Button.Margins.Bottom);

        if Assigned(LItem.DropdownButton) then
        begin
          LItem.DropdownButton.Top := LTop;

          if LItem.DropdownButton.Visible then
            Inc(LTop, LItem.DropdownButton.Height);

          if LItem.DropdownButton.AlignWithMargins then
            Inc(LTop, LItem.DropdownButton.Margins.Top + LItem.DropdownButton.Margins.Bottom);
        end;
      end;
    end;
  finally
    UnlockDrawing;
  end;
end;

function TButtonBar.InUpdateBlock: Boolean;
begin
  Result := FItems.UpdateCount > 0;
end;

procedure TButtonBar.SetButtonPanelSize;
begin
  if Assigned(FButtonPanel) then
  begin
    if Orientation = soHorizontal then
      FButtonPanel.Height := Height
    else
      FButtonPanel.Width := Width;
  end;
end;

procedure TButtonBar.UpdateButtons(const AIsLast: Boolean = False);
var
  LIndex: Integer;
begin
  if not Assigned(FButtonPanel) or not (([csLoading, csDestroying] * ComponentState = []) or HandleAllocated) then
    Exit;

  if InUpdateBlock then
    Exit;

  if AIsLast or (FItems.Count = 0) then
  begin
    if Assigned(FButtonPanel) then
      FreeAndNil(FButtonPanel);

    Invalidate;
    Exit;
  end;

  LockDrawing;
  try
    FButtonPanel.AutoSize := False;
    FButtonPanel.Left := 0;
    FButtonPanel.Top := 0;

    SetButtonPanelSize;

    for LIndex := 0 to FItems.Count - 1 do
      Assign(FItems.Item[LIndex]);

    UpdateButtonPositions;

    FButtonPanel.AutoSize := True;
  finally
    UnlockDrawing;
  end;
end;

procedure TButtonBar.DummyClickEvent(ASender: TObject);
begin
  { Dummy click event for enabling button }
end;

{$IF NOT DEFINED(ALPHASKINS)}
function TButtonBar.ScaleInt(const ANumber: Integer): Integer;
begin
  Result := Muldiv(ANumber, CurrentPPI, 96);
end;
{$ENDIF}

procedure TButtonBar.Assign(ASource: TPersistent);
var
  LItem: TButtonBarCollectionItem;
  LTextWidth: Integer;
  LNotifyEvent: TNotifyEvent;
begin
  if InUpdateBlock then
    Exit;

  if ASource is TButtonBarCollectionItem then
  begin
    LItem := TButtonBarCollectionItem(ASource);

    LItem.Button.Action := LItem.Action;
    LItem.Button.AllowAllUp := LItem.AllowAllUp;
    LItem.Button.Cursor := LItem.Cursor;
    LItem.Button.Down := LItem.Down;
    LItem.Button.Flat := LItem.Flat;
    LItem.Button.GroupIndex := LItem.GroupIndex;
    if LItem.Layout = blGlyphLeft then
      LItem.Button.Margin := ScaleInt(3);
    LItem.Button.Images := FImages;
    if csDesigning in ComponentState then
      LItem.Button.Visible := True
    else
      LItem.Button.Visible := LItem.Visible;
    LItem.Button.OnBeforeMenuDropdown := OnBeforeMenuDropdown;

    if opShowHints in FOptions then
      LItem.Button.Hint := LItem.Hint
    else
      LItem.Button.Hint := '';

    if Assigned(LItem.Counter) then
      LItem.Button.Counter.Assign(LItem.Counter);

    if (LItem.Style = stDivider) or not (opShowCaptions in FOptions) then
      LItem.Button.Caption := ''
    else
      LItem.Button.Caption := LItem.Caption;

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
      LItem.Button.Font.Size := Font.Size;
      LItem.Button.DropdownMenu := LItem.Dropdown.PopupMenu;

{$IFDEF ALPHASKINS}
      LItem.Button.Blend := LItem.Blend;
      LItem.Button.DisabledGlyphKind := LItem.DisabledGlyphKind;
      LItem.Button.Reflected := LItem.Reflected;
      LItem.Button.ButtonStyle := tbsTextButton;
{$ENDIF}

      LNotifyEvent := DummyClickEvent;

      if LItem.Visible and LItem.Dropdown.Visible and Assigned(LItem.Dropdown.PopupMenu) and
        Assigned(LItem.Button.OnClick) and (@LItem.Action.OnExecute <> @LNotifyEvent) then
        CreateDropdownButton(LItem)
      else
      if Assigned(LItem.DropdownButton) then
        FreeAndNil(LItem.DropdownButton);

      if not (csDesigning in ComponentState) and LItem.Visible and LItem.Dropdown.Visible and
        Assigned(LItem.Dropdown.PopupMenu) and Assigned(LItem.Action) and not Assigned(LItem.Action.OnExecute) then
        LItem.Action.OnExecute := DummyClickEvent; { Action is disabled without execute event. }

      LItem.Button.DropdownButtonVisible := not Assigned(LItem.DropdownButton);

      if Assigned(LItem.DropdownButton) then
      begin
        LItem.DropdownButton.Style := csDropdown;
        LItem.DropdownButton.DropdownButtonVisible := True;
        LItem.DropdownButton.Flat := LItem.Flat;

        if Orientation = soHorizontal then
          LItem.DropdownButton.Align := alLeft
        else
          LItem.DropdownButton.Align := alTop;

        LItem.DropdownButton.DropdownMenu := LItem.Dropdown.PopupMenu;
        LItem.DropdownButton.Width := ScaleInt(LItem.Dropdown.ButtonWidth);
        LItem.DropdownButton.Hint := LItem.Dropdown.Hint;
        LItem.DropdownButton.Visible := LItem.Dropdown.Visible and LItem.Visible;
{$IFDEF ALPHASKINS}
        LItem.DropdownButton.ButtonStyle := tbsDropDown;
        LItem.DropdownButton.SplitterStyle := dsLine;
{$ENDIF}
      end
      else
      if Assigned(LItem.Button.DropdownMenu) then
      begin
{$IFDEF ALPHASKINS}
        LItem.Button.ButtonStyle := tbsDropDown;
        LItem.Button.SplitterStyle := dsLine;
{$ENDIF}
      end;

      if Orientation = soHorizontal then
      begin
        LItem.Button.Width := ScaleInt(FDefaults.ButtonSize);

        if opShowCaptions in FOptions then
        begin
          LItem.Button.Canvas.Font.Size := Font.Size;
          LTextWidth := LItem.Button.Canvas.TextWidth(LItem.Button.Caption) + ScaleInt(6); { 6 = 3 x 2 Margin }
          if LTextWidth > LItem.Button.Width then
            LItem.Button.Width := LTextWidth;
        end;

        if LItem.Button.DropdownButtonVisible and Assigned(LItem.Button.DropdownMenu) then
          LItem.Button.Width := LItem.Button.Width + ScaleInt(LItem.Dropdown.ButtonWidth);
      end
      else
        LItem.Button.Height := ScaleInt(FDefaults.ButtonSize);
    end;
  end
  else
    inherited;
end;

function TButtonBar.ShowNotItemsFound: Boolean;
begin
  Result := (csDesigning in ComponentState) and (FItems.Count = 0);
end;

procedure TButtonBar.WMPaint(var AMessage: TWMPaint);
begin
  if ShowNotItemsFound then
    ControlState := ControlState + [csCustomPaint];

  inherited;

  if ShowNotItemsFound then
     ControlState := ControlState - [csCustomPaint];
end;

procedure TButtonBar.WMSize(var AMessage: TWMSize);
begin
  SetButtonPanelSize;
end;

procedure TButtonBar.PaintWindow(DC: HDC);
begin
  if ShowNotItemsFound then
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
  end
  else
    inherited;
end;

procedure TButtonBar.Paint;
var
  LRect: TRect;
  LTextHeight, LTextWidth: Integer;
  LFlags: Cardinal;
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

  DrawText(FCanvas.Handle, ButtonBarNoItemsFound, -1, LRect, LFlags)
end;

procedure TButtonBar.SetImages(const AValue: TCustomImageList);
begin
  FImages := AValue;

  UpdateButtons;
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

function TButtonBar.GetItemByName(const AName: string): TButtonBarCollectionItem;
var
  LIndex: Integer;
  LItem: TButtonBarCollectionItem;
begin
  for LIndex := 0 to FItems.Count - 1 do
  begin
    LItem := Item[LIndex];

    if CompareText(LItem.Name, AName) = 0 then
      Exit(LItem);
  end;

  raise ESTButtonBarException.CreateResFmt(@ButtonBarNoItemFoundWithName, [AName]);
end;

end.

unit Form.Main;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Actions, System.Classes, System.ImageList, System.SysUtils, System.Variants,
  Vcl.ActnList, Vcl.ComCtrls, Vcl.Controls, Vcl.Dialogs, Vcl.Forms, Vcl.Graphics, Vcl.ImgList, Vcl.Menus,
  ButtonBar.Control;

type
  TMainForm = class(TForm)
    ActionDemo2: TAction;
    ActionDemo2Popup: TAction;
    ActionDemo4Popup: TAction;
    ActionList: TActionList;
    ButtonBar1: TButtonBar;
    ButtonBar2: TButtonBar;
    ButtonBar3: TButtonBar;
    ButtonBar4: TButtonBar;
    ImageList: TImageList;
    MenuItemPopupMenuDemo2: TMenuItem;
    MenuItemPopupMenuDemo4: TMenuItem;
    PopupMenuDemo2: TPopupMenu;
    PopupMenuDemo4: TPopupMenu;
    procedure ActionDemo2Execute(Sender: TObject);
    procedure ActionDemo2PopupExecute(Sender: TObject);
    procedure ActionDemo4PopupExecute(Sender: TObject);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ActionDemo2Execute(Sender: TObject);
begin
  ShowMessage('Demo 2 button click');
end;

procedure TMainForm.ActionDemo2PopupExecute(Sender: TObject);
begin
  ShowMessage('Demo 2 popup click');
end;

procedure TMainForm.ActionDemo4PopupExecute(Sender: TObject);
begin
  ShowMessage('Demo 4 only popup click');
end;

end.

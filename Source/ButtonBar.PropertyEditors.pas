unit ButtonBar.PropertyEditors;

interface

uses
  DesignEditors;

type
  TButtonBarCollectionEditor = class(TComponentEditor)
  public
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

implementation

uses
  ButtonBar.Control, ColnEdit;

function TButtonBarCollectionEditor.GetVerb(Index: Integer): string;
begin
  Result := 'Edit items...';
end;

function TButtonBarCollectionEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

procedure TButtonBarCollectionEditor.ExecuteVerb(Index: Integer);
begin
  inherited;

  ShowCollectionEditor(Designer, Component, TButtonBar(Component).Items, 'Items');
end;

end.

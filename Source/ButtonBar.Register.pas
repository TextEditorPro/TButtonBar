unit ButtonBar.Register;

interface

uses
  System.Classes, ButtonBar.Control;

procedure Register;

implementation

uses
  DesignIntf, ButtonBar.PropertyEditors;

procedure Register;
begin
  RegisterComponents('ButtonBar', [TButtonBar]);

  UnlistPublishedProperty(TButtonBar, 'Control');
  UnlistPublishedProperty(TButtonBar, 'DockSite');
  UnlistPublishedProperty(TButtonBar, 'DragCursor');
  UnlistPublishedProperty(TButtonBar, 'DragKind');
  UnlistPublishedProperty(TButtonBar, 'DragMode');
  UnlistPublishedProperty(TButtonBar, 'DragScroll');

  RegisterComponentEditor(TButtonBar,  TButtonBarCollectionEditor);
end;

end.

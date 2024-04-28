unit UField;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TField = class(TShape)
  private
    { Private-Deklarationen }
  public
    procedure FieldMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ShowName();
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TField }

constructor TField.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  Self.OnMouseDown := FieldMouseDown;

end;

procedure TField.FieldMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  //ShowName();

end;

procedure TField.ShowName();
begin

  ShowMessage(Self.Name);

end;

end.

unit UField;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TField = class(TShape)
  public
    procedure FeldHervorheben();
    procedure FeldhervorhebungAufheben();
    procedure FieldMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ShowName();
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TField }

constructor TField.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  OnMouseDown := FieldMouseDown;

  Pen.Width := 2;

end;

procedure TField.FeldHervorheben();
begin
  Pen.Color := clBlue;
end;

procedure TField.FeldhervorhebungAufheben();
begin
  Pen.Color := clBlack;
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

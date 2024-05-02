unit UField;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UFigur;

type
  TField = class(TShape)
  public
    procedure FeldHervorheben();
    procedure FeldhervorhebungAufheben();
    procedure FieldMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SetAusgewaehlteFigur(p_figur : TFigur);
    constructor Create(AOwner: TComponent); override;
  private
    class var ausgewaehlteFigur : TFigur;
  end;

implementation

{ TField }

constructor TField.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  OnMouseDown := FieldMouseDown;

  Pen.Width := 2;

end;

procedure TField.SetAusgewaehlteFigur(p_figur : TFigur);
begin
  ausgewaehlteFigur := p_figur;
end;

procedure TField.FeldHervorheben();
begin
  Pen.Width := 3;
  Pen.Color := clWebMediumAquamarine;
end;

procedure TField.FeldhervorhebungAufheben();
begin
  Pen.Color := clBlack;
  Pen.Width := 2;
end;

procedure TField.FieldMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin

  if (Pen.Color = clWebMediumAquamarine) then
  begin
    ausgewaehlteFigur.aktuellePositionX := 1;
  end;


end;

end.

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
    procedure FigurZuweisen(p_figur : TFigur);
    function GetZugewieseneFigur() : TFigur;
    constructor Create(AOwner: TComponent); override;
  private
    zugewieseneFigur : TFigur;
  end;

implementation

uses UController, UMain;

var
  controller : TController;

{ TField }

constructor TField.Create(AOwner: TComponent);
begin

  inherited Create(AOwner);
  OnMouseDown := FieldMouseDown;

  Pen.Width := 2;

  zugewieseneFigur := nil;

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
    //controller.SetAusgewaehlteFigurPositionX(1);
  end;


end;

procedure TField.FigurZuweisen(p_figur: TFigur);
begin
  zugewieseneFigur := p_figur;
end;

function TField.GetZugewieseneFigur() : TFigur;
var dummy : TFigur;
var istWeiss : boolean;
begin

  if (zugewieseneFigur = nil) then
  begin

    // Den Dummy das Gegenteil der Farbe der eigenen Figur setzen, damit der Feldwechsel definitiv stattfinden kann
    if (controller.GetAusgewaehlteFigur().GetIstWeiss()) then istWeiss := false else istWeiss := true;

    dummy := TFigur.Create(FormMain, istWeiss, 1234, 1234);

    result := dummy;
    exit;
  end;

  result := zugewieseneFigur;
end;

end.

unit USpringer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UFigur;

type
  TSpringer = class(TFigur)
  public
    procedure ZuegeBerechnen(); override;
  end;

implementation

{ TSpringer }

procedure TSpringer.ZuegeBerechnen();
var
  test : TZweiDimensionaleArray;
begin

  //legaleZuege :=  .........

end;

end.

unit UFigur;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

// wird ben�tigt, um eine zweidimensionale Array als R�ckgabetyp einer
// Funktion zu verwenden
type
  TZweiDimensionaleArray = array[1..8, 1..8] of Integer;

type
  TFigur = class

  private
    istWeiss : boolean;
  protected
    legaleZuege : TZweiDimensionaleArray; // gibt die Indexes der legalen Zuege in der fields2D Array zur�ck
    procedure ZuegeBerechnen(); virtual;
  public
    function GetZuege() : TZweiDimensionaleArray;
    constructor Create();
  end;

implementation

constructor TFigur.Create;
begin

end;

function TFigur.GetZuege() : TZweiDimensionaleArray;
begin
  ZuegeBerechnen();
  result := legaleZuege;
end;

procedure TFigur.ZuegeBerechnen();
var i, j : integer;
begin

  // kreiert Testdaten, wird im regul�ren Programmbetrieb
  // nicht aufgerufen, da Methode in den jeweiligen Kindern �berschrieben wird
  for i := 1 to 8 do
    for j := 1 to 8 do
      legaleZuege[i][j] := i * j;
end;

end.


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

// gibt eine Liste der legalen Springerzuege im fields2D Array zur�ck
procedure TSpringer.ZuegeBerechnen();
var
  moeglichkeit : array[1..2] of integer;
  moeglichkeitenTheoretisch : array[1..64, 1..2] of integer;
  moeglichkeitenTatsaechlich : TZweiDimensionaleArray;
  i: Integer;
begin

  {

   Moeglichkeiten Springerzuege:

   X    Y
   +1   +2
   +1   -2
   -1   +2
   -1   -2
   +2   +1
   +2   -1
   -2   +1
   -2   -1

  }

    // Moeglichkeit 1, Koordinate X
    moeglichkeitenTheoretisch[1, 1] := aktuelleKoordinateX + 1;
    // Moeglichkeit 1, Koordinate Y
    moeglichkeitenTheoretisch[1, 2] := aktuelleKoordinateY + 2;

    moeglichkeitenTheoretisch[2, 1] := aktuelleKoordinateX + 1;
    moeglichkeitenTheoretisch[2, 2] := aktuelleKoordinateY - 2;

    moeglichkeitenTheoretisch[3, 1] := aktuelleKoordinateX - 1;
    moeglichkeitenTheoretisch[3, 2] := aktuelleKoordinateY + 2;

    moeglichkeitenTheoretisch[4, 1] := aktuelleKoordinateX - 1;
    moeglichkeitenTheoretisch[4, 2] := aktuelleKoordinateY - 2;

    moeglichkeitenTheoretisch[5, 1] := aktuelleKoordinateX + 2;
    moeglichkeitenTheoretisch[5, 2] := aktuelleKoordinateY + 1;

    moeglichkeitenTheoretisch[6, 1] := aktuelleKoordinateX + 2;
    moeglichkeitenTheoretisch[6, 2] := aktuelleKoordinateY - 1;

    moeglichkeitenTheoretisch[7, 1] := aktuelleKoordinateX - 2;
    moeglichkeitenTheoretisch[7, 2] := aktuelleKoordinateY + 1;

    moeglichkeitenTheoretisch[8, 1] := aktuelleKoordinateX - 2;
    moeglichkeitenTheoretisch[8, 2] := aktuelleKoordinateY - 1;

    // Rest der Array mit 0, 0 fuellen, damit der Hauptcode, der immer durch
    // alle 64 iteriert, weiss, dass da nichts mehr kommt
    for i := 9 to 64 do
    begin

      moeglichkeitenTheoretisch[i, 1] := 0;
      moeglichkeitenTheoretisch[i, 2] := 0;

    end;

    // Manche Moeglichkeiten sind noch illegale Zuege, das Brett ist ja nicht
    // unbegrenzt, also werden jetzt Koordinaten ueber 8 und kleiner 0
    // geloescht (0 nicht, weil das ja der Platzhalter ist)

    for i := 1 to 64 do
    begin

      if (moeglichkeitenTheoretisch[i, 1] > 8)
      or (moeglichkeitenTheoretisch[i, 2] > 8)
      or (moeglichkeitenTheoretisch[i, 1] < 0)
      or (moeglichkeitenTheoretisch[i, 2] < 0) then
      begin

        // hier war ich stehen geblieben

      end;


    end;


  legaleZuege := moeglichkeitenTatsaechlich;

end;

end.
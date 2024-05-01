unit UBauer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UFigur;

type
  TBauer = class(TFigur)
  public
    procedure ZuegeBerechnen(); override;
    constructor Create(p_istWeiss: boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY: integer);
  end;

implementation

{ TBauer }

// gibt eine Liste der legalen Laeuferzuege im fields2D Array zurueck
constructor TBauer.Create(p_istWeiss: boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY: integer);
begin

  inherited Create(p_istWeiss, p_aktuelleKoordinateX, p_aktuelleKoordinateY);

  if (p_istWeiss) then pfad := 'Bauer-w.png' else pfad := 'Bauer-s.png';
end;

procedure TBauer.ZuegeBerechnen();
var
  moeglichkeitenTheoretisch : array[1..64, 1..2] of integer;
  moeglichkeitenTatsaechlich : TZweiDimensionaleArray;
  i, hinzugefuegteZuege: Integer;
begin

  {

   Moeglichkeiten Bauernzuege:

   X          Y
   +0         +1
   +0         +2  (nur wenn noch nicht bewegt)
   +1         +1  (nur beim Schlagen)
   -1         +1  (nur beim Schlagen)

  }

    // Moeglichkeit 1, Koordinate X
    moeglichkeitenTheoretisch[1, 1] := aktuelleKoordinateX;
    // Moeglichkeit 1, Koordinate Y
    moeglichkeitenTheoretisch[1, 2] := aktuelleKoordinateY + 1;

    moeglichkeitenTheoretisch[1, 1] := aktuelleKoordinateX;
    moeglichkeitenTheoretisch[1, 2] := aktuelleKoordinateY + 2;

    moeglichkeitenTheoretisch[1, 1] := aktuelleKoordinateX + 1;
    moeglichkeitenTheoretisch[1, 2] := aktuelleKoordinateY + 1;

    moeglichkeitenTheoretisch[1, 1] := aktuelleKoordinateX - 1;
    moeglichkeitenTheoretisch[1, 2] := aktuelleKoordinateY + 1;

    // Rest der Array mit 0, 0 fuellen, damit der Hauptcode, der immer durch
    // alle 64 iteriert, weiss, dass da nichts mehr kommt
    for i := 5 to 64 do
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

        // illegale Moeglichkeiten 0 setzen
        moeglichkeitenTheoretisch[i, 1] := 0;
        moeglichkeitenTheoretisch[i, 2] := 0;
      end;

    end;

    hinzugefuegteZuege := 0;

    for i := 1 to 64 do
    begin

      // nochmal durch alle iterieren und die Nicht-Null-Datens�tze in
      // die tatsaechliche Ausgabe-Array packen

      if (moeglichkeitenTheoretisch[i, 1] <> 0) and (moeglichkeitenTheoretisch[i, 2] <> 0) then
      begin

        Inc(hinzugefuegteZuege);
        moeglichkeitenTatsaechlich[hinzugefuegteZuege, 1] := moeglichkeitenTheoretisch[i, 1];
        moeglichkeitenTatsaechlich[hinzugefuegteZuege, 2] := moeglichkeitenTheoretisch[i, 2];

      end;

    end;

    // und abschliessend alle nicht benutzten Felder der Array wieder mit 0, 0 f�llen
    for i := hinzugefuegteZuege + 1 to 64 do
    begin

      moeglichkeitenTatsaechlich[i, 1] := 0;
      moeglichkeitenTatsaechlich[i, 2] := 0;

    end;

  legaleZuege := moeglichkeitenTatsaechlich;

end;

end.
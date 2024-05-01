unit UTurm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UFigur;

type
  TTurm = class(TFigur)
  public
    procedure ZuegeBerechnen(); override;
    constructor Create(p_istWeiss: boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY: integer);
  end;

implementation

{ TLaeufer }

// gibt eine Liste der legalen Turmzuege im fields2D Array zurueck
constructor TTurm.Create(p_istWeiss: boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY: integer);
begin

  inherited Create(p_istWeiss, p_aktuelleKoordinateX, p_aktuelleKoordinateY);

  if (p_istWeiss) then pfad := 'turm-w.png' else pfad := 'turm-s.png';
end;

procedure TTurm.ZuegeBerechnen();
var
  moeglichkeitenTheoretisch : array[1..64, 1..2] of integer;
  moeglichkeitenTatsaechlich : TZweiDimensionaleArray;
  i, j, hinzugefuegteZuege, moeglichkeitNummer: Integer;
begin

  {

   Moeglichkeiten Turmzuege:

   X          Y
   +1...+7    +0
   -1...-7    +0
   +0       +1...+7
   +0       -1...-7

  }

  moeglichkeitNummer := 1;

  // Laufrichtungen
  for i := 1 to 4 do
  begin

    // Moeglichkeiten pro Richtung
    for j := 1 to 7 do
    begin

      case i of

        1:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX + j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY;
          end;
        2:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX - j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY;
          end;
        3:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY + j;
          end;
        4:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY - j;
          end;

      end;

      Inc(moeglichkeitNummer);

    end;

  end;

    // Rest der Array mit 0, 0 fuellen, damit der Hauptcode, der immer durch
    // alle 64 iteriert, weiss, dass da nichts mehr kommt
    for i := 29 to 64 do
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

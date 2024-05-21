unit UDame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UFigur;

type
  TDame = class(TFigur)
  public
    procedure ZuegeBerechnen(); override;
    function KategorisiereDiagonaleZuege() : TArray<Integer>;
    constructor Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
  end;

implementation

{ TDame }

uses UController;

constructor TDame.Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
begin

  inherited Create(p_Form, p_istWeiss, p_aktuelleKoordinateX, p_aktuelleKoordinateY);

  if (p_istWeiss) then pfad := 'dame-w.png' else pfad := 'dame-s.png';
  BildLaden();

end;

// gibt eine Liste der legalen Damenzuege im fields2D Array zurück
procedure TDame.ZuegeBerechnen();
var
  moeglichkeitenTheoretisch : array[1..64, 1..2] of integer;
  moeglichkeitenTatsaechlich : TZweiDimensionaleArray;
  i, j, hinzugefuegteZuege, moeglichkeitNummer: Integer;
begin

  {

   Moeglichkeiten Damenzuege:

   = Turmzuege

   X          Y
   +1...+7    +0
   -1...-7    +0
   +0       +1...+7
   +0       -1...-7

   + Laeuferzuege

   X          Y
   +1...+7    +1...+7
   +1...-7    -1...+7
   -1...+7    +1...+7
   -1...+7    -1...-7

  }

    // das muss hier sein sonst kommen ganz komische Sachen raus
    for i := 1 to 64 do
    begin
      moeglichkeitenTheoretisch[i, 1] := 0;
      moeglichkeitenTheoretisch[i, 2] := 0;
      moeglichkeitenTatsaechlich[i, 1] := 0;
      moeglichkeitenTatsaechlich[i, 2] := 0;
    end;

  moeglichkeitNummer := 1;

  for i := 1 to 4 do
  begin

    for j := 1 to 7 do
    begin

      case i of

        1:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX + j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY;

            Inc(moeglichkeitNummer);

            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX + j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY + j;
          end;
        2:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX - j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY;

            Inc(moeglichkeitNummer);

            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX + j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY - j;
          end;
        3:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY + j;

            Inc(moeglichkeitNummer);

            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX - j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY + j;
          end;
        4:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY - j;

            Inc(moeglichkeitNummer);

            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX - j;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY - j;
          end;

      end;

      Inc(moeglichkeitNummer);

    end;

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

      // nochmal durch alle iterieren und die Nicht-Null-Datensätze in
      // die tatsaechliche Ausgabe-Array packen

      if (moeglichkeitenTheoretisch[i, 1] <> 0) and (moeglichkeitenTheoretisch[i, 2] <> 0) then
      begin

        Inc(hinzugefuegteZuege);
        moeglichkeitenTatsaechlich[hinzugefuegteZuege, 1] := moeglichkeitenTheoretisch[i, 1];
        moeglichkeitenTatsaechlich[hinzugefuegteZuege, 2] := moeglichkeitenTheoretisch[i, 2];

      end;

    end;

    // und abschliessend alle nicht benutzten Felder der Array wieder mit 0, 0 füllen
    for i := hinzugefuegteZuege + 1 to 64 do
    begin

      moeglichkeitenTatsaechlich[i, 1] := 0;
      moeglichkeitenTatsaechlich[i, 2] := 0;

    end;

  legaleZuege := moeglichkeitenTatsaechlich;

end;

function TDame.KategorisiereDiagonaleZuege(p_hervorgehoben : integer, p_hervorgehobeneFelder : THervorgehobeneFelderArray) : TArray<Integer>;
var
  letzteIndexe: TArray<Integer>;
  i: Integer;
begin
  SetLength(letzteIndexe, 8);
  for i := 0 to 7 do
    letzteIndexe[i] := 0;

  for i := 1 to p_hervorgehoben do
  begin
    if (p_hervorgehobeneFelder[i] = nil) then break;
    var feldX := p_hervorgehobeneFelder[i].GetX();
    var feldY := p_hervorgehobeneFelder[i].GetY();

    if (feldX > aktuelleKoordinateX) and (feldY > aktuelleKoordinateY) then
      letzteIndexe[0] := i // Diagonal oben rechts
    else if (feldX > aktuelleKoordinateX) and (feldY < aktuelleKoordinateY) then
      letzteIndexe[1] := i // Diagonal unten rechts
    else if (feldX < aktuelleKoordinateX) and (feldY > aktuelleKoordinateY) then
      letzteIndexe[2] := i // Diagonal oben links
    else if (feldX < aktuelleKoordinateX) and (feldY < aktuelleKoordinateY) then
      letzteIndexe[3] := i // Diagonal unten links
    else if (feldX > aktuelleKoordinateX) and (feldY = aktuelleKoordinateY) then
      letzteIndexe[4] := i // Horizontal rechts
    else if (feldX < aktuelleKoordinateX) and (feldY = aktuelleKoordinateY) then
      letzteIndexe[5] := i // Horizontal links
    else if (feldX = aktuelleKoordinateX) and (feldY > aktuelleKoordinateY) then
      letzteIndexe[6] := i // Vertikal oben
    else if (feldX = aktuelleKoordinateX) and (feldY < aktuelleKoordinateY) then
      letzteIndexe[7] := i // Vertikal unten
  end;

  Result := letzteIndexe;
end;


end.

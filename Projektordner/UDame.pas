unit UDame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UFigur;

type
  TDame = class(TFigur)
  public
    procedure ZuegeBerechnen(); override;
    constructor Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
  end;

implementation

{ TDame }

constructor TDame.Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
begin

  inherited Create(p_Form, p_istWeiss, p_aktuelleKoordinateX, p_aktuelleKoordinateY);

  if (p_istWeiss) then pfad := 'dame-w.png' else pfad := 'dame-s.png';
  BildLaden();

end;

// gibt eine Liste der legalen Damenzuege im fields2D Array zur�ck
procedure TDame.ZuegeBerechnen();
var
  moeglichkeitenTheoretisch: array[1..64, 1..2] of integer;
  moeglichkeitenTatsaechlich: TZweiDimensionaleArray;
  i, j, hinzugefuegteZuege, moeglichkeitNummer: Integer;
begin
  // das muss hier sein sonst kommen ganz komische Sachen raus
  for i := 1 to 64 do
  begin
    moeglichkeitenTheoretisch[i, 1] := 0;
    moeglichkeitenTheoretisch[i, 2] := 0;
    moeglichkeitenTatsaechlich[i, 1] := 0;
    moeglichkeitenTatsaechlich[i, 2] := 0;
  end;

  moeglichkeitNummer := 1;

  for i := 1 to 8 do
  begin
    for j := 1 to 7 do
    begin
      case i of
        1:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX + j; // nach rechts
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY;
          end;
        2:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX - j; // nach links
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY;
          end;
        3:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY + j; // nach unten
          end;
        4:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX;
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY - j; // nach oben
          end;
        5:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX + j; // nach rechts unten
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY + j;
          end;
        6:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX + j; // nach rechts oben
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY - j;
          end;
        7:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX - j; // nach links unten
            moeglichkeitenTheoretisch[moeglichkeitNummer, 2] := aktuelleKoordinateY + j;
          end;
        8:
          begin
            moeglichkeitenTheoretisch[moeglichkeitNummer, 1] := aktuelleKoordinateX - j; // nach links oben
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
    or (moeglichkeitenTheoretisch[i, 1] < 1)
    or (moeglichkeitenTheoretisch[i, 2] < 1) then
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

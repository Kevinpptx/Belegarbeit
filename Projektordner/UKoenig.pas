unit UKoenig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UFigur;

type
  TKoenig = class(TFigur)
  public
    procedure ZuegeBerechnen(); override;
    procedure SetImSchach(p_stehtImSchach : boolean);
    function GetImSchach() : boolean;
    constructor Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
  private
    stehtImSchach : boolean;
  end;

implementation

{ TKoenig }

constructor TKoenig.Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
begin

  inherited Create(p_Form, p_istWeiss, p_aktuelleKoordinateX, p_aktuelleKoordinateY);

  if (p_istWeiss) then pfad := 'koenig-w.png' else pfad := 'koenig-s.png';
  BildLaden();

  stehtImSchach := false;

end;

function TKoenig.GetImSchach(): boolean;
begin
  result := stehtImSchach;
end;

procedure TKoenig.SetImSchach(p_stehtImSchach: boolean);
begin
  stehtImSchach := p_stehtImSchach;
end;

// gibt eine Liste der legalen Koenigszuege im fields2D Array zurueck
procedure TKoenig.ZuegeBerechnen();
var
  moeglichkeitenTheoretisch : array[1..64, 1..2] of integer;
  moeglichkeitenTatsaechlich : TZweiDimensionaleArray;
  i, hinzugefuegteZuege: Integer;
begin

  {

   Moeglichkeiten Koenigszuege:

   X          Y
   +1         +0
   +1         +1
   +1         -1
   -1         +0
   -1         +1
   -1         -1
   +0         +1
   +0         -1

  }

    // Moeglichkeit 1, Koordinate X
    moeglichkeitenTheoretisch[1, 1] := aktuelleKoordinateX + 1;
    // Moeglichkeit 1, Koordinate Y
    moeglichkeitenTheoretisch[1, 2] := aktuelleKoordinateY;

    moeglichkeitenTheoretisch[2, 1] := aktuelleKoordinateX + 1;
    moeglichkeitenTheoretisch[2, 2] := aktuelleKoordinateY + 1;

    moeglichkeitenTheoretisch[3, 1] := aktuelleKoordinateX + 1;
    moeglichkeitenTheoretisch[3, 2] := aktuelleKoordinateY - 1;

    moeglichkeitenTheoretisch[4, 1] := aktuelleKoordinateX - 1;
    moeglichkeitenTheoretisch[4, 2] := aktuelleKoordinateY;

    moeglichkeitenTheoretisch[5, 1] := aktuelleKoordinateX - 1;
    moeglichkeitenTheoretisch[5, 2] := aktuelleKoordinateY + 1;

    moeglichkeitenTheoretisch[6, 1] := aktuelleKoordinateX - 1;
    moeglichkeitenTheoretisch[6, 2] := aktuelleKoordinateY - 1;

    moeglichkeitenTheoretisch[7, 1] := aktuelleKoordinateX;
    moeglichkeitenTheoretisch[7, 2] := aktuelleKoordinateY + 1;

    moeglichkeitenTheoretisch[8, 1] := aktuelleKoordinateX;
    moeglichkeitenTheoretisch[8, 2] := aktuelleKoordinateY - 1;

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

end.

unit UFigur;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

// wird benoetigt, um eine zweidimensionale Array als Rückgabetyp einer
// Funktion zu verwenden
type
  TZweiDimensionaleArray = array[1..64, 1..2] of Integer;

type
  TFigur = class abstract(TImage)
  protected
    pfad : string;
    istWeiss, ersterZug { ersterZug nur fuer Bauern wichtig } : boolean;
    legaleZuege : TZweiDimensionaleArray; // [MoeglichkeitNr][1 = X / 2 = Y (in fields2D)]
    aktuelleKoordinateX : integer; // gibt die Koordinate X der aktuellen Position in der fields2D Array zurück
    aktuelleKoordinateY : integer; // gibt die Koordinate Y der aktuellen Position in der fields2D Array zurück
    procedure ZuegeBerechnen(); virtual; abstract;
    procedure BildLaden();
    procedure ZuegeAnzeigen();
    procedure Click(); override;
    function KategorisiereDiagonaleZuege() : TArray<Integer>; virtual;
  public
    procedure SetAktuelleKoordinateX(p_x : integer);
    procedure SetAktuelleKoordinateY(p_y : integer);
    function GetAktuelleKoordinateX() : integer;
    function GetAktuelleKoordinateY() : integer;
    function GetZuege() : TZweiDimensionaleArray;
    function GetIstWeiss() : boolean;
    constructor Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
  private
    class var hervorgehoben : integer;
  end;

implementation

uses UMain, UController, USpringer, UBauer, ULaeufer, UTurm, UKoenig, UDame, UField;

var
  controller : TController;

procedure TFigur.BildLaden();
begin

  Picture.LoadFromFile(pfad);
  Transparent := true;
  Stretch := true;
  BringToFront();

end;

constructor TFigur.Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
var
  i: Integer;
begin

  inherited Create(p_Form);

  istWeiss := p_istWeiss;
  ersterZug := true;
  aktuelleKoordinateX := p_aktuelleKoordinateX;
  aktuelleKoordinateY := p_aktuelleKoordinateY;
  pfad := '';
  Parent := p_Form;

  if (controller = nil) then
    controller := TController.Create();

end;

procedure TFigur.ZuegeAnzeigen();
var
  i, j, k, aktuelleX, aktuelleY, anzahlLegalerZuege, indexLegalerZuege, ignorierenBisIndex, zuletztGepruefteKoordinateX, zuletztGepruefteKoordinateY,
  pruefKoordinateX, pruefKoordinateY: Integer;
  felder : TFields2DArrayZumUebergeben;
  hervorgehobeneFelder, legaleFelderFinal : THervorgehobeneFelderArray;
  richtungen: array[1..8] of TPoint;
  blockiert: array[1..8] of Boolean;
begin

  controller.HervorgehobeneFelderZuruecksetzen();

  indexLegalerZuege := 1;
  anzahlLegalerZuege := 0;

  felder := FormMain.GetFields2D();
  hervorgehobeneFelder := controller.GetHervorgehobeneFelder();
  ZuegeBerechnen();

  hervorgehoben := 0;

  // Hervorgehobene Felder - Liste vorbereiten
  for i := 1 to 64 do
  begin

    if (legaleZuege[i, 1] = 0) or (legaleZuege[i, 2] = 0) then break;

    Inc(hervorgehoben);
    hervorgehobeneFelder[hervorgehoben] := felder[legaleZuege[i, 2], legaleZuege[i, 1]];

  end;

  // Bevor wir sie wirklich an den Controller uebergeben noch checken, ob Figuren im Weg
  var gecheckteFigur : TFigur;

  if (self.ClassType = TBauer) then
  begin

    controller.SetAusgewaehlteFigur(self);

    anzahlLegalerZuege := 4;

    var nichtPruefen : boolean;

    nichtPruefen := false;

    if (self.istWeiss) then
    begin

      // rechts schlagbar?
      if (self.aktuelleKoordinateX + 1 <= 8) and (self.aktuelleKoordinateY - 1 >= 1) then
      begin
        if not(felder[self.aktuelleKoordinateY - 1, self.aktuelleKoordinateX + 1].GetZugewieseneFigur().istWeiss = self.istWeiss)
        and not (felder[self.aktuelleKoordinateY - 1, self.aktuelleKoordinateX + 1].GetZugewieseneFigur().GetAktuelleKoordinateX = 1234) then
        begin
          legaleFelderFinal[indexLegalerZuege] := felder[self.aktuelleKoordinateY - 1, self.aktuelleKoordinateX + 1];
          Inc(indexLegalerZuege);
        end
        else Dec(anzahlLegalerZuege);
      end
      else Dec(anzahlLegalerZuege);

      // links schlagbar?
      if (self.aktuelleKoordinateX - 1 >= 1) and (self.aktuelleKoordinateY - 1 >= 1) then
      begin
        if not(felder[self.aktuelleKoordinateY - 1, self.aktuelleKoordinateX - 1].GetZugewieseneFigur().istWeiss = self.istWeiss)
        and not (felder[self.aktuelleKoordinateY - 1, self.aktuelleKoordinateX - 1].GetZugewieseneFigur().GetAktuelleKoordinateX = 1234) then
        begin
          legaleFelderFinal[indexLegalerZuege] := felder[self.aktuelleKoordinateY - 1, self.aktuelleKoordinateX - 1];
          Inc(indexLegalerZuege);
        end
        else Dec(anzahlLegalerZuege);
      end
      else Dec(anzahlLegalerZuege);

      // Figur im Weg bei 1 nach vorn?
      if (aktuelleKoordinateY - 1 >= 1) then
      begin
        if not (felder[aktuelleKoordinateY - 1, aktuelleKoordinateX].GetZugewieseneFigur.istWeiss = self.istWeiss) then
        begin
          legaleFelderFinal[indexLegalerZuege] := felder[aktuelleKoordinateY - 1, aktuelleKoordinateX];
          Inc(indexLegalerZuege);
        end
        else
        begin
          Dec(anzahlLegalerZuege);
          nichtPruefen := true;
        end;
      end
      else Dec(anzahlLegalerZuege);

      // erster Zug (2 Felder darf er vor)? Figur im Weg bei 2 nach vorn?
      if not (nichtPruefen) then
      begin
        if (ersterZug) then begin
          if (aktuelleKoordinateY - 2 >= 1) then
          begin
            if not (felder[aktuelleKoordinateY - 2, aktuelleKoordinateX].GetZugewieseneFigur.istWeiss = self.istWeiss) then
            begin
              legaleFelderFinal[indexLegalerZuege] := felder[aktuelleKoordinateY - 2, aktuelleKoordinateX];
              Inc(indexLegalerZuege);
              ersterZug := false;
            end
            else Dec(anzahlLegalerZuege);
          end
          else Dec(anzahlLegalerZuege);
        end
        else Dec(anzahlLegalerZuege);
      end
      else Dec(anzahlLegalerZuege);

    end
    else
    begin

      // links schlagbar?
      if (self.aktuelleKoordinateX + 1 <= 8) and (self.aktuelleKoordinateY + 1 <= 8) then
      begin
        if not(felder[self.aktuelleKoordinateY + 1, self.aktuelleKoordinateX + 1].GetZugewieseneFigur().istWeiss = self.istWeiss)
        and not(felder[self.aktuelleKoordinateY + 1, self.aktuelleKoordinateX + 1].GetZugewieseneFigur().GetAktuelleKoordinateX() = 1234) then
        begin
          legaleFelderFinal[indexLegalerZuege] := felder[self.aktuelleKoordinateY + 1, self.aktuelleKoordinateX + 1];
          Inc(indexLegalerZuege);
        end
        else Dec(anzahlLegalerZuege);
      end
      else Dec(anzahlLegalerZuege);

      // rechts schlagbar?
      if (self.aktuelleKoordinateX - 1 >= 8) and (self.aktuelleKoordinateY + 1 <= 8) then
      begin
        if not(felder[self.aktuelleKoordinateY + 1, self.aktuelleKoordinateX - 1].GetZugewieseneFigur().istWeiss = self.istWeiss)
        and not (felder[self.aktuelleKoordinateY + 1, self.aktuelleKoordinateX - 1].GetZugewieseneFigur().GetAktuelleKoordinateX() = 1234) then
        begin
          legaleFelderFinal[indexLegalerZuege] := felder[self.aktuelleKoordinateY + 1, self.aktuelleKoordinateX - 1];
          Inc(indexLegalerZuege);
        end
        else Dec(anzahlLegalerZuege);
      end
      else Dec(anzahlLegalerZuege);

      // Figur im Weg bei 1 nach vorn?
      if (aktuelleKoordinateY + 1 <= 8) then
      begin
        if not (felder[aktuelleKoordinateY + 1, aktuelleKoordinateX].GetZugewieseneFigur.istWeiss = self.istWeiss) then
        begin
          legaleFelderFinal[indexLegalerZuege] := felder[aktuelleKoordinateY + 1, aktuelleKoordinateX];
          Inc(indexLegalerZuege);
        end
        else
        begin
          Dec(anzahlLegalerZuege);
          nichtPruefen := true;
        end
      end
      else Dec(anzahlLegalerZuege);

      // erster Zug (2 Felder darf er vor)? Figur im Weg bei 2 nach vorn?
      if not (nichtPruefen) then
      begin
        if (ersterZug) then begin
          if (aktuelleKoordinateY + 2 >= 1) then
          begin
            if not (felder[aktuelleKoordinateY + 2, aktuelleKoordinateX].GetZugewieseneFigur.istWeiss = self.istWeiss) then
            begin
              legaleFelderFinal[indexLegalerZuege] := felder[aktuelleKoordinateY + 2, aktuelleKoordinateX];
              Inc(indexLegalerZuege);
              ersterZug := false;
            end
            else Dec(anzahlLegalerZuege);
          end
          else Dec(anzahlLegalerZuege);
        end
        else Dec(anzahlLegalerZuege);
      end
      else Dec(anzahlLegalerZuege);

    end;

  end
  else if (self.ClassType = TSpringer) then
  begin

    controller.SetAusgewaehlteFigur(self);

    for i := 1 to hervorgehoben do
    begin

      if (hervorgehobeneFelder[i] = nil) then break;

      //controller.SetAusgewaehlteFigur(self);
      gecheckteFigur := hervorgehobeneFelder[i].GetZugewieseneFigur();

      if (gecheckteFigur.istWeiss = self.istWeiss) then
      begin
        // illegal
      end
      else
      begin
        // legal
        legaleFelderFinal[indexLegalerZuege] := hervorgehobeneFelder[i];
        Inc(indexLegalerZuege);
        Inc(anzahlLegalerZuege);
      end;

    end;

  end
  else if (self.ClassType = TLaeufer) then
  begin

    controller.SetAusgewaehlteFigur(self);

    var letzteIndexe : TArray<Integer>;
    letzteIndexe := KategorisiereDiagonaleZuege();

    ignorierenBisIndex := 0;

    for i := 1 to hervorgehoben do
    begin

      if (hervorgehobeneFelder[i] = nil) then break;

      //controller.SetAusgewaehlteFigur(self);
      gecheckteFigur := hervorgehobeneFelder[i].GetZugewieseneFigur();

      if (gecheckteFigur.istWeiss = self.istWeiss) then
      begin
        // illegal

        // gucken, was dieses (geblockte) Feld fuer ein Zugtyp (Oben rechts, unten rechts, usw.) waere, dann alle vom selben Typ ignorieren

        if (letzteIndexe[0] <> 0) and (i <= letzteIndexe[0]) then
        begin
          //ShowMessage('Das Feld ' + hervorgehobeneFelder[i].Name + ' geht nach unten rechts');
          ignorierenBisIndex := letzteIndexe[0];
        end
        else if (letzteIndexe[1] <> 0) and (i <= letzteIndexe[1]) then
        begin
          //ShowMessage('Das Feld ' + hervorgehobeneFelder[i].Name + ' geht nach oben rechts');
          ignorierenBisIndex := letzteIndexe[1];
        end
        else if (letzteIndexe[2] <> 0) and (i <= letzteIndexe[2]) then
        begin
          //ShowMessage('Das Feld ' + hervorgehobeneFelder[i].Name + ' geht nach unten links');
          ignorierenBisIndex := letzteIndexe[2];
        end
        else if (letzteIndexe[3] <> 0) and (i <= letzteIndexe[3]) then
        begin
          //ShowMessage('Das Feld ' + hervorgehobeneFelder[i].Name + ' geht nach oben links');
          ignorierenBisIndex := letzteIndexe[3];
        end;
      end
      else
      begin
        // legal

        if not (i <= ignorierenBisIndex) then
        begin
          legaleFelderFinal[indexLegalerZuege] := hervorgehobeneFelder[i];
          Inc(indexLegalerZuege);
          Inc(anzahlLegalerZuege);
        end;

      end;

    end;

  end
  else if (self.ClassType = TTurm) then
  begin

    controller.SetAusgewaehlteFigur(self);

    ignorierenBisIndex := 0;

    for i := 1 to hervorgehoben do
    begin

      //controller.SetAusgewaehlteFigur(self);
      gecheckteFigur := hervorgehobeneFelder[i].GetZugewieseneFigur();

      // Feld der Figur im fields2D-Array finden, um den FeldIndex (Koordinaten) zu kriegens
      for j := 1 to 8 do
        for k := 1 to 8 do
          if (felder[j, k] = hervorgehobeneFelder[i]) then
          begin
            pruefKoordinateX := k;
            pruefKoordinateY := j;
            break;
          end;

      // In welche Richtung geht der Turm?
      if (i <> 1) and (zuletztGepruefteKoordinateX <> pruefKoordinateX) and (zuletztGepruefteKoordinateY <> pruefKoordinateY) then
      begin

        if (zuletztGepruefteKoordinateX > aktuelleKoordinateX) and (zuletztGepruefteKoordinateY > aktuelleKoordinateY) then


      end
      else
      if (i <> 1) and (zuletztGepruefteKoordinateX <> pruefKoordinateX) then
      begin
        if (zuletztGepruefteKoordinateX > pruefKoordinateX) then
        begin
          ShowMessage('Richtung: links' + ' mit i = ' + inttostr(i));
        end
        else if (zuletztGepruefteKoordinateX < pruefKoordinateX) then ShowMessage('Richtung: rechts' + ' mit i = ' + inttostr(i));
      end
      else
      if (i <> 1) and (zuletztGepruefteKoordinateY <> pruefKoordinateY) then
      begin
        if (zuletztGepruefteKoordinateY > pruefKoordinateY) then
        begin
          ShowMessage('Richtung: oben' + ' mit i = ' + inttostr(i));
        end
        else if (zuletztGepruefteKoordinateY < pruefKoordinateY) then ShowMessage('Richtung: unten' + ' mit i = ' + inttostr(i));
      end;

      zuletztGepruefteKoordinateX := pruefKoordinateX;
      zuletztGepruefteKoordinateY := pruefKoordinateY;

      if (gecheckteFigur.istWeiss = self.istWeiss) then
      begin
        // illegal

        var nameAktuellesFeld : string;
        var spalteAktuellesFeld : char;
        var reiheAktuellesFeld, checkIndex : integer;

        nameAktuellesFeld := felder[aktuelleKoordinateY, aktuelleKoordinateX].Name;
        spalteAktuellesFeld := nameAktuellesFeld[1];
        reiheAktuellesFeld := strtoint(nameAktuellesFeld[2]);

        checkIndex := i + 1;

        // unnoetige while-Durchlaeufe vermeiden
        //if not (ignorierenBisIndex >= checkIndex) then
        //begin

        while (hervorgehobeneFelder[checkIndex].Name[1] = spalteAktuellesFeld) do
        begin

          ignorierenBisIndex := checkIndex;
          Inc(checkIndex);

          if (checkIndex > hervorgehoben) then break;

        end;

        checkIndex := i + 1;

        while (strtoint(hervorgehobeneFelder[checkIndex].Name[2]) = reiheAktuellesFeld) do
        begin

          if not (ignorierenBisIndex >= checkIndex) then ignorierenBisIndex := checkIndex;

          Inc(checkIndex);

          if (checkIndex > hervorgehoben) then break;

        end;

        //end;

      end
      else
      begin
        // legal
        if not (i <= ignorierenBisIndex) then
        begin
          legaleFelderFinal[indexLegalerZuege] := hervorgehobeneFelder[i];
          Inc(indexLegalerZuege);
          Inc(anzahlLegalerZuege);
        end;

      end;

    end;

  end
  else if (self.ClassType = TKoenig) then
  begin

    controller.SetAusgewaehlteFigur(self);

    for i := 1 to hervorgehoben do
    begin

      //controller.SetAusgewaehlteFigur(self);
      gecheckteFigur := hervorgehobeneFelder[i].GetZugewieseneFigur();

      if (gecheckteFigur.istWeiss = self.istWeiss) then
      begin
        // illegal
      end
      else
      begin
        // legal
        legaleFelderFinal[indexLegalerZuege] := hervorgehobeneFelder[i];
        Inc(indexLegalerZuege);
        Inc(anzahlLegalerZuege);
      end;

    end;

  end
else if (self.ClassType = TDame) then
  begin

    controller.SetAusgewaehlteFigur(self);

    aktuelleX := self.GetAktuelleKoordinateX();
    aktuelleY := self.GetAktuelleKoordinateY();

    richtungen[1] := Point(1, 0);   // Rechts
    richtungen[2] := Point(-1, 0);  // Links
    richtungen[3] := Point(0, 1);   // Unten
    richtungen[4] := Point(0, -1);  // Oben
    richtungen[5] := Point(1, 1);   // Unten rechts
    richtungen[6] := Point(-1, 1);  // Unten links
    richtungen[7] := Point(1, -1);  // Oben rechts
    richtungen[8] := Point(-1, -1); // Oben links

    for i := 1 to 8 do
      blockiert[i] := False;

    j := 1;
    for var dist := 1 to 8 do
    begin
      for k := 1 to 8 do
      begin
        var x := aktuelleX + richtungen[k].X * dist;
        var y := aktuelleY + richtungen[k].Y * dist;

        if (x >= 1) and (x <= 8) and (y >= 1) and (y <= 8) and not blockiert[k] then
        begin
          gecheckteFigur := felder[y, x].GetZugewieseneFigur();

          if (gecheckteFigur.GetAktuelleKoordinateX() <> 1234) then
          begin
            if (gecheckteFigur.GetIstWeiss() = self.GetIstWeiss()) then
            begin
              blockiert[k] := True;
            end
            else
            begin
              legaleFelderFinal[j] := felder[y, x];
              Inc(j);
              blockiert[k] := True;
            end;
          end
          else
          begin
            legaleFelderFinal[j] := felder[y, x];
            Inc(j);
          end;
        end;
      end;
    end;

    // Hervorgehobene Felder an den Controller übergeben
    controller.SetHervorgehobeneFelder(legaleFelderFinal, j - 1);
  end;

  // Hervorgehobene Felder an den Controller übergeben
  controller.SetHervorgehobeneFelder(legaleFelderFinal, indexLegalerZuege - 1);
end;

procedure TFigur.Click();
begin
  inherited;
  ZuegeAnzeigen();
end;

procedure TFigur.SetAktuelleKoordinateX(p_x : integer);
begin
  aktuelleKoordinateX := p_x;
end;

procedure TFigur.SetAktuelleKoordinateY(p_y : integer);
begin
  aktuelleKoordinateY := p_y;
end;

function TFigur.GetAktuelleKoordinateX(): integer;
begin
  result := aktuelleKoordinateX;
end;

function TFigur.GetAktuelleKoordinateY(): integer;
begin
  result := aktuelleKoordinateY;
end;

function TFigur.GetZuege() : TZweiDimensionaleArray;
begin
  ZuegeBerechnen();
  result := legaleZuege;
end;

function TFigur.GetIstWeiss(): Boolean;
begin
  result := istWeiss;
end;

function TFigur.KategorisiereDiagonaleZuege() : TArray<Integer>;
begin

end;

end.


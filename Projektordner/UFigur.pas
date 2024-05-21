unit UFigur;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

// wird benoetigt, um eine zweidimensionale Array als R�ckgabetyp einer
// Funktion zu verwenden
type
  TZweiDimensionaleArray = array[1..64, 1..2] of Integer;

type
  TRichtung = record
    dx, dy: Integer;
  end;


type
  TFigur = class abstract(TImage)
  protected
    pfad : string;
    istWeiss : boolean;
    legaleZuege : TZweiDimensionaleArray; // [MoeglichkeitNr][1 = X / 2 = Y (in fields2D)]
    aktuelleKoordinateX : integer; // gibt die Koordinate X der aktuellen Position in der fields2D Array zur�ck
    aktuelleKoordinateY : integer; // gibt die Koordinate Y der aktuellen Position in der fields2D Array zur�ck
    procedure ZuegeBerechnen(); virtual; abstract;
    procedure BildLaden();
    procedure ZuegeAnzeigen();
    procedure Click(); override;
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
  aktuelleKoordinateX := p_aktuelleKoordinateX;
  aktuelleKoordinateY := p_aktuelleKoordinateY;
  pfad := '';
  Parent := p_Form;
  hervorgehoben := 0;

  if (controller = nil) then
    controller := TController.Create();

end;

const
richtungen: array[1..4] of TRichtung = (
    (dx: 1; dy: 1),  // Diagonal nach rechts unten
    (dx: 1; dy: -1), // Diagonal nach rechts oben
    (dx: -1; dy: 1), // Diagonal nach links unten
    (dx: -1; dy: -1) // Diagonal nach links oben
  );

procedure TFigur.ZuegeAnzeigen();
var
  i, anzahlLegalerZuege, indexLegalerZuege: Integer;
  felder: TFields2DArrayZumUebergeben;
  hervorgehobeneFelder, legaleFelderFinal: THervorgehobeneFelderArray;
  gecheckteFigur: TFigur;
begin

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

  if (self.ClassType = TBauer) then
  begin
    raise Exception.Create('Nicht implementiert.');
  end
  else if (self.ClassType = TSpringer) then
  begin

    for i := 1 to hervorgehoben do
    begin

      if (hervorgehobeneFelder[i] = nil) then break;

      controller.SetAusgewaehlteFigur(self);
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
  
    var
      x, y, j: Integer;
      feld: TField;

    for j := Low(richtungen) to High(richtungen) do
    begin
      x := aktuelleKoordinateX;
      y := aktuelleKoordinateY;

      while True do
      begin
        Inc(x, richtungen[j].dx);
        Inc(y, richtungen[j].dy);

        if (x < 1) or (x > 8) or (y < 1) or (y > 8) then
          Break; // Au�erhalb des Bretts

        feld := felder[y, x];
        if feld = nil then
          Break; // Fehlerhafte Feldreferenz

        gecheckteFigur := feld.GetZugewieseneFigur();

        if gecheckteFigur = nil then
        begin
          // Kein Hindernis, Feld ist legal
          legaleFelderFinal[indexLegalerZuege] := feld;
          Inc(indexLegalerZuege);
          Inc(anzahlLegalerZuege);
        end
        else
        begin
          // Es gibt eine Figur auf dem Feld
          if gecheckteFigur.istWeiss <> self.istWeiss then
          begin
            // Gegnerische Figur, Feld ist legal
            legaleFelderFinal[indexLegalerZuege] := feld;
            Inc(indexLegalerZuege);
            Inc(anzahlLegalerZuege);
          end;
          Break; // Eigene Figur oder Gegnerische Figur blockiert den Weg
        end;
      end;
    end;
  end
  else if (self.ClassType = TTurm) then
  begin
    var ignorierenBisIndex : integer;

    ignorierenBisIndex := 0;

    for i := 1 to hervorgehoben do
    begin

      controller.SetAusgewaehlteFigur(self);
      gecheckteFigur := hervorgehobeneFelder[i].GetZugewieseneFigur();

      if (gecheckteFigur.istWeiss = self.istWeiss) then
      begin
        // illegal

        var nameAktuellesFeld : string;
        var stopp : boolean;
        var spalteAktuellesFeld : char;
        var reiheAktuellesFeld, checkIndex : integer;

        nameAktuellesFeld := felder[aktuelleKoordinateY, aktuelleKoordinateX].Name;
        spalteAktuellesFeld := nameAktuellesFeld[1];
        reiheAktuellesFeld := strtoint(nameAktuellesFeld[2]);

        checkIndex := i + 1;

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

    for i := 1 to hervorgehoben do
    begin

      controller.SetAusgewaehlteFigur(self);
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
    raise Exception.Create('Nicht implementiert.');
  end
  else raise Exception.Create('Das sollte nie passieren duerfen.');

  controller.SetHervorgehobeneFelder(legaleFelderFinal, anzahlLegalerZuege);

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

end.


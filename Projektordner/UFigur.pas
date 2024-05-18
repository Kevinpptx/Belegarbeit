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
    //class var hervorgehobeneFelder : array[1..27] of TField;
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

procedure TFigur.ZuegeAnzeigen();
var
  i: Integer;
  felder : TFields2DArrayZumUebergeben;
  hervorgehobeneFelder : THervorgehobeneFelderArray;
begin

  felder := FormMain.GetFields2D();
  hervorgehobeneFelder := controller.GetHervorgehobeneFelder();
  ZuegeBerechnen();

  // vorher hervorgehobene ent-hervorheben
  if (hervorgehoben <> 0) then
  begin

    for i := 1 to hervorgehoben do
    begin
      hervorgehobeneFelder[i].FeldhervorhebungAufheben();
      hervorgehobeneFelder[i] := nil;
    end;

    hervorgehoben := 0;

  end;

  // Hervorgehobene Felder - Liste vorbereiten
  for i := 1 to 64 do
  begin

    if (legaleZuege[i, 1] = 0) or (legaleZuege[i, 2] = 0) then break;


    Inc(hervorgehoben);
    //if (hervorgehobeneFelder[hervorgehoben] = nil) then  continue;                                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

    //felder[legaleZuege[i, 2], legaleZuege[i, 1]].FeldHervorheben();
    hervorgehobeneFelder[hervorgehoben] := felder[legaleZuege[i, 2], legaleZuege[i, 1]];

  end;

  // Bevor wir sie wirklich an den Controller uebergeben noch checken, ob Figuren im Weg
  var gecheckteFigur : TFigur;

  if (self.ClassType = TBauer) then
  begin
    raise Exception.Create('Nicht implementiert.');
  end
  else if (self.ClassType = TSpringer) then
  begin

    for i := 1 to 27 do
    begin

      // FEHLER IST: WENN i > WIRD ALS DIE MOEGLICHKEITEN KOMMT IRGENDWO EIN NULLT POINTER ALSO HIER ______  UEBERPRUEFEN, OB DIE LAENGE DER ZUEGE SCHON ERREICHT IST
      // ODER i NICHT BIS 27 SONDERN BIS ZU EINER VARIABLEN ANZAHL MACHEN!!!!!!!

      controller.SetAusgewaehlteFigur(self);
      gecheckteFigur := hervorgehobeneFelder[i].GetZugewieseneFigur();

      if (gecheckteFigur.istWeiss = self.istWeiss) then
      begin
        ShowMessage('Nach ' + hervorgehobeneFelder[i].Name + ' zu gehen waere illegal!');
      end
      else ShowMessage('Nach ' + hervorgehobeneFelder[i].Name + ' zu gehen ist legal!');

    end;

  end
  else if (self.ClassType = TLaeufer) then
  begin
    raise Exception.Create('Nicht implementiert.');
  end
  else if (self.ClassType = TTurm) then
  begin
    raise Exception.Create('Nicht implementiert.');
  end
  else if (self.ClassType = TKoenig) then
  begin
    raise Exception.Create('Nicht implementiert.');
  end
  else if (self.ClassType = TDame) then
  begin
    raise Exception.Create('Nicht implementiert.');
  end
  else raise Exception.Create('Das sollte nie passieren duerfen.');

  controller.SetHervorgehobeneFelder(hervorgehobeneFelder);

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


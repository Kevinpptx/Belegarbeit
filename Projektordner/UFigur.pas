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
  TFigur = class(TImage)
  protected
    pfad : string;
    istWeiss : boolean;
    legaleZuege : TZweiDimensionaleArray; // [MoeglichkeitNr][1 = X / 2 = Y (in fields2D)]
    aktuelleKoordinateX : integer; // gibt die Koordinate X der aktuellen Position in der fields2D Array zur�ck
    aktuelleKoordinateY : integer; // gibt die Koordinate Y der aktuellen Position in der fields2D Array zur�ck
    procedure ZuegeBerechnen(); virtual;
    procedure BildLaden();
  public
    function GetAktuelleKoordinateX() : integer;
    function GetAktuelleKoordinateY() : integer;
    function GetZuege() : TZweiDimensionaleArray;
    constructor Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
  end;

implementation

procedure TFigur.BildLaden();
begin

  Picture.LoadFromFile(pfad);
  Transparent := true;
  Stretch := true;
  BringToFront();

end;

constructor TFigur.Create(p_Form : TForm; p_istWeiss : boolean; p_aktuelleKoordinateX, p_aktuelleKoordinateY : integer);
begin

  inherited Create(p_Form);

  istWeiss := p_istWeiss;
  aktuelleKoordinateX := p_aktuelleKoordinateX;
  aktuelleKoordinateY := p_aktuelleKoordinateY;
  pfad := '';
  Parent := p_Form;

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

procedure TFigur.ZuegeBerechnen();
begin

  ShowMessage('Warum wird das ausgef�hrt?!');
  // diese Form der Methode wird im regulaeren Programmbetrieb nicht aufgerufen,
  // da Methode in den jeweiligen Kindern ueberschrieben wird, aber ich haette sie
  // trotzdem gern hier, im Sinne der OOP

end;

end.


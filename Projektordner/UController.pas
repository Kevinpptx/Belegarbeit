// Existiert, um zirkulaere Unit-Referenzen zu umgehen.

unit UController;

interface

uses UFigur, UField;

type
  THervorgehobeneFelderArray = array[1..27] of TField;

type
  TController = class
  public
    procedure SetAusgewaehlteFigur(p_figur : TFigur);
    procedure SetAusgewaehlteFigurPosition(p_x, p_y : integer);
    procedure SetAusgewaehlteFigurPositionX(p_x : integer);
    procedure SetAusgewaehlteFigurPositionY(p_y : integer);
    procedure SetHervorgehobeneFelder(p_hervorgehobeneFelder : THervorgehobeneFelderArray; zugAnzahl : integer);
    function GetHervorgehobeneFelder() : THervorgehobeneFelderArray;
    function GetAusgewaehlteFigur() : TFigur;
  private
    class var ausgewaehlteFigur : TFigur;
    class var hervorgehobeneFelder : array[1..27] of TField;
  protected
  end;

implementation

{ TController }

procedure TController.SetAusgewaehlteFigur(p_figur: TFigur);
begin
  ausgewaehlteFigur := p_figur;
end;

procedure TController.SetAusgewaehlteFigurPosition(p_x, p_y : integer);
begin
  ausgewaehlteFigur.SetAktuelleKoordinateX(p_x);
  ausgewaehlteFigur.SetAktuelleKoordinateY(p_y);
end;

procedure TController.SetAusgewaehlteFigurPositionX(p_x : integer);
begin
  ausgewaehlteFigur.SetAktuelleKoordinateX(p_x);
end;

procedure TController.SetAusgewaehlteFigurPositionY(p_y : integer);
begin
  ausgewaehlteFigur.SetAktuelleKoordinateY(p_y);
end;

procedure TController.SetHervorgehobeneFelder(p_hervorgehobeneFelder : THervorgehobeneFelderArray; zugAnzahl : integer);
var
  i: Integer;
begin

  for i := 1 to zugAnzahl do
  begin
    if (hervorgehobeneFelder[i] = nil) then break;
    hervorgehobeneFelder[i].FeldhervorhebungAufheben();
  end;

  for i := 1 to zugAnzahl do
  begin
    if (p_hervorgehobeneFelder[i] = nil) then break;
    hervorgehobeneFelder[i] := p_hervorgehobeneFelder[i];
    hervorgehobeneFelder[i].FeldHervorheben();
  end;

end;

function TController.GetAusgewaehlteFigur() : TFigur;
begin
  result := ausgewaehlteFigur;
end;

function TController.GetHervorgehobeneFelder() : THervorgehobeneFelderArray;
var
  tempArray : THervorgehobeneFelderArray;
  i : integer;
begin

  for i := 1 to 27 do
  begin
    tempArray[i] := hervorgehobeneFelder[i];
  end;

  result := tempArray;

end;


end.

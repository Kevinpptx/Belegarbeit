unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    procedure FormActivate(Sender: TObject);
    procedure InitializeFields();
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UField;

var
  fields : array[1..64] of TField;
  //[reihe 1-8] [spalte a-h (a = 1 usw.)]
  fields2D : array[1..8, 1..8] of TField;
  field : TField;
  switch : boolean;
  letter : char;
  number : integer;

  type
    TSpringer = class
      public
        function ZuegeBerechnen() : integer;
        //constructor Create(); override;
  end;

function TSpringer.ZuegeBerechnen() : integer;
begin

  var baum : integer;
  baum := 1;

  Result := baum;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin

  InitializeFields();

end;

// Ich erstelle eine Klasse Figur, von der alle einzelnen FIgurenklassen erben
// die Standardsachen sind ja gleich zwischen Figuren
// die Z�geBerechnen Methode wird immer �berschrieben


procedure TForm1.InitializeFields();
var
  i, offsetLeft, offsetTop, fieldSize, marginLeft, marginTop, row, col, row2D, col2D: Integer;
begin

  offsetLeft := 0;
  offsetTop := 0;
  fieldSize := 200;
  marginLeft:= 200;
  marginTop := 100;
  letter := 'a';
  number := 8;
  row := 1;
  col := 1;

  for i := 1 to 64 do
  begin

      field := TField.Create(Self);
      field.Parent := Self;

      field.Height := fieldSize;
      field.Width := fieldSize;
      field.Left := 0 + offsetLeft + marginLeft;
      field.Top := 0 + offsetTop + marginTop;
      field.Name := letter + inttostr(number);
  
      fields[i] := field;

      // Farbe
      if (i mod 2 = 0) and not (switch) then
        begin
          fields[i].Brush.Color := clBlack;
        end
      else if (i mod 2 = 1) and (switch) then
      begin
        fields[i].Brush.Color := clBlack;
      end;
  
      Inc(offsetLeft, fieldSize);
      Inc(col);

      if (i mod 8 = 0) then
      begin
      
        offsetLeft := 0;
        Inc(offsetTop, fieldSize);

        Inc(row);
        col := 1;

        case row of

          1: number := 8;
          2: number := 7;
          3: number := 6;
          4: number := 5;
          5: number := 4;
          6: number := 3;
          7: number := 2;
          8: number := 1;

        end;

        if (switch) then switch := false
        else switch := true;
      
      end;

      case col of

          1: letter := 'a';
          2: letter := 'b';
          3: letter := 'c';
          4: letter := 'd';
          5: letter := 'e';
          6: letter := 'f';
          7: letter := 'g';
          8: letter := 'h';

      end;
      
  end;


  // fields (eindimensional) zu fields2D (zweidimensional konvertieren)
  row2D := 1;
  col2D := 1;

  for i := 1 to 64 do
  begin


    if (col2D > 8) then
    begin

      Inc(row2D);
      col2D := 1;

    end;
    
    fields2D[row2D, col2D] := fields[i];

    Inc(col2D);

       // 2D Array dies
       // das Ananas
   // fields2D[row2D, col2D];

  end;

  Sleep(1000);

end;


//TODO: Methoden f�r die einzelnen legalen Z�ge berechnen erstellen
// die legalen Z�ge auch zwischenspeichern

end.

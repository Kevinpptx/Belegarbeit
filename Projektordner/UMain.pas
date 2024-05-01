unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, pngimage;

type
  TForm1 = class(TForm)
    btDemonstration: TButton;
    procedure FormActivate(Sender: TObject);
    procedure InitializeFields();
    procedure btDemonstrationClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses UField, USpringer, UFigur, UTurm; // UFigur wird fuer TZweiDimensionaleArray gebr.

var
  fields : array[1..64] of TField;
  //[reihe 1-8] (Y) [spalte a-h] (X) (also oben links ist [1, 1] und unten rechts  [8, 8])
  fields2D : array[1..8, 1..8] of TField;
  field : TField;
  switch : boolean;
  letter : char;
  number : integer;

procedure TForm1.btDemonstrationClick(Sender: TObject);
var
    im1, im2, im3, im4, im5, im6, im7, im8 : TImage;
begin
  // fields2D ist [Y] [X]
  im1 := TImage.Create(Form1);
  im2 := TImage.Create(Form1);
  im3 := TImage.Create(Form1);
  im4 := TImage.Create(Form1);
  im5 := TImage.Create(Form1);
  im6 := TImage.Create(Form1);
  im7 := TImage.Create(Form1);
  im8 := TImage.Create(Form1);

  im1.Parent := Form1;
  im2.Parent := Form1;
  im3.Parent := Form1;
  im4.Parent := Form1;
  im5.Parent := Form1;
  im6.Parent := Form1;
  im7.Parent := Form1;
  im8.Parent := Form1;

  im1.Picture.LoadFromFile('bauer-w.png');
  im2.Picture.LoadFromFile('bauer-w.png');
  im3.Picture.LoadFromFile('bauer-w.png');
  im4.Picture.LoadFromFile('bauer-w.png');
  im5.Picture.LoadFromFile('bauer-w.png');
  im6.Picture.LoadFromFile('bauer-w.png');
  im7.Picture.LoadFromFile('bauer-w.png');
  im8.Picture.LoadFromFile('bauer-w.png');

  im1.Transparent := true;
  im2.Transparent := true;
  im3.Transparent := true;
  im4.Transparent := true;
  im5.Transparent := true;
  im6.Transparent := true;
  im7.Transparent := true;
  im8.Transparent := true;

  im1.Stretch := true;
  im2.Stretch := true;
  im3.Stretch := true;
  im4.Stretch := true;
  im5.Stretch := true;
  im6.Stretch := true;
  im7.Stretch := true;
  im8.Stretch := true;

  im1.Left := fields2D[7, 1].Left;
  im1.Top := fields2D[7, 1].Top;
  im2.Left := fields2D[7, 2].Left;
  im2.Top := fields2D[7, 2].Top;
  im3.Left := fields2D[7, 3].Left;
  im3.Top := fields2D[7, 3].Top;
  im4.Left := fields2D[7, 4].Left;
  im4.Top := fields2D[7, 4].Top;
  im5.Left := fields2D[7, 5].Left;
  im5.Top := fields2D[7, 5].Top;
  im6.Left := fields2D[7, 6].Left;
  im6.Top := fields2D[7, 6].Top;
  im7.Left := fields2D[7, 7].Left;
  im7.Top := fields2D[7, 7].Top;
  im8.Left := fields2D[7, 8].Left;
  im8.Top := fields2D[7, 8].Top;

  im1.BringToFront();
  im2.BringToFront();
  im3.BringToFront();
  im4.BringToFront();
  im5.BringToFront();
  im6.BringToFront();
  im7.BringToFront();
  im8.BringToFront();
end;

procedure TForm1.FormActivate(Sender: TObject);
begin

  InitializeFields();

end;


procedure TForm1.InitializeFields();
var
  i, offsetLeft, offsetTop, fieldSize, marginLeft, marginTop, row, col, row2D, col2D: Integer;
  lz : TZweiDimensionaleArray;
begin

  offsetLeft := 0;
  offsetTop := 0;
  fieldSize := 100;
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

  end;

  var test1 : TSpringer;
  test1 := TSpringer.Create(true, 5, 5);
  lz := test1.GetZuege();

  var test2 : TTurm;
  test2 := TTurm.Create(true, 5, 5);
  lz := test2.GetZuege();

  Sleep(1000);

end;

//TODO: Methoden f�r die einzelnen legalen Z�ge berechnen erstellen
// die legalen Z�ge auch zwischenspeichern

//Shape1.BringToFront();
//Shape1.SendToBack();

//ACHTUNG: WENN DAS SPIEL ENDET ODER NEU STARTET o.ae. DANN IMMER x.Free()!!!

end.

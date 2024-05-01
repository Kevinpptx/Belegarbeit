unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, pngimage;

type
  TFormMain = class(TForm)
    btDemonstration: TButton;
    lbABC: TLabel;
    lb8: TLabel;
    lb7: TLabel;
    lb6: TLabel;
    lb5: TLabel;
    lb4: TLabel;
    lb3: TLabel;
    lb2: TLabel;
    lb1: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FelderInitialisieren();
    procedure btDemonstrationClick(Sender: TObject);
    procedure SpielZuruecksetzen();
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

// UFigur wird fuer TZweiDimensionaleArray gebr.
uses UField, USpringer, UFigur, UTurm, UBauer, ULaeufer, UDame, UKoenig;

var
  fields : array[1..64] of TField;
  //[reihe 1-8] (Y) [spalte a-h] (X) (also oben links ist [1, 1] und unten rechts  [8, 8])
  fields2D : array[1..8, 1..8] of TField;
  field : TField;
  switch : boolean;
  letter : char;
  number : integer;

procedure TFormMain.btDemonstrationClick(Sender: TObject);
var
    im1, im2, im3, im4, im5, im6, im7, im8 : TImage;
begin
  SpielZuruecksetzen();
end;

procedure TFormMain.FormActivate(Sender: TObject);
begin

  FelderInitialisieren();

end;


procedure TFormMain.SpielZuruecksetzen;
var
  bauer1w, bauer2w, bauer3w, bauer4w, bauer5w, bauer6w, bauer7w, bauer8w,
  bauer1s, bauer2s, bauer3s, bauer4s, bauer5s, bauer6s, bauer7s, bauer8s : TBauer;
  springer1w, springer2w, springer1s, springer2 : TSpringer;
  laeufer1w, laeufer2w, laeufer1s, laeufer2s : TLaeufer;
  turm1w, turm2w, turm1s, turm2s : TTurm;
  damew, dames : TDame;
  koenigw, koenigs : TKoenig;
  i: integer;
begin

  // Hinweis: Bei fields2D gilt [Y-Koordinate] [X-Koordinate] also Y kommt zuerst bei Koordinatenangaben

  bauer1w := TBauer.Create(FormMain, true, 1, 7);  // fehlerhaft
  bauer1w.Left := fields2D[7, 1].Left;
  bauer1w.Top := fields2D[7, 1].Top;

  turm1w := TTurm.Create(FormMain, true, 1, 8);   // fehlerhaft
  turm1w.Left := fields2D[8, 1].Left;
  turm1w.Top := fields2D[8, 1].Top;

  springer1w := TSpringer.Create(FormMain, true, 2, 8);
  springer1w.Left := fields2D[8, 2].Left;
  springer1w.Top := fields2D[8, 2].Top;

  laeufer1w := TLaeufer.Create(FormMain, true, 4, 4);
  laeufer1w.Left := fields2D[4, 4].Left;
  laeufer1w.Top := fields2D[4, 4].Top;

  damew := TDame.Create(FormMain, true, 5, 5);
  damew.Left := fields2D[5, 5].Left;
  damew.Top := fields2D[5, 5].Top;

  koenigw := TKoenig.Create(FormMain, true, 3, 3);
  koenigw.Left := fields2D[3, 3].Left;
  koenigw.Top := fields2D[3, 3].Top;

  // ab hier nur test

  var test, test2, test3, test4, test5, test6 : TZweiDimensionaleArray;
  test := bauer1w.GetZuege();
  test2 := turm1w.GetZuege();
  test3 := springer1w.GetZuege();
  test4 := laeufer1w.GetZuege();
  test5 := damew.GetZuege();
  test6 := koenigw.GetZuege();

  for i := 1 to 64 do
  begin

    if (test[i, 1] = 0) and (test[i, 2] = 0) then break;

    //fields2D[test[i, 2], test[i, 1]].FeldHervorheben();

  end;

  for i := 1 to 64 do
  begin

    if (test2[i, 1] = 0) and (test2[i, 2] = 0) then break;

    //fields2D[test2[i, 2], test2[i, 1]].FeldHervorheben();

  end;

  for i := 1 to 64 do
  begin

    if (test3[i, 1] = 0) and (test3[i, 2] = 0) then break;

    //fields2D[test3[i, 2], test3[i, 1]].FeldHervorheben();

  end;

  for i := 1 to 64 do
  begin

    if (test4[i, 1] = 0) and (test4[i, 2] = 0) then break;

    //fields2D[test4[i, 2], test4[i, 1]].FeldHervorheben();

  end;

  for i := 1 to 64 do
  begin

    if (test5[i, 1] = 0) and (test5[i, 2] = 0) then break;

    //fields2D[test5[i, 2], test5[i, 1]].FeldHervorheben();

  end;

  for i := 1 to 64 do
  begin

    if (test6[i, 1] = 0) and (test6[i, 2] = 0) then break;

    //fields2D[test6[i, 2], test6[i, 1]].FeldHervorheben();

  end;


  //fields2D[5, 5].FeldHervorheben();

//  im1.Left := fields2D[7, 1].Left;
//  im1.Top := fields2D[7, 1].Top;
//  im2.Left := fields2D[7, 2].Left;
//  im2.Top := fields2D[7, 2].Top;
//  im3.Left := fields2D[7, 3].Left;
//  im3.Top := fields2D[7, 3].Top;
//  im4.Left := fields2D[7, 4].Left;
//  im4.Top := fields2D[7, 4].Top;
//  im5.Left := fields2D[7, 5].Left;
//  im5.Top := fields2D[7, 5].Top;
//  im6.Left := fields2D[7, 6].Left;
//  im6.Top := fields2D[7, 6].Top;
//  im7.Left := fields2D[7, 7].Left;
//  im7.Top := fields2D[7, 7].Top;
//  im8.Left := fields2D[7, 8].Left;
//  im8.Top := fields2D[7, 8].Top;
end;

procedure TFormMain.FelderInitialisieren();
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

  Sleep(1000);

end;

//TODO: Methoden f�r die einzelnen legalen Z�ge berechnen erstellen
// die legalen Z�ge auch zwischenspeichern

//Shape1.BringToFront();
//Shape1.SendToBack();

//ACHTUNG: WENN DAS SPIEL ENDET ODER NEU STARTET o.ae. DANN IMMER x.Free()!!!

end.

object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Demonstration eines primitiven Schachcomputers'
  ClientHeight = 1042
  ClientWidth = 1908
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  TextHeight = 15
  object lbABC: TLabel
    Left = 232
    Top = 912
    Width = 737
    Height = 45
    Caption = 
      'A         B         C         D         E         F         G   ' +
      '      H'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb8: TLabel
    Left = 152
    Top = 128
    Width = 18
    Height = 45
    Caption = '8'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb7: TLabel
    Left = 152
    Top = 229
    Width = 18
    Height = 45
    Caption = '7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb6: TLabel
    Left = 152
    Top = 325
    Width = 18
    Height = 45
    Caption = '6'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb5: TLabel
    Left = 152
    Top = 424
    Width = 18
    Height = 45
    Caption = '5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb4: TLabel
    Left = 152
    Top = 528
    Width = 18
    Height = 45
    Caption = '4'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb3: TLabel
    Left = 152
    Top = 624
    Width = 18
    Height = 45
    Caption = '3'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb2: TLabel
    Left = 152
    Top = 728
    Width = 18
    Height = 45
    Caption = '2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb1: TLabel
    Left = 152
    Top = 824
    Width = 18
    Height = 45
    Caption = '1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -32
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object btDemonstration: TButton
    Left = 1632
    Top = 16
    Width = 259
    Height = 65
    Caption = 'Demonstration starten'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btDemonstrationClick
  end
end

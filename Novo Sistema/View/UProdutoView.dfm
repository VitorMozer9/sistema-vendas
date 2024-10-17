object frmProdutoView: TfrmProdutoView
  Left = 330
  Top = 202
  Width = 661
  Height = 374
  Caption = 'Produtos'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object stbBarraStatus: TStatusBar
    Left = 0
    Top = 316
    Width = 645
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object pnlBotoes: TPanel
    Left = 0
    Top = 256
    Width = 645
    Height = 60
    Align = alBottom
    TabOrder = 1
  end
  object pnlArea: TPanel
    Left = 0
    Top = 0
    Width = 645
    Height = 256
    Align = alClient
    TabOrder = 2
  end
end

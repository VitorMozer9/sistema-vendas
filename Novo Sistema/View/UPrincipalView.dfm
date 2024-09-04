object fmPrincipal: TfmPrincipal
  Left = 177
  Top = 188
  Width = 928
  Height = 480
  Caption = 'Novo Sistema'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = menMenu
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object menMenu: TMainMenu
    Left = 16
    Top = 24
    object menCadastros: TMenuItem
      Caption = 'Cadastros'
      object menClientes: TMenuItem
        Caption = 'Clientes'
      end
      object menProdutos: TMenuItem
        Caption = 'Produtos'
      end
    end
    object menRelatorios: TMenuItem
      Caption = 'Relatorios'
      object menVendas: TMenuItem
        Caption = 'Vendas'
      end
    end
    object menMovimentos: TMenuItem
      Caption = 'Movimentos'
      object menRelVendas: TMenuItem
        Caption = 'Vendas'
      end
    end
    object menSair: TMenuItem
      Caption = 'Sair'
      OnClick = menSairClick
    end
  end
end

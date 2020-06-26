object CloudPessoaEnderecoView: TCloudPessoaEnderecoView
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Cadastrar Cliente'
  ClientHeight = 276
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTitulo: TPanel
    Left = 0
    Top = 0
    Width = 387
    Height = 46
    Align = alTop
    Color = 7884599
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 500
    object lblTitulo: TLabel
      Left = 1
      Top = 1
      Width = 385
      Height = 44
      Align = alClient
      Alignment = taCenter
      Caption = 'Cadastrar Endere'#231'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16184821
      Font.Height = -24
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 205
      ExplicitHeight = 32
    end
  end
  object pnlCentro: TPanel
    Left = 0
    Top = 46
    Width = 387
    Height = 230
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    ExplicitWidth = 701
    ExplicitHeight = 187
    object lblBairro: TLabel
      Left = 11
      Top = 102
      Width = 33
      Height = 13
      Caption = 'Bairro:'
    end
    object lblCEP: TLabel
      Left = 115
      Top = 15
      Width = 22
      Height = 13
      Caption = 'CEP:'
    end
    object lblCidade: TLabel
      Left = 11
      Top = 144
      Width = 39
      Height = 13
      Caption = 'Cidade:'
    end
    object lblComplemento: TLabel
      Left = 177
      Top = 102
      Width = 75
      Height = 13
      Caption = 'Complemento:'
    end
    object lblEstado: TLabel
      Left = 177
      Top = 144
      Width = 38
      Height = 13
      Caption = 'Estado:'
    end
    object lblLogradouro: TLabel
      Left = 11
      Top = 60
      Width = 23
      Height = 13
      Caption = 'Rua:'
    end
    object lblNumero: TLabel
      Left = 280
      Top = 60
      Width = 44
      Height = 13
      Caption = 'N'#250'mero:'
    end
    object lblPais: TLabel
      Left = 237
      Top = 144
      Width = 23
      Height = 13
      Caption = 'Pa'#237's:'
    end
    object btnCancelar: TButton
      Left = 232
      Top = 192
      Width = 145
      Height = 25
      Caption = 'Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      OnClick = btnCancelarClick
    end
    object btnConfirmar: TButton
      Left = 83
      Top = 192
      Width = 145
      Height = 25
      Caption = 'Confirmar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      OnClick = btnConfirmarClick
    end
    object CampoBairro: TEdit
      Left = 11
      Top = 119
      Width = 157
      Height = 21
      ReadOnly = True
      TabOrder = 5
      OnKeyDown = CampoBairroKeyDown
    end
    object CampoCidade: TEdit
      Left = 11
      Top = 161
      Width = 156
      Height = 21
      ReadOnly = True
      TabOrder = 7
      OnKeyDown = CampoCidadeKeyDown
    end
    object CampoComplemento: TEdit
      Left = 177
      Top = 119
      Width = 200
      Height = 21
      TabOrder = 6
      OnKeyDown = CampoComplementoKeyDown
    end
    object CampoEstado: TEdit
      Left = 177
      Top = 161
      Width = 46
      Height = 21
      ReadOnly = True
      TabOrder = 8
      OnKeyDown = CampoEstadoKeyDown
    end
    object CampoLogradouro: TEdit
      Left = 11
      Top = 77
      Width = 255
      Height = 21
      NumbersOnly = True
      ReadOnly = True
      TabOrder = 3
      OnKeyDown = CampoLogradouroKeyDown
    end
    object CampoNumero: TEdit
      Left = 280
      Top = 77
      Width = 97
      Height = 21
      TabOrder = 4
      OnKeyDown = CampoNumeroKeyDown
    end
    object CampoPais: TEdit
      Left = 237
      Top = 161
      Width = 139
      Height = 21
      ReadOnly = True
      TabOrder = 9
      OnKeyDown = CampoPaisKeyDown
    end
    object edtCep: TEdit
      Left = 115
      Top = 31
      Width = 108
      Height = 21
      NumbersOnly = True
      TabOrder = 2
      OnEnter = edtCepEnter
      OnExit = edtCepExit
      OnKeyDown = edtCepKeyDown
    end
    object rdViacEP: TRadioGroup
      Left = 11
      Top = 3
      Width = 97
      Height = 54
      BiDiMode = bdLeftToRight
      Caption = 'Busca ViaCep'
      DoubleBuffered = False
      ItemIndex = 0
      Items.Strings = (
        'Json'
        'WebService')
      ParentBiDiMode = False
      ParentDoubleBuffered = False
      TabOrder = 0
    end
    object btnPesquisarCEP: TButton
      Left = 232
      Top = 29
      Width = 145
      Height = 25
      Caption = 'Pesquisar CEP'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnPesquisarCEPClick
    end
  end
end

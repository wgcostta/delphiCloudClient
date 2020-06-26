unit Cloud.Pessoa.Endereco.View;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Cloud.Dto.Pessoa,
  CloudBuscaCEP, Cloud.Dto.Pessoa.Endereco, Vcl.ExtCtrls;

type
  TCloudPessoaEnderecoView = class(TForm)

    btnConfirmar: TButton;
    btnCancelar: TButton;
    lblCEP: TLabel;
    lblLogradouro: TLabel;
    lblNumero: TLabel;
    lblComplemento: TLabel;
    lblBairro: TLabel;
    lblCidade: TLabel;
    lblEstado: TLabel;
    lblPais: TLabel;
    edtCep: TEdit;
    CampoLogradouro: TEdit;
    CampoComplemento: TEdit;
    CampoNumero: TEdit;
    CampoBairro: TEdit;
    CampoCidade: TEdit;
    CampoEstado: TEdit;
    CampoPais: TEdit;
    pnlTitulo: TPanel;
    pnlCentro: TPanel;
    lblTitulo: TLabel;
    rdViacEP: TRadioGroup;
    btnPesquisarCEP: TButton;
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure BuscarCep;
    procedure edtCepEnter(Sender: TObject);
    procedure edtCepExit(Sender: TObject);
    procedure edtCepKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CampoNumeroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CampoComplementoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CampoLogradouroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CampoBairroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CampoCidadeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CampoEstadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CampoPaisKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnPesquisarCEPClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    iId,iIdPessoa : Integer;
    Dados: array of variant;
    { Public declarations }
  end;

var
  CloudPessoaEnderecoView: TCloudPessoaEnderecoView;

implementation

{$R *.dfm}

procedure TCloudPessoaEnderecoView.btnCancelarClick(Sender: TObject);
begin
   Close;
end;

procedure TCloudPessoaEnderecoView.btnConfirmarClick(Sender: TObject);
begin
   if edtCep.Text <> '' then
   begin
     Dados := [iID.ToString,
              iIdPessoa.ToString,
              CampoLogradouro.Text,
              edtCep.Text,
              CampoNumero.Text,
              CampoComplemento.Text,
              CampoBairro.Text,
              CampoCidade.Text,
              CampoEstado.Text,
              CampoPais.Text]
   end;

   ModalResult := mrOk;
end;

procedure TCloudPessoaEnderecoView.btnPesquisarCEPClick(Sender: TObject);
begin
    BuscarCep;
end;

procedure TCloudPessoaEnderecoView.BuscarCep;
var
   buscaCep : TCloudModelCep;
begin
   if edtCep.Text <> '' then
   begin
      buscaCep := TCloudModelCep.Create(edtCep.Text);
      try
         if rdViacEP.ItemIndex = 0 then
            buscaCep.getCEPJson
         else
            buscaCep.getCEPWebservices;

         if buscaCep.bLocalizado then
         begin
            CampoCidade.Text     := buscaCep.Cidade.Nome;
            CampoBairro.Text     := buscaCep.Bairro;
            CampoLogradouro.Text := buscaCep.Logradouro;
            CampoBairro.Text     := buscaCep.Bairro;
            CampoEstado.Text     := buscaCep.Cidade.UF;
            CampoPais.Text       := 'Brasil'; //Api não retorna o País, mas possui outros dados.
         end
         else
         begin
            ShowMessage('Não foi possível Localizar o CEP');
         end;
      finally
         buscaCep.Free;
      end;
   end;
end;

procedure TCloudPessoaEnderecoView.CampoBairroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.CampoCidadeKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.CampoComplementoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.CampoEstadoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.CampoLogradouroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.CampoNumeroKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.CampoPaisKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.edtCepEnter(Sender: TObject);
begin
   BuscarCep;
end;

procedure TCloudPessoaEnderecoView.edtCepExit(Sender: TObject);
begin
   BuscarCep;
end;

procedure TCloudPessoaEnderecoView.edtCepKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if Key = VK_RETURN then
      perform(WM_NEXTDLGCTL,0,0);
end;

procedure TCloudPessoaEnderecoView.FormShow(Sender: TObject);
begin
   edtCep.SetFocus;
end;

end.

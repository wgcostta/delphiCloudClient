unit CloudServiceXML;

interface

uses
  System.Classes,  Xml.XMLDoc, XMLIntf, System.SysUtils,
  Forms, System.StrUtils, System.DateUtils,
  System.Math,
  Cloud.Dto.Cliente;


type
   TCloudServiceXML = class(TComponent)
   private
    FendXml: IXMLNode;
    Fxml: TXMLDocument;
    FloteXML: TXMLDocument;
    FpessoaXML: IXMLNode;
    FendPessoasXML: IXMLNode;
    procedure NovoXML;
    procedure GeraRaiz;
    procedure GeraInfNFe(pessoa: TCloudCliente);
    procedure Setxml(const Value: TXMLDocument);
    procedure SetloteXML(const Value: TXMLDocument);
   public
    sNomeArquivo : string;
    function GeraXML(pessoa: TCloudCliente): string;
    function GeraLote(iId: Integer; pessoa: TCloudCliente): TXMLDocument;
    procedure SalvaLoteDisco(iIdPessoa: Integer);
    constructor Create(AOwner: TComponent);
      property endXml: IXMLNode read FendXml write FendXml;
      property xml: TXMLDocument read Fxml write Setxml;
      property loteXML: TXMLDocument read FloteXML write SetloteXML;
      property pessoaXML: IXMLNode read FpessoaXML write FpessoaXML;
      property endPessoasXML: IXMLNode read FendPessoasXML write FendPessoasXML;
   published



end;

implementation

uses
  Cloud.Dto.Pessoa.Endereco;

{ TCloudServiceXML }

function TCloudServiceXML.GeraXML(pessoa: TCloudCliente): string;
begin
   Result := '';
   NovoXML;
   GeraRaiz;
   GeraInfNFe(pessoa);
   Result := GeraLote(pessoa.ID, pessoa).XML.Text;
end;

procedure TCloudServiceXML.NovoXML;
begin
   xml :=  TXMLDocument.Create(Self);;
   xml.Active  := True;
end;

procedure TCloudServiceXML.SalvaLoteDisco(iIdPessoa: Integer);
begin
   sNomeArquivo := ExtractFilePath(ParamStr(0)) + '000000' + iIdPessoa.ToString + '-env-pessoa.xml';
   loteXML.Active := True;

   try
      loteXML.SaveToFile(sNomeArquivo);
   except

   end;
end;

procedure TCloudServiceXML.SetloteXML(const Value: TXMLDocument);
begin
  FloteXML := Value;
end;

procedure TCloudServiceXML.Setxml(const Value: TXMLDocument);
begin
  Fxml := Value;
end;

constructor TCloudServiceXML.Create(AOwner: TComponent);
begin
   sNomeArquivo := '';
end;

procedure TCloudServiceXML.GeraInfNFe(pessoa: TCloudCliente);
begin
   endPessoasXML.Attributes['Id'] := 'Pessoa' + pessoa.ID.ToString;
   endPessoasXML.Attributes['versao'] := '1.0';
end;

function TCloudServiceXML.GeraLote(iId: Integer;
  pessoa: TCloudCliente): TXMLDocument;
var
  sVersao: String;
  iContador : Integer;
begin
   Result := nil;

   loteXML := TXMLDocument.Create(Self);
   loteXML.Active := True;
   loteXML.Version  := '1.0';
   loteXML.Encoding := 'UTF-8';

   pessoaXML := loteXML.AddChild('enviNFe', 'http://www.infosistemas.com.br/');

   pessoaXML.AddChild('idLote').NodeValue     := FormatFloat('0000000', iId);
   pessoaXML.AddChild('nome').NodeValue       := pessoa.Nome;
   pessoaXML.AddChild('identidade').NodeValue := pessoa.identidade;
   pessoaXML.AddChild('cpf').NodeValue        := pessoa.CPF;
   pessoaXML.AddChild('telefone').NodeValue   := pessoa.Telefone;
   pessoaXML.AddChild('email').NodeValue      := pessoa.Email;

   if (pessoa.Endereco <> nil) and (pessoa.Endereco.Count > 0) then
   begin
      for iContador := 0 to Pred(pessoa.endereco.Count) do
      begin
         endPessoasXML := pessoaXML.AddChild('enderecos');

         endXML := endPessoasXML.AddChild('endXML');

         endXML.AddChild('idPessoa').NodeValue  := pessoa.Endereco[iContador].id;
         endXML.AddChild('endereco').NodeValue  := pessoa.Endereco[iContador].Logradouro;
         endXML.AddChild('Cep').NodeValue       := pessoa.Endereco[iContador].Cep;
         endXML.AddChild('Numero').NodeValue    := pessoa.Endereco[iContador].Numero;
         endXML.AddChild('Complemento').NodeValue   := pessoa.Endereco[iContador].Complemento;
         endXML.AddChild('Bairro').NodeValue   := pessoa.Endereco[iContador].Bairro;
         endXML.AddChild('Cidade').NodeValue   := pessoa.Endereco[iContador].Cidade;
         endXML.AddChild('Estado').NodeValue   := pessoa.Endereco[iContador].Estado;
         endXML.AddChild('Pais').NodeValue      := pessoa.Endereco[iContador].Pais;
      end;
   end;

   xml.Active := True;
   pessoaXML.ChildNodes.Add(xml.DocumentElement);

   SalvaLoteDisco(pessoa.id);

   Result := loteXML;
end;

procedure TCloudServiceXML.GeraRaiz;
var
   raiz: IXMLNode;
begin
   raiz := xml.AddChild('NFe','http://www.infosistemas.com.br/');
   endPessoasXML := raiz.AddChild('infNFe');
end;

end.

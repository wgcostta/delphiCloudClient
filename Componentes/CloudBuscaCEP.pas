unit CloudBuscaCEP;

interface

uses
  System.SysUtils, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Xml.Win.msxmldom,Vcl.Forms,JSON,
  Cloud.Interfaces,
  Cloud.Dto.Pessoa.Endereco;

type
   TCidade = class(Tobject)
   private
      FUF: String;
      FCodigo: Integer;
      FNome: String;
      FIBGE: string;
      FUFIBGE: string;
    procedure SetNome(const Value: String);
    procedure SetUF(const Value: String);
   public
      property Codigo: Integer read FCodigo;
      property Nome: String read FNome write SetNome;
      property UF: String read FUF write SetUF;
      property UFIBGE: string read FUFIBGE;
      property IBGE: string read FIBGE;
  end;


   TCloudModelCep = class (TObject)
   strict private
      FCep: string;
      FLogradouro: string;
      FBairro: string;
      FCidade: TCidade;
      
  private
    FbLocalizado: Boolean;
    procedure SetBairro(const Value: string);
    procedure SetLogradouro(const Value: string);
   public
      constructor Create(const Cep: string); overload;
      destructor Destroy; override;
      property Cep: string read FCep;
      property Logradouro: string read FLogradouro write SetLogradouro;
      property Bairro: string read FBairro write SetBairro;
      property Cidade: TCidade read FCidade;
      property bLocalizado : Boolean read FbLocalizado write FbLocalizado;
      function getCEPWebservices: Boolean;
      function getCEPJson : Boolean;
  end;

implementation

uses
   Rest.Json, REST.Client, REST.types    , Cloud.Dto.ViaCep, Cloud.Rest;

{ TEndereco }

constructor TCloudModelCep.Create(const Cep: string);
begin
   FCidade := TCidade.Create;
   FCep := Cep;
   FLogradouro := '';
   FBairro := '';
   Self.FbLocalizado := False;
end;

destructor TCloudModelCep.Destroy;
begin
   FreeAndNil(FCidade);
   inherited;
end;

function TCloudModelCep.getCEPJson : Boolean;
var
  sURL : string;
  viacep : TCloudViaCep;
begin
  viacep := TCloudViaCep.Create;
  try
    viacep := TCloudRest.New('https://viacep.com.br/ws/' + FCEP + '/json/')
                  .build(GET)
                  .executar
                  .response.converter.get<TCloudViaCep>;

    if viacep.logradouro <> '' then
    begin
      FCep := viacep.cep;
      Logradouro := viacep.logradouro;
      Bairro := viacep.bairro;
      FCidade.Nome := viacep.localidade;
      FCidade.UF := viacep.uf;
      FCidade.FIBGE :=  viacep.ibge;
      FCidade.FUFIBGE :=  Copy(Cidade.IBGE,1,2);
      Self.FbLocalizado := Logradouro <> '';
      Result := Self.FbLocalizado;
    end;
  finally
    viacep.Free;
  end;
end;

function TCloudModelCep.getCEPWebservices : Boolean;
resourcestring
   __rCEP_INVALIDO = 'O n�mero do CEP deve ser composto por 8 Digitos.';
   __rCEP_NAO_ENCONTRADO = 'Cep n�o encontrado.';
const
   _rCep = 'cep';
   _rLogradouro = 'logradouro';
   _rBairro = 'bairro';
   _rLocalidade = 'localidade';
   _rUF = 'uf';
   _rIBGE = 'ibge';
   _rWS = 'https://viacep.com.br/ws/';
   _rXML = '/xml/';
   _rERRO = 'erro';
   _rTrue = 'true';
var
   _rDXML: IXMLDocument;
begin
   FCep := StringReplace(Cep, '-', '', [rfReplaceAll]).Trim;

   if Cep.Length <> 8 then
   begin
      Self.FbLocalizado := False;
      Abort;
   end;

   _rDXML := TXMLDocument.Create(nil);
   try
      try
         _rDXML.FileName := _rWS + Cep + _rXML;
         _rDXML.Active := True;
         { Quando consultado um CEP de formato v�lido, por�m inexistente, }
         { por exemplo: "99999999", o retorno conter� um valor de "erro"  }
         { igual a "true". Isso significa que o CEP consultado n�o foi    }
         { encontrado na base de dados. https://viacep.com.br/            }
      except
         on E:Exception do
         begin
            Self.FbLocalizado := False;
            Abort;
         end;
      end;

      if _rDXML.DocumentElement.ChildValues[0] = _rTrue then
      begin
         Self.FbLocalizado := False;
         Abort;
      end;

      FCep := _rDXML.DocumentElement.ChildNodes[_rCep].Text;
      Logradouro := AnsiUpperCase(_rDXML.DocumentElement.ChildNodes[_rLogradouro].Text);
      Bairro := AnsiUpperCase(_rDXML.DocumentElement.ChildNodes[_rBairro].Text);
      FCidade.Nome := AnsiUpperCase(_rDXML.DocumentElement.ChildNodes[_rLocalidade].Text);
      FCidade.UF := AnsiUpperCase(_rDXML.DocumentElement.ChildNodes[_rUF].Text);
      FCidade.FIBGE :=   _rDXML.DocumentElement.ChildNodes[_rIBGE].Text;
      FCidade.FUFIBGE :=  Copy(Cidade.IBGE,1,2);
      Self.FbLocalizado := Logradouro <> '';
   finally
      _rDXML := nil;
   end;
end;

procedure TCloudModelCep.SetBairro(const Value: string);
begin
  FBairro := AnsiUpperCase(Value);
end;

procedure TCloudModelCep.SetLogradouro(const Value: string);
begin
  FLogradouro := AnsiUpperCase(Value);
end;

{ TCidade }

procedure TCidade.SetNome(const Value: String);
begin
  FNome := AnsiUpperCase(Value);
end;

procedure TCidade.SetUF(const Value: String);
begin
  FUF := AnsiUpperCase(Value);
end;

end.
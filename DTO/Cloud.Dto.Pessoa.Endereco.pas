unit Cloud.Dto.Pessoa.Endereco;

interface

uses
  Vcl.Graphics,
  Cloud.Dto.Tabela;

type
  TCloudEndereco = class(TCloudTabela)
  private
    FBairro: string;
    FCep: string;
    FNumero: String;
    FidPessoa: integer;
    FComplemento: string;
    FCidade: string;
    FPais: string;
    FLogradouro: string;
    FEstado: string;
  public
    property idPessoa: integer read FidPessoa write FidPessoa;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Cep: string read FCep write FCep;
    property Numero: String read FNumero write FNumero;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro : string read FBairro write FBairro;
    property Cidade : string read FCidade write FCidade;
    property Estado : string read FEstado write FEstado;
    property Pais : string read FPais write FPais;
      constructor Create;
      destructor Destroy; override;
  end;

implementation

{ TCloudEndereco }

constructor TCloudEndereco.Create;
begin

end;

destructor TCloudEndereco.Destroy;
begin

  inherited;
end;

end.

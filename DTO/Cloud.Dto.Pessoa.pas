unit Cloud.Dto.Pessoa;

interface

uses
  Vcl.Graphics,
  Cloud.Dto.Pessoa.Endereco,
  Generics.Collections,
  Cloud.Dto.Tabela;

type
  TCloudPessoa = class(TCloudTabela)
  private
    FNome: string;
    FTelefone: string;
    FEmail: string;
    FEndereco: TObjectList<TCloudEndereco>;
  public
    property Nome: string read FNome write FNome;
    property Telefone: string read FTelefone write FTelefone;
    property Email : string read FEmail write FEmail;
    property Endereco : TObjectList<TCloudEndereco> read FEndereco write FEndereco;
      constructor Create;
      destructor Destroy; override;
  end;

implementation

{ TCloudPessoa }

constructor TCloudPessoa.Create;
begin
   Self.FNome := '';
   Self.FTelefone := '';
   Self.FEmail    := '';
   FEndereco := TObjectList<TCloudEndereco>.Create(False);
end;

destructor TCloudPessoa.Destroy;
begin
//   Endereco.Free;
  inherited;
end;

end.

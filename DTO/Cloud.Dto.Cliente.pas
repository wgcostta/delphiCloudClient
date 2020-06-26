unit Cloud.Dto.Cliente;

interface

uses
  Vcl.Graphics,

  Generics.Collections,
  Cloud.Dto.Pessoa;

type
  TCloudCliente = class(TCloudPessoa)
  private
    FIdentidade: string;
    FCPF: string;
  public
    property Identidade: string read FIdentidade write FIdentidade;
    property CPF: string read FCPF write FCPF;
      constructor Create;
      destructor Destroy; override;
  end;

implementation

{ TCloudPessoa }

constructor TCloudCliente.Create;
begin
   inherited;
   Self.FCPF := '';
   Self.FIdentidade := '';
end;

destructor TCloudCliente.Destroy;
begin

  inherited;
end;

end.

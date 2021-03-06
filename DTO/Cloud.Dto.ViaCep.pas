unit Cloud.Dto.ViaCep;

{*******************************************************************************
    Generated By   : JsonToDelphiClass - 0.65
    Project link   : https://github.com/PKGeorgiev/Delphi-JsonToDelphiClass
    Generated On   : 2020-06-21 14:25:22

    Created By     : Petar Georgiev - (http://pgeorgiev.com)
    Adapted Web By : Marlon Nardi - (http://jsontodelphi.com)
*******************************************************************************}

interface

uses Generics.Collections, Rest.Json, Cloud.Dto.Tabela;

type

TCloudViaCep = class(TCloudTabela)
private
  FBairro: String;
  FCep: String;
  FComplemento: String;
  FGia: String;
  FIbge: String;
  FLocalidade: String;
  FLogradouro: String;
  FUf: String;
  FUnidade: String;
public
  property bairro: String read FBairro write FBairro;
  property cep: String read FCep write FCep;
  property complemento: String read FComplemento write FComplemento;
  property gia: String read FGia write FGia;
  property ibge: String read FIbge write FIbge;
  property localidade: String read FLocalidade write FLocalidade;
  property logradouro: String read FLogradouro write FLogradouro;
  property uf: String read FUf write FUf;
  property unidade: String read FUnidade write FUnidade;
  function ToJsonString: string;
  class function FromJsonString(AJsonString: string): TCloudViaCep;
end;

implementation

{TRootClass}


function TCloudViaCep.ToJsonString: string;
begin
  result := TJson.ObjectToJsonString(self);
end;

class function TCloudViaCep.FromJsonString(AJsonString: string): TCloudViaCep;
begin
  result := TJson.JsonToObject<TCloudViaCep>(AJsonString)
end;

end.

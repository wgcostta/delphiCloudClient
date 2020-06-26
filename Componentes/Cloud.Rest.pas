unit Cloud.Rest;

interface

uses
  System.Generics.Collections, REST.Client, Cloud.Rest.Client.ParamHeaderDto, REST.Types, System.JSON, IpPeerClient, IdHTTP,
  IdSSLOpenSSL, uLkJSON, 
  Cloud.Model.RetornoJson,
  Cloud.Dto.Tabela;

  type
   TCloudRequestMetodo = ( POST, PUT, GET, DELETE, PATCH );

   TCloudRestRetorno = class;
   TCloudRest = class;


 TCloudRestConverter = class
   private
      restRetorno: TCloudRestRetorno;
   public
      public constructor create(response: TCloudRestRetorno);
      function get<T: TCloudTabela, constructor>(): T;
      function getList<T: TCloudTabela, constructor>() : TObjectList<T>;
   end;

   TCloudRestRetorno = class
  private
    FResponse: AnsiString;
    FStatusCode: Integer;
    FJson: TJsonValue;
    procedure SetJson(const Value: TJsonValue);
    procedure Setresponse(const Value: AnsiString);
    procedure SetstatusCode(const Value: Integer);

  public
    constructor Create; overload;
    constructor Create(statusCode: Integer; response: AnsiString; json: TJsonValue); overload;

    function converter: TCloudRestConverter;
  published
     property statusCode: Integer read FStatusCode write SetstatusCode;
     property response: AnsiString read FResponse write Setresponse;
     property json:TJsonValue read FJson write SetJson;
  end;


   IVSMRestRetorno = interface
   ['{BF377004-5A3B-4598-9BCB-C6873B0FB96E}']
      function response: TCloudRestRetorno;
   end;

   IVSMRestConfig = interface
   ['{DFA90817-672B-48B9-9183-BF1C1E017646}']
      function adicionarHeader(sNome, sValor: string): IVSMRestConfig;
      function adicionarParametro(sNome, sValor: string): IVSMRestConfig;
      function adicionarBody(sValor: string): IVSMRestConfig;  overload;
      function adicionarBody(entidade: TObject): IVSMRestConfig; overload;
      function build(metodo: TCloudRequestMetodo): TCloudRest;
   end;



   TCloudRest = class(TInterfacedObject, IVSMRestConfig, IVSMRestRetorno)
     private
      RESTClient   : TRESTClient;
      RESTRequest  : TRESTRequest;
      RESTResponse : TRESTResponse;
      FUrlServico: String;
      FTimeOut: Integer;
      FTipoMetodo: TRESTRequestMethod;
      parametrosHearder: TObjectList<TCloudRestClientParamHeaderDto>;
      parametros: TObjectList<TCloudRestClientParamHeaderDto>;
      FContentType: TRESTContentType;
      FAcceptMode: String;
      FConteudoBody: String;
      FAutoCreateParams: Boolean;
      FResource: string;
      restRetorno: TCloudRestRetorno;

      function tipoMetodo (metodo: TCloudRequestMetodo) : TRESTRequestMethod;
      procedure consumir;
      procedure preencherRetorno(restRequest  : TRESTRequest);

   public
      constructor Create(urlServico: string);

      function adicionarHeader(sNome, sValor: string): IVSMRestConfig;
      function adicionarParametro(sNome, sValor: string): IVSMRestConfig;
      function adicionarBody(sValor: string): IVSMRestConfig;overload;
      function adicionarBody(entidade: TObject): IVSMRestConfig; overload;
      function build(metodo: TCloudRequestMetodo): TCloudRest;
      function response: TCloudRestRetorno;


      function executar: IVSMRestRetorno;
      class function New(urlServico: string): IVSMRestConfig;
   end;



implementation

uses
  System.Classes, System.StrUtils, System.SysUtils, REST.Json, System.TypInfo, //uVSMObjectUtils,
  System.NetEncoding;


{ TCloudRest }

function TCloudRest.adicionarBody(entidade: TObject): IVSMRestConfig;
begin
   FConteudoBody := TJson.ObjectToJsonString(entidade);
   Result        := Self;
end;

function TCloudRest.adicionarHeader(sNome, sValor: string): IVSMRestConfig;
begin
   parametrosHearder.Add(TCloudRestClientParamHeaderDto.Create(sNome, sValor));
   Result := Self;
end;

function TCloudRest.adicionarParametro(sNome, sValor: string): IVSMRestConfig;
begin
   parametros.Add(TCloudRestClientParamHeaderDto.Create(sNome, sValor));
   Result := Self;
end;

function TCloudRest.adicionarBody(sValor: string): IVSMRestConfig;
begin
   FConteudoBody := sValor;
   Result        := Self;
end;

function TCloudRest.build(metodo: TCloudRequestMetodo): TCloudRest;
var
   parametro : TCloudRestClientParamHeaderDto;
   sEncode: String;
begin
   try
      RESTClient.BaseURL := FUrlServico;

      RESTRequest.AutoCreateParams := FAutoCreateParams;
      RESTRequest.Client           := RESTClient;
      RESTRequest.Resource         := FResource;
      RESTRequest.Response         := RESTResponse;
      RESTRequest.Timeout          := FTimeOut;
      RESTRequest.Accept           := FAcceptMode;
      RESTRequest.Method           := tipoMetodo(metodo);

      // Adiciona parâmetros da header
      if Assigned(parametrosHearder) then
      begin
         for parametro in parametrosHearder do
         begin
            if not (Trim(parametro.nome).IsEmpty) then
               RESTRequest.Params.AddHeader(parametro.nome, parametro.valor);
         end;
      end;

      if Assigned(parametros) then
      begin
         for parametro in parametros do
         begin
            if not (Trim(parametro.nome).IsEmpty) then
               RESTRequest.Params.AddItem(parametro.nome, parametro.valor);
         end;
      end;

      // Adiciona body
      if FConteudoBody <> '' then
         RESTRequest.AddBody(FConteudoBody, FContentType);
   except
      on E:Exception do
      begin
         Exit;
      end;
   end;

   Result := Self;
end;

constructor TCloudRest.Create(urlServico: string);
begin
   FUrlServico       := urlServico;
   FResource         := '';
   FConteudoBody     := '';
   FAutoCreateParams := True;
   FTimeOut          := 10000;
   FTipoMetodo       := rmGET;
   FContentType      := ctAPPLICATION_JSON;
   FAcceptMode       := 'application/json';
   parametrosHearder := TObjectList<TCloudRestClientParamHeaderDto>.Create;
   parametros        := TObjectList<TCloudRestClientParamHeaderDto>.Create;
   RESTClient        := TRESTClient.Create(FUrlServico);
   RESTRequest       := TRESTRequest.Create(RESTClient);
end;

function TCloudRest.executar: IVSMRestRetorno;
begin
   consumir ;
   Result := Self;
end;

procedure TCloudRest.consumir;
begin
   try
      RESTRequest.Execute;
      preencherRetorno(RESTRequest);
   except
      on E:Exception do
      begin
         restRetorno :=  TCloudRestRetorno.Create;
      end;
   end;
end;

class function TCloudRest.New(urlServico: string): IVSMRestConfig;
begin
   Result := TCloudRest.Create(urlServico);
end;

procedure TCloudRest.preencherRetorno(restRequest  : TRESTRequest);
begin
   restRetorno := TCloudRestRetorno.Create( restRequest.Response.StatusCode, restRequest.Response.Content, restRequest.Response.JSONValue);
end;

function TCloudRest.response: TCloudRestRetorno;
begin
   Result := restRetorno;
end;

function TCloudRest.tipoMetodo(metodo: TCloudRequestMetodo): TRESTRequestMethod;
begin
   case metodo of
      POST:   Result := rmPOST;
      PUT:    Result := rmPUT;
      GET:    Result := rmGET;
      DELETE: Result := rmDELETE;
      PATCH : Result := rmPATCH;
   end;
end;

{ TCloudRest }


{ VSMRestRetorno }

function TCloudRestRetorno.converter: TCloudRestConverter;
begin
   Result := TCloudRestConverter.create(Self);
end;


constructor TCloudRestRetorno.Create(statusCode: Integer; response: AnsiString; json: TJsonValue);
begin
   Self.FStatusCode := statusCode;
   Self.FResponse   := response;
   Self.FJson       := json;
end;

constructor TCloudRestRetorno.Create;
begin
   Self.FStatusCode := 500;
   Self.FResponse   := '';
end;

procedure TCloudRestRetorno.SetJson(const Value: TJsonValue);
begin
  FJson := Value;
end;

procedure TCloudRestRetorno.Setresponse(const Value: AnsiString);
begin
  Fresponse := Value;
end;

procedure TCloudRestRetorno.SetstatusCode(const Value: Integer);
begin
  FstatusCode := Value;
end;

{ TCloudRestConverter }

function TCloudRestConverter.get<T>(): T;
begin
    Result := TJson.JsonToObject<T>(Self.restRetorno.Fjson as TJSONObject);
end;

function TCloudRestConverter.getList<T>() : TObjectList<T>;
var
   LJsonArr: TJSONArray;
   LJsonValue: TJSONValue;
   Classe: T;
begin
   Result := TObjectList<T>.Create;

   LJsonArr := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(restRetorno.response),0) as TJSONArray;

   if LJsonArr <> nil then
   begin
      for LJsonValue in LJsonArr do
      begin
         Result.Add(TJson.JsonToObject<T>(LJsonValue.ToJSON));
      end;
   end;
end;

constructor TCloudRestConverter.create(response: TCloudRestRetorno);
begin
   Self.restRetorno := response;
end;

{ TCloudRestAuth }


end.

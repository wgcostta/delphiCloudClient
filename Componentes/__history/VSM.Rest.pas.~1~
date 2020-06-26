unit VSM.Rest;

interface

uses
  System.Generics.Collections, uVSMAtributos, REST.Client, VSMRestClientParamHeaderDto, REST.Types, System.JSON, IpPeerClient, IdHTTP, 
  IdSSLOpenSSL, uLkJSON, VSM.Rest.Auth, VSM.Model.RetornoJson;

  type
   TVSMRequestMetodo = ( POST, PUT, GET, DELETE, PATCH );

   TVSMRestRetorno = class;
   TVSMRest = class;
   TVSMRestAuth = class;


 TVSMRestConverter = class
   private
      restRetorno: TVSMRestRetorno;
   public
      public constructor create(response: TVSMRestRetorno);
      function get<T: TVSMTabela, constructor>(): T;
      function getList<T: TVSMTabela, constructor>() : TObjectList<T>;
   end;

   TVSMRestRetorno = class
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

    function converter: TVSMRestConverter;
  published
     property statusCode: Integer read FStatusCode write SetstatusCode;
     property response: AnsiString read FResponse write Setresponse;
     property json:TJsonValue read FJson write SetJson;
  end;


   IVSMRestRetorno = interface
   ['{BF377004-5A3B-4598-9BCB-C6873B0FB96E}']
      function response: TVSMRestRetorno;
   end;

   IVSMRestConfig = interface
   ['{DFA90817-672B-48B9-9183-BF1C1E017646}']
      function auth(solucao: TSolucoesAuth): IVSMRestConfig;
      function adicionarHeader(sNome, sValor: string): IVSMRestConfig;
      function adicionarParametro(sNome, sValor: string): IVSMRestConfig;
      function adicionarBody(sValor: string): IVSMRestConfig;  overload;
      function adicionarBody(entidade: TObject): IVSMRestConfig; overload;
      function build(metodo: TVSMRequestMetodo): TVSMRest;
   end;

   TVSMRestAuth = class
   private
      FrestAuth: TVSMRestAutentication;
      FconfigRest: IVSMRestConfig;

      procedure SetrestAuth(const Value: TVSMRestAutentication);
      procedure SetconfigRest(const Value: IVSMRestConfig);
      { private declarations }
   protected
      { protected declarations }
   public
      constructor Create(restAuth: TVSMRestAutentication; config: IVSMRestConfig);
      function getAccessToken: string;
      { public declarations }
   published
      property restAuth: TVSMRestAutentication read FrestAuth write SetrestAuth;
      property restConfig: IVSMRestConfig read FconfigRest write SetconfigRest;
      { published declarations }
   end;

   TVSMRest = class(TInterfacedObject, IVSMRestConfig, IVSMRestRetorno)
     private
      RESTClient   : TRESTClient;
      RESTRequest  : TRESTRequest;
      RESTResponse : TRESTResponse;
      FUrlServico: String;
      FTimeOut: Integer;
      FTipoMetodo: TRESTRequestMethod;
      parametrosHearder: TObjectList<TVSMRestClientParamHeaderDto>;
      parametros: TObjectList<TVSMRestClientParamHeaderDto>;
      FContentType: TRESTContentType;
      FRestAuth: TVSMRestAuth;
      FAcceptMode: String;
      FConteudoBody: String;
      FAutoCreateParams: Boolean;
      FResource: string;
      restRetorno: TVSMRestRetorno;

      function tipoMetodo (metodo: TVSMRequestMetodo) : TRESTRequestMethod;
      procedure consumir;
      procedure preencherRetorno(restRequest  : TRESTRequest);

   public
      constructor Create(urlServico: string);
      function auth(solucao: TSolucoesAuth): IVSMRestConfig;
      function adicionarHeader(sNome, sValor: string): IVSMRestConfig;
      function adicionarParametro(sNome, sValor: string): IVSMRestConfig;
      function adicionarBody(sValor: string): IVSMRestConfig;overload;
      function adicionarBody(entidade: TObject): IVSMRestConfig; overload;
      function build(metodo: TVSMRequestMetodo): TVSMRest;
      function response: TVSMRestRetorno;


      function executar: IVSMRestRetorno;
      class function New(urlServico: string): IVSMRestConfig;
   end;



implementation

uses
  System.Classes, System.StrUtils, System.SysUtils, REST.Json, System.TypInfo, //uVSMObjectUtils,
  System.NetEncoding, VSM.Rest.Enumeradores;


{ TVSMRest }

function TVSMRest.adicionarBody(entidade: TObject): IVSMRestConfig;
begin
   FConteudoBody := TJson.ObjectToJsonString(entidade);
   Result        := Self;
end;

function TVSMRest.adicionarHeader(sNome, sValor: string): IVSMRestConfig;
begin
   parametrosHearder.Add(TVSMRestClientParamHeaderDto.Create(sNome, sValor));
   Result := Self;
end;

function TVSMRest.adicionarParametro(sNome, sValor: string): IVSMRestConfig;
begin
   parametros.Add(TVSMRestClientParamHeaderDto.Create(sNome, sValor));
   Result := Self;
end;

function TVSMRest.auth(solucao: TSolucoesAuth): IVSMRestConfig;
begin
   Self.FRestAuth := TVSMRestAuth.Create(TVSMRestAuthFactory.GetRestAuth(solucao), Self);
   Result         := Self;
end;

function TVSMRest.adicionarBody(sValor: string): IVSMRestConfig;
begin
   FConteudoBody := sValor;
   Result        := Self;
end;

function TVSMRest.build(metodo: TVSMRequestMetodo): TVSMRest;
var
   parametro : TVSMRestClientParamHeaderDto;
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

      // Adiciona token de autenticação
      if Assigned(FRestAuth) and (FRestAuth <> nil) then
      begin
         case FRestAuth.restAuth.Type_Authorizarion_API of
            tpBasicAuth :
               begin
                  if (Trim(FRestAuth.restAuth.Token) <> '') then
                  begin
                     RESTRequest.Params.AddHeader('x-api-key', FRestAuth.restAuth.Token);
                     RESTRequest.Params.AddHeader('Authorization', FRestAuth.restAuth.Encode);
                  end;
               end;
            tpOAuth2 :
               begin
                   RESTRequest.Params.AddHeader('Authorization', 'Bearer ' + FRestAuth.getAccessToken);
               end;
            tpBearerToken :
               begin
                  RESTRequest.Params.AddHeader('Authorization', FRestAuth.restAuth.Token);
               end;
         end;
         RESTRequest.Params.ParameterByName('Authorization').Options := [poDoNotEncode];
      end;

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
//         TVSMLogUtils.GetInstance.WriteLog('TVSMRESTClient.ConsumirWsToClass',
//                                           'Falha ao tentar conectar com o WebService (Tempo limite da operação atingido). ' +
//                                           E.Message);
         Exit;
      end;
   end;

   Result := Self;
end;

constructor TVSMRest.Create(urlServico: string);
begin
   FUrlServico       := urlServico;
   FResource         := '';
   FConteudoBody     := '';
   FAutoCreateParams := True;
   FTimeOut          := 10000;
   FTipoMetodo       := rmGET;
   FContentType      := ctAPPLICATION_JSON;
   FAcceptMode       := 'application/json';
   parametrosHearder := TObjectList<TVSMRestClientParamHeaderDto>.Create;
   parametros        := TObjectList<TVSMRestClientParamHeaderDto>.Create;
   RESTClient        := TRESTClient.Create(FUrlServico);
   RESTRequest       := TRESTRequest.Create(RESTClient);
end;

function TVSMRest.executar: IVSMRestRetorno;
begin
   consumir ;
   Result := Self;
end;

procedure TVSMRest.consumir;
begin
   try
      RESTRequest.Execute;
      preencherRetorno(RESTRequest);
   except
      on E:Exception do
      begin
         restRetorno :=  TVSMRestRetorno.Create;

//         TVSMLogUtils.GetInstance.WriteLog('TVSMRESTClient.ConsumirWsToClass',
//                                           'Falha ao tentar conectar com o WebService (Tempo limite da operação atingido). ' +
//                                           E.Message);
      end;
   end;
end;

class function TVSMRest.New(urlServico: string): IVSMRestConfig;
begin
   Result := TVSMRest.Create(urlServico);
end;

procedure TVSMRest.preencherRetorno(restRequest  : TRESTRequest);
begin
   restRetorno := TVSMRestRetorno.Create( restRequest.Response.StatusCode, restRequest.Response.Content, restRequest.Response.JSONValue);
end;

function TVSMRest.response: TVSMRestRetorno;
begin
   Result := restRetorno;
end;

function TVSMRest.tipoMetodo(metodo: TVSMRequestMetodo): TRESTRequestMethod;
begin
   case metodo of
      POST:   Result := rmPOST;
      PUT:    Result := rmPUT;
      GET:    Result := rmGET;
      DELETE: Result := rmDELETE;
      PATCH : Result := rmPATCH;
   end;
end;

{ TVSMRest }


{ VSMRestRetorno }

function TVSMRestRetorno.converter: TVSMRestConverter;
begin
   Result := TVSMRestConverter.create(Self);
end;


constructor TVSMRestRetorno.Create(statusCode: Integer; response: AnsiString; json: TJsonValue);
begin
   Self.FStatusCode := statusCode;
   Self.FResponse   := response;
   Self.FJson       := json;
end;

constructor TVSMRestRetorno.Create;
begin
   Self.FStatusCode := 500;
   Self.FResponse   := '';
end;

procedure TVSMRestRetorno.SetJson(const Value: TJsonValue);
begin
  FJson := Value;
end;

procedure TVSMRestRetorno.Setresponse(const Value: AnsiString);
begin
  Fresponse := Value;
end;

procedure TVSMRestRetorno.SetstatusCode(const Value: Integer);
begin
  FstatusCode := Value;
end;

{ TVSMRestConverter }

function TVSMRestConverter.get<T>(): T;
begin
    Result := TJson.JsonToObject<T>(Self.restRetorno.Fjson as TJSONObject);
end;

function TVSMRestConverter.getList<T>: TObjectList<T>;
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

constructor TVSMRestConverter.create(response: TVSMRestRetorno);
begin
   Self.restRetorno := response;
end;

{ TVSMRestAuth }

constructor TVSMRestAuth.Create(restAuth: TVSMRestAutentication; config: IVSMRestConfig);
begin
   Self.restAuth   := restAuth;
   Self.restConfig := config;
end;

function TVSMRestAuth.getAccessToken: string;
var
   Params         : TStringList;
   IdHTTP         : TIdHTTP;
   IdSSLIOHandler : TIdSSLIOHandlerSocketOpenSSL;

   // Retorna Token de Acesso do JSON de resposta da requisição
   function RetornaToken(JSON : String) : String;
   var
      js    : TlkJSONobject;
      Token : string;
   begin
      try
         js     := TlkJSON.ParseText(JSON) as TlkJSONobject;
         Result := js.getString('access_token');
      except
         Result := '';
      end;
   end;

begin
   if(Self.restAuth.token.IsEmpty)then
   begin
      Params := TStringList.Create();
      Params.add(restAuth.grantType);

      IdSSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      IdHTTP         := TIdHTTP.Create();
      try
         with IdSSLIOHandler do begin
            SSLOptions.Method      := sslvSSLv23;
            SSLOptions.SSLVersions := [sslvSSLv23];
         end;

         IdHTTP.ConnectTimeout := restAuth.timeOut;
         IdHTTP.IOHandler      := IdSSLIOHandler;

         IdHTTP.Request.Clear;
         IdHTTP.Request.BasicAuthentication := True;
         IdHTTP.Request.Username            := restAuth.user;
         IdHTTP.Request.Password            := restAuth.pass;

         try
            Self.restAuth.token := RetornaToken(IdHTTP.Post(restAuth.Url, params));
         except
            on E:Exception do
            begin
//               TVSMLogUtils.GetInstance.WriteLog('TVSM.Rest.getAccessToken',
//                                                 'Falha ao tentar obter token de autentização. ' + E.Message);
            end;
         end;
      finally
        IdHTTP.Free;
        IdSSLIOHandler.Free;
        Params.Free;
      end;
   end;
   Result := Self.restAuth.token
end;

procedure TVSMRestAuth.SetconfigRest(const Value: IVSMRestConfig);
begin
  FconfigRest := Value;
end;

procedure TVSMRestAuth.SetrestAuth(const Value: TVSMRestAutentication);
begin
  FrestAuth := Value;
end;

end.

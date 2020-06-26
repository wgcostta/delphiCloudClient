unit Cloud.Model.EnvioEmail;

interface

uses Cloud.Interfaces,
     Cloud.Dto.Cliente;


type
   TCloudModelEnvioEmail = class(TInterfacedObject, IModelEnvioEmail)
         private
    FEmailDest: string;
    FPessoaEnvio: TCloudCliente;
      constructor Create;
      destructor Destroy; override;
      property pessoaEnvio : TCloudCliente read FPessoaEnvio write FPessoaEnvio;
      property emailDest   : string read FEmailDest write FEmailDest;
    protected
     function setPessoa(Pessoa : TCloudCliente) : IModelEnvioEmail;
     function setEmailDestino(emailDestino : string) : IModelEnvioEmail;
     function &End : IModelEnvioEmail;
     function EnviarEmail : Boolean;
    public
      class function New : IModelEnvioEmail;
    published
   end;

implementation

{ TCloudModelEnvioEmail }

uses CloudServiceEmail,
     Cloud.Dto.Email,
     Classes, CloudServiceXML;

function TCloudModelEnvioEmail.&End: IModelEnvioEmail;
begin
   Result := Self;
end;

constructor TCloudModelEnvioEmail.Create;
begin

end;

destructor TCloudModelEnvioEmail.Destroy;
begin

  inherited;
end;

function TCloudModelEnvioEmail.EnviarEmail: Boolean;
var
   email : TEmail;
   anexos, ccStr, sCorpo  : TStringList;
   srvXML : TCloudServiceXML;
   sXML   : string;
begin
   Result := False;
   try
      anexos := TStringList.Create;
      ccStr  := TStringList.Create;
      sCorpo := TStringList.Create;

      email := TEmail.Create(sUserEmail, sPassWord, sHost, sPorta, bTLS, bAuth);
      srvXML := TCloudServiceXML.Create(nil);
      try
         sXML := srvXML.GeraXML(pessoaEnvio);
         anexos.Add('text/xml'+'='+srvXML.sNomeArquivo);
         ccStr.Text := sCC;
         sCorpo.Text := sTextoCorpo;

         Result := email.EnviarEmailSimples(sAssunto,
                                 sFileCorpo,
                                  emailDest,
                                   nil,
                                   ccStr,
                                   sCorpo,
                                   anexos,
                                   False);
      finally
         email.Free;
         anexos.Free;
         srvXML.Free;
         ccStr.Free;
         sCorpo.Free;
      end;
   except
      Result := False;
   end;
end;

class function TCloudModelEnvioEmail.New: IModelEnvioEmail;
begin
   Result := Self.Create;
end;

function TCloudModelEnvioEmail.setEmailDestino(
  emailDestino: string): IModelEnvioEmail;
begin
   Result := Self;
   FEmailDest := emailDestino;
end;

function TCloudModelEnvioEmail.setPessoa(
  Pessoa: TCloudCliente): IModelEnvioEmail;
begin
   Result := Self;
   FPessoaEnvio := Pessoa;
end;

end.

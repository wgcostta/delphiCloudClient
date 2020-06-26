unit CloudServiceEmail;

interface

uses
   Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
   Dialogs, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
   IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase, IdSMTP,
   IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
   IdMessage, StdCtrls, IdText, Buttons, IdAttachmentFile;

type
   TEmail = Class(TObject)
   private                             
      _sUserEmail, _sPassWord, _sHost, _sPorta, _sAssunto, _sFileCorpo, _sDestinatariosA: String;
      _bTLS, _bAuth, _bMostraStatus: boolean;
      _sDestinatarios, _sCC, _sCCo: TStringList;
      _sTextoCorpo, _sAnexo: TStrings;
      iTamanhoEmail: Integer;
      A_IdSMTP         : TIdSMTP;
      A_IdSSLIOHandler : TIdSSLIOHandlerSocketOpenSSL;
      A_IdMessage      : TIdMessage;
      FAbortou: Boolean;
      procedure A_IdSMTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
      procedure A_IdSMTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
      procedure A_IdSMTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
      procedure SetAbortou(const Value: Boolean);
   public
      constructor Create(); overload;
      constructor Create(sUserEmail, sPassWord, sHost, sPorta: string; bTLS, bAuth : boolean); overload;
      function Enviar(): Boolean;
      function EnviarEmailSimples(sAssunto, sFileCorpo,  sDestinatarios : string; sCC, sCCo : TStringList;
                            sTextoCorpo, sAnexo : TStrings; bMostraStatus:Boolean=True): Boolean;
      function EnviarEmail(sUserEmail, sPassWord, sHost, sPorta, sAssunto, sFileCorpo : string;
                            bTLS, bAuth : boolean; sDestinatarios, sCC, sCCo : TStringList;
                            sTextoCorpo, sAnexo : TStrings; bMostraStatus:Boolean=True): Boolean;
   published
      procedure AbortaEnvio(Sender: TObject);
      property Abortou: Boolean read FAbortou write SetAbortou;
   end;

implementation

uses IdMessageParts;

constructor TEmail.Create();
begin

end;

constructor TEmail.Create(sUserEmail, sPassWord, sHost, sPorta: string; bTLS, bAuth : boolean);
begin
   _sUserEmail   := sUserEmail;
   _sPassWord    := sPassWord;
   _sHost        := sHost;
   _sPorta       := sPorta;
   _bTLS         := bTLS;
   _bAuth        := bAuth;
end;

function TEmail.Enviar: Boolean;
var
  i                : Smallint;
  A_Texto          : TStringList;
  sTipo, sArquivo  : String;
  fsTamanhoEmail   :TMemoryStream;
begin
   Result := False;
   
   A_IdSMTP         := TIdSMTP.Create(nil);
   A_IdSSLIOHandler := TIdSSLIOHandlerSocketOpenSSL.Create();
   A_IdMessage      := TIdMessage.Create();

   with A_IdSMTP do
   begin
      OnWork       := A_IdSMTPWork;

      OnWorkBegin  := A_IdSMTPWorkBegin;

      OnWorkEnd    := A_IdSMTPWorkEnd;
   end;

   fsTamanhoEmail  :=TMemoryStream.Create;

   A_IdSMTP.Disconnect;

   A_IdSMTP.Host     := _sHost;
   A_IdSMTP.Port     := StrToInt(_sPorta);

   if A_IdSMTP.Port = 0 then
      A_IdSMTP.Port := 25;

   A_IdSMTP.Username := _sUserEmail;
   A_IdSMTP.Password := _sPassWord;

   if _bAuth then
      A_IdSMTP.AuthType  := satDefault
   else
      A_IdSMTP.AuthType  := satNone;

   if _bTLS then
   begin
      A_IdSSLIOHandler.SSLOptions.Method := sslvTLSv1;
      A_IdSSLIOHandler.SSLOptions.Mode   := sslmClient;
      A_IdSMTP.IOHandler                 := A_IdSSLIOHandler;
      A_IdSMTP.UseTLS                    := utUseImplicitTLS;
   end
   else
   begin
      A_IdSMTP.IOHandler := nil;
      A_IdSMTP.UseTLS    := utNoTLSSupport;
   end;

   if ((pos('hotmail', LowerCase(_sUserEmail)) > 0) or
       (pos('outlook', LowerCase(_sUserEmail)) > 0)) then
   begin
      A_IdSSLIOHandler.SSLOptions.Method := sslvTLSv1;
      A_IdSSLIOHandler.SSLOptions.Mode   := sslmClient;
      A_IdSMTP.IOHandler                 := A_IdSSLIOHandler;
      A_IdSMTP.UseTLS                    := utUseExplicitTLS;
   end;

   A_IdMessage.Clear;
   A_IdMessage.Body.Clear;
   A_IdMessage.Recipients.Clear;
   A_IdMessage.From.Address              := _sUserEmail;
   A_IdMessage.From.Name                 := _sUserEmail;
   A_IdMessage.ReceiptRecipient.Address  := _sUserEmail;
   A_IdMessage.Subject                   := _sAssunto;
   A_IdMessage.ContentType               := 'multipart/mixed';
   A_IdMessage.CharSet                   := 'Latin1';

    A_IdMessage.Recipients.EMailAddresses := _sDestinatariosA; //NOVO JEITO


   if _sCC <> nil then
      for i := 0 to _sCC.Count - 1 do
         A_IdMessage.CCList.EMailAddresses := _sCC[i];

   if _sCCo <> nil then
      for i := 0 to _sCCo.Count - 1 do
         A_IdMessage.BccList.EMailAddresses := _sCCo[i];

   if ((Trim(_sFileCorpo) <> '') and FileExists(_sFileCorpo)) or (Trim(_sTextoCorpo.Text) <> '') then
   with TIdText.Create(A_IdMessage.MessageParts) do
   begin
      CharSet := 'Latin1';
      ContentType     := 'text/html';
      ContentTransfer := '7bit';
      for i := 0 to _sTextoCorpo.Count - 1 do
         Body.Append(_sTextoCorpo[i] + '<br>');

      if (Trim(_sFileCorpo) <> '') and FileExists(_sFileCorpo) then
      begin
         A_Texto := TStringList.Create;
         A_Texto.LoadFromFile(_sFileCorpo);
         Body.Append(A_Texto.Text);
         FreeAndNil(A_Texto);
      end;
   end;

   for i := 0 to _sAnexo.Count - 1 do
   begin
      sTipo := _sAnexo.Names[i];
      sArquivo := _sAnexo.ValueFromIndex[i];

      if FileExists(sArquivo) then
      with TIdAttachmentFile.Create(A_IdMessage.MessageParts, sArquivo) do
      begin
         //ContentType        := 'application/octet-stream';
         ContentType := sTipo;
         Headers.Add('Content-ID: <'+ sArquivo + '>');
         ContentDisposition := 'attachment';
         ContentTransfer    := 'base64';
      end;
   end;

   A_IdMessage.SaveToStream(fsTamanhoEmail);

   iTamanhoEmail := fsTamanhoEmail.Size;

   FreeAndNil(fsTamanhoEmail);

   A_IdSMTP.Disconnect(False);
   try
      //Envio de E-mail
      A_IdSMTP.Connect;
      A_IdSMTP.Authenticate;
      A_IdSMTP.Send(A_IdMessage);
      A_IdSMTP.Disconnect(False);
      Result := True;
   except
      on E: Exception do
      begin

         if not FAbortou and _bMostraStatus then

         A_IdSMTP.Disconnect(False);
      end;
   end;

   FreeAndNil(A_IdMessage);
   FreeAndNil(A_IdSSLIOHandler);
   FreeAndNil(A_IdSMTP);
end;


function TEmail.EnviarEmail(sUserEmail, sPassWord, sHost, sPorta,
                            sAssunto, sFileCorpo: string; bTLS, bAuth: boolean; sDestinatarios, sCC,
                            sCCo: TStringList; sTextoCorpo, sAnexo: TStrings; bMostraStatus:Boolean=True): Boolean;
begin
   _sUserEmail     := sUserEmail;
   _sPassWord      := sPassWord;
   _sHost          := sHost;
   _sPorta         := sPorta;
   _bTLS           := bTLS;
   _bAuth          := bAuth;
   _sAssunto       := sAssunto;
   _sFileCorpo     := sFileCorpo;
   _sDestinatarios := sDestinatarios;
   _sCC            := sCC;
   _sCCo           := sCCo;
   _sTextoCorpo    := sTextoCorpo;
   _sAnexo         := sAnexo;
   _bMostraStatus  := bMostraStatus;

   Result := Enviar;
end;

function TEmail.EnviarEmailSimples(sAssunto, sFileCorpo, sDestinatarios: string;
                                   sCC, sCCo: TStringList; sTextoCorpo, sAnexo: TStrings; bMostraStatus:Boolean=True): Boolean;
begin
   _sAssunto       := sAssunto;
   _sFileCorpo     := sFileCorpo;
   _sDestinatariosA := sDestinatarios;
   _sCC            := sCC;
   _sCCo           := sCCo;
   _sTextoCorpo    := sTextoCorpo;
   _sAnexo         := sAnexo;
   _bMostraStatus  := bMostraStatus;

   Result := Enviar;
end;

procedure TEmail.A_IdSMTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
begin
  inherited;

   if FAbortou then
      A_IdSMTP.Socket.Close;
end;

procedure TEmail.A_IdSMTPWorkBegin(ASender: TObject;  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
  inherited;
   if _bMostraStatus then
   begin
//      // Passa a instancia do objeto que ira conter o metodo de cancelamento
//      FRM_PROGRESSBAR.oObjeto := self;
//      // Passa o nome do metodo que ira cancelar o envio dos emails, acionado pelo botão cancelar do form progresso
//      FRM_PROGRESSBAR.sMetodo := 'AbortaEnvio';
//      FRM_PROGRESSBAR.Mostrar('Enviando Mensagem...',iTamanhoEmail);
//      FRM_PROGRESSBAR.Atualizar(0);
   end;

end;

procedure TEmail.A_IdSMTPWorkEnd(ASender: TObject;
  AWorkMode: TWorkMode);
begin
  inherited;
   if _bMostraStatus then
//      FRM_PROGRESSBAR.Esconder;
end;

// O metodo deve estar declarado como published, se estiverem como public ou private não será reconhecido por referencia
procedure TEmail.AbortaEnvio(Sender: TObject);
begin
   SetAbortou(True);
end;

procedure TEmail.SetAbortou(const Value: Boolean);
begin
  FAbortou := Value;
end;

end.

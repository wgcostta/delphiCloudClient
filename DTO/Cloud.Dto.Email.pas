unit Cloud.Dto.Email;

interface
  CONST
  sUserEmail = 'chamados.vsm@gmail.com';
  sPassWord  = 'vsm00000';
  sHost      = 'smtp.gmail.com' ;
  sPorta     = '465';
  bTLS           = True;
  bAuth          = True;
  sAssunto       = 'Cadastro de Pessoas';
  sTextoCorpo    = 'Processo Seletivo InfoSistemas - DELPHI' + sLineBreak +
                 'Segue em Anexo XML com os Dados do Cliente solicitados'+ sLineBreak +
                 'Cordialmente, Wagner Costa.' ;
  sDestinatarios = '';
  sCC            = 'wg.o.costa@gmail.com';
  sCCo           = '';
  sFileCorpo     = '';
  sAnexo         = '';

implementation

end.

unit Cloud.Interfaces;
{  Utilizar a linguagem Delphi (Qualquer versão);
    Criar uma tela de cadastro de clientes, com os seguintes campos:
    Dados do Cadastro:

      Nome
      Identidade
      CPF
      Telefone
      Email
        Endereço
        Cep
        Logradouro
        Numero
        Complemento
        Bairro
        Cidade
        Estado
        Pais
    Ao informar um Cep o sistema deve realizar a busca dos dados relacionados ao mesmo no seguinte endereço: https://viacep.com.br/;
    A forma de consumo da API do via Cep, deverá ser utiliza JSON;
    Ao termino do cadastro o usuário deverá enviar um e-mail contendo as informações cadastrais e anexar um arquivo no formato XML com o mesmo conteúdo;
    Os registros devem ficar salvo em memória, não é necessário criar um banco de dados ou arquivo para o armazenamento dos dados;
    Disponibilizar o código fonte do projeto no github;
}
interface

uses DBClient,
     Generics.Collections,
     Cloud.Dto.Pessoa,
     Cloud.Dto.Pessoa.Endereco, Cloud.Dto.Tabela;

type
  ICloudController = interface
    ['{D297498B-F1A8-4C82-B541-D5D11DA7FBAC}']
   function AddPessoa(var FListaPessoas: TObjectList<TCloudPessoa>) : Boolean;
   function DeletePessoa(var FListaPessoas: TObjectList<TCloudPessoa>;iIdDeletar : Integer): Boolean;
   function UpdatePessoa(var FListaPessoas: TObjectList<TCloudPessoa>;iIDAtualizar : Integer): Boolean;
   function IncluirPessoaNaLista(Dados: array of variant): TCloudPessoa;
   procedure CriarCliente(var FListaPessoas: TObjectList<TCloudPessoa>);
   function CadastrarEndereco(var FListaPessoas: TObjectList<TCloudPessoa>;iIDAtualizar : Integer): Boolean;
   function EnviarEmail(Pessoa : TCloudPessoa;emailDestino : string) : string;
  end;

  IModelEnvioEmail = interface
    ['{95FD0A6B-EE09-4C6A-A4FA-4EA98FB6F3A9}']
   function setPessoa(Pessoa : TCloudPessoa) : IModelEnvioEmail;
   function setEmailDestino(emailDestino : string) : IModelEnvioEmail;
   function &End : IModelEnvioEmail;
   function EnviarEmail : Boolean;
  end;

  ICloudModelPessoa = interface
     ['{BA7D4C2D-ED8A-4DD3-8398-1560C2FCBC92}']
     function ValidaEmail(email: String): Boolean;
  end;


implementation

end.

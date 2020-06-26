unit Cloud.Dto.Tabela;

interface
uses
   DBClient,
   Generics.Collections,
   System.RTTI,
   System.TypInfo;

   type
      TCloudTabela = class

      end;

      TVSMCloudTabelaHelper = class helper for TCloudTabela
         public
            class procedure PreencherDataSet<T : TCloudTabela>(var ClientDataSet: TClientDataSet;
                                 FLista: TObjectList<T>);
      end;



implementation

{ TCloudTabela }

class procedure TVSMCloudTabelaHelper.PreencherDataSet<T>(var ClientDataSet: TClientDataSet; FLista: TObjectList<T>);
var
  AuxValue: TValue;
  Contexto: TRttiContext;
  TipoRtti: TRttiType;
  PropriedadeNome: TRttiProperty;
  Funcionario: TCloudTabela;
begin
   ClientDataSet.Close;
   ClientDataSet.CreateDataSet;
   // Cria o contexto do RTTI
   Contexto := TRttiContext.Create;
   try
      // Obtém as informações de RTTI da classe TFuncionario
      AuxValue := GetTypeData(PTypeInfo(TypeInfo(T)))^.ClassType.Create;
      TipoRtti := Contexto.GetType(AuxValue.AsObject.ClassInfo);
//      TipoRtti := Contexto.GetType(TCloudTabela.ClassInfo);

      // Obtém um objeto referente à propriedade "Nome" da classe TFuncionario
      PropriedadeNome := TipoRtti.GetProperty('Nome');

      // Percorre a lista de objetos, inserindo o valor da propriedade "Nome" do ClientDataSet
      for Funcionario in FLista do
      ClientDataSet.AppendRecord([PropriedadeNome.GetValue(Funcionario).AsString]);

      ClientDataSet.First;
   finally
      Contexto.Free;
   end;
end;

end.

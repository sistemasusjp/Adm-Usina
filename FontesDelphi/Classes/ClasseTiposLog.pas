unit ClasseTiposLog;

interface

type
  TTipoLog = ( tlErro = 0,
               tlIncluiu = 1,
               tlAlterou = 2,
               tlExcluiu = 3,
               tlExcluiuFisicamente = 4,
               tlLogon = 5,
               tlLogoff = 6,
               tlEstatisticaUso = 7 );

const
  CONST_TipoLog : array of String
                      = ['ERRO',
                         'INCLUIU',
                         'ALTEROU',
                         'EXCLUIU',
                         'EXCLUIU_FISICAMENTE',
                         'LOGON',
                         'LOGOFF',
                         'ESTATISTICAUSO'];

implementation

end.

unit Configuracoes.Controller;

interface
   uses Horse,
        System.JSON, System.SysUtils,

        { MyUnits }
        Model.Configuracoes;

procedure Registry;
procedure ListarConfiguracoes(Req: THorseRequest; Res: THorseResponse; Next : Tproc);

implementation

procedure Registry;
begin
  THorse.Get('Configuracoes',ListarConfiguracoes);
end;


procedure ListarConfiguracoes(Req: THorseRequest; Res: THorseResponse; Next : Tproc);
var
  Config : TConfig;
begin
  Config := TConfig.Create;

  try
    Res.Send<TJSONObject>(Config.getConfig)
  finally
    FreeAndNil(Config);
  end;
end;
end.

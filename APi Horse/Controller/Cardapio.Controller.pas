unit Cardapio.Controller;

interface
  uses System.SysUtils,
       Horse, Horse.jhonson,
       Model.Cardapio;

  procedure Registry;
  procedure ListarCardapio(Req: THorseRequest; Res:THorseResponse; Next : TProc );


implementation

procedure ListarCardapio(Req: THorseRequest; Res:THorseResponse; Next : TProc );
var
  Cardapio : TCardaprio;
begin
  Cardapio := TCardaprio.Create;
  try
    Res.Send(Cardapio.ListaCardapio).Status(200);
  finally
    FreeAndNil(Cardapio);
  end;
end;

procedure Registry;
begin
  THorse.Get('Cardapio',ListarCardapio);
end;

end.

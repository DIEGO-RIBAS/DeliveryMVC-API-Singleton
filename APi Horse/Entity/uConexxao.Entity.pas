unit uConexxao.Entity;

interface
   uses system.SysUtils;

   type

   TConexaoMySQl = class
     private
      FDriverID : string;
      FUserName : string;
      FPassword :string;
      FDataBase : string;

   public
     property DriverID : string read FDriverID;
     property UserName : string read FUserName;
     property Password :string read FPassword;
     property DataBase :string read FDataBase;

     constructor Create;
   end;

   TConexaoSQLite = class
     private
      FDriverID : string;
      FUserName : string;
      FPassword :string;
      FDataBase : string;

   public
     property DriverID : string read FDriverID;
     property UserName : string read FUserName;
     property Password :string read FPassword;
     property DataBase :string read FDataBase;

     constructor Create;

   end;

implementation

{ TConexaoMySQl }

constructor TConexaoMySQl.Create;
begin
  FDriverID := 'MySQl';
  FUserName := 'root';
  FPassword := 'dominus';
  FDataBase := 'dominus';
end;

{ TConexaoSQLite }

constructor TConexaoSQLite.Create;
begin
  FDriverID := 'SQLite';
  FUserName := '';
  FPassword := '';
  FDataBase := ExtractFilePath(ParamStr(0))+ 'FoodDB.DB';
end;

end.

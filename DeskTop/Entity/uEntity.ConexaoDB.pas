unit uEntity.ConexaoDB;

interface
   uses System.SysUtils, system.classes;

   type

     TConexaoMySQL = class
       private
         FUser       : string;
         FPassWord   : string;
         FDataBase   : string;
         FNameDrive  : string;
       public
         property User       : string read FUser      write FUser ;
         property PassWord   : string read FPassWord  write FPassWord;
         property DataBase   : string read FDataBase  write FDataBase;
         property NameDriver : string read FNameDrive write FNameDrive;

         constructor create;
       end;

   TConexaoSQLite = class
     private
      FNameDriver : string;
      FUserName : string;
      FPassword :string;
      FDataBase : string;

   public
     property NameDriver : string read FNameDriver;
     property UserName : string read FUserName;
     property Password :string read FPassword;
     property DataBase :string read FDataBase;

     constructor Create;

   end;

implementation

{ TConexaoMySQL }

constructor TConexaoMySQL.create;
begin
  FUser       := 'root';
  FPassWord   := 'dominus';
  FDataBase   := 'dominus';
  FNameDrive  := 'MySQL';
end;

{ TConexaoSQLite }

constructor TConexaoSQLite.Create;
begin
  FNameDriver := 'SQLite';
  FUserName := '';
  FPassword := '';
  FDataBase := ExtractFilePath(ParamStr(0))+ 'DeskTopCliente.db';
                                          //'D:\Delphi\Projetos\Food\DB\DeskTopCliente.db';
end;

end.

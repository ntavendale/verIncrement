program verIncrement;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  BuildVersion in 'BuildVersion.pas',
  RCProcessor in 'RCProcessor.pas';

procedure WriteUsage;
begin
  WriteLn('Oamaru Group Version Incrementer Utility. Use of this software free for comerical and non comercial use.');
  WriteLn('Demo only. No warranty, express or implied.');
  WriteLn('');
  WriteLn('Syntax: verIncrement <options> filename');
  WriteLn('');
  WriteLn('-v <Major.Minor.Release> = Base Version. Empty and exeisting base in file will be used');
  WriteLn('-d <DecrementBy> = Decrement By (Default 1)');
  WriteLn('-i <IncrementBy> = Increment By (Default 1). Default if -d or -i not specified.');
  WriteLn('-? = Disply help');
end;

function VersionOverride: String;
var
  i: Integer;
begin
  Result := String.Empty;
  for i := 1 to ParamCount do
  begin
    if ('-V' = ParamStr(i).ToUpper) or ('/V'  = ParamStr(i).ToUpper) then
    begin
      Result := ParamStr(i + 1);
      EXIT;
    end;
  end;
end;

var
  i: Integer;
  LVer: String;
begin
  try
    if 0 = ParamCount then
    begin
      WriteUsage;
      EXIT;
    end;

    LVer := VersionOverride;

    for i := 1 to (ParamCount - 1) do
    begin

    end;
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, String.Format('%s: %s', [E.ClassName, E.Message]));
    end;
  end;
end.




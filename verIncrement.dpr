program verIncrement;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.IOUtils,
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

function DecrementBy: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to ParamCount do
  begin
    if ('-D' = ParamStr(i).ToUpper) or ('/D'  = ParamStr(i).ToUpper) then
    begin
      try
        Result := StrToIntDef(ParamStr(i + 1), 1);
      except
        Result := 1;
      end;
      EXIT;
    end;
  end;
end;

function IncrementBy: Integer;
var
  i: Integer;
begin
  Result := 1;
  for i := 1 to ParamCount do
  begin
    if ('-I' = ParamStr(i).ToUpper) or ('/I'  = ParamStr(i).ToUpper) then
    begin
      try
        Result := StrToIntDef(ParamStr(i + 1), 1);
      except
        Result := 1;
      end;
      EXIT;
    end;
  end;
end;

var
  LVer: String;
  LCurrentVersion: TBuildVersion;
  LFile: String;
  LDec, LInc: Integer;
  LRCProcessor : TRCProcessor;
begin
  try
    if 0 = ParamCount then
    begin
      WriteUsage;
      EXIT;
    end;

    LVer := VersionOverride;

    LDec := DecrementBy;
    LInc := IncrementBy;

    LFile := ParamStr(ParamCount);
    if not TFile.Exists(LFile) then
    begin
      WriteLn(String.Format('File %s does not exist!', [LFile]));
      ExitCode := 1;
    end;

    LRCProcessor := TRCProcessor.Create(LFile);
    try
      if not String.IsNullOrWhiteSpace(LVer) then
      begin
        LCurrentVersion := LVer;
      end else
      begin
        LCurrentVersion := LRCProcessor.Version;
      end;

      if LDec <> 0 then
      begin
        try
          LCurrentVersion.Build := LCurrentVersion.Build - LDec;
        except
          LCurrentVersion.Build := 0;
        end;
      end else
      begin
        LCurrentVersion.Build := LCurrentVersion.Build + LInc;
      end;
      LRCProcessor.SetVersion(LCurrentVersion);
      LRCProcessor.Save;
      TFile.WriteAllText(IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0))) + 'currentVersion.json', String.Format('{"major":%d,"minor":%d,"release":%d,"build":%d}', [LCurrentVersion.Major, LCurrentVersion.Minor, LCurrentVersion.Release, LCurrentVersion.Build]));
    finally
      LRCProcessor.Free;
    end;
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, String.Format('%s: %s', [E.ClassName, E.Message]));
    end;
  end;
end.




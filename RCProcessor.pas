unit RCProcessor;

interface

uses
  System.SysUtils, System.Classes, BuildVersion;

type
  TRCProcessor = class
    private
      FFileName: String;
      FVersion: String;
      FFileContents: TStringList;
      function GetVersion: TBuildVersion;
    public
      constructor Create(AFileName: String; ABaseVersion: String);
      destructor Destroy; override;
      procedure SetVersion(AVersion: TBuildVersion);
  end;

implementation

constructor TRCProcessor.Create(AFileName: String; ABaseVersion: String);
begin
  FFileName := AFileName;
  FVersion := ABaseVersion;
  FFileContents := TStringList.Create;
  FFileContents.LoadFromFile(FFileName);
end;

destructor TRCProcessor.Destroy;
begin
  FFileContents.Free;
  inherited Destroy;
end;

function TRCProcessor.GetVersion: TBuildVersion;
var
  i: Integer;
  LTemp: String;
  LVerStr: TArray<String>;
begin
  for i := 0 to (FFileContents.Count - 1) do
  begin
    if -1 <> FFileContents[i].IndexOf('FILEVERSION') then
    begin
      LVerStr := FFileContents[i].Replace('FILEVERSION', '').Trim.Split([',']);
      BREAK;
    end;
    if -1 <> FFileContents[i].IndexOf('PRODUCTVERSION') then
    begin
      LVerStr := FFileContents[i].Replace('PRODUCTVERSION', '').Trim.Split([',']);
      BREAK;
    end;
    if -1 <> FFileContents[i].IndexOf('VALUE "ProductVersion",') then
    begin
      LTemp := FFileContents[i].Replace('VALUE "ProductVersion", "', '').Trim;
      LVerStr := LTemp.Replace('\0"', '').Trim.Split([',']);
      BREAK;
    end;
    if -1 <> FFileContents[i].IndexOf('VALUE "FileVersion",') then
    begin
      LTemp := FFileContents[i].Replace('VALUE "FileVersion", "', '').Trim;
      LVerStr := LTemp.Replace('\0"', '').Trim.Split([',']);
      BREAK;
    end;
  end;
  Result.Major := StrToInt(LVerStr[0]);
  Result.Minor := StrToInt(LVerStr[1]);
  Result.Release := StrToInt(LVerStr[2]);
  Result.Build := StrToInt(LVerStr[3]);
end;

procedure TRCProcessor.SetVersion(AVersion: TBuildVersion);
var
  i: Integer;
begin
  for i := 0 to (FFileContents.Count - 1) do
  begin
    if -1 <> FFileContents[i].IndexOf('FILEVERSION') then
      FFileContents[i] := String.Format('FILEVERSION %d,%d,%d,%d', [AVersion.Major, AVersion.Minor, AVersion.Release, AVersion.Build]);
    if -1 <> FFileContents[i].IndexOf('PRODUCTVERSION') then
      FFileContents[i] := String.Format('PRODUCTVERSION %d,%d,%d,%d', [AVersion.Major, AVersion.Minor, AVersion.Release, AVersion.Build]);
    if -1 <> FFileContents[i].IndexOf('VALUE "ProductVersion",') then
      FFileContents[i] := String.Format('VALUE "ProductVersion", "%d,%d,%d,%d\0"', [AVersion.Major, AVersion.Minor, AVersion.Release, AVersion.Build]);
    if -1 <> FFileContents[i].IndexOf('VALUE "FileVersion",') then
      FFileContents[i] := String.Format('VALUE "FileVersion", "%d,%d,%d,%d\0"', [AVersion.Major, AVersion.Minor, AVersion.Release, AVersion.Build]);
  end;
end;

end.

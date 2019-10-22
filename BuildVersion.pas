unit BuildVersion;

interface

uses
  System.SysUtils, System.Classes;

type
  TBuildVersion = record
     Major: Cardinal;
     Minor: Cardinal;
     Release: Cardinal;
     Build: Cardinal;
     class operator Implicit(a: String): TBuildVersion;     // Implicit conversion of an Integer to type TMyClass
     class operator Implicit(a: TBuildVersion): String;     // Implicit conversion of TMyClass to Integer
     class operator Equal(a, b: TBuildVersion) : Boolean;
     class operator GreaterThan(a, b: TBuildVersion) : Boolean;
     class operator GreaterThanOrEqual(a, b: TBuildVersion) : Boolean;
     class operator LessThan(a, b: TBuildVersion) : Boolean;
     class operator LessThanOrEqual(a, b: TBuildVersion) : Boolean;
     class operator Inc(a: TBuildVersion): TBuildVersion;
     class operator Dec(a: TBuildVersion): TBuildVersion;
   end;

implementation

class operator TBuildVersion.Implicit(a: String): TBuildVersion;
var
  LComponents: TArray<String>;
  Len: Integer;
begin
  if String.IsNullOrWhiteSpace(a) then
    raise EConvertError.Create(String.Format('String %s is not a valid Version', [a]));

  LComponents := a.Split(['.']);
  Len := Length(LComponents);
  if (0 = Length(LComponents)) then
    raise EConvertError.Create(String.Format('String %s is not a valid Version', [a]));

  Result.Major := 0;
  Result.Minor := 0;
  Result.Release := 0;
  Result.Build := 0;

  if Len > 0 then
  begin
    try
      Result.Major := StrToInt(LComponents[0].Trim);
    except
      raise EConvertError.Create(String.Format('String %s is not a valid Version', [a]));
    end;
  end;

  if Len > 1 then
  begin
    try
      Result.Minor := StrToInt(LComponents[1].Trim);
    except
      raise EConvertError.Create(String.Format('String %s is not a valid Version', [a]));
    end;
  end;

  if Len > 2 then
  begin
    try
      Result.Release := StrToInt(LComponents[2].Trim);
    except
      raise EConvertError.Create(String.Format('String %s is not a valid Version', [a]));
    end;
  end;

  if Len > 3 then
  begin
    try
      Result.Build := StrToInt(LComponents[3].Trim);
    except
      raise EConvertError.Create(String.Format('String %s is not a valid Version', [a]));
    end;
  end;
end;

class operator TBuildVersion.Implicit(a: TBuildVersion): String;     // Implicit conversion of TMyClass to String
begin
  Result := String.Format('%d.%d.%d.%d', [a.Major, a.Minor, a.Release, a.Build]);
end;

class operator TBuildVersion.Equal(a, b: TBuildVersion) : Boolean;
begin
  Result := (a.Major = b.Major) and
            (a.Minor = b.Minor) and
            (a.Build = b.Build) and
            (a.Release = b.Release);
end;

class operator TBuildVersion.GreaterThan(a, b: TBuildVersion) : Boolean;
begin
  Result := (a.Major > b.Major) or
            ((a.Major = b.Major) and (a.Minor > b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build > b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release > b.Release));
end;

class operator TBuildVersion.GreaterThanOrEqual(a, b: TBuildVersion) : Boolean;
begin
  Result := (a.Major = b.Major) and
            (a.Minor = b.Minor) and
            (a.Build = b.Build) and
            (a.Release = b.Release);
  if Result then
    EXIT;

  Result := (a.Major > b.Major) or
            ((a.Major = b.Major) and (a.Minor > b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build > b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release > b.Release));
end;

class operator TBuildVersion.LessThan(a, b: TBuildVersion) : Boolean;
begin
  Result := (a.Major < b.Major) or
            ((a.Major = b.Major) and (a.Minor < b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build < b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release < b.Release));
end;

class operator TBuildVersion.LessThanOrEqual(a, b: TBuildVersion) : Boolean;
begin
  Result := (a.Major = b.Major) and
            (a.Minor = b.Minor) and
            (a.Build = b.Build) and
            (a.Release = b.Release);
  if Result then
    EXIT;

  Result := (a.Major < b.Major) or
            ((a.Major = b.Major) and (a.Minor < b.Minor)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build < b.Build)) or
            ((a.Major = b.Major) and (a.Minor = b.Minor) and (a.Build = b.Build) and (a.Release < b.Release));
end;

class operator TBuildVersion.Inc(a: TBuildVersion): TBuildVersion;
begin
  Result.Major := a.Major;
  Result.Minor := a.Minor;
  Result.Release := a.Release;
  Result.Build := a.Build + 1;
end;

class operator TBuildVersion.Dec(a: TBuildVersion): TBuildVersion;
begin
  Result.Major := a.Major;
  Result.Minor := a.Minor;
  Result.Release := a.Release;
  if 0 = a.Build then
    raise Exception.Create(String.Format('Invalid build number %d', [a.Build]));
  Result.Build := a.Build - 1;
end;

end.

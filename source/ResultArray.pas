unit ResultArray;

{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
{$POINTERMATH ON}

interface
uses
  classes, SysUtils, lpsolve;

type
  TResultArray = class
  private
    FList: TList;
    function  GetValue(row, col: integer): TFloat;
    procedure SetValue(row, col: integer; Value: TFloat);
    function  GetColCount: integer;
  public
    constructor Create;
    destructor Destroy; override;
    function  Add(aSize: integer): PFloatArray;
    procedure GetStats(item, len: integer; var min, max: integer);
    procedure Clear;
    property  Value[row, col: integer]: TFloat read GetValue write SetValue; default;
    property  ColCount: integer read GetColCount;
  end;

implementation

{ TResultArray }

function TResultArray.GetValue(row, col: integer): TFloat;
begin
  result := PFloatArray(FList.Items[row])[col];
end;

procedure TResultArray.SetValue(row, col: integer; Value: TFloat);
begin
  PFloatArray(FList.Items[row])[col] := Value;
end;

function TResultArray.GetColCount: integer;
begin
  result := FList.Count;
end;

constructor TResultArray.Create;
begin
  FList := TList.Create;
end;

destructor TResultArray.Destroy;
begin
  Clear;
  FList.Free;
  inherited;
end;

function TResultArray.Add(aSize: integer): PFloatArray;
begin
  Result := GetMem(aSize * sizeof(TFloat));
  FList.Add(Result);
  FillChar(Result^, aSize * sizeof(TFloat), 0);
  Inc(Result);
end;

procedure TResultArray.Clear;
var
  i: integer;
begin
  for i := 0 to FList.Count - 1 do
    FreeMem(FList.Items[i]);
  FList.Clear;
end;

procedure TResultArray.GetStats(item, len: integer; var min, max: integer);
var
  i: integer;
begin
  min := 0; max := 0;
  for i := 1 to len do
  begin
    if min = 0 then
      min := 1
    else
      if abs(PFloatArray(FList.Items[item])[i]) < abs(PFloatArray(FList.Items[item])[min]) then
        min := i;
    if max = 0 then
      max := 1
    else
      if abs(PFloatArray(FList.Items[item])[i]) > abs(PFloatArray(FList.Items[item])[max]) then
        max := i;
  end;
end;

end.



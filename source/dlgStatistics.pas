unit dlgStatistics;

{$MODE Delphi}

interface

uses
  Classes, SysUtils, Controls, Forms, StdCtrls, ComCtrls;

type
  TStatisticsForm = class(TForm)
    Button1: TButton;
    Stats: TListView;
    Stats2: TListView;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StatisticsForm: TStatisticsForm;

implementation
uses
  main, lpobject;

{$R *.lfm}

procedure TStatisticsForm.FormCreate(Sender: TObject);

  procedure AddStat(const name, value: string);
  begin
    with stats.Items.Add do
    begin
      Caption := name;
      SubItems.Add(Value);
    end;
  end;

  procedure AddStat2(const key, nmin, nmax: string; min, max: double);
  begin
    with stats2.Items.Add do
    begin
      Caption := key;
      SubItems.Add(nmin);
      SubItems.Add(FloatToStr(min));
      SubItems.Add(nmax);
      SubItems.Add(FloatToStr(max));
    end;
  end;

var
  a,b,c,d,y, i, j: integer;
begin
  Screen.Cursor := crHourGlass;
  Application.ProcessMessages;
  try
    with MainForm, LPSolver do
    begin
      //constraints
      if (Ncolumns = 0) or (not isLoaded) or (Editor.Modified)  then
      begin
        //if (Mode = sfXLI) then
        //begin
        //  Editor.Lines.SaveToFile(TempFile);
        //  isLoaded := LoadFromFile(TempFile, LPSolver.Verbose, Mode);
        //end else
          isLoaded := LoadFromStrings(Editor.lines, Verbose, Mode);
      end;
      if isLoaded then
      begin
        AddStat('Constraints', inttostr(NRows));
        //Variables
        AddStat('Variables', inttostr(Ncolumns));
        a := 0;
        b := 0;
        c := 0;
        for y := 1 to Ncolumns do
          if IsInt[y] then inc(a) else
          if IsSemiCont[y] then inc(b) else
          if IsSOSVar[y] then inc(c);
        AddStat('Integers', inttostr(a));
        AddStat('Semi-cont', inttostr(b));
        AddStat('SOS', inttostr(c));
        AddStat('Non zero', inttostr(NonZeros));
      end;

      // objective
      if (NColumns > 0) then
      begin
        a := 0;
        b := 0;
        for i := 1 to NColumns do
          if (Mat[0,i] <> 0) then
          begin
            if (a = 0) or (abs(Mat[0,i]) < abs(Mat[0,a])) then a := i;
            if (b = 0) or (abs(Mat[0,i]) > abs(Mat[0,b])) then b := i;
          end;
        if (a > 0) and (b > 0) then
          AddStat2('objective', ColName[a], ColName[b], Mat[0,a], Mat[0,b]);
      end;

      if NRows > 0 then
      begin
        a := 0;
        b := 0;
        for i := 1 to NRows do
          if (Rh[i] <> 0) then
          begin
            if (a = 0) or (abs(Rh[i]) < abs(Rh[a])) then a := i;
            if (b = 0) or (abs(Rh[i]) > abs(Rh[b])) then b := i;
          end;
        if (a > 0) and (b > 0) then
          AddStat2('Constraint', RowName[a],RowName[b], Rh[a], Rh[b]);
      end;

      if (NRows > 0) and (NColumns > 0) then
      begin
        a := 0; b := 0; c := 0; d := 0;
        for i := 1 to NRows do
          for j := 1 to NColumns do
            if Mat[i, j] <> 0 then
            begin
              if (a = 0) or (abs(Mat[i,j]) < abs(Mat[a,b])) then begin a := i; b := j end;
              if (c = 0) or (abs(Mat[i,j]) > abs(Mat[c,d])) then begin c := i; d := j end;
            end;
        if (a > 0) and (c > 0) then
        begin
          AddStat2('Coefficients',  ColName[b] , ColName[d], Mat[a, b], Mat[c,d]);
          with Stats2.Items.Add.SubItems do
          begin
            Add(RowName[a]);
            Add('');
            Add(RowName[c]);
          end;
        end;
      end;
    end;
  finally
    Screen.Cursor :=  crDefault;
  end;

end;

end.


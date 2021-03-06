program LpSolveIDE;

{$MODE Delphi}
{$IFDEF MSWINDOWS}
  {$APPTYPE CONSOLE}
// this keeps a console window for lp_solve stderr and stdout.
// can run without but a cmd window pops up on each write
// The cmd window close box bypasses the close query method  that the window uses.
// also if the window errors with exception, it will DRWatson from its close box
// but closing the cmd window exits both without DRWason SEND request.

  {.$DEFINE HIDE_CONSOLE_WND}
//this hide console window if needed

{$ENDIF}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HIDE_CONSOLE_WND}
  windows,
  {$ENDIF HIDE_CONSOLE_WND}
  Interfaces, SysUtils, Forms, LazFileUtils, main;

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := '';
  {$IFDEF HIDE_CONSOLE_WND}ShowWindow(GetConsoleWindow, SW_HIDE);{$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  if (ParamCount > 0) then
    if FileExistsUtf8(ParamStr(1)) then
      MainForm.OpenFile(ParamStr(1));
  Application.Run;
end.


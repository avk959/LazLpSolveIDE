program LpSolveIDE;

{$MODE Delphi}

{$APPTYPE CONSOLE}
// this keeps a console window for lp_solve stderr and stdout.
// can run without but a cmd window pops up on each write
// The cmd window close box bypasses the close query method  that the widow uses.
// also if the window errors with exception, it will DRWatson from its close box
// but closing the cmd window exits both without DRWason SEND request.
uses
  Interfaces, SysUtils, Forms, main, LPHighlighter, dlgSearchText, dlgReplaceText,
  dlgConfirmReplace, dlgGotoLine, dlgAbout, ResultArray, Params, dlgStatistics;

{$R *.res}

begin
  Application.Initialize;
  Application.HelpFile := '';
  Application.CreateForm(TMainForm, MainForm);
  if (ParamCount > 0) then
    if FileExists(ParamStr(1)) then
      MainForm.OpenFile(ParamStr(1));
  Application.Run;
end.


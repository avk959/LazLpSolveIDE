unit dlgEditorOpts;

{$mode delphi}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ColorBox, EditBtn, StdCtrls, ExtCtrls, ComCtrls,
  Buttons, Spin, LPSynEdit, SynEdit, SynEditHighlighter, LPHighlighter, SynGutterBase,
  SynGutterLineNumber;

type

  { TfrmEditorOptsDlg }

  TfrmEditorOptsDlg = class(TForm)
    btOk: TButton;
    btCancel: TButton;
    chgKeywordStyle: TCheckGroup;
    chgNumberStyle: TCheckGroup;
    chgCommentStyle: TCheckGroup;
    clbLineNumberColor: TColorBox;
    clbCurrLine: TColorBox;
    clbKeyword: TColorBox;
    clbNumber: TColorBox;
    clbComment: TColorBox;
    edFontName: TEdit;
    FontDlg: TFontDialog;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    sePreveiw: TLPSynEdit;
    PageControl1: TPageControl;
    pnMain: TPanel;
    sbShowFontDialog: TSpeedButton;
    spedFontSize: TSpinEdit;
    sedLineSpace: TSpinEdit;
    sedCharSpace: TSpinEdit;
    sedNthNumber: TSpinEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure chgCommentStyleItemClick(Sender: TObject; Index: integer);
    procedure chgKeywordStyleItemClick(Sender: TObject; Index: integer);
    procedure chgNumberStyleItemClick(Sender: TObject; Index: integer);
    procedure clbCommentChange(Sender: TObject);
    procedure clbCurrLineChange(Sender: TObject);
    procedure clbKeywordChange(Sender: TObject);
    procedure clbLineNumberColorChange(Sender: TObject);
    procedure clbNumberChange(Sender: TObject);
    procedure edFontNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbShowFontDialogClick(Sender: TObject);
    procedure sedCharSpaceChange(Sender: TObject);
    procedure sedLineSpaceChange(Sender: TObject);
    procedure sedNthNumberChange(Sender: TObject);
    procedure spedFontSizeChange(Sender: TObject);
  private
    FEditor: TSynEdit;
    FHighlighter: TLPHighlighter;
    procedure SetEditor(aValue: TSynEdit);
    procedure ReadOptions;
    procedure SaveOptions;
  public
    property Editor: TSynEdit read FEditor write SetEditor;
  end;

var
  frmEditorOptsDlg: TfrmEditorOptsDlg;

implementation

{$R *.lfm}

const
  SDisplayText =
    '  /* EXAMPLE */ '                      + SLineBreak +
    '  /* Objective function */'            + SLineBreak +
    'minimize: +1.5 x1 + x2 + 1.5 x3 + x4;' + SLineBreak +
    '  /* Constraints */'                   + SLineBreak +
    'c1: x1 + x2 + 2 x3 = 40;'              + SLineBreak +
    'c2: 3.2 x2 + x3 + 1.7 x4 >= 50;'       + SLineBreak +
    'int x2;'                               + SLineBreak +
    'binary x3;';
  IDX_ITALIC = 0;
  IDX_BOLD   = 1;
{ TfrmEditorOptsDlg }

procedure TfrmEditorOptsDlg.FormCreate(Sender: TObject);
begin
  FHighlighter := TLPHighlighter.Create(self);
  FHighlighter.Language := lLP;
  sePreveiw.Text := SDisplayText;
  sePreveiw.CaretY := 3;
  sePreveiw.Highlighter := FHighlighter;
end;

procedure TfrmEditorOptsDlg.edFontNameChange(Sender: TObject);
begin
  sePreveiw.Font.Name := edFontName.Text;
end;

procedure TfrmEditorOptsDlg.clbLineNumberColorChange(Sender: TObject);
begin
  TSynGutterLineNumber(sePreveiw.Gutter.Parts[1]).MarkupInfo.Foreground := clbLineNumberColor.Selected;
end;

procedure TfrmEditorOptsDlg.clbNumberChange(Sender: TObject);
begin
  FHighlighter.NumberAttri.Foreground := clbNumber.Selected;
end;

procedure TfrmEditorOptsDlg.clbCurrLineChange(Sender: TObject);
begin
  sePreveiw.LineHighlightColor.Background := clbCurrLine.Selected;
end;

procedure TfrmEditorOptsDlg.chgKeywordStyleItemClick(Sender: TObject; Index: integer);
begin
  if Index = IDX_ITALIC then
    begin
      if chgKeywordStyle.Checked[Index] then
        FHighlighter.KeyAttri.Style := FHighlighter.KeyAttri.Style + [fsItalic]
      else
        FHighlighter.KeyAttri.Style := FHighlighter.KeyAttri.Style - [fsItalic];
    end
  else
    begin
      if chgKeywordStyle.Checked[Index] then
        FHighlighter.KeyAttri.Style := FHighlighter.KeyAttri.Style + [fsBold]
      else
        FHighlighter.KeyAttri.Style := FHighlighter.KeyAttri.Style - [fsBold]
    end;
end;

procedure TfrmEditorOptsDlg.chgCommentStyleItemClick(Sender: TObject; Index: integer);
begin
  if Index = IDX_ITALIC then
    begin
      if chgCommentStyle.Checked[Index] then
        FHighlighter.CommentAttri.Style := FHighlighter.CommentAttri.Style + [fsItalic]
      else
        FHighlighter.CommentAttri.Style := FHighlighter.CommentAttri.Style - [fsItalic];
    end
  else
    begin
      if chgCommentStyle.Checked[Index] then
        FHighlighter.CommentAttri.Style := FHighlighter.CommentAttri.Style + [fsBold]
      else
        FHighlighter.CommentAttri.Style := FHighlighter.CommentAttri.Style - [fsBold]
    end;
end;

procedure TfrmEditorOptsDlg.chgNumberStyleItemClick(Sender: TObject; Index: integer);
begin
  if Index = IDX_ITALIC then
    begin
      if chgNumberStyle.Checked[Index] then
        FHighlighter.NumberAttri.Style := FHighlighter.NumberAttri.Style + [fsItalic]
      else
        FHighlighter.NumberAttri.Style := FHighlighter.NumberAttri.Style - [fsItalic];
    end
  else
    begin
      if chgNumberStyle.Checked[Index] then
        FHighlighter.NumberAttri.Style := FHighlighter.NumberAttri.Style + [fsBold]
      else
        FHighlighter.NumberAttri.Style := FHighlighter.NumberAttri.Style - [fsBold]
    end;
end;

procedure TfrmEditorOptsDlg.clbCommentChange(Sender: TObject);
begin
  FHighlighter.CommentAttri.Foreground := clbComment.Selected;
end;

procedure TfrmEditorOptsDlg.clbKeywordChange(Sender: TObject);
begin
  FHighlighter.KeyAttri.Foreground := clbKeyword.Selected;
end;

procedure TfrmEditorOptsDlg.FormDestroy(Sender: TObject);
begin
  if (ModalResult = mrOk) and Assigned(FEditor) then
    SaveOptions;
end;

procedure TfrmEditorOptsDlg.sbShowFontDialogClick(Sender: TObject);
begin
  if not FontDlg.Execute then
    exit;
  edFontName.Text := FontDlg.Font.Name;
end;

procedure TfrmEditorOptsDlg.sedCharSpaceChange(Sender: TObject);
begin
  sePreveiw.ExtraCharSpacing := sedCharSpace.Value;
end;

procedure TfrmEditorOptsDlg.sedLineSpaceChange(Sender: TObject);
begin
  sePreveiw.ExtraLineSpacing := sedLineSpace.Value;
end;

procedure TfrmEditorOptsDlg.sedNthNumberChange(Sender: TObject);
begin
  TSynGutterLineNumber(sePreveiw.Gutter.Parts[1]).ShowOnlyLineNumbersMultiplesOf := sedNthNumber.Value;
end;

procedure TfrmEditorOptsDlg.spedFontSizeChange(Sender: TObject);
begin
  sePreveiw.Font.Size := spedFontSize.Value;
end;

procedure TfrmEditorOptsDlg.SetEditor(aValue: TSynEdit);
begin
  if FEditor = aValue then
    exit;
  FEditor := aValue;
  ReadOptions;
end;

procedure TfrmEditorOptsDlg.ReadOptions;
begin
  edFontName.Text := Editor.Font.Name;
  spedFontSize.Value := Editor.Font.Size;
  sedLineSpace.Value := Editor.ExtraLineSpacing;
  sedCharSpace.Value := Editor.ExtraCharSpacing;
  sedNthNumber.Value := TSynGutterLineNumber(Editor.Gutter.Parts[1]).ShowOnlyLineNumbersMultiplesOf;
  clbLineNumberColor.Selected := TSynGutterLineNumber(Editor.Gutter.Parts[1]).MarkupInfo.Foreground;
  clbCurrLine.Selected := Editor.LineHighlightColor.Background;

  clbKeyword.Selected := Editor.Highlighter.KeywordAttribute.Foreground;
  chgKeywordStyle.Checked[IDX_ITALIC] := fsItalic in Editor.Highlighter.KeywordAttribute.Style;
  chgKeywordStyleItemClick(chgKeywordStyle, IDX_ITALIC);
  chgKeywordStyle.Checked[IDX_BOLD] := fsBold in Editor.Highlighter.KeywordAttribute.Style;
  chgKeywordStyleItemClick(chgKeywordStyle, IDX_BOLD);

  clbNumber.Selected := TLPHighlighter(Editor.Highlighter).NumberAttri.Foreground;
  chgNumberStyle.Checked[IDX_ITALIC] := fsItalic in TLPHighlighter(Editor.Highlighter).NumberAttri.Style;
  chgNumberStyleItemClick(chgNumberStyle, IDX_ITALIC);
  chgNumberStyle.Checked[IDX_BOLD] := fsBold in TLPHighlighter(Editor.Highlighter).NumberAttri.Style;
  chgNumberStyleItemClick(chgNumberStyle, IDX_BOLD);

  clbComment.Selected := Editor.Highlighter.CommentAttribute.Foreground;
  chgCommentStyle.Checked[IDX_ITALIC] := fsItalic in Editor.Highlighter.CommentAttribute.Style;
  chgCommentStyleItemClick(chgCommentStyle, IDX_ITALIC);
  chgCommentStyle.Checked[IDX_BOLD] := fsBold in Editor.Highlighter.CommentAttribute.Style;
  chgCommentStyleItemClick(chgCommentStyle, IDX_BOLD);
end;

procedure TfrmEditorOptsDlg.SaveOptions;
begin
  Editor.Lines.BeginUpdate;
  try
    Editor.Font.Name := edFontName.Text;
    Editor.Font.Size := spedFontSize.Value;
    Editor.ExtraLineSpacing := sedLineSpace.Value;
    Editor.ExtraCharSpacing := sedCharSpace.Value;
    TSynGutterLineNumber(Editor.Gutter.Parts[1]).ShowOnlyLineNumbersMultiplesOf := sedNthNumber.Value;
    TSynGutterLineNumber(Editor.Gutter.Parts[1]).MarkupInfo.Foreground := clbLineNumberColor.Selected;
    Editor.LineHighlightColor.Background := clbCurrLine.Selected;

    Editor.Highlighter.KeywordAttribute.Foreground := clbKeyword.Selected;
    if chgKeywordStyle.Checked[IDX_ITALIC] then
      Editor.Highlighter.KeywordAttribute.Style := Editor.Highlighter.KeywordAttribute.Style + [fsItalic]
    else
      Editor.Highlighter.KeywordAttribute.Style := Editor.Highlighter.KeywordAttribute.Style - [fsItalic];
    if chgKeywordStyle.Checked[IDX_BOLD] then
      Editor.Highlighter.KeywordAttribute.Style := Editor.Highlighter.KeywordAttribute.Style + [fsBold]
    else
      Editor.Highlighter.KeywordAttribute.Style := Editor.Highlighter.KeywordAttribute.Style - [fsBold];

    TLPHighlighter(Editor.Highlighter).NumberAttri.Foreground := clbNumber.Selected;
    if chgNumberStyle.Checked[IDX_ITALIC] then
      TLPHighlighter(Editor.Highlighter).NumberAttri.Style :=
        TLPHighlighter(Editor.Highlighter).NumberAttri.Style + [fsItalic]
    else
      TLPHighlighter(Editor.Highlighter).NumberAttri.Style :=
        TLPHighlighter(Editor.Highlighter).NumberAttri.Style - [fsItalic];
    if chgNumberStyle.Checked[IDX_BOLD] then
      TLPHighlighter(Editor.Highlighter).NumberAttri.Style :=
        TLPHighlighter(Editor.Highlighter).NumberAttri.Style + [fsBold]
    else
      TLPHighlighter(Editor.Highlighter).NumberAttri.Style :=
        TLPHighlighter(Editor.Highlighter).NumberAttri.Style - [fsBold];

    Editor.Highlighter.CommentAttribute.Foreground := clbComment.Selected;
    if chgCommentStyle.Checked[IDX_ITALIC] then
      Editor.Highlighter.CommentAttribute.Style := Editor.Highlighter.CommentAttribute.Style + [fsItalic]
    else
      Editor.Highlighter.CommentAttribute.Style := Editor.Highlighter.CommentAttribute.Style - [fsItalic];
    if chgCommentStyle.Checked[IDX_BOLD] then
      Editor.Highlighter.CommentAttribute.Style := Editor.Highlighter.CommentAttribute.Style + [fsBold]
    else
      Editor.Highlighter.CommentAttribute.Style := Editor.Highlighter.CommentAttribute.Style - [fsBold];
  finally
    Editor.Lines.EndUpdate;
  end;
end;

end.


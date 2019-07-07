unit dlgSearchText;

{$MODE Delphi}

{.$I SynEdit.inc}

interface

uses
  Classes, SysUtils, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus;

type
  TTextSearchDialog = class(TForm)
    Label1: TLabel;
    cbSearchText: TComboBox;
    rgSearchDirection: TRadioGroup;
    gbSearchOptions: TGroupBox;
    cbSearchCaseSensitive: TCheckBox;
    cbSearchWholeWords: TCheckBox;
    cbSearchFromCursor: TCheckBox;
    cbSearchSelectedOnly: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    cbRegularExpression: TCheckBox;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function GetSearchBackwards: boolean;
    function GetSearchCaseSensitive: boolean;
    function GetSearchFromCursor: boolean;
    function GetSearchInSelection: boolean;
    function GetSearchText: string;
    function GetSearchTextHistory: string;
    function GetSearchWholeWords: boolean;
    procedure SetSearchBackwards(Value: boolean);
    procedure SetSearchCaseSensitive(Value: boolean);
    procedure SetSearchFromCursor(Value: boolean);
    procedure SetSearchInSelection(Value: boolean);
    procedure SetSearchText(Value: string);
    procedure SetSearchTextHistory(Value: string);
    procedure SetSearchWholeWords(Value: boolean);
    procedure SetSearchRegularExpression(const Value: boolean);
    function GetSearchRegularExpression: boolean;
  public
    property SearchBackwards: boolean read GetSearchBackwards
      write SetSearchBackwards;
    property SearchCaseSensitive: boolean read GetSearchCaseSensitive
      write SetSearchCaseSensitive;
    property SearchFromCursor: boolean read GetSearchFromCursor
      write SetSearchFromCursor;
    property SearchInSelectionOnly: boolean read GetSearchInSelection
      write SetSearchInSelection;
    property SearchText: string read GetSearchText write SetSearchText;
    property SearchTextHistory: string read GetSearchTextHistory
      write SetSearchTextHistory;
    property SearchWholeWords: boolean read GetSearchWholeWords
      write SetSearchWholeWords;
    property SearchRegularExpression: boolean read GetSearchRegularExpression
      write SetSearchRegularExpression;
  end;

var
  gbSearchBackwards: boolean;
  gbSearchCaseSensitive: boolean;
  gbSearchFromCaret: boolean;
  gbSearchSelectionOnly: boolean;
  gbSearchTextAtCaret: boolean;
  gbSearchWholeWords: boolean;
  gbSearchRegex: boolean;

  gsSearchText: string;
  gsSearchTextHistory: string;
  gsReplaceText: string;
  gsReplaceTextHistory: string;
  

implementation

{$R *.lfm}

{ TTextSearchDialog }

function TTextSearchDialog.GetSearchBackwards: boolean;
begin
  Result := rgSearchDirection.ItemIndex = 1;
end;

function TTextSearchDialog.GetSearchCaseSensitive: boolean;
begin
  Result := cbSearchCaseSensitive.Checked;
end;

function TTextSearchDialog.GetSearchFromCursor: boolean;
begin
  Result := cbSearchFromCursor.Checked;
end;

function TTextSearchDialog.GetSearchInSelection: boolean;
begin
  Result := cbSearchSelectedOnly.Checked;
end;

function TTextSearchDialog.GetSearchRegularExpression: boolean;
begin
  Result := cbRegularExpression.Checked;
end;

function TTextSearchDialog.GetSearchText: string;
begin
  Result := cbSearchText.Text;
end;

function TTextSearchDialog.GetSearchTextHistory: string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to cbSearchText.Items.Count - 1 do begin
    if i >= 10 then
      break;
    if i > 0 then
      Result := Result + LineEnding;
    Result := Result + cbSearchText.Items[i];
  end;
end;

function TTextSearchDialog.GetSearchWholeWords: boolean;
begin
  Result := cbSearchWholeWords.Checked;
end;

procedure TTextSearchDialog.SetSearchBackwards(Value: boolean);
begin
  rgSearchDirection.ItemIndex := Ord(Value);
end;

procedure TTextSearchDialog.SetSearchCaseSensitive(Value: boolean);
begin
  cbSearchCaseSensitive.Checked := Value;
end;

procedure TTextSearchDialog.SetSearchFromCursor(Value: boolean);
begin
  cbSearchFromCursor.Checked := Value;
end;

procedure TTextSearchDialog.SetSearchInSelection(Value: boolean);
begin
  cbSearchSelectedOnly.Checked := Value;
end;

procedure TTextSearchDialog.SetSearchText(Value: string);
begin
  cbSearchText.Text := Value;
end;

procedure TTextSearchDialog.SetSearchTextHistory(Value: string);
begin
  cbSearchText.Items.Text := Value;
end;

procedure TTextSearchDialog.SetSearchWholeWords(Value: boolean);
begin
  cbSearchWholeWords.Checked := Value;
end;

procedure TTextSearchDialog.SetSearchRegularExpression(
  const Value: boolean);
begin
  cbRegularExpression.Checked := Value;
end;

{ event handlers }

procedure TTextSearchDialog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  s: string;
  i: integer;
begin
  if ModalResult = mrOK then
  begin
    s := cbSearchText.Text;
    if s <> '' then
    begin
      i := cbSearchText.Items.IndexOf(s);
      if i > -1 then
      begin
        cbSearchText.Items.Delete(i);
        cbSearchText.Items.Insert(0, s);
        cbSearchText.Text := s;
      end else
        cbSearchText.Items.Insert(0, s);
    end;
  end;
end;

end.

 

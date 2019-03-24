unit LPHighlighter;

{$MODE Delphi}

{.$I SynEdit.inc}

interface

uses
  Classes, SysUtils, Graphics, SynEditTypes, SynEditHighlighter;

type
  TtkTokenKind = (tkComment, tkIdentifier, tkKey, tkNull, tkNumber,
    tkPreprocessor, tkSpace, tkString, tkSymbol, tkUnknown);
  TRangeState = (rsANil, rsAnsi, rsLPStyle, rsLPTStyle, rsMPSStyle, rsLinStyle, rsUnKnown);
  TStringDelim = (sdSingleQuote, sdDoubleQuote);
  TProcTableProc = procedure of object;

  TLPLanguage = (
    lUnknown,
    lLP,
    lLPT,
    lMPS,
    lMathProg,
    lXML,
    lLINDO,
    lZIMPL,
    lLPX
  );

const
  Languages: array[TLPLanguage] of string = ('', 'LP', 'CPLEX', 'MPS', 'MATHPROG', 'XML', 'LINDO', 'ZIMPL', 'XPRESS');

type

  { TLPHighlighter }

  //TLPHighlighter = class(TSynCustomHighlighter)
  TLPHighlighter = class(TSynCustomHighlighter)
  private
    fRange: TRangeState;
    fLine: PChar;
    fProcTable: array[#0..#255] of TProcTableProc;
    Run: LongInt;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fLineNumber : Integer;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fNumberAttri: TSynHighlighterAttributes;
    fPreprocessorAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    fSymbolAttri: TSynHighlighterAttributes;
    fStringDelimCh: char;
    fIdentChars: TSynIdentChars;
    fDetectPreprocessor: boolean;
    FLanguage: TLPLanguage;
//    procedure AsciiCharProc;
    procedure CRProc;
    procedure IdentProc;
    procedure IntegerProc;
    procedure LFProc;
    procedure NullProc;
    procedure NumberProc;
    procedure SlashProc;
    procedure AntiSlashProc;
    procedure StarProc;
    procedure SharpProc;
    procedure ExclamProc;
    procedure SpaceProc;
    procedure StringProc;
    procedure UnknownProc;
    procedure MakeMethodTables;
    procedure LPStyleProc;
    procedure LPTStyleProc;
    function GetStringDelim: TStringDelim;
    procedure SetStringDelim(const Value: TStringDelim);
    function GetIdentifierChars: string;
    procedure SetIdentifierChars(const Value: string);
    procedure SetDetectPreprocessor(Value: boolean);
    procedure SetLanguage(const Value: TLPLanguage);
    //procedure SetScriptFormat(const Value: TScriptFormat);
  protected
    function GetIdentChars: TSynIdentChars; override;
  public
    class function GetLanguageName: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
      override;
    function GetEol: Boolean; override;
    function GetRange: Pointer; override;
    function GetTokenID: TtkTokenKind;
    function GetToken: String; override;
    procedure GetTokenEx(out TokenStart: PChar; out TokenLength: integer); override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    function IsKeyword(const AKeyword: string): boolean; override;              //mh 2000-11-08
    procedure Next; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    procedure SetLine(const NewValue: String; LineNumber: Integer); override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property DetectPreprocessor: boolean read fDetectPreprocessor write SetDetectPreprocessor;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property IdentifierChars: string read GetIdentifierChars write SetIdentifierChars;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property NumberAttri: TSynHighlighterAttributes read fNumberAttri write fNumberAttri;
    property PreprocessorAttri: TSynHighlighterAttributes read fPreprocessorAttri write fPreprocessorAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;
    property SymbolAttri: TSynHighlighterAttributes read fSymbolAttri write fSymbolAttri;
    property StringDelim: TStringDelim read GetStringDelim write SetStringDelim default sdSingleQuote;
    property Language: TLPLanguage read FLanguage write SetLanguage;
  end;

  function FindLanguage(str: string): TLPLanguage;

implementation

uses
  SynEditStrConst;

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable:  array[#0..#255] of Integer;

  LPKeyWords: array[0..11] of string = ('MAX','MIN','INT','SEC','SOS','SOSX',
    'MINIMIZE', 'MAXIMIZE', 'MINIMISE', 'MAXIMISE', 'BIN', 'BINARY');

  LPTKeyWords: array[0..29] of string = ('bin','binaries','binary','bound',
    'bounds','end','free','gen','general','generals','inf','infinity','int',
    'integer','integers','max','maximize','maximum','min','minimize','minimum',
    's.t.','semi-continuous','sos','st','st.','subject','such','that','to');

  LPXKeyWords: array[0..39] of string = ('bin','binaries','binary','bins','bound',
    'bounds','continuous','end','free','gen','general','generals','gens','inf','infinity',
    'int','integer','integers','ints','max','maximize','maximum','min','minimize','minimum',
    'p.i.','s.c.','s.i.','s.t.','semi','semi-continuous','semis','sos','st','st.','subject',
    'such','that','to', 'to:');

  MPSKeyWord0: array[0..9] of string = ('NAME','ROWS','COLUMNS','RHS','RANGES',
    'BOUNDS','SOS','ENDATA', 'OBJSENSE', 'OBJNAME');

  MPSKeyWord2: array[0..14] of string = ('N','L','G','E',
    'LO','UP','FX','FR','MI','PL','BV','LI','UI','SC', 'SI');

  MathProgWords: array[0..59] of string = ('abs','and','binary','by','ceil',
    'check','cross','data','default','diff','dimen','display','div','else',
    'end','exists','exp','floor','for','forall','if','in','integer','inter',
    'Irand224','less','log','log10','logical','max','maximize','min','minimize',
    'mod','Normal','Normal01','not','or','param','printf','prod','round','s.t.',
    'set','setof','solve','sqrt','subj','subject','sum','symbolic','symdiff',
    'then','to','trunc','Uniform','Uniform01','union','var','within');

  LindoWords: array[0..12] of string = ('MAXIMIZE', 'MINIMIZE', 'MAX', 'MIN',
    'SUBJECT', 'TO', 'END', 'GIN', 'TITLE', 'SLB', 'SUB', 'INT', 'INTEGER');

  ZIMPLWords: array[0..55] of string = ('mod', 'abs', 'sgn', 'floor', 'ceil',
    'min', 'max', 'card', 'ord', 'if', 'then', 'else', 'end', 'sqrt', 'log',
    'ln', 'exp', 'set', 'cross', 'to', 'union', 'without', 'inter', 'symdiff',
    'by', 'proj', 'in', 'with', 'and', 'or', 'powerset', 'subsets', 'indexset', 'param',
    'default', 'var', 'binary', 'real', 'integer', 'minimize', 'maximize', 'sum',
    'subto', 'forall', 'do', 'read', 'as', 'skip', 'use', 'fs', 'comment', 'vif',
    'vabs', 'print', 'check', 'data');

  procedure MakeIdentTable;
  var
    I, J: Char;
  begin
    for I := #0 to #255 do
    begin
      Case I of
        '_', '0'..'9', 'a'..'z', 'A'..'Z', '''', '-', '.': Identifiers[I] := True;
      else Identifiers[I] := False;
      end;
      J := UpCase(I);
      Case I in ['_', 'a'..'z', 'A'..'Z'] of
        True: mHashTable[I] := Ord(J) - 64
      else mHashTable[I] := 0;
      end;
    end;
  end;

  function FindLanguage(str: string): TLPLanguage;
  var l: TLPLanguage;
  begin
    for l := low(TLPLanguage) to high(TLPLanguage) do
      if Languages[l] = UpperCase(str) then
      begin
        result := l;
        exit;
      end;
    result := lUnknown;
  end;


function TLPHighlighter.IsKeyword(const AKeyword: string): boolean;
var i: integer;
function IsMark: boolean;
var
  v: int64;
begin
 result := false;
 if length(AKeyword) >= 5 then
   if CompareStr(Copy(AKeyword, 0, 4), 'MARK') = 0 then
     if TryStrToInt64(copy(AKeyword, 5, length(AKeyword)-4), v) then
       result := true;
end;

begin
  result := true;
  case Language of
    lMPS:
      begin
        if fTokenPos = 0 then
        begin
          for i := low(MPSKeyWord0) to high(MPSKeyWord0) do
            if CompareStr(MPSKeyWord0[i], AKeyword) = 0 then
              Exit;
        end else if fTokenPos = 1 then
        begin
          for i := low(MPSKeyWord2) to high(MPSKeyWord2) do
            if CompareStr(MPSKeyWord2[i], AKeyword) = 0 then
              Exit;
        end else if fTokenPos = 4 then
        begin
          if IsMark then exit;
        end else if fTokenPos = 14 then
        begin
          if CompareStr('''MARKER''', AKeyword) = 0 then exit;
        end else if fTokenPos = 39 then
        begin
          if (CompareStr('''INTORG''', AKeyword) = 0) or
            (CompareStr('''INTEND''', AKeyword) = 0) then
              exit;
        end;

      end;
    lLP:
      for i := low(LPKeyWords) to high(LPKeyWords) do
        if CompareText(LPKeyWords[i], AKeyword) = 0 then
          Exit;
    lLPT:
      for i := low(LPTKeyWords) to high(LPTKeyWords) do
        if CompareText(LPTKeyWords[i], AKeyword) = 0 then
          Exit;
    lMathProg:
      for i := low(MathProgWords) to high(MathProgWords) do
        if CompareText(MathProgWords[i], AKeyword) = 0 then
          Exit;
    lLINDO:
      for i := low(LindoWords) to high(LindoWords) do
        if CompareText(LindoWords[i], AKeyword) = 0 then
          Exit;
    lZIMPL:
      for i := low(ZIMPLWords) to high(ZIMPLWords) do
        if CompareText(ZIMPLWords[i], AKeyword) = 0 then
          Exit;
    lLPX:
      for i := low(LPXKeyWords) to high(LPXKeyWords) do
        if CompareText(LPXKeyWords[i], AKeyword) = 0 then
          Exit;
          
  end;
  result := false;
end;

procedure TLPHighlighter.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      '#': fProcTable[I] := SharpProc;
      '!': fProcTable[I] := ExclamProc;
      #13: fProcTable[I] := CRProc;
      'A'..'Z', 'a'..'z', '_', '''': fProcTable[I] := IdentProc;
      '$': fProcTable[I] := IntegerProc;
      #10: fProcTable[I] := LFProc;
      #0: fProcTable[I] := NullProc;
      '0'..'9': fProcTable[I] := NumberProc;
      '/': fProcTable[I] := SlashProc;
      '\': fProcTable[I] := AntiSlashProc;
      '*': fProcTable[I] := StarProc;
      #1..#9, #11, #12, #14..#32: fProcTable[I] := SpaceProc;
      else fProcTable[I] := UnknownProc;
    end;
  fProcTable[fStringDelimCh] := StringProc;
end;

constructor TLPHighlighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCommentAttri := TSynHighlighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  AddAttribute(fCommentAttri);
  fIdentifierAttri := TSynHighlighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(fIdentifierAttri);
  fKeyAttri := TSynHighlighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);
  fNumberAttri := TSynHighlighterAttributes.Create(SYNS_AttrNumber);
  AddAttribute(fNumberAttri);
  fSpaceAttri := TSynHighlighterAttributes.Create(SYNS_AttrSpace);
  AddAttribute(fSpaceAttri);
  fStringAttri := TSynHighlighterAttributes.Create(SYNS_AttrString);
  AddAttribute(fStringAttri);
  fSymbolAttri := TSynHighlighterAttributes.Create(SYNS_AttrSymbol);
  AddAttribute(fSymbolAttri);
  fPreprocessorAttri := TSynHighlighterAttributes.Create(SYNS_AttrPreprocessor);
  AddAttribute(fPreprocessorAttri);
  SetAttributesOnChange(DefHighlightChange);

  fStringAttri.Foreground := clNavy;
  fStringDelimCh := '''';
  fIdentChars := inherited GetIdentChars;
  MakeMethodTables;
  fRange := rsUnknown;
end; { Create }

procedure TLPHighlighter.SetLine(const NewValue: String; LineNumber: Integer);
begin
  fLine := PChar(NewValue);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end;

procedure TLPHighlighter.LPStyleProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    fTokenID := tkComment;
    repeat
      if (fLine[Run] = '*') and (fLine[Run + 1] = '/') then begin
        fRange := rsUnKnown;
        Inc(Run, 2);
        break;
      end;
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end;
end;

procedure TLPHighlighter.LPTStyleProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    fTokenID := tkComment;
    repeat
      if (fLine[Run] = '*') and (fLine[Run + 1] = '\') then begin
        fRange := rsUnKnown;
        Inc(Run, 2);
        break;
      end;
      Inc(Run);
    until fLine[Run] in [#0, #10, #13];
  end;
end;

//procedure TLPHighlighter.AsciiCharProc;
//begin
//  if fDetectPreprocessor then begin
//    fTokenID := tkPreprocessor;
//    repeat
//      inc(Run);
//    until fLine[Run] in [#0, #10, #13];
//  end else begin
//    fTokenID := tkString;
//    repeat
//      inc(Run);
//    until not (fLine[Run] in ['0'..'9']);
//  end;
//end;

procedure TLPHighlighter.CRProc;
begin
  fTokenID := tkSpace;
  Inc(Run);
  if fLine[Run] = #10 then Inc(Run);
end;

procedure TLPHighlighter.IdentProc;
begin
  while Identifiers[fLine[Run]] do inc(Run);
  if IsKeyWord(GetToken) then fTokenId := tkKey else fTokenId := tkIdentifier;
end;

procedure TLPHighlighter.IntegerProc;
begin
  inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in ['0'..'9', 'A'..'F', 'a'..'f'] do inc(Run);
end;

procedure TLPHighlighter.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TLPHighlighter.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TLPHighlighter.NumberProc;
begin
  inc(Run);
  fTokenID := tkNumber;
  while FLine[Run] in ['0'..'9', '.', 'e', 'E', 'x'] do
  begin
    case FLine[Run] of
      'x': begin // handle C style hex numbers
             IntegerProc;
             break;
           end;
      '.':
        if FLine[Run + 1] = '.' then break;
    end;
    inc(Run);
  end;
end;

procedure TLPHighlighter.SlashProc;
begin
  Inc(Run);
  case FLine[Run] of
    '/':
      begin
        if Language in [lLP, lMathProg] then
        begin
          fTokenID := tkComment;
          Inc(Run);
          while FLine[Run] <> #0 do
          begin
            case FLine[Run] of
              #10, #13: break;
            end;
            inc(Run);
          end;
        end
        else
          fTokenId := tkSymbol;
      end;
    '*':
      begin
        if Language in [lLP, lMathProg] then
        begin
          fTokenID := tkComment;
          fRange := rsLPStyle;
          Inc(Run);
          while fLine[Run] <> #0 do
            case fLine[Run] of
              '*':
                if fLine[Run + 1] = '/' then
                begin
                  fRange := rsUnKnown;
                  inc(Run, 2);
                  break;
                end else inc(Run);
              #10, #13:
                break;
              else
                Inc(Run);
            end;
        end
        else
          fTokenId := tkSymbol;
      end;
    else
      fTokenID := tkSymbol;
  end;
end;

procedure TLPHighlighter.AntiSlashProc;
begin
  Inc(Run);
  case FLine[Run] of
    '\':
      begin
        if (Language = lLPT) or (Language = lLPX) then
        begin
          fTokenID := tkComment;
          Inc(Run);
          while FLine[Run] <> #0 do
          begin
            case FLine[Run] of
              #10, #13: break;
            end;
            inc(Run);
          end;
        end
        else
          fTokenId := tkSymbol;
      end;
    '*':
      begin
        if (Language = lLPT) or (Language = lLPX) then
        begin
          fTokenID := tkComment;
          fRange := rsLPTStyle;
          Inc(Run);
          while fLine[Run] <> #0 do
            case fLine[Run] of
              '*':
                if fLine[Run + 1] = '\' then
                begin
                  fRange := rsUnKnown;
                  inc(Run, 2);
                  break;
                end else inc(Run);
              #10, #13:
                break;
              else
                Inc(Run);
            end;
        end
        else
          fTokenId := tkSymbol;
      end;
    else
      fTokenID := tkSymbol;
  end;
end;

procedure TLPHighlighter.StarProc;
begin
  if Language = lMPS then
  begin
    fTokenID := tkComment;
    fRange := rsMPSStyle;
    inc(Run);
    while FLine[Run] <> #0 do
      case FLine[Run] of
        #10: break;
        #13: break;
      else inc(Run);
      end;
  end else
  begin
    inc(Run);
    fTokenID := tkSymbol;
  end;
end;

procedure TLPHighlighter.SpaceProc;
begin
  inc(Run);
  fTokenID := tkSpace;
  while FLine[Run] in [#1..#9, #11, #12, #14..#32] do inc(Run);
end;

procedure TLPHighlighter.StringProc;
begin
  fTokenID := tkString;
  if (fLine[Run + 1] = fStringDelimCh) and (fLine[Run + 2] = fStringDelimCh) then
    Inc(Run, 2);
  repeat
    case FLine[Run] of
      #0, #10, #13: break;
    end;
    inc(Run);
  until FLine[Run] = fStringDelimCh;
  if FLine[Run] <> #0 then inc(Run);
end;

procedure TLPHighlighter.UnknownProc;
begin
  inc(Run);
  fTokenID := tkUnKnown;
end;

procedure TLPHighlighter.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsLPStyle: LPStyleProc;
    rsLPTStyle: LPTStyleProc;
  else
    fProcTable[fLine[Run]];
  end;
end;

function TLPHighlighter.GetDefaultAttribute(Index: integer): TSynHighlighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT: Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER: Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD: Result := fKeyAttri;
    SYN_ATTR_STRING: Result := fStringAttri;
    SYN_ATTR_WHITESPACE: Result := fSpaceAttri;
    SYN_ATTR_SYMBOL: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TLPHighlighter.GetEol: Boolean;
begin
  Result := fTokenId = tkNull;
end;

function TLPHighlighter.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

function TLPHighlighter.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

procedure TLPHighlighter.GetTokenEx(out TokenStart: PChar; out TokenLength: integer);
begin
  TokenLength := Run - fTokenPos;
  TokenStart := FLine + fTokenPos;
end;

function TLPHighlighter.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TLPHighlighter.GetTokenAttribute: TSynHighlighterAttributes;
begin
  case fTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkNumber: Result := fNumberAttri;
    tkPreprocessor: Result := fPreprocessorAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkSymbol: Result := fSymbolAttri;
    tkUnknown: Result := fSymbolAttri;
  else
    Result := nil;
  end;
end;

function TLPHighlighter.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TLPHighlighter.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

procedure TLPHighlighter.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TLPHighlighter.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

class function TLPHighlighter.GetLanguageName: string;
begin
  Result := SYNS_LangGeneral;
end;


function TLPHighlighter.GetStringDelim: TStringDelim;
begin
  if fStringDelimCh = '''' then
    Result := sdSingleQuote
  else
    Result := sdDoubleQuote;
end;

procedure TLPHighlighter.SetStringDelim(const Value: TStringDelim);
var
  newCh: char;
begin
  case Value of
    sdSingleQuote: newCh := '''';
    else newCh := '"';
  end; //case
  if newCh <> fStringDelimCh then begin
    fStringDelimCh := newCh;
    MakeMethodTables;
  end;
end;

function TLPHighlighter.GetIdentifierChars: string;
var
  ch: char;
  s: shortstring;
begin
  s := '';
  for ch := #0 to #255 do
    if ch in fIdentChars then s := s + ch;
  Result := s;
end;

procedure TLPHighlighter.SetIdentifierChars(const Value: string);
var
  i: integer;
begin
  fIdentChars := [];
  for i := 1 to Length(Value) do begin
    fIdentChars := fIdentChars + [Value[i]];
  end; //for
  WordBreakChars := WordBreakChars - fIdentChars;
end;

function TLPHighlighter.GetIdentChars: TSynIdentChars;
begin
  Result := fIdentChars;
end;

procedure TLPHighlighter.SetDetectPreprocessor(Value: boolean);
begin
  if Value <> fDetectPreprocessor then begin
    fDetectPreprocessor := Value;
    DefHighlightChange(Self);
  end;
end;

procedure TLPHighlighter.SetLanguage(const Value: TLPLanguage);
begin
  if FLanguage <> Value then
  begin
    case Value of
    lZIMPL:
      begin
        StringDelim := sdDoubleQuote;
        fProcTable[fStringDelimCh] := StringProc;
      end;
    lMathProg:
      begin
        StringDelim := sdSingleQuote;
        fProcTable[fStringDelimCh] := StringProc;
      end;
    else
      fProcTable[fStringDelimCh] := IdentProc;
    end;
    FLanguage := Value;

    DefHighlightChange(Self);
  end;
end;

procedure TLPHighlighter.SharpProc;
begin
  if Language in [lMathProg, lZIMPL] then
  begin
    fTokenID := tkComment;
    fRange := rsMPSStyle;
    inc(Run);
    while FLine[Run] <> #0 do
      case FLine[Run] of
        #10: break;
        #13: break;
      else inc(Run);
      end;
  end else
  begin
    inc(Run);
    fTokenID := tkSymbol;
  end;
end;

procedure TLPHighlighter.ExclamProc;
begin
  if Language = lLINDO then
  begin
    fTokenID := tkComment;
    fRange := rsLinStyle;
    inc(Run);
    while FLine[Run] <> #0 do
      case FLine[Run] of
        #10: break;
        #13: break;
      else inc(Run);
      end;
  end else
  begin
    inc(Run);
    fTokenID := tkSymbol;
  end;
end;

initialization
  MakeIdentTable;
end.





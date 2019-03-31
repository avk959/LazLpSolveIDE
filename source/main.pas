
unit main;

{$MODE DELPHI}

interface

uses
  Classes, SysUtils, Variants, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Menus,  StrUtils, ActnList, ImgList, IniFiles, clipbrd,
  ResultArray, LpObject,  LpSolve, VirtualTrees,

  SynEdit, SynEditTypes, LPSynEdit, LPHighlighter, SynEditHighlighter, SynHighlighterXML,
  SynEditMiscClasses, SynEditTextTrimmer, SynEditExport, SynExportHTML, SynMacroRecorder,
  SynGutterLineNumber, LclType, LCLIntf, LazFileUtils, UTF8Process;

type

  TSourceExportFormat = (efHTML{, efRTF, efTEX});
  TResultExportFormat = (efrHTML, efrRTF, efrCSV);
  { TMainForm }

  TMainForm = class(TForm)
    acEditorOptions: TAction;
    acSelectAll: TAction;
    AppProps: TApplicationProperties;
    LPSolver: TLPSolver;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    mmiEditorOpts: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N10: TMenuItem;
    N9: TMenuItem;
    N8: TMenuItem;
    mFile: TMenuItem;
    MPSOptions: TGroupBox;
    Open1: TMenuItem;
    pnLog: TPanel;
    pnMain: TPanel;
    Quit1: TMenuItem;
    PageControl: TPageControl;
    SolParams1: TMenuItem;
    StatusBar: TStatusBar;
    TabSheetEditor: TTabSheet;
    MainSplitter: TSplitter;
    OpenDialogScript: TOpenDialog;
    Problem1: TMenuItem;
    Solve1: TMenuItem;
    ToolButton16: TToolButton;
    View: TMenuItem;
    LP1: TMenuItem;
    MPS1: TMenuItem;
    TabSheetOptions: TTabSheet;
    pcOptions: TPageControl;
    tsGeneral: TTabSheet;
    AntiDegenOptions: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    PresolveOptions: TGroupBox;
    CheckBox38: TCheckBox;
    CheckBox39: TCheckBox;
    CheckBox40: TCheckBox;
    CheckBox41: TCheckBox;
    CheckBox42: TCheckBox;
    CheckBox43: TCheckBox;
    CheckBox44: TCheckBox;
    CheckBox45: TCheckBox;
    CheckBox46: TCheckBox;
    BasisCrashOption: TComboBox;
    Label3: TLabel;
    tsOptions: TTabSheet;
    BBRuleModeOptions: TGroupBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    IgnoreIntegerOption: TCheckBox;
    BoundsTighterOption: TCheckBox;
    BreackAtFirstOption: TCheckBox;
    SimplexTypeOption: TComboBox;
    Label10: TLabel;
    SolutionLimitOption: TEdit;
    Label11: TLabel;
    TimeoutOption: TEdit;
    Label13: TLabel;
    tsMessages: TTabSheet;
    Label8: TLabel;
    Label14: TLabel;
    DebugOption: TCheckBox;
    LagTraceOption: TCheckBox;
    PrintSolOption: TComboBox;
    TraceOption: TCheckBox;
    VerboseOption: TComboBox;
    OpenDialogOptions: TOpenDialog;
    SaveDialogOptions: TSaveDialog;
    InfiniteOption: TEdit;
    Label16: TLabel;
    EpsbOption: TEdit;
    Label17: TLabel;
    EpsdOption: TEdit;
    Label18: TLabel;
    EpselOption: TEdit;
    Label19: TLabel;
    EpsPerturbOption: TEdit;
    Label20: TLabel;
    EpsPivotOption: TEdit;
    Label21: TLabel;
    BreakAtValueOption: TEdit;
    Label23: TLabel;
    NegRangeOption: TEdit;
    Label24: TLabel;
    Save1: TMenuItem;
    SaveDialogScript: TSaveDialog;
    PageControlLog: TPageControl;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    //MemoLog: TSynMemo;
    MemoLog: TSynEdit;
    MemoMessages: TSynEdit;
    ActionList: TActionList;
    acOpen: TAction;
    acSaveAs: TAction;
    ImageList: TImageList;
    acSolve: TAction;
    acSave: TAction;
    Save2: TMenuItem;
    PopupMenu: TPopupMenu;
    acCut: TAction;
    acCopy: TAction;
    acPaste: TAction;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Edit1: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    acUndo: TAction;
    acRedo: TAction;
    N1: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N2: TMenuItem;
    Undo2: TMenuItem;
    Redo2: TMenuItem;
    acNew: TAction;
    NewFile: TMenuItem;
    acSyntaxCheck: TAction;
    SyntaxCheck1: TMenuItem;
    acFind: TAction;
    Search1: TMenuItem;
    Search2: TMenuItem;
    acReplace: TAction;
    Replace1: TMenuItem;
    acFindNext: TAction;
    Searchagain1: TMenuItem;
    acFindPrev: TAction;
    Findprevious1: TMenuItem;
    acNewLP: TAction;
    acNewMPS: TAction;
    NewLPscript1: TMenuItem;
    NewMPSscript1: TMenuItem;
    freeMPSOption: TCheckBox;
    IBMMPSOption: TCheckBox;
    NegateObjConstMPSOption: TCheckBox;
    acStop: TAction;
    Stop1: TMenuItem;
    acViewAsLP: TAction;
    acViewAsMPS: TAction;
    LPformat1: TMenuItem;
    NewLPscript2: TMenuItem;
    N3: TMenuItem;
    MessagesOptions: TGroupBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    CheckBox29: TCheckBox;
    CheckBox30: TCheckBox;
    CheckBox31: TCheckBox;
    acSaveDefaultOptions: TAction;
    acSaveOptions: TAction;
    acLoadOptions: TAction;
    Options1: TMenuItem;
    Saveoptions1: TMenuItem;
    Loadoptions1: TMenuItem;
    Saveasdefault1: TMenuItem;
    acGotoLine: TAction;
    Gotolinenumber1: TMenuItem;
    N4: TMenuItem;
    acStatistics: TAction;
    Statistics1: TMenuItem;
    XLIViewActionList: TActionList;
    XLINewActionList: TActionList;
    SynXMLSyn: TSynXMLSyn;
    Editor: TLpSynEdit;
    tsPlugin: TTabSheet;
    Label25: TLabel;
    BFPOption: TComboBox;
    XLIDataNameOption: TEdit;
    XLIOption: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    TabSheet2: TTabSheet;
    acExportHTML: TAction;
    ExportDialog: TSaveDialog;
    Export1: TMenuItem;
    ExporttoHtml1: TMenuItem;
    acObjExpHTML: TAction;
    Result1: TMenuItem;
    ExporttoHTML2: TMenuItem;
    ExporttoRTF2: TMenuItem;
    acObjExpCSV: TAction;
    ExporttoCSV1: TMenuItem;
    acObjCopHTML: TAction;
    acObjCopCSV: TAction;
    acLoadScript: TAction;
    Loadscript1: TMenuItem;
    acAbout: TAction;
    Help1: TMenuItem;
    About1: TMenuItem;
    acQuit: TAction;
    PageControl1: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ObjectiveTable: TVirtualStringTree;
    ConstraintTable: TVirtualStringTree;
    acConExpHTML: TAction;
    acConExpCSV: TAction;
    ExporttoHTML3: TMenuItem;
    ExporttoRTF3: TMenuItem;
    ExporttoCSV2: TMenuItem;
    Matrix: TTabSheet;
    MatrixTable: TVirtualStringTree;
    N7: TMenuItem;
    ExportMatrice1: TMenuItem;
    acMatExpHtml: TAction;
    acMatExpCsv: TAction;
    acMatExpCsv1: TMenuItem;
    acMatExpHtml1: TMenuItem;
    acMatExpRtf1: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton11: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton13: TToolButton;
    ToolButton4: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton12: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    SynMacroRecorder: TSynMacroRecorder;
    EpsIntOption: TEdit;
    Label12: TLabel;
    CheckBox58: TCheckBox;
    CheckBox60: TCheckBox;
    TabSheet1: TTabSheet;
    PageControl3: TPageControl;
    TabSheet7: TTabSheet;
    ObjectiveSensTable: TVirtualStringTree;
    TabSheet8: TTabSheet;
    RHSSensTable: TVirtualStringTree;
    acConExpRTF: TAction;
    acExportRtf: TAction;
    acExportTex: TAction;
    acMatExpRtf: TAction;
    acObjCopRTF: TAction;
    acObjExpRTF: TAction;
    acSensDualExpRtf: TAction;
    acSensObjExpRtf: TAction;
    acSensObjExpHtml: TAction;
    acSensObjExpCsv: TAction;
    acSensDualExpHtml: TAction;
    acSensDualExpCsv: TAction;
    Sensitivity1: TMenuItem;
    ObjectivetoCSV1: TMenuItem;
    ObjectivetoHTML1: TMenuItem;
    ObjectivetoRTF1: TMenuItem;
    N6: TMenuItem;
    ObjectivetoCSV2: TMenuItem;
    ObjectivetoHTML2: TMenuItem;
    ObjectivetoRTF2: TMenuItem;
    acSaveBasis: TAction;
    Savebasis1: TMenuItem;
    LoadBasis1: TMenuItem;
    OpenDialogBasis: TOpenDialog;
    SaveDialogBasis: TSaveDialog;
    acSolveBasis: TAction;
    ToolButton14: TToolButton;
    Help2: TMenuItem;
    acHelp: TAction;
    Help3: TMenuItem;
    acHelpOnline: TAction;
    CheckBox57: TCheckBox;
    CheckBox61: TCheckBox;
    CheckBox62: TCheckBox;
    CheckBox63: TCheckBox;
    CheckBox64: TCheckBox;
    CheckBox65: TCheckBox;
    CheckBox66: TCheckBox;
    CheckBox67: TCheckBox;
    CheckBox68: TCheckBox;
    CheckBox69: TCheckBox;
    CheckBox72: TCheckBox;
    CheckBox73: TCheckBox;
    Priority: TTrackBar;
    ToolButton15: TToolButton;
    ImproveOptions: TGroupBox;
    CheckBox75: TCheckBox;
    CheckBox76: TCheckBox;
    CheckBox77: TCheckBox;
    CheckBox78: TCheckBox;
    ScaleOptions: TGroupBox;
    Label9: TLabel;
    CheckBox51: TCheckBox;
    CheckBox50: TCheckBox;
    CheckBox49: TCheckBox;
    CheckBox48: TCheckBox;
    CheckBox47: TCheckBox;
    ScaleTypeOption: TComboBox;
    CheckBox59: TCheckBox;
    CheckBox70: TCheckBox;
    CheckBox71: TCheckBox;
    PivotModeOption: TGroupBox;
    CheckBox32: TCheckBox;
    CheckBox33: TCheckBox;
    CheckBox34: TCheckBox;
    CheckBox35: TCheckBox;
    CheckBox36: TCheckBox;
    CheckBox37: TCheckBox;
    CheckBox52: TCheckBox;
    CheckBox53: TCheckBox;
    CheckBox54: TCheckBox;
    CheckBox55: TCheckBox;
    CheckBox56: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    MaxPivotOption: TEdit;
    PivotRuleOption: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    BBRuleSelectOption: TComboBox;
    BBFloorFirstOption: TComboBox;
    DepthLimitOption: TEdit;
    ObjBoundOption: TEdit;
    Label5: TLabel;
    ScaleLimitOption: TEdit;
    Label22: TLabel;
    CheckBox74: TCheckBox;
    CheckBox79: TCheckBox;
    CheckBox80: TCheckBox;
    CheckBox81: TCheckBox;
    acLoadParams: TAction;
    acSaveParams: TAction;
    N5: TMenuItem;
    CheckBox83: TCheckBox;
    acResetOptions: TAction;
    procedure acEditorOptionsExecute(Sender: TObject);
    procedure AppPropsQueryEndSession(var Cancel: Boolean);
    procedure AppPropsShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure LPSolverLog(sender: TComponent; log: PAnsiChar);
    procedure OptionCheckBoxClick(Sender: TObject);
    procedure ScaleTypeOptionChange(Sender: TObject);
    procedure SimplexTypeOptionChange(Sender: TObject);
    procedure BBRuleSelectOptionChange(Sender: TObject);
    procedure BBFloorFirstOptionChange(Sender: TObject);
    procedure PivotRuleOptionChange(Sender: TObject);
    procedure VerboseOptionChange(Sender: TObject);
    procedure EditOptionChange(Sender: TObject; var Key: Char);
    procedure EditorStatusChange(Sender: TObject;
      Changes: TSynStatusChanges);
    procedure LPSolverMessage(sender: TComponent; mesg: TMessage);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure EditorDropFiles(Sender: TObject; X, Y: Integer;
      AFiles: TStrings);
    procedure LPSolverAbort(sender: TComponent; var return: Boolean);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveUpdate(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acCutExecute(Sender: TObject);
    procedure acCutUpdate(Sender: TObject);
    procedure acCopyExecute(Sender: TObject);
    procedure acCopyUpdate(Sender: TObject);
    procedure acPasteExecute(Sender: TObject);
    procedure acPasteUpdate(Sender: TObject);
    procedure acOpenExecute(Sender: TObject);
    procedure acSolveExecute(Sender: TObject);
    procedure acUndoExecute(Sender: TObject);
    procedure acUndoUpdate(Sender: TObject);
    procedure acRedoExecute(Sender: TObject);
    procedure acRedoUpdate(Sender: TObject);
    procedure acSelectAllExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acNewExecute(Sender: TObject);
    procedure acFindExecute(Sender: TObject);
    procedure ShowSearchReplaceDialog(AReplace: boolean);
    procedure acReplaceExecute(Sender: TObject);
    procedure acFindNextExecute(Sender: TObject);
    procedure acFindPrevExecute(Sender: TObject);
    procedure EditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer;
              var Action: TSynReplaceAction);
    procedure acSyntaxCheckExecute(Sender: TObject);
    procedure acNewLPExecute(Sender: TObject);
    procedure acNewMPSExecute(Sender: TObject);
    procedure acStopExecute(Sender: TObject);
    procedure acViewAsLPExecute(Sender: TObject);
    procedure acViewAsMPSExecute(Sender: TObject);

    procedure acGotoLineExecute(Sender: TObject);
    procedure acStatisticsExecute(Sender: TObject);
    procedure ObjectiveTableGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure LPSolverLoad(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ObjectiveTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure ObjectiveTableCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ObjectiveTableInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure acExportHTMLExecute(Sender: TObject);
    procedure acExportRtfExecute(Sender: TObject);
    procedure acExportTexExecute(Sender: TObject);
    procedure ObjectiveTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
    procedure acObjExpHTMLExecute(Sender: TObject);
    procedure acObjExpRTFExecute(Sender: TObject);
    procedure acObjExpCSVExecute(Sender: TObject);
    procedure acObjCopHTMLExecute(Sender: TObject);
    procedure acObjCopRTFExecute(Sender: TObject);
    procedure acObjCopCSVExecute(Sender: TObject);
    procedure CopyasRTF1Click(Sender: TObject);
    procedure CopyasCSV1Click(Sender: TObject);
    procedure acLoadScriptExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acQuitExecute(Sender: TObject);
    procedure ConstraintTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
    procedure ConstraintTableCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure ConstraintTableGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure ConstraintTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure ConstraintTableInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure acConExpHTMLExecute(Sender: TObject);
    procedure acConExpRTFExecute(Sender: TObject);
    procedure acConExpCSVExecute(Sender: TObject);
    procedure MatrixTableGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure MatrixTableInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure MatrixTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure MatrixTableCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure MatrixTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure acMatExpCsvExecute(Sender: TObject);
    procedure acMatExpHtmlExecute(Sender: TObject);
    procedure acMatExpRtfExecute(Sender: TObject);
    procedure ObjectiveSensTableGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType; var CellText: string);
    procedure ObjectiveSensTableInitNode(Sender: TBaseVirtualTree;
      ParentNode, Node: PVirtualNode;
      var InitialStates: TVirtualNodeInitStates);
    procedure ObjectiveSensTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
      Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
      var ContentRect: TRect);
    procedure ObjectiveSensTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure ObjectiveSensTableCompareNodes(Sender: TBaseVirtualTree;
      Node1, Node2: PVirtualNode; Column: TColumnIndex;
      var Result: Integer);
    procedure RHSSensTableInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure RHSSensTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure RHSSensTableGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure RHSSensTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
      Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure RHSSensTableCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure acSensObjExpHtmlExecute(Sender: TObject);
    procedure acSensObjExpRtfExecute(Sender: TObject);
    procedure acSensDualExpHtmlExecute(Sender: TObject);
    procedure acSensDualExpRtfExecute(Sender: TObject);
    procedure acSensObjExpCsvExecute(Sender: TObject);
    procedure acSensDualExpCsvExecute(Sender: TObject);
    procedure acSaveBasisExecute(Sender: TObject);
    procedure acIsSolving(Sender: TObject);
    procedure acIsNotSolving(Sender: TObject);
    procedure acSolveBasisExecute(Sender: TObject);
    procedure URLshow(const UrlStr: string);
    procedure acHelpOnlineExecute(Sender: TObject);
    procedure acHelpExecute(Sender: TObject);
//    procedure acURLshowMenuExecute(Sender: TObject);
    procedure PriorityChange(Sender: TObject);

    procedure acSaveParamsExecute(Sender: TObject);
    procedure acLoadParamsExecute(Sender: TObject);
    procedure acResetOptionsExecute(Sender: TObject);
    procedure SolParams1Click(Sender: TObject);
    procedure acSaveDefaultOptionsExecute(Sender: TObject);
    procedure acSaveOptionsExecute(Sender: TObject);
    procedure acLoadOptionsExecute(Sender: TObject);
    procedure acSolParams(Sender: TObject);

    function  GetCurrentFile: string;
    procedure Help3Click(Sender: TObject);



//    procedure MadExceptionHandler1Exception(const exceptIntf: IMEException;
//      var handled: Boolean);
  private
    FLockEvents: boolean;
    FHighlighter: TLPHighlighter;
    FCurrentFile: TFileName;
    fSearchFromCaret: boolean;
    FLastOpenFile,
    FConfigFolder,
    FChmFileReader: string;
    FlpParamsFile: TFileName;
    FLastLineCount: integer;
    FSolving: boolean;
    FLastAbortEvent: cardinal;
    FLoaded: boolean;
    FInvertCount: Cardinal;
    FXliIndex: integer;
    FScriptFormat: TScriptFormat;
    FObjectives: TResultArray;
    FConstraints: TResultArray;
    FObjectivesSens: TResultArray;
    FRHSSens: TResultArray;
    FIsMIP: boolean;
    FHaveBasis: boolean;
    procedure SetSolving(value: boolean);
    function  GetMode: TScriptFormat;
    procedure SetMode(const Value: TScriptFormat);
    procedure SetCurrentFile(filename: string);
    procedure DoSearchReplaceText(AReplace: boolean; ABackwards: boolean);
    procedure NewScript(ScFormat: tScriptFormat);
    function ModeChange(m: TScriptFormat): boolean;
    procedure CheckGutter;
    function EditorSaveToStrings: boolean;
    procedure ReadIniFile;
    procedure ReadSettings;
    procedure WriteSettings;
    procedure AddCurrentResult(header: string);
    procedure OnMinimize(sender: TObject);
  protected
    procedure Loaded; override;
  public
    procedure UpdateVirtualTrees;
    procedure ClearVirtualTrees;
    procedure acNewXLIExecute(Sender: TObject);
    procedure acViewXLIExecute(Sender: TObject);
    procedure WriteOptions;
    procedure ReadOptions;
    procedure ExportTo(format: TSourceExportFormat; extension, filter: string);
    procedure ResultExportTo(Table: TVirtualStringTree; format: TResultExportFormat; extension, filter: string);
    procedure OpenFile(filename: string);

    function  GetlpParamsFile: TFileName;
    procedure SetlpParamsFile(filename: TFileName);

    property Mode: TScriptFormat read GetMode write SetMode;
    property isLoaded: boolean read FLoaded write FLoaded;
    property lpParamsFile: TFileName  read GetlpParamsFile write SetlpParamsFile;
  end;

  { TXliExtension }

  TXliExtension = class(TAction)
  private
  const
  {$IF DEFINED(MSWINDOWS)}
    LIB_PREFIX = '';
    LIB_SUFFIX = '.dll';
  {$ELSEIF DEFINED(DARWIN)}
    LIB_PREFIX = 'lib';
    LIB_SUFFIX = '.dylib';
  {$ELSEIF DEFINED(UNIX)}
    LIB_PREFIX = 'lib';
    LIB_SUFFIX = '.so';
  {$ENDIF}
  var
    FLibName: string;
    FExtension: string;
    FLanguage: TLPLanguage;
  public
    property LibName: string read FLibName;
    property Extension: string read FExtension;
    property Language: TLPLanguage read FLanguage;
  end;

  TViewXliExtension = class(TXliExtension)
    constructor Create(AOwner: TComponent; const aLibName, aExtension: string; aLang: TLPLanguage); reintroduce;
  end;

  TNewXliExtension = class(TXliExtension)
    constructor Create(AOwner: TComponent; const aLibName, aExtension: string; aLang: TLPLanguage); reintroduce;
  end;

  TScallingStat = record
    VarMin: integer;
    VarMax: integer;
    RHSMin: integer;
    RHSMax: integer;
    CoefVarMin: integer;
    CoefRHSMin: integer;
    CoefValMin: TFloat;
    CoefVarMax: integer;
    CoefRHSMax: integer;
    CoefValMax: TFloat;
  end;


var
  MainForm: TMainForm;
  DoAbort: boolean = False;
  DefaultCheckColor: TColor;

resourcestring
  STextNotFound    = 'Text not found';
  SFileNotFound    = 'File not found';
  SFileNotFoundFmt = 'Could not find file' + sLineBreak + '%s';

implementation
uses
  dlgSearchText, dlgReplaceText, dlgConfirmReplace, dlgGotoLine, dlgStatistics, dlgAbout, Params,
  dlgEditorOpts;

{$R *.lfm}

const
  SAppConfigIni   = 'LpSolveIDE.ini';
  SSettingsIni    = 'Settings.ini';
  SLocalHelpFile  = 'lp_solve55.chm';
  SMainForm       = 'MainForm';
  SEditor         = 'Editor';
  SHelp           = 'Help';
  SDefaultLpo     = 'default.lpo';
  SWindowState    = 'WindowState';
  STop            = 'Top';
  SLeft           = 'Left';
  SWidth          = 'Width';
  SHeight         = 'Height';
  SLogHeight      = 'LogHeight';
  SFontName       = 'FontName';
  SFontSize       = 'FontSize';
  SExtraLineSpace = 'ExtraLineSpace';
  SExtraCharSpace = 'ExtraCharSpace';
  SRightEdge      = 'RightEdge';
  SEveryNthNumber = 'EveryNthNumber';
  SLineNumColor   = 'LineNumberColor';
  SCurrLineColor  = 'CurrLineColor';
  SKeywordColor   = 'KeywordColor';
  SKeywordItalic  = 'KeywordItalic';
  SKeywordBold    = 'KeywordBold';
  SNumberColor    = 'NumberColor';
  SNumberItalic   = 'NumberItalic';
  SNumberBold     = 'NumberBold';
  SCommentColor   = 'CommentColor';
  SCommentItalic  = 'CommentItalic';
  SCommentBold    = 'CommentBold';
  SChmFileReader  = 'ChmFileReader';


function FileFormat(const filename: string; var XliIndex: integer): TScriptFormat;
var
  ext: string;
  i: integer;
begin
  result := sfLP;
  ext := UpperCase(ExtractFileExt(FileName));
  if ext = '.LP' then result := sfLP else
  if ext = '.MPS' then result := sfMPS else
  for i := 0 to mainform.XLIViewActionList.ComponentCount - 1 do
    with TViewXliExtension(mainform.XLIViewActionList.Components[i]) do
      if (UpperCase(extension) = ext) then
      begin
        result := sfXLI;
        XliIndex := i;
        exit;
      end;
end;

function ScriptExt(sf: TScriptFormat): string;
begin
  case sf of
    sfMPS: result := '.mps';
    sfLP : result := '.lp';
  else
    with MainForm do
      result := TViewXliExtension(XLIViewActionList.Components[FXliIndex]).Extension;
  end;
end;

{ TNewXliExtension }

constructor TNewXliExtension.Create(AOwner: TComponent; const aLibName, aExtension: string;
  aLang: TLPLanguage);
var
  h: TLibHandle;
  m: TMenuItem;
begin
  inherited Create(AOwner);
  FLibName := aLibName;
  FExtension := aExtension;
  FLanguage := aLang;
  Tag := Mainform.XLINewActionList.ComponentCount - 1;
  h := LoadLibrary(PChar(LIB_PREFIX + LibName + LIB_SUFFIX));
  assert(h <> 0);
  caption := xli_name(GetProcAddress(h, 'xli_name'));
  FreeLibrary(h);
  OnExecute := MainForm.acNewXLIExecute;

  m := TMenuItem.Create(MainForm);
  m.Action := Self;
  m.ImageIndex := 6;
  MainForm.NewFile.Add(m);
end;

{ TXliExtension }

constructor TViewXliExtension.Create(AOwner: TComponent; const aLibName, aExtension: string;
  aLang: TLPLanguage);
var
  h: TLibHandle;
  m: TMenuItem;
begin
  inherited Create(AOwner);
  FLibName := aLibName;
  FExtension := aExtension;
  FLanguage := aLang;
  Tag := Mainform.XLIViewActionList.ComponentCount - 1;
  h := LoadLibrary(PChar(LIB_PREFIX + LibName + LIB_SUFFIX));
  assert(h <> 0);
  caption := xli_name(GetProcAddress(h, 'xli_name'));
  FreeLibrary(h);
  OnExecute := MainForm.acViewXLIExecute;
  OnUpdate := MainForm.acIsNotSolving;

  m := TMenuItem.Create(MainForm);
  m.Action := Self;
  m.RadioItem := true;
  MainForm.View.Add(m);

  m := TMenuItem.Create(MainForm);
  m.Action := Self;
  m.RadioItem := true;
  MainForm.PopupMenu.Items.Add(m);
end;

{ TMainForm }

// *****************************************************************************
// LPSolver Events
// *****************************************************************************

procedure TMainForm.LPSolverLog(sender: TComponent; log: PAnsiChar);
begin
  MemoLog.Lines.Add(Trim(log));
  MemoLog.CaretY := MemoLog.Lines.Count;
end;

procedure TMainForm.AppPropsQueryEndSession(var Cancel: Boolean);
begin
  FormCloseQuery(Application, Cancel);
  Cancel := not Cancel;
end;

procedure TMainForm.acEditorOptionsExecute(Sender: TObject);
begin
  with TfrmEditorOptsDlg.Create(nil) do
    try
      Editor := Self.Editor;
      ShowModal;
    finally
      Free;
    end;
  Editor.SetFocus;
end;

procedure TMainForm.AppPropsShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
const
  hFmt = '%s(%d)';
begin
  if HintInfo.HintControl = Priority then
    HintStr := Format(hFmt, [HintStr, Priority.Position]);
end;

procedure TMainForm.FormDropFiles(Sender: TObject; const FileNames: array of string);
var
  sl: TStringList;
  s: string;
begin
  if Length(FileNames) < 1 then
    exit;
  sl := TStringList.Create;
  try
    for s in FileNames do
      sl.Add(s);
    EditorDropFiles(Sender, -1, -1, sl);
  finally
    sl.Free;
  end;
end;

procedure TMainForm.LPSolverMessage(sender: TComponent; mesg: TMessage);
var elapsed: cardinal;
const Messages: array[TMessage] of string = ('Presolve', 'Iteration', 'Invert',
  'LP Feasible', 'LP Optimal', 'LP Equal', 'LP Better', 'MILP Feasible', 'MILP Equal',
  'MILP Better', 'MILP Strategy', 'MILP Optimal', 'Performance', 'InitPseudoCost');

  procedure AddCurrentMessage;
  begin
    MemoMessages.Lines.Add(TimeToStr(Time) + ': ' + Messages[mesg]);
  end;

begin
  if DoAbort then exit;
  case mesg of
    mInvert:
      begin
        inc(FInvertCount);
        StatusBar.Panels[3].Text := 'INV: ' + inttostr(FInvertCount);
      end;
    mLpOptimal, mLpEqual, mLpBetter, mMiLpFeasible, mMiLpEqual, mMiLpBetter, mMiLpOptimal:
      begin
        AddCurrentResult(Messages[mesg]);
        AddCurrentMessage;
      end;
    mIteration:
      begin
        StatusBar.Panels[1].Text := 'ITE: ' + inttostr(LPSolver.TotalIter);
    //whp  add nodes count  maybe WorkingObjective
        StatusBar.Panels[4].Text := 'NOD: ' + inttostr(LPSolver.TotalNodes);
        elapsed := round(LPSolver.TimeElapsed);
        if elapsed > 0 then
          StatusBar.Panels[2].Text := 'IPS: ' + inttostr(Cardinal(LPSolver.TotalIter) div elapsed);
        StatusBar.Panels[5].Text := Format('TME: %.2f', [LPSolver.TimeElapsed]);
      end;
    mPresolve:
      begin
        // presolve can reduce size of the matrix
        AddCurrentMessage;
        UpdateVirtualTrees;
      end;
  else
    AddCurrentMessage;
  end;
  MemoMessages.CaretY := MemoMessages.Lines.Count;
end;

procedure TMainForm.LPSolverAbort(sender: TComponent; var return: Boolean);
begin
  return := DoAbort;
  if (GetTickCount64 - FLastAbortEvent) > 50 then
    try
      if not DoAbort then
        Application.ProcessMessages;
      FLastAbortEvent := GetTickCount64;
    except
      return := true;
      raise;
    end;
end;

procedure TMainForm.LPSolverLoad(Sender: TObject);
begin
  UpdateVirtualTrees;
end;

// *****************************************************************************
// Mode property
// *****************************************************************************


function TMainForm.GetMode: TScriptFormat;
begin
  result := FScriptFormat;
end;

procedure TMainForm.Help3Click(Sender: TObject);
var ob: TMenuItem; str : string;
begin
  ob := Sender as TMenuItem;
  str := ob.Caption ;
  str := RightStr(str,Length(str)-1) ;
  URLshow(str);
end;
{
procedure TMainForm.acURLshowMenuExecute(Sender: TObject);
var ob: TMenuItem; str : string;
begin
  ob := Sender as TMenuItem;
  str := ob.Caption ;
  URLshow(str);
end;
}
procedure TMainForm.SetMode(const Value: TScriptFormat);
var
  i: integer;

  function FindLanguage(sf: TScriptFormat): TLPLanguage;
  begin
    case sf of
      sfLP: Result := lLP;
      sfMPS: result := lMPS;
      sfXLI:
        begin
          result := TViewXliExtension(XLIViewActionList.Components[FXliIndex]).Language;
        end;
    else
      result := lUnknown;
    end;
  end;

var
  lang: TLPLanguage;
begin
  begin
    FScriptFormat := Value;
    lang := FindLanguage(Value);
    if (lang = lXML) then
      Editor.Highlighter := SynXMLSyn
    else
      begin
        FHighlighter.Language := lang;
        Editor.Highlighter := FHighlighter;
      end;
    acViewAsLP.Checked := false;
    acViewAsMPS.Checked := false;
    for i := 0 to XLIViewActionList.ComponentCount - 1 do
      TAction(XLIViewActionList.Components[i]).Checked := false;
    case FScriptFormat of
      sfLP:  acViewAsLP.Checked := true;
      sfMPS: acViewAsMPS.Checked := true;
      sfXLI: TAction(XLIViewActionList.Components[FXliIndex]).Checked := true;
    end;
    Editor.EnableMPS := (Value = sfMPS) and (not LPSolver.FreeMPS);
  end;
end;


// *****************************************************************************
// Actions
// *****************************************************************************

procedure TMainForm.acQuitExecute(Sender: TObject);
begin
  Close;                  // WHP  try to close parent cmd window
end;

procedure TMainForm.acSaveExecute(Sender: TObject);
begin
  if (FCurrentFile <> '') and (FCurrentFile = FLastOpenFile) then
  begin
    Editor.Lines.SaveToFile(FCurrentFile);
    Editor.Modified := false;
  end else
    acSaveAs.Execute;
end;

procedure TMainForm.acSaveUpdate(Sender: TObject);
begin
  acSave.Enabled := Editor.Modified;
end;

procedure TMainForm.acSaveAsExecute(Sender: TObject);
var
  destcript: TScriptFormat;
  xliindex: integer = -1;
begin
  case mode of
    sfMPS: SaveDialogScript.FilterIndex := 2;
    sfLP : SaveDialogScript.FilterIndex := 1;
    sfXLI: SaveDialogScript.FilterIndex := 3 + FXliIndex;
  end;
  if FCurrentFile <> '' then
    SaveDialogScript.FileName := ChangeFileExt(FCurrentFile, ScriptExt(Mode));

  if SaveDialogScript.Execute then
    begin
      isLoaded := LPSolver.LoadFromStrings(Editor.Lines, LPSolver.Verbose, Mode);
      destcript := FileFormat(SaveDialogScript.FileName, xliindex);

      if destcript = Mode then
        begin
          Editor.Lines.SaveToFile(SaveDialogScript.FileName);
          Editor.Modified := false;
          FLastOpenFile := SaveDialogScript.FileName;
          SetCurrentFile(SaveDialogScript.FileName);
        end
      else
        if isLoaded then
          begin
            if SaveDialogScript.FilterIndex >= 3 then
              LPSolver.XLI :=
                TNewXliExtension(XLINewActionList.Components[SaveDialogScript.FilterIndex - 3]).LibName;
            if not LPSolver.SaveToFile(SaveDialogScript.FileName, destcript) then
              begin
                MessageDlg('Can''t save script', mtWarning, [mbOK], 0);
                exit;
              end;
            Editor.Modified := false;
            OpenFile(SaveDialogScript.FileName);
          end
        else
            MessageDlg('Parse error.', mtError, [mbOK], 0);
    end;
end;

procedure TMainForm.acCutExecute(Sender: TObject);
begin
  Editor.CutToClipboard;
end;

procedure TMainForm.acCutUpdate(Sender: TObject);
begin
  acCut.Enabled := Editor.SelText <> '';
end;

procedure TMainForm.acCopyExecute(Sender: TObject);
begin
  if (ActiveControl is TCustomSynEdit) then
    TCustomSynEdit(ActiveControl).CopyToClipboard;
end;

procedure TMainForm.acCopyUpdate(Sender: TObject);
begin
  acCopy.Enabled := Editor.SelText <> '';
end;

procedure TMainForm.acPasteExecute(Sender: TObject);
begin
  Editor.PasteFromClipboard;
end;

procedure TMainForm.acPasteUpdate(Sender: TObject);
begin
  acPaste.Enabled := Editor.CanPaste;
end;

procedure TMainForm.acOpenExecute(Sender: TObject);
begin
  if Editor.Modified or (FCurrentFile <> FLastOpenFile) then
    case MessageDlg('The current script have been modified, do you want to save it ?',
                    mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrCancel: exit;
      mrYes:    acSave.Execute;
    end;
  if OpenDialogScript.Execute then
    OpenFile(OpenDialogScript.FileName);
end;


procedure TMainForm.acSolveExecute(Sender: TObject);
var
  i, j: integer;
  objbound: TFloat;
begin
{$IFDEF MSWINDOWS}
  std_system('cls');
{$ENDIF}
  MemoLog.Clear;
  if LPSolver.IgnoreInteger then
    begin
      MemoLog.Lines.Add('Ignoring integer restrictions');
      MemoLog.Lines.Add('');
    end;
  MemoMessages.Clear;
  for i := 1 to StatusBar.Panels.Count - 1 do
    StatusBar.Panels.Items[i].Text := '';
  acLoadScript.Execute;
  if isLoaded then
    begin
      FIsMIP := false;
      with LPSolver do
        for j := 1 to Ncolumns do
          begin
            if LPSolver.IgnoreInteger then
              begin
                IsInt[j] := False;
                IsSemiCont[j] := False;
              end;
            if IsInt[j] or IsSemiCont[j] or IsSOSVar[j] then
              begin
                FIsMIP := True;
                Break;
              end;
          end;
      DoAbort := False;
      FLastAbortEvent := GetTickCount64;
      FInvertCount := 0;
      try
        objbound := LPSolver.ObjBound;
        SetSolving(true);
        try
          if FHaveBasis then
            LPSolver.LoadBasis(OpenDialogBasis.FileName);
          if LPSolver.Solve in [stOptimal, stSubOptimal, stPresolved] then
            AddCurrentResult('result');
        finally
          SetSolving(False);
          LPSolver.ObjBound := objbound;
        end;
      except
        on E: EInvalidOp do
          // launching an empty script.
        else
          raise;
      end;
    end
  else
    MemoLog.Lines.Add('Parse error');
  MemoLog.CaretY := MemoLog.Lines.Count;
end;

procedure TMainForm.acUndoExecute(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetEditor;
  Editor.Undo;
end;

procedure TMainForm.acUndoUpdate(Sender: TObject);
begin
  acUndo.Enabled := Editor.CanUndo;
end;

procedure TMainForm.acRedoExecute(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetEditor;
  Editor.Redo;
end;

procedure TMainForm.acRedoUpdate(Sender: TObject);
begin
  acRedo.Enabled := Editor.CanRedo;
end;

procedure TMainForm.acSelectAllExecute(Sender: TObject);
begin
  Editor.SelectAll;
end;

procedure TMainForm.acNewExecute(Sender: TObject);
begin
  if Editor.Modified then
    case MessageDlg('The current script has been modified, do you want to save it ?',
       mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrCancel: exit;
      mrYes: acSave.Execute;
    end;

  Editor.Clear;
  case FScriptFormat of
    sfLP :
      begin
        Editor.Lines.Add('/* Objective function */');
        Editor.Lines.Add('min: ;');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Variable bounds */');
      end;
    sfMPS:
      begin
        Editor.Lines.Add('* MPS file created by lp_solve v5.5!');
        Editor.Lines.Add('* Model constraints = 0 (of which 0 equalities)');
        Editor.Lines.Add('*       variables   = 0 (of which 0 integer-valued and 0 semi-continuous)');
        Editor.Lines.Add('*');
        Editor.Lines.Add('NAME          (null)');
        Editor.Lines.Add('ROWS');
        Editor.Lines.Add(' N  R0');
        Editor.Lines.Add('COLUMNS');
        Editor.Lines.Add('RHS');
        Editor.Lines.Add('ENDATA');
      end;
  end;
  SetCurrentFile('');
  Editor.Modified := false;
  CheckGutter;
end;

procedure TMainForm.acFindExecute(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetEditor;
  ShowSearchReplaceDialog(False);
end;

procedure TMainForm.acReplaceExecute(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetEditor;
  ShowSearchReplaceDialog(true);
end;

procedure TMainForm.acFindNextExecute(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetEditor;
  DoSearchReplaceText(FALSE, FALSE);
end;

procedure TMainForm.acFindPrevExecute(Sender: TObject);
begin
  PageControl.ActivePage := TabSheetEditor;
  DoSearchReplaceText(FALSE, True);
end;

procedure TMainForm.acSyntaxCheckExecute(Sender: TObject);
var lp: TLPSolver;
begin
  lp := TLPSolver.Create(nil);
  lp.XLI := LPSolver.XLI;
  lp.ConfigFolder := FConfigFolder;
  Screen.Cursor := crHourGlass;
  try
    if lp.LoadFromStrings(Editor.Lines, LPSolver.Verbose, Mode) then
      MessageDlg('The script is correct.', mtInformation, [mbOK], 0)
    else
      MessageDlg('The scripts has syntax error(s).', mtWarning, [mbOK], 0);
  finally
    Screen.Cursor := crDefault;
   lp.Free;
  end;
end;

procedure TMainForm.acNewLPExecute(Sender: TObject);
begin
  NewScript(sfLP);
end;

procedure TMainForm.acNewMPSExecute(Sender: TObject);
begin
  NewScript(sfMPS);
end;

procedure TMainForm.acStopExecute(Sender: TObject);
begin
  DoAbort := true;
end;

procedure TMainForm.acViewAsLPExecute(Sender: TObject);
begin
  acLoadScript.Execute;
  ModeChange(sfLP);
end;

procedure TMainForm.acViewAsMPSExecute(Sender: TObject);
begin
  acLoadScript.Execute;
  ModeChange(sfMPS);
end;

procedure TMainForm.acSaveDefaultOptionsExecute(Sender: TObject);
var stream: TFileStream;
begin
  Stream := TFileStream.Create(FConfigFolder + SDefaultLpo, fmCreate);
  try
    LPSolver.SaveProfile(stream);
  finally
    stream.Free;
  end;
end;

procedure TMainForm.acSaveOptionsExecute(Sender: TObject);
var FileStream: TFileStream;
begin
  if SaveDialogOptions.Execute then
    begin
      FileStream := TFileStream.Create(SaveDialogOptions.FileName, fmCreate);
      try
        LPSolver.SaveProfile(FileStream);
      finally
        FileStream.Free;
      end;
    end;
end;

procedure TMainForm.acLoadOptionsExecute(Sender: TObject);
var
  FileStream: TFileStream;
begin
  if OpenDialogOptions.Execute then
    begin
      FileStream := TFileStream.Create(OpenDialogOptions.FileName, fmOpenRead);
      try
        LPSolver.LoadProfile(FileStream);
        FLockEvents := true;
        try
          ReadOptions;
        finally
          FLockEvents := false;
        end;
      finally
        FileStream.Free;
      end;
    end;
end;
procedure TMainForm.SolParams1Click(Sender: TObject);
begin
  acSolParams(Sender);
end;
procedure TMainForm.acSolParams(Sender: TObject);
var
  f: TParamForm;
begin
  f := TParamForm.Create(nil);
//  with f do   //TParamForm.FormCreate
  try
    f.ShowModal;
  finally
    f.Free;
  end;
end;
procedure TMainForm.acGotoLineExecute(Sender: TObject);
var
  f: TGotoLineForm;
begin
  PageControl.ActivePage := TabSheetEditor;
  f := TGotoLineForm.Create(nil);
  try
    f.LineNumer.Text := IntToStr(Editor.CaretY);
    if f.ShowModal = mrOK then
      begin
        Editor.CaretY := StrToInt(f.LineNumer.Text);  //GotoLineAndCenter(StrToInt(f.LineNumer.Text));
        Editor.CaretX := 0;
        Editor.SetFocus;
      end;
  finally
    f.Free;
  end;
end;

procedure TMainForm.acStatisticsExecute(Sender: TObject);
begin
  with TStatisticsForm.Create(nil) do
    try
      ShowModal;
    finally
      free;
    end;
end;

procedure TMainForm.acNewXLIExecute(Sender: TObject);
begin
  acLoadScript.Execute;
  FXliIndex := TNewXliExtension(Sender).Tag;
  LPSolver.XLI := TNewXliExtension(Sender).LibName;
  NewScript(sfXLI);
end;

procedure TMainForm.acViewXLIExecute(Sender: TObject);
begin
  acLoadScript.Execute;
  FXliIndex := TNewXliExtension(Sender).Tag;
  LPSolver.XLI := TNewXliExtension(Sender).LibName;
  ModeChange(sfXLI);
end;

procedure TMainForm.acExportHTMLExecute(Sender: TObject);
begin
  ExportTo(efHTML, '.htm', '*.htm;*.html');
end;

procedure TMainForm.acExportRtfExecute(Sender: TObject);
begin
  //ExportTo(efRTF, '.rtf', '*.rtf');
end;

procedure TMainForm.acExportTexExecute(Sender: TObject);
begin
  //ExportTo(efTEX, '.tex', '*.tex');
end;

procedure TMainForm.acObjExpHTMLExecute(Sender: TObject);
begin
  ResultExportTo(ObjectiveTable, efrHTML, '.html', '*.htm;*.html');
end;

procedure TMainForm.acObjExpRTFExecute(Sender: TObject);
begin
  ResultExportTo(ObjectiveTable, efrRTF, '.rtf', '*.rtf');
end;

procedure TMainForm.acObjExpCSVExecute(Sender: TObject);
begin
  ResultExportTo(ObjectiveTable, efrCSV, '.csv', '*.csv');
end;

procedure TMainForm.acObjCopHTMLExecute(Sender: TObject);
begin
  //Clipboard.SetAsHandle(CF_HTML, ObjectiveTable.ContentToClipboard(CF_HTML, tstAll));
  Clipboard.AsText := ObjectiveTable.ContentToHTML(tstAll);
end;

procedure TMainForm.acObjCopRTFExecute(Sender: TObject);
begin
  Clipboard.AsText := ObjectiveTable.ContentToRTF(tstAll);
end;

procedure TMainForm.acObjCopCSVExecute(Sender: TObject);
begin
   Clipboard.AsText := ObjectiveTable.ContentToText(tstAll, ',');
end;

procedure TMainForm.acLoadScriptExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    MemoLog.Clear;
    if LPSolver.IgnoreInteger then
      begin
        MemoLog.Lines.Add('Ignoring integer restrictions');
        MemoLog.Lines.Add('');
      end;
    MemoMessages.Clear;
    isLoaded := LPSolver.LoadFromStrings(Editor.Lines, LPSolver.Verbose, Mode);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.acAboutExecute(Sender: TObject);
begin
  with TAboutForm.Create(nil) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

// *****************************************************************************
// Read & Write options
// *****************************************************************************

procedure TMainForm.WriteOptions;
var
  i: integer;
  e: TFloat;
  AntiDegens: TAntiDegens;
  Presolve: TPresolves;
  ScaleMode: TScaleModes;
  BBRuleMode: TBBRuleModes;
  Messages: TMessages;
  PivotMode: TPricerModes;
  Improve: TImproves;
begin

  // AntiDegens
  AntiDegens := [];
  with AntiDegenOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
        if TCheckBox(Controls[i]).Checked then
          include(AntiDegens, TAntiDegen(TCheckBox(Controls[i]).Tag));
  LPSolver.AntiDegen := AntiDegens;

  // Presolve
  Presolve := [];
  with PresolveOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
        if TCheckBox(Controls[i]).Checked then
          include(Presolve, TPresolve(TCheckBox(Controls[i]).Tag));
  LPSolver.Presolve := Presolve;

  // ScaleMode
  ScaleMode := [];
  with ScaleOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
        if TCheckBox(Controls[i]).Checked then
          include(ScaleMode, TScaleMode(TCheckBox(Controls[i]).Tag));
  LPSolver.ScaleMode := ScaleMode;


  // Improve
  Improve := [];
  with ImproveOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
        if TCheckBox(Controls[i]).Checked then
          include(Improve, TImprove(TCheckBox(Controls[i]).Tag));
  LPSolver.Improve := Improve;


  LPSolver.ScaleType := TScaleType(ScaleTypeOption.ItemIndex);
  if TryStrToInt(SolutionLimitOption.Text, i) then LPSolver.SolutionLimit := i;
  if TryStrToInt(TimeoutOption.Text, i) then LPSolver.Timeout := i;
  LPSolver.BasisCrash := TBasisCrash(BasisCrashOption.ItemIndex);
  LPSolver.SimplexType := TSimplexType(SimplexTypeOption.ItemIndex);
  LPSolver.IgnoreInteger := IgnoreIntegerOption.Checked;
  LPSolver.BoundsTighter := BoundsTighterOption.Checked;
  LPSolver.BreakAtFirst := BreackAtFirstOption.Checked;

  BBRuleMode := [];
  with BBRuleModeOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
        if TCheckBox(Controls[i]).Checked then
          include(BBRuleMode, TBBRuleMode(TCheckBox(Controls[i]).Tag));
  LPSolver.BBRuleMode := BBRuleMode;

  LPSolver.BBRuleSelect := TBBRuleSelect(BBRuleSelectOption.ItemIndex);
  LPSolver.BBFloorFirst := TBranch(BBFloorFirstOption.ItemIndex);
  if TryStrToInt(DepthLimitOption.Text, i) then LPSolver.BBDepthLimit := i;

  Messages := [];
  with MessagesOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
        if TCheckBox(Controls[i]).Checked then
          include(Messages, TMessage(TCheckBox(Controls[i]).Tag));
  LPSolver.Messages := Messages;

  LPSolver.PrintSol := TMyBool(PrintSolOption.ItemIndex);
  LPSolver.Verbose := TVerbose(VerboseOption.ItemIndex);
  LPSolver.Debug := DebugOption.Checked;
  LPSolver.LagTrace := LagTraceOption.Checked;
  LPSolver.Trace := TraceOption.Checked;

  PivotMode := [];
  with PivotModeOption do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
        if TCheckBox(Controls[i]).Checked then
          include(PivotMode, TPricerMode(TCheckBox(Controls[i]).Tag));
  LPSolver.PivotMode := PivotMode;

  if TryStrToInt(MaxPivotOption.Text, i) then LPSolver.MaxPivot := i;
  LPSolver.PivotRule := TPricerRule(PivotRuleOption.ItemIndex);

  if TryStrToFloat(ObjBoundOption.Text, e) then LPSolver.ObjBound := e;
  if TryStrToFloat(InfiniteOption.Text, e) then LPSolver.Infinite := e;
  if TryStrToFloat(EpsbOption.Text, e) then LPSolver.Epsb := e;
  if TryStrToFloat(EpsdOption.Text, e) then LPSolver.Epsd := e;
  if TryStrToFloat(EpselOption.Text, e) then LPSolver.Epsel := e;
  if TryStrToFloat(EpsIntOption.Text, e) then LPSolver.EpsInt := e;
  if TryStrToFloat(EpsPerturbOption.Text, e) then LPSolver.EpsPerturb := e;
  if TryStrToFloat(EpsPivotOption.Text, e) then LPSolver.EpsPivot := e;
  if TryStrToFloat(ScaleLimitOption.Text, e) then LPSolver.ScaleLimit := e;
  if TryStrToFloat(BreakAtValueOption.Text, e) then LPSolver.BreakAtValue := e;
  if TryStrToFloat(NegRangeOption.Text, e) then LPSolver.NegRange := e;

  LPSolver.FreeMPS := freeMPSOption.Checked;
  LPSolver.IBMMPS := IBMMPSOption.Checked;
  LPSolver.NegateObjConstMPS := NegateObjConstMPSOption.Checked;
  LPSolver.BFP := BFPOption.Text;
  Editor.EnableMPS := (Mode = sfMPS) and not LPSolver.FreeMPS;

  LPSolver.XLIDataName := XLIDataNameOption.Text;
  LPSolver.XLIOptions := XLIOption.Text;
end;

procedure TMainForm.ReadOptions;
var
  i: integer;
  def: TLPSolver;
begin
  def := TLPSolver.Create(nil);

  with AntiDegenOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
      begin
        TCheckBox(Controls[i]).Checked :=
          TAntiDegen(TCheckBox(Controls[i]).Tag) in LPSolver.AntiDegen;
        if (TAntiDegen(TCheckBox(Controls[i]).Tag) in def.AntiDegen) <> TCheckBox(Controls[i]).Checked then
          TCheckBox(Controls[i]).Color := clRed else
          TCheckBox(Controls[i]).Color := DefaultCheckColor;
      end;

  with PresolveOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
      begin
        TCheckBox(Controls[i]).Checked :=
          TPresolve(TCheckBox(Controls[i]).Tag) in LPSolver.Presolve;
        if (TPresolve(TCheckBox(Controls[i]).Tag) in def.Presolve) <> TCheckBox(Controls[i]).Checked then
          TCheckBox(Controls[i]).Color := clRed else
          TCheckBox(Controls[i]).Color := DefaultCheckColor;
      end;

  with ScaleOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
      begin
        TCheckBox(Controls[i]).Checked :=
          TScaleMode(TCheckBox(Controls[i]).Tag) in LPSolver.ScaleMode;
        if (TScaleMode(TCheckBox(Controls[i]).Tag) in def.ScaleMode) <> TCheckBox(Controls[i]).Checked then
          TCheckBox(Controls[i]).Color := clRed else
          TCheckBox(Controls[i]).Color := DefaultCheckColor;
      end;

  ScaleTypeOption.ItemIndex := ord(LPSolver.ScaleType);
  if ScaleTypeOption.ItemIndex <> ord(def.ScaleType) then
    Label9.Font.Color := clRed else
    Label9.Font.Color := clDefault;

  SolutionLimitOption.Text := inttostr(LPSolver.SolutionLimit);
  if LPSolver.SolutionLimit <> def.SolutionLimit then
    Label11.Font.Color := clRed else
    Label11.Font.Color := clDefault;

  TimeoutOption.Text := inttostr(LPSolver.Timeout);
  if LPSolver.Timeout <> def.Timeout then
    Label13.Font.Color := clRed else
    Label13.Font.Color := clDefault;

  BasisCrashOption.ItemIndex := ord(LPSolver.BasisCrash);
  if LPSolver.BasisCrash <> def.BasisCrash then
    Label3.Font.Color := clRed else
    Label3.Font.Color := clDefault;

  with ImproveOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
      begin
        TCheckBox(Controls[i]).Checked :=
          TImprove(TCheckBox(Controls[i]).Tag) in LPSolver.Improve;
        if (TImprove(TCheckBox(Controls[i]).Tag) in def.Improve) <> TCheckBox(Controls[i]).Checked then
          TCheckBox(Controls[i]).Color := clRed else
          TCheckBox(Controls[i]).Color := DefaultCheckColor;
      end;

  SimplexTypeOption.ItemIndex := ord(LPSolver.SimplexType);
  if LPSolver.SimplexType <> def.SimplexType then
    Label10.Font.Color := clRed else
    Label10.Font.Color := clDefault;

  IgnoreIntegerOption.Checked := LPSolver.IgnoreInteger;
  if LPSolver.IgnoreInteger <> def.IgnoreInteger then
    IgnoreIntegerOption.Color := clRed else
    IgnoreIntegerOption.Color := DefaultCheckColor;

  BoundsTighterOption.Checked := LPSolver.BoundsTighter;
  if LPSolver.BoundsTighter <> def.BoundsTighter then
    BoundsTighterOption.Color := clRed else
    BoundsTighterOption.Color := DefaultCheckColor;

  BreackAtFirstOption.Checked := LPSolver.BreakAtFirst;
  if LPSolver.BreakAtFirst <> def.BreakAtFirst then
    BreackAtFirstOption.Color := clRed else
    BreackAtFirstOption.Color := DefaultCheckColor;

  with BBRuleModeOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
      begin
        TCheckBox(Controls[i]).Checked :=
          TBBRuleMode(TCheckBox(Controls[i]).Tag) in LPSolver.BBRuleMode;
        if (TBBRuleMode(TCheckBox(Controls[i]).Tag) in def.BBRuleMode) <> TCheckBox(Controls[i]).Checked then
          TCheckBox(Controls[i]).Color := clRed else
          TCheckBox(Controls[i]).Color := DefaultCheckColor;
      end;

  BBRuleSelectOption.ItemIndex := ord(LPSolver.BBRuleSelect);
  if LPSolver.BBRuleSelect <> def.BBRuleSelect then
    Label1.Font.Color := clRed else
    Label1.Font.Color := clDefault;

  BBFloorFirstOption.ItemIndex := ord(LPSolver.BBFloorFirst);
  if LPSolver.BBFloorFirst <> def.BBFloorFirst then
    Label2.Font.Color := clRed else
    Label2.Font.Color := clDefault;

  DepthLimitOption.Text := inttostr(LPSolver.BBDepthLimit);
  if LPSolver.BBDepthLimit <> def.BBDepthLimit then
    Label4.Font.Color := clRed else
    Label4.Font.Color := clDefault;

  with MessagesOptions do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
      begin
        TCheckBox(Controls[i]).Checked :=
          TMessage(TCheckBox(Controls[i]).Tag) in LPSolver.Messages;
      end;

  PrintSolOption.ItemIndex := ord(LPSolver.PrintSol);
  if LPSolver.PrintSol <> def.PrintSol then
    Label8.Font.Color := clRed else
    Label8.Font.Color := clDefault;

  VerboseOption.ItemIndex := ord(LPSolver.Verbose);
  if LPSolver.Verbose <> def.Verbose then
    Label14.Font.Color := clRed else
    Label14.Font.Color := clDefault;

  DebugOption.Checked := LPSolver.Debug;
  if LPSolver.Debug <> def.Debug then
    DebugOption.Color := clRed else
    DebugOption.Color := DefaultCheckColor;

  LagTraceOption.Checked := LPSolver.LagTrace;
  if LPSolver.LagTrace <> def.LagTrace then
    LagTraceOption.Color := clRed else
    LagTraceOption.Color := DefaultCheckColor;

  TraceOption.Checked := LPSolver.Trace;
  if LPSolver.Trace <> def.Trace then
    TraceOption.Color := clRed else
    TraceOption.Color := DefaultCheckColor;

  with PivotModeOption do
    for i := 0 to ControlCount - 1 do
      if Controls[i] is TCheckBox then
      begin
        TCheckBox(Controls[i]).Checked :=
          TPricerMode(TCheckBox(Controls[i]).Tag) in LPSolver.PivotMode;
        if (TPricerMode(TCheckBox(Controls[i]).Tag) in def.PivotMode) <> TCheckBox(Controls[i]).Checked then
          TCheckBox(Controls[i]).Color := clRed else
          TCheckBox(Controls[i]).Color := DefaultCheckColor;
      end;

  MaxPivotOption.Text := inttostr(LPSolver.MaxPivot);
  if LPSolver.MaxPivot <> def.MaxPivot then
    Label6.Font.Color := clRed else
    Label6.Font.Color := clDefault;

  PivotRuleOption.ItemIndex := ord(LPSolver.PivotRule);
  if LPSolver.PivotRule <> def.PivotRule then
    Label7.Font.Color := clRed else
    Label7.Font.Color := clDefault;

  ObjBoundOption.Text := FloatToStr(LPSolver.ObjBound);
  if LPSolver.ObjBound <> def.ObjBound then
    Label15.Font.Color := clRed else
    Label15.Font.Color := clDefault;

  InfiniteOption.Text := FloatToStr(LPSolver.Infinite);
  if LPSolver.Infinite <> def.Infinite then
    Label16.Font.Color := clRed else
    Label16.Font.Color := clDefault;

  EpsbOption.Text := FloatToStr(LPSolver.Epsb);
  if LPSolver.Epsb <> def.Epsb then
    Label17.Font.Color := clRed else
    Label17.Font.Color := clDefault;

  EpsdOption.Text := FloatToStr(LPSolver.Epsd);
  if LPSolver.Epsd <> def.Epsd then
    Label18.Font.Color := clRed else
    Label18.Font.Color := clDefault;

  EpselOption.Text := FloatToStr(LPSolver.Epsel);
  if LPSolver.Epsel <> def.Epsel then
    Label19.Font.Color := clRed else
    Label19.Font.Color := clDefault;

  EpsIntOption.Text := FloatToStr(LPSolver.EpsInt);
  if LPSolver.EpsInt <> def.EpsInt then
    Label12.Font.Color := clRed else
    Label12.Font.Color := clDefault;

  EpsPerturbOption.Text := FloatToStr(LPSolver.EpsPerturb);
  if LPSolver.EpsPerturb <> def.EpsPerturb then
    Label20.Font.Color := clRed else
    Label20.Font.Color := clDefault;

  EpsPivotOption.Text := FloatToStr(LPSolver.EpsPivot);
  if LPSolver.EpsPivot <> def.EpsPivot then
    Label21.Font.Color := clRed else
    Label21.Font.Color := clDefault;

  ScaleLimitOption.Text := FloatToStr(LPSolver.ScaleLimit);
  if LPSolver.ScaleLimit <> def.ScaleLimit then
    Label22.Font.Color := clRed else
    Label22.Font.Color := clDefault;

  BreakAtValueOption.Text := FloatToStr(LPSolver.BreakAtValue);
  if LPSolver.BreakAtValue <> def.BreakAtValue then
    Label23.Font.Color := clRed else
    Label23.Font.Color := clDefault;

  NegRangeOption.Text := FloatToStr(LPSolver.NegRange);
  if LPSolver.NegRange <> def.NegRange then
    Label24.Font.Color := clRed else
    Label24.Font.Color := clDefault;

  freeMPSOption.Checked := LPSolver.FreeMPS;
  if LPSolver.FreeMPS <> def.FreeMPS then
    freeMPSOption.Color := clRed else
    freeMPSOption.Color := DefaultCheckColor;

  IBMMPSOption.Checked := LPSolver.IBMMPS;
  if LPSolver.IBMMPS <> def.IBMMPS then
    IBMMPSOption.Color := clRed else
    IBMMPSOption.Color := DefaultCheckColor;

  NegateObjConstMPSOption.Checked := LPSolver.NegateObjConstMPS;
  if LPSolver.NegateObjConstMPS <> def.NegateObjConstMPS then
    NegateObjConstMPSOption.Color := clRed else
    NegateObjConstMPSOption.Color := DefaultCheckColor;

  BFPOption.Text := LPSolver.BFP;
  if BFPOption.Text <> '' then
    Label25.Font.Color := clRed else
    Label25.Font.Color := clDefault;

  XLIDataNameOption.Text := LPSolver.XLIDataName;
  if XLIDataNameOption.Text <> '' then
    Label26.Font.Color := clRed else
    Label26.Font.Color := clDefault;

  XLIOption.Text := LPSolver.XLIOptions;
  if XLIOption.Text <> '' then
    Label27.Font.Color := clRed else
    Label27.Font.Color := clDefault;
  def.Free;
end;

procedure TMainForm.OptionCheckBoxClick(Sender: TObject);
begin
  if not FLockEvents then
  begin
    WriteOptions;
    ReadOptions;
  end;
end;

procedure TMainForm.ScaleTypeOptionChange(Sender: TObject);
begin
  case TScaleType(ScaleTypeOption.ItemIndex) of
    sNone       : ScaleTypeOption.Hint := 'Linear scaling (none)';
    sExtreme    : ScaleTypeOption.Hint := 'Scale to convergence using largest absolute value';
    sRange      : ScaleTypeOption.Hint := 'Scale based on the simple numerical range';
    sMean       : ScaleTypeOption.Hint := 'Numerical range-based scaling';
    sGeometric  : ScaleTypeOption.Hint := 'Geometric scaling';
    sCurtisreId : ScaleTypeOption.Hint := 'Curtis-reid scaling';
  else
    ScaleTypeOption.Hint := '';
  end;
end;

procedure TMainForm.SimplexTypeOptionChange(Sender: TObject);
begin
  case TSimplexType(SimplexTypeOption.ItemIndex) of
    stPrimalPrimal : SimplexTypeOption.Hint := 'Phase1 Primal, Phase2 Primal';
    stDualPrimal   : SimplexTypeOption.Hint := 'Phase1 Dual, Phase2 Primal';
    stPrimalDual   : SimplexTypeOption.Hint := 'Phase1 Primal, Phase2 Dual';
    stDualDual     : SimplexTypeOption.Hint := 'Phase1 Dual, Phase2 Dual';
  end;
end;

procedure TMainForm.BBRuleSelectOptionChange(Sender: TObject);
begin
  case TBBRuleSelect(BBRuleSelectOption.ItemIndex) of
    bbFirstSelect        : BBRuleSelectOption.Hint := 'Select lowest indexed non-integer column';
    bbGapSelect          : BBRuleSelectOption.Hint := 'Selection based on distance from the current bounds';
    bbRangeSelect        : BBRuleSelectOption.Hint := 'Selection based on the largest current bound';
    bbFractionSelect     : BBRuleSelectOption.Hint := 'Selection based on largest fractional value';
    bbPseudocostSelect   : BBRuleSelectOption.Hint := 'Simple, unweighted pseudo-cost of a variable';
    bbPseudoNonIntSelect : BBRuleSelectOption.Hint := 'This is an extended pseudo-costing strategy based on minimizing the number of integer infeasibilities';
    bbPseudoRatioSelect  : BBRuleSelectOption.Hint := 'This is an extended pseudo-costing strategy based on maximizing the normal pseudo-cost divided by the number of infeasibilities. Effectively, it is similar to (the reciprocal of) a cost/benefit ratio';
    bbUserSelect         : BBRuleSelectOption.Hint := '';
  end;
end;

procedure TMainForm.BBFloorFirstOptionChange(Sender: TObject);
begin
  case TBranch(BBFloorFirstOption.ItemIndex) of
    bCeiling   : BBFloorFirstOption.Hint := 'Take ceiling branch first';
    bFloor     : BBFloorFirstOption.Hint := 'Take floor branch first';
    bAutomatic : BBFloorFirstOption.Hint := 'Algorithm decides which branch being taken first';
    bDefault   : BBFloorFirstOption.Hint := '';
  end;
end;

procedure TMainForm.PivotRuleOptionChange(Sender: TObject);
begin
  case TPricerRule(PivotRuleOption.ItemIndex) of
    pFirstindex   : PivotRuleOption.Hint := 'Select first';
    pDantzig      : PivotRuleOption.Hint := 'Select according to Dantzig';
    pDevex        : PivotRuleOption.Hint := 'Devex pricing from Paula Harris';
    pSteepestedge : PivotRuleOption.Hint := 'Steepest Edge';
  end;
end;

procedure TMainForm.VerboseOptionChange(Sender: TObject);
begin
  case TVerbose(VerboseOption.ItemIndex) of
    vNeutral   : VerboseOption.Hint := 'Only some specific debug messages in de debug print routines are reported.';
    vCritical  : VerboseOption.Hint := 'Only critical messages are reported. Hard errors like instability, out of memory, ...';
    vSevere    : VerboseOption.Hint := 'Only severe messages are reported. Errors.';
    vImportant : VerboseOption.Hint := 'Only important messages are reported. Warnings and Errors.';
    vNormal    : VerboseOption.Hint := 'Normal messages are reported. This is the default.';
    vDetailed  : VerboseOption.Hint := 'Detailed messages are reported. Like model size, continuing B&B improvements, ...';
    vFull      : VerboseOption.Hint := 'All messages are reported. Usefull for debugging purposes and small models.';
  end;
end;

procedure TMainForm.EditOptionChange(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13) and not FLockEvents then
  begin
    WriteOptions;
    ReadOptions;
    if Sender is TEdit then TEdit(Sender).SelectAll else
    if Sender is TComboBox then TComboBox(Sender).SelectAll;
    abort;
  end;
end;

procedure TMainForm.EditorStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
var
  carret: TPoint;
begin
  CheckGutter;
  carret := Editor.CaretXY;
  StatusBar.Panels[0].Text := Format('%d:%d', [carret.X, carret.Y]);
end;

// *****************************************************************************
//  ObjectiveTable events
// *****************************************************************************

procedure TMainForm.ObjectiveTableGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  row: integer;
  value: TFloat;
begin
  row := PInteger(Sender.GetNodeData(Node))^;
  try
    if Column = 0 then
      begin
        if Node.Index > 0 then
          CellText := trim(LPSolver.ColName[row]) else
          CellText := '';
      end
    else
      begin
        value := FObjectives[Column-1, row];
        if value <= -LPSolver.Infinite then
          CellText := '-inf'
        else
          if value >=  LPSolver.Infinite then
            CellText := '+inf'
          else
            CellText := FloatToStr(value);
      end;
  except
    CellText := 'ERROR'
  end;
end;

procedure TMainForm.ObjectiveTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  with  HitInfo do
    if Button = mbLeft then
      with Sender, Treeview do
        begin
          if SortColumn > NoColumn then
            Columns[SortColumn].Options := Columns[SortColumn].Options + [coParentColor];

          if (SortColumn = NoColumn) or (SortColumn <> Column) then
          begin
            SortColumn := Column;
            if Column = 0 then
              SortDirection := sdAscending else
              SortDirection := sdDescending;
          end
          else
            if SortDirection = sdAscending then
              SortDirection := sdDescending
            else
              SortDirection := sdAscending;

          Columns[SortColumn].Color := $F7F7F7;
          SortTree(SortColumn, SortDirection, true);
        end;
end;

procedure TMainForm.ObjectiveTableCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var
  id1, id2: integer;
begin
  id1 := PInteger(Sender.GetNodeData(Node1))^;
  id2 := PInteger(Sender.GetNodeData(Node2))^;

  if id1 = 0 then
  begin
    case ObjectiveTable.Header.SortDirection of
      sdAscending  : result := -1;
      sdDescending : result :=  1;
    end;
  end else
  if id2 = 0 then
  begin
    case ObjectiveTable.Header.SortDirection of
      sdAscending  : result :=  1;
      sdDescending : result := -1;
    end;
  end else

  if Column = 0 then
    result := CompareText(LPSolver.ColName[id1], LPSolver.ColName[id2]) else
    if FObjectives[Column-1, id1] > FObjectives[Column-1, id2] then result := 1 else
      if FObjectives[Column-1, id1] < FObjectives[Column-1, id2] then result := -1 else
      result := 0;
end;

procedure TMainForm.ObjectiveTableInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  PInteger(Sender.GetNodeData(Node))^ := Node.Index;
end;

procedure TMainForm.ObjectiveTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
begin
  if Node.Index = 0 then
    begin
      TargetCanvas.Brush.Color := clInfoBk;
      TargetCanvas.FillRect(CellRect);
    end;
end;

// *****************************************************************************
//
// *****************************************************************************

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  acSaveDefaultOptions.Execute;
end;

procedure TMainForm.Loaded;
var
  stream: TFileStream;
  lps: TLPSolver;
  OptFileName: string;
begin
  inherited;
  DefaultCheckColor := BreackAtFirstOption.Color;
  OptFileName := FConfigFolder + SDefaultLpo;
  //if FileExists(ExtractFilePath(ParamStr(0)) + 'default.lpo') then
  if FileExistsUtf8(OptFileName) then
    begin
      //stream := TFileStream.Create(ExtractFilePath(ParamStr(0)) + 'default.lpo', fmOpenRead);
      stream := TFileStream.Create(OptFileName, fmOpenRead);
      try
        lps := TLPSolver.Create(nil);
        try
          lps.LoadProfile(Stream);
        finally
          lps.Free;
        end;
        Stream.Seek(0, soFromBeginning);
        LPSolver.LoadProfile(stream);
      except
        LPSolver.Reset;
        stream.Free;
        stream := nil;
        //DeleteFile(ExtractFilePath(ParamStr(0)) + 'default.lpo');
        DeleteFile(OptFileName);
      end;
      if stream <> nil then
        stream.Free;
    end
  else
    begin
      LPSolver.Reset;
    end;
  FLockEvents := true;
  try
    ReadOptions;
  finally
    FLockEvents := false;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FHaveBasis := false;
  Application.OnMinimize := OnMinimize;
  FObjectives := TResultArray.Create;
  FConstraints := TResultArray.Create;
  FObjectivesSens := TResultArray.Create;
  FRHSSens := TResultArray.Create;
  FHighlighter := TLPHighlighter.Create(self);
  FLoaded := false;
  FXliIndex := -1;
  FLastLineCount := -1;
  FSolving := false;
  FLockEvents := False;
  Mode := sfLP;
  Editor.SetDefaultKeystrokes;//////////
  Editor.TrimSpaceType := settIgnoreAll;//////////
  FHighlighter.CommentAttri.Foreground := clGreen;
  FHighlighter.NumberAttri.Foreground := clNavy;
  FHighlighter.KeyAttri.Foreground := $00D90000;/////////
  Editor.Highlighter := FHighlighter;
  SetCurrentFile('');
  FLastOpenFile := '';
  FlpParamsFile:= '';
  FConfigFolder := IncludeTrailingPathDelimiter(GetAppConfigDirUTF8(False));
  ForceDirectoriesUTF8(FConfigFolder);
  LpSolver.ConfigFolder := FConfigFolder;
  acHelp.Visible := FileExistsUtf8(ExtractFilePath(Application.ExeName) + SLocalHelpFile); /////////
  acHelp.Enabled := acHelp.Visible; ////////
  ReadIniFile;
  ReadSettings; /////////////
  acNewLP.Execute;
end;

procedure TMainForm.EditorDropFiles(Sender: TObject; X, Y: Integer;
  AFiles: TStrings);
begin
  if Editor.Modified or (FCurrentFile <> FLastOpenFile) then
    case MessageDlg('The current script have been modified, do you want to save it ?',
       mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrCancel: exit;
      mrYes: acSave.Execute;
    end;
  OpenFile(AFiles.Strings[0]);
end;

procedure TMainForm.SetlpParamsFile(filename: TFileName);
begin
   FlpParamsFile := filename;
end;
function  TMainForm.GetlpParamsFile: TFileName;
begin
  result :=  FlpParamsFile;
end;

function TMainForm.GetCurrentFile: string;
begin
  result := FCurrentFile;
end;

procedure TMainForm.SetCurrentFile(filename: string);
var
  majorversion, minorversion, release, build: integer;
begin
  FCurrentFile := filename;
  lp_solve_version(@majorversion, @minorversion, @release, @build);
  if filename <> '' then
    Caption := format('LPSolve IDE - %d.%d.%d.%d - %s',[majorversion, minorversion,
                       release, build, FCurrentFile])
  else
    Caption := format('LPSolve IDE - %d.%d.%d.%d',[majorversion, minorversion,
                       release, build]);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Editor.Modified or (FCurrentFile <> FLastOpenFile) then
    case MessageDlg('The current script has been modified, do you want to save it ?',
                     mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrCancel: CanClose := False;
      mrYes: acSave.Execute;
    end;
end;


procedure TMainForm.OpenFile(filename: string);
begin
  Screen.Cursor := crHourGlass;
  try
    Editor.Lines.LoadFromFile(filename);
    Mode := FileFormat(filename, FXliIndex);
    if mode = sfXLI then
      LPSolver.XLI := TViewXliExtension(XLIViewActionList.Components[FXliIndex]).LibName;
    SetCurrentFile(filename);
    FLastOpenFile := filename;
    isLoaded := false;
    Editor.Modified := false;
    ClearVirtualTrees;
    CheckGutter;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.DoSearchReplaceText(AReplace: boolean;
  ABackwards: boolean);
var
  Options: TSynSearchOptions;
begin
  Statusbar.SimpleText := '';
  if AReplace then
    Options := [ssoPrompt, ssoReplace, ssoReplaceAll]
  else
    Options := [];
  if ABackwards then
    Include(Options, ssoBackwards);
  if gbSearchCaseSensitive then
    Include(Options, ssoMatchCase);
  if not fSearchFromCaret then
    Include(Options, ssoEntireScope);
  if gbSearchSelectionOnly then
    Include(Options, ssoSelectedOnly);
  if gbSearchWholeWords then
    Include(Options, ssoWholeWord);
  if gbSearchRegex then
    Include(Options, ssoRegExpr);
  if Editor.SearchReplace(gsSearchText, gsReplaceText, Options) = 0 then
    begin
      //MessageBeep(MB_ICONASTERISK);
      Statusbar.SimpleText := STextNotFound;
      if ssoBackwards in Options then
        Editor.BlockEnd := Editor.BlockBegin
      else
        Editor.BlockBegin := Editor.BlockEnd;
      Editor.CaretXY := Editor.BlockBegin;
    end;

  if ConfirmReplaceDialog <> nil then
    ConfirmReplaceDialog.Free;
end;

procedure TMainForm.ShowSearchReplaceDialog(AReplace: boolean);
var
  dlg: TTextSearchDialog;
begin
  Statusbar.SimpleText := '';
  if AReplace then
    dlg := TTextReplaceDialog.Create(Self) else
    dlg := TTextSearchDialog.Create(Self);
  with dlg do
  try
    // assign search options
    SearchBackwards := gbSearchBackwards;
    SearchCaseSensitive := gbSearchCaseSensitive;
    SearchFromCursor := gbSearchFromCaret;
    SearchInSelectionOnly := gbSearchSelectionOnly;
    // start with last search text
    SearchText := gsSearchText;
    if gbSearchTextAtCaret then
    begin
      // if something is selected search for that text
      if Editor.SelAvail and (Editor.BlockBegin.Y = Editor.BlockEnd.Y) then
        SearchText := Editor.SelText
      else
        SearchText := Editor.GetWordAtRowCol(Editor.CaretXY);
    end;
    SearchTextHistory := gsSearchTextHistory;
    if AReplace then
      with dlg as TTextReplaceDialog do
      begin
        ReplaceText := gsReplaceText;
        ReplaceTextHistory := gsReplaceTextHistory;
      end;
    SearchWholeWords := gbSearchWholeWords;
    //dlg.cbSearchText.Text := Editor.WordAtCursor;
    dlg.cbSearchText.Text := Editor.GetWordAtRowCol(Editor.CaretXY);
    SearchRegularExpression := gbSearchRegex;

    if ShowModal = mrOK then
    begin
      gbSearchBackwards := SearchBackwards;
      gbSearchCaseSensitive := SearchCaseSensitive;
      gbSearchFromCaret := SearchFromCursor;
      gbSearchSelectionOnly := SearchInSelectionOnly;
      gbSearchWholeWords := SearchWholeWords;
      gbSearchRegex := SearchRegularExpression;
      gsSearchText := SearchText;
      gsSearchTextHistory := SearchTextHistory;
      if AReplace then
        with dlg as TTextReplaceDialog do
        begin
          gsReplaceText := ReplaceText;
          gsReplaceTextHistory := ReplaceTextHistory;
        end;
      fSearchFromCaret := gbSearchFromCaret;
      if (gsSearchText <> '') then
      begin
        DoSearchReplaceText(AReplace, gbSearchBackwards);
        fSearchFromCaret := TRUE;
        Editor.SetFocus;
      end;
    end;
  finally
    dlg.Free;
  end;
end;

procedure TMainForm.EditorReplaceText(Sender: TObject; const ASearch, AReplace: string; Line, Column: Integer;
  var Action: TSynReplaceAction);
var
  APos: TPoint;
  EditRect: TRect;
begin
  if ASearch = AReplace then
    Action := raSkip
  else
    begin
      APos := Editor.ClientToScreen(Editor.RowColumnToPixels(Classes.Point(Line, Column)));
      EditRect := ClientRect;
      EditRect.TopLeft := ClientToScreen(EditRect.TopLeft);
      EditRect.BottomRight := ClientToScreen(EditRect.BottomRight);

      if ConfirmReplaceDialog = nil then
        ConfirmReplaceDialog := TConfirmReplaceDialog.Create(Application);
      ConfirmReplaceDialog.PrepareShow(EditRect, APos.X, APos.Y,
        APos.Y + Editor.LineHeight, ASearch);
      case ConfirmReplaceDialog.ShowModal of
        mrYes:      Action := raReplace;
        mrYesToAll: Action := raReplaceAll;
        mrNo:       Action := raSkip;
      else
        Action := raCancel;
      end;
    end;
end;


procedure TMainForm.NewScript(ScFormat: tScriptFormat);
begin
  if Editor.Modified then
    case MessageDlg('The current script has been modified, do you want to save it ?',
       mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrCancel: exit;
      mrYes: acSave.Execute;
    end;
  Mode := ScFormat;
  Editor.Clear;
  case Mode of
    sfLP :
      begin
        Editor.Lines.Add('/* Objective function */');
        Editor.Lines.Add('min: ;');
        Editor.Lines.Add('');
        Editor.Lines.Add('/* Variable bounds */');
      end;
    sfMPS:
      begin
        Editor.Lines.Add('* MPS file created by lp_solve v5.5!');
        Editor.Lines.Add('* Model constraints = 0 (of which 0 equalities)');
        Editor.Lines.Add('*       variables   = 0 (of which 0 integer-valued and 0 semi-continuous)');
        Editor.Lines.Add('*');
        Editor.Lines.Add('NAME');
        Editor.Lines.Add('ROWS');
        Editor.Lines.Add(' N  R0');
        Editor.Lines.Add('COLUMNS');
        Editor.Lines.Add('RHS');
        Editor.Lines.Add('ENDATA');
      end;
  end;
  ClearVirtualTrees;
  SetCurrentFile('');
  Editor.Modified := false;
  isLoaded := false;
  CheckGutter;
end;

procedure TMainForm.SetSolving(value: boolean);
begin
  FSolving := value;

  tsGeneral.Enabled := not Value;
  tsOptions.Enabled := not Value;
  tsMessages.Enabled := not Value;
  tsPlugin.Enabled := not Value;

  UpdateActions;
end;

function TMainForm.ModeChange(m: TScriptFormat): boolean;
  function IsEditorEmpty: boolean;
  var i: integer;
  begin
    result := false;
    for i := 0 to Editor.Lines.Count - 1 do
      if trim(Editor.Lines.Strings[i]) <> '' then
        exit;
    result := true;
  end;

  function ChangeFormat(empty: boolean): boolean;
  begin
    Mode := m;
    if m <> sfXLI then
      Editor.Clear;
    result := true;
    if not empty then
      result := EditorSaveToStrings;
    if FCurrentFile <> '' then
      SetCurrentFile(ChangeFileExt(FCurrentFile, ScriptExt(Mode))) else
      SetCurrentFile('');
    Editor.Modified := false;
    CheckGutter;
  end;
var
  previousmode: TScriptFormat;
begin
  result := false;
  previousmode := mode;
  if MessageDlg('Comments or number precision could be lost, continue ?', mtWarning,
    [mbYes, mbNo], 0) = mrNo then
      exit;
  Screen.Cursor := crHourGlass;
  try
    if isLoaded then
      result := ChangeFormat(false) else
      begin
        if not IsEditorEmpty then
          begin
            if MessageDlg('Parse error, continue anyway ?', mtWarning, [mbYes, mbNo], 0) = mrYes then
              result := ChangeFormat(true);
          end
        else
          result := ChangeFormat(true);
      end;
  finally
    if not result then mode := previousmode;
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.CheckGutter;
begin
  if FLastLineCount <> Editor.Lines.Count then
    begin
      FLastLineCount := Editor.Lines.Count;
      //Editor.Gutter.LeftOffset := Editor.Canvas.TextWidth(inttostr(Editor.Lines.Count));
    end;
end;

function TMainForm.EditorSaveToStrings: boolean;
var
  fOnChange: TNotifyEvent;
  //fOnChanging: TNotifyEvent;
  //fOnCleared: TNotifyEvent;
  //fOnDeleted: TStringListChangeEvent;
  //fOnInserted: TStringListChangeEvent;
  //fOnPutted: TStringListChangeEvent;
begin
  with Editor do
    begin
      fOnChange := OnChange;
      //fOnChanging := OnChanging;
      //fOnCleared := OnCleared;
      //fOnDeleted := OnDeleted;
      //fOnInserted := OnInserted;
      //fOnPutted := OnPutted;
      OnChange := nil;
      //OnChanging := nil;
      //OnCleared := nil;
      //OnDeleted := nil;
      //OnInserted := nil;
      //OnPutted := nil;
    end;
  try
    result := LPSolver.SaveToStrings(Editor.Lines, Mode);
  finally
    with Editor do
      begin
        OnChange := fOnChange;
        //OnChanging := fOnChanging;
        //OnCleared := fOnCleared;
        //OnDeleted := fOnDeleted;
        //OnInserted := fOnInserted;
        //OnPutted := fOnPutted;
      end;
  end;
end;

procedure TMainForm.ReadIniFile;
var
  ini: TIniFile;
  str: TStringList;
  i: integer;
  lang: TLPLanguage;
  lib, ext, filter, filterall, IniName: string;
begin
  IniName := ExtractFilePath(Application.ExeName) + SAppConfigIni;
  ini := TIniFile.Create(IniName, [ifoStripComments]);
  str := TStringList.Create;
  try
    //Set8087CW(ini.ReadInteger('OPTIONS', 'CW', Default8087CW));
    ini.ReadSection('XLI', str);

    for i := 0 to str.Count - 1 do
      try
        lib := ini.ReadString('XLI', str.Strings[i], 'unknown');
        ext := ini.ReadString(lib, 'extension', 'txt');
        lang := FindLanguage(ini.ReadString(lib, 'language', ''));
        TViewXliExtension.Create(XLIViewActionList, lib, ext, lang);
        TNewXliExtension.Create(XLINewActionList, lib, ext, lang);
      except
        //MessageDlg('Can''t find XLI: ' + lib, mtError, [mbOK], 0);
        MemoLog.Lines.Add('Can''t find XLI: ' + lib)
      end;
    FilterAll := 'All known files|*.lp; *.mps';
    Filter := 'LP files (*.lp)|*.lp|MPS files (*.mps)|*.mps';
    for i := 0 to XLIViewActionList.ComponentCount - 1 do
      with TViewXliExtension(XLIViewActionList.Components[i]) do
        begin
          filterall := format('%s; *%s', [filterall, extension]);
          filter := format('%s|%s (*%s)|*%s', [Filter, caption, extension, extension]);
        end;
    OpenDialogScript.Filter := filterall + '|' + filter;
    SaveDialogScript.Filter := filter;
    if acHelp.Visible then            ///////////////
      begin
        FChmFileReader := ini.ReadString(SHelp, SChmFileReader, '');
        if FChmFileReader <> '' then
          if ExtractFilePath(FChmFileReader) = '' then
            FChmFileReader := ExtractFilePath(Application.ExeName) + FChmFileReader;
      end;
  finally
    ini.Free;
    str.Free;
  end;
end;

procedure TMainForm.ReadSettings;
var
  Ini: TIniFile;
  I: Integer;
begin
  Ini := TIniFile.Create(FConfigFolder + SSettingsIni, [ifoStripComments]);
  try
    //MainForm position:
    Left := Ini.ReadInteger(SMainForm, SLeft, Left);
    Top := Ini.ReadInteger(SMainForm, STop, Top);
    Width := Ini.ReadInteger(SMainForm, SWidth, Width);
    Height := Ini.ReadInteger(SMainForm, SHeight, Height);
    I := Ini.ReadInteger(SMainForm, SWindowState, Integer(WindowState));
    WindowState := TWindowState(I);
    //Splitter position:
    pnLog.Height := Ini.ReadInteger(SMainForm, SLogHeight, pnLog.Height);
    //editor settings:
    Editor.Lines.BeginUpdate;
    try
      Editor.Font.Name := Ini.ReadString(SEditor, SFontName, Editor.Font.Name);
      Editor.Font.Size := Ini.ReadInteger(SEditor, SFontSize, Editor.Font.Size);
      Editor.ExtraLineSpacing := Ini.ReadInteger(SEditor, SExtraLineSpace, Editor.ExtraLineSpacing);
      Editor.ExtraCharSpacing := Ini.ReadInteger(SEditor, SExtraCharSpace, Editor.ExtraCharSpacing);
      Editor.RightEdge := Ini.ReadInteger(SEditor, SRightEdge, Editor.RightEdge);
      I := TSynGutterLineNumber(Editor.Gutter.Parts[1]).ShowOnlyLineNumbersMultiplesOf;
      TSynGutterLineNumber(Editor.Gutter.Parts[1]).ShowOnlyLineNumbersMultiplesOf :=
         Ini.ReadInteger(SEditor, SEveryNthNumber, I);
      I := Integer(TSynGutterLineNumber(Editor.Gutter.Parts[1]).MarkupInfo.Foreground);
      I := Ini.ReadInteger(SEditor, SLineNumColor, I);
      TSynGutterLineNumber(Editor.Gutter.Parts[1]).MarkupInfo.Foreground := TColor(I);
      I := Ini.ReadInteger(SEditor, SCurrLineColor, Integer(Editor.LineHighlightColor.Background));
      Editor.LineHighlightColor.Background := TColor(I);

      I := Ini.ReadInteger(SEditor, SKeywordColor, Integer(FHighlighter.KeyAttri.Foreground));
      FHighlighter.KeyAttri.Foreground := TColor(I);
      if Ini.ReadBool(SEditor, SKeywordItalic, fsItalic in FHighlighter.KeyAttri.Style) then
        FHighlighter.KeyAttri.Style := FHighlighter.KeyAttri.Style + [fsItalic];
      if Ini.ReadBool(SEditor, SKeywordBold, fsBold in FHighlighter.KeyAttri.Style) then
        FHighlighter.KeyAttri.Style := FHighlighter.KeyAttri.Style + [fsBold];

      I := Ini.ReadInteger(SEditor, SNumberColor, Integer(FHighlighter.NumberAttri.Foreground));
      FHighlighter.NumberAttri.Foreground := TColor(I);
      if Ini.ReadBool(SEditor, SNumberItalic, fsItalic in FHighlighter.NumberAttri.Style) then
        FHighlighter.NumberAttri.Style := FHighlighter.NumberAttri.Style + [fsItalic];
      if Ini.ReadBool(SEditor, SNumberBold, fsBold in FHighlighter.NumberAttri.Style) then
        FHighlighter.NumberAttri.Style := FHighlighter.NumberAttri.Style + [fsBold];

      I := Ini.ReadInteger(SEditor, SCommentColor, Integer(FHighlighter.CommentAttri.Foreground));
      FHighlighter.CommentAttri.Foreground := TColor(I);
      if Ini.ReadBool(SEditor, SCommentItalic, fsItalic in FHighlighter.CommentAttri.Style) then
        FHighlighter.CommentAttri.Style := FHighlighter.CommentAttri.Style + [fsItalic];
      if Ini.ReadBool(SEditor, SCommentBold, fsBold in FHighlighter.CommentAttri.Style) then
        FHighlighter.CommentAttri.Style := FHighlighter.CommentAttri.Style + [fsBold];
    finally
      Editor.Lines.EndUpdate;
    end;
  finally
    Ini.Free;
  end;
end;

procedure TMainForm.WriteSettings;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FConfigFolder + SSettingsIni);
  try
    //MainForm position
    Ini.WriteInteger(SMainForm, SWindowState, Integer(WindowState));
    if WindowState <> wsMaximized then
      begin
        Ini.WriteInteger(SMainForm, SLeft, Left);
        Ini.WriteInteger(SMainForm, STop, Top);
        Ini.WriteInteger(SMainForm, SWidth, Width);
        Ini.WriteInteger(SMainForm, SHeight, Height);
      end;
    //Splitter position:
    Ini.WriteInteger(SMainForm, SLogHeight, pnLog.Height);
    //editor settings:
    Ini.WriteString(SEditor, SFontName, Editor.Font.Name);
    Ini.WriteInteger(SEditor, SFontSize, Editor.Font.Size);
    Ini.WriteInteger(SEditor, SExtraLineSpace, Editor.ExtraLineSpacing);
    Ini.WriteInteger(SEditor, SExtraCharSpace, Editor.ExtraCharSpacing);
    Ini.WriteInteger(SEditor, SRightEdge, Editor.RightEdge);
    Ini.WriteInteger(SEditor, SEveryNthNumber,
        TSynGutterLineNumber(Editor.Gutter.Parts[1]).ShowOnlyLineNumbersMultiplesOf);
    Ini.WriteInteger(SEditor, SLineNumColor,
        Integer(TSynGutterLineNumber(Editor.Gutter.Parts[1]).MarkupInfo.Foreground));
    Ini.WriteInteger(SEditor, SCurrLineColor, Integer(Editor.LineHighlightColor.Background));

    Ini.WriteInteger(SEditor, SKeywordColor, Integer(FHighlighter.KeyAttri.Foreground));
    Ini.WriteBool(SEditor, SKeywordItalic, fsItalic in FHighlighter.KeyAttri.Style);
    Ini.WriteBool(SEditor, SKeywordBold, fsBold in FHighlighter.KeyAttri.Style);

    Ini.WriteInteger(SEditor, SNumberColor, Integer(FHighlighter.NumberAttri.Foreground));
    Ini.WriteBool(SEditor, SNumberItalic, fsItalic in FHighlighter.NumberAttri.Style);
    Ini.WriteBool(SEditor, SNumberBold, fsBold in FHighlighter.NumberAttri.Style);

    Ini.WriteInteger(SEditor, SCommentColor, Integer(FHighlighter.CommentAttri.Foreground));
    Ini.WriteBool(SEditor, SCommentItalic, fsItalic in FHighlighter.CommentAttri.Style);
    Ini.WriteBool(SEditor, SCommentBold, fsBold in FHighlighter.CommentAttri.Style);
  finally
    Ini.Free;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  WriteSettings;
  FObjectives.Free;
  FConstraints.Free;
  FObjectivesSens.Free;
  FRHSSens.Free;
end;

procedure TMainForm.ExportTo(format: TSourceExportFormat; extension,
  filter: string);
var exporter: TSynCustomExporter;
begin
  if FCurrentFile <> '' then
    ExportDialog.FileName := ExtractFileName(FCurrentFile) + extension else
    ExportDialog.FileName := '';
  ExportDialog.Filter := filter;
  if ExportDialog.Execute then
    begin
      case format of
        efHTML:
          begin
            exporter := TSynExporterHTML.Create(nil);
            TSynExporterHTML(exporter).ExportAsText := true;
          end;
        //efRTF : exporter := TSynExporterRTF.Create(nil);
        //efTEX : exporter := TSynExporterTeX.Create(nil);
      else
        raise Exception.Create('unexpected error.');
      end;
      try
        exporter.Highlighter := Editor.Highlighter;
        exporter.ExportAll(Editor.Lines);
        exporter.SaveToFile(ExportDialog.FileName);
      finally
        exporter.Free;
      end;
    end;
end;

procedure TMainForm.AddCurrentResult(header: string);
var
  objfrom, objtill, objfromvalue, objtillvalue: Pointer;
  duals, dualsfrom, dualstill: Pointer;
begin
   if abs(LPSolver.Objective) <> LPSolver.Infinite then
   begin
     assert(LPSolver.GetVariables(FObjectives.Add(LPSolver.NColumns+1)));
     FObjectives[FObjectives.ColCount -1, 0] := LPSolver.Objective;
     with ObjectiveTable.Header.Columns.Add do begin
       Text := header;
       Hint := header;
     end;


     // OBJECTIVE
     if (not FIsMIP) and (LPSolver.NColumns > 0) then
     begin
       objfrom      := FObjectivesSens.Add(LPSolver.NColumns+1);
       objtill      := FObjectivesSens.Add(LPSolver.NColumns+1);
       objfromvalue := FObjectivesSens.Add(LPSolver.NColumns+1);
       objtillvalue := FObjectivesSens.Add(LPSolver.NColumns+1);

       LPSolver.GetSensitivityObjEx(objfrom, objtill, objfromvalue, objtillvalue);

       with ObjectiveSensTable.Header.Columns.Add do begin
         Text := 'from';
         Hint := 'from';
       end;
       with ObjectiveSensTable.Header.Columns.Add do begin
         Text := 'till';
         Hint := 'till';
       end;
       with ObjectiveSensTable.Header.Columns.Add do begin
         Text := 'from value';
         Hint := 'from value';
       end;
       with ObjectiveSensTable.Header.Columns.Add do begin
         Text := 'till value';
         Hint := 'till value';
       end;
     end;

     // RHS
     if (not FIsMIP) and (LPSolver.NColumns > 0) then
     begin
       duals      := FRHSSens.Add(LPSolver.NColumns + LPSolver.NRows + 1);
       dualsfrom  := FRHSSens.Add(LPSolver.NColumns + LPSolver.NRows + 1);
       dualstill  := FRHSSens.Add(LPSolver.NColumns + LPSolver.NRows + 1);

       LPSolver.GetSensitivityRhs(duals, dualsfrom, dualstill);

       with RHSSensTable.Header.Columns.Add do begin
         Text := 'value';
         Hint := 'value';
       end;
       with RHSSensTable.Header.Columns.Add do begin
         Text := 'from';
         Hint := 'from';
       end;
       with RHSSensTable.Header.Columns.Add do begin
         Text := 'till';
         Hint := 'till';
       end;
     end;

     assert(LPSolver.GetConstraints(FConstraints.Add(LPSolver.NRows+1)));
     FConstraints[FConstraints.ColCount -1, 0] := LPSolver.Objective;
     with ConstraintTable.Header.Columns.Add do begin
       Text := header;
       Hint := header;
     end;

   end;
end;

procedure TMainForm.ResultExportTo(Table: TVirtualStringTree;
  format: TResultExportFormat; extension, filter: string);
var
  data: string;
  f: TFileStream;
begin
  if FCurrentFile <> '' then
    ExportDialog.FileName := ExtractFileName(FCurrentFile) + extension else
    ExportDialog.FileName := '';
  ExportDialog.Filter := filter;
  if ExportDialog.Execute then
    begin
      case format of
        efrHTML: data := Table.ContentToHTML(tstAll);
        efrRTF : data := Table.ContentToRTF(tstAll);
        efrCSV : data := Table.ContentToText(tstAll, ';');
      end;
      f := TFileStream.Create(ExportDialog.FileName, fmcreate);
      try
        f.Write(PChar(data)^, length(data)+1);
      finally
        f.Free;
      end;
    end;
end;

procedure TMainForm.CopyasRTF1Click(Sender: TObject);
begin
  //Clipboard.SetAsHandle(CF_VRTF, ObjectiveTable.ContentToClipboard(CF_VRTF, tstAll));
  Clipboard.AsText := ObjectiveTable.ContentToRTF(tstAll);
end;

procedure TMainForm.CopyasCSV1Click(Sender: TObject);
begin
  //Clipboard.SetAsHandle(CF_CSV, ObjectiveTable.ContentToClipboard(CF_CSV, tstAll));
  Clipboard.AsText := ObjectiveTable.ContentToText(tstAll, ';');
end;

procedure TMainForm.ConstraintTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
begin
  if Node.Index = 0 then
    begin
      TargetCanvas.Brush.Color := clInfoBk;
      TargetCanvas.FillRect(CellRect);
    end;
end;

procedure TMainForm.ConstraintTableCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var id1, id2: integer;
begin
  id1 := PInteger(Sender.GetNodeData(Node1))^;
  id2 := PInteger(Sender.GetNodeData(Node2))^;

  if id1 = 0 then
  begin
    case ConstraintTable.Header.SortDirection of
      sdAscending  : result := -1;
      sdDescending : result :=  1;
    end;
  end else
  if id2 = 0 then
  begin
    case ConstraintTable.Header.SortDirection of
      sdAscending  : result :=  1;
      sdDescending : result := -1;
    end;
  end else

  if Column = 0 then
    result := CompareText(LPSolver.RowName[id1], LPSolver.RowName[id2]) else
    if FConstraints[Column-1, id1] > FConstraints[Column-1, id2] then result := 1 else
      if FConstraints[Column-1, id1] < FConstraints[Column-1, id2] then result := -1 else
      result := 0;
end;

procedure TMainForm.ConstraintTableGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
var
  row: integer;
  value: TFloat;
begin
  row := PInteger(Sender.GetNodeData(Node))^;

  try
    if Column = 0 then
    begin
      if Node.Index > 0 then
        CellText := trim(LPSolver.RowName[row]) else
        CellText := '';
    end else
    begin
      value := FConstraints[Column-1, row];
      if value <= -LPSolver.Infinite then CellText := '-inf' else
      if value >=  LPSolver.Infinite then CellText := '+inf' else
      CellText := FloatToStr(value);
    end;
  except
    CellText := 'ERROR'
  end;
end;

procedure TMainForm.ConstraintTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  with HitInfo do
    if Button = mbLeft then
      with Sender, Treeview do
        begin
          if SortColumn > NoColumn then
            Columns[SortColumn].Options := Columns[SortColumn].Options + [coParentColor];

          if (SortColumn = NoColumn) or (SortColumn <> Column) then
            begin
              SortColumn := Column;
              if Column = 0 then
                SortDirection := sdAscending
              else
                SortDirection := sdDescending;
            end
          else
            if SortDirection = sdAscending then
              SortDirection := sdDescending
            else
              SortDirection := sdAscending;

          Columns[SortColumn].Color := $F7F7F7;
          SortTree(SortColumn, SortDirection, true);
        end;
end;

procedure TMainForm.ConstraintTableInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  PInteger(Sender.GetNodeData(Node))^ := Node.Index;
end;

procedure TMainForm.acConExpHTMLExecute(Sender: TObject);
begin
  ResultExportTo(ConstraintTable, efrHTML, '.html', '*.htm;*.html');
end;

procedure TMainForm.acConExpRTFExecute(Sender: TObject);
begin
  ResultExportTo(ConstraintTable, efrRTF, '.rtf', '*.rtf');
end;

procedure TMainForm.acConExpCSVExecute(Sender: TObject);
begin
  ResultExportTo(ConstraintTable, efrCSV, '.csv', '*.csv');
end;

procedure TMainForm.MatrixTableGetText(Sender: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType; var CellText: string);
begin
  if Column = 0 then
    begin
      if Node.Index > 0 then
        CellText := trim(LPSolver.RowName[PInteger(Sender.GetNodeData(Node))^])
      else
        if LPSolver.Maximize then
          CellText := 'max'
        else
          CellText := 'min';
    end
  else
    if Column = LPSolver.NColumns + 1 then
      CellText := FloatToStr(LPSolver.Rh[PInteger(Sender.GetNodeData(Node))^])
    else
      CellText := FloatToStr(LPSolver.Mat[PInteger(Sender.GetNodeData(Node))^, Column]);
end;

procedure TMainForm.MatrixTableInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  PInteger(Sender.GetNodeData(Node))^ := Node.Index;
end;

procedure TMainForm.MatrixTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  with HitInfo do
    if Button = mbLeft then
      with Sender, Treeview do
        begin
          if SortColumn > NoColumn then
            Columns[SortColumn].Options := Columns[SortColumn].Options + [coParentColor];

          if (SortColumn = NoColumn) or (SortColumn <> Column) then
            begin
              SortColumn := Column;
              if Column = 0 then
                SortDirection := sdAscending
              else
                SortDirection := sdDescending;
            end
          else
            if SortDirection = sdAscending then
              SortDirection := sdDescending
            else
              SortDirection := sdAscending;

          Columns[SortColumn].Color := $F7F7F7;
          SortTree(SortColumn, SortDirection, true);
        end;
end;

procedure TMainForm.MatrixTableCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var id1, id2: integer;
begin
  id1 := PInteger(Sender.GetNodeData(Node1))^;
  id2 := PInteger(Sender.GetNodeData(Node2))^;

  if id1 = 0 then
  begin
    case MatrixTable.Header.SortDirection of
      sdAscending  : result := -1;
      sdDescending : result :=  1;
    end;
  end else
  if id2 = 0 then
  begin
    case MatrixTable.Header.SortDirection of
      sdAscending  : result :=  1;
      sdDescending : result := -1;
    end;
  end else

  if Column = 0 then
    result := CompareText(LPSolver.RowName[id1], LPSolver.RowName[id2]) else
  if Column = LPSolver.NColumns + 1 then
  begin
    if LPSolver.Rh[id1] > LPSolver.Rh[id2] then result := 1 else
      if LPSolver.Rh[id1] < LPSolver.Rh[id2] then result := -1 else
      result := 0;
  end else
  begin
    if LPSolver.Mat[id1, Column] > LPSolver.Mat[id2, Column] then result := 1 else
      if LPSolver.Mat[id1, Column] < LPSolver.Mat[id2, Column] then result := -1 else
      result := 0;
  end;
end;

procedure TMainForm.MatrixTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
begin
  if node.Index = 0 then
    begin
      TargetCanvas.Brush.Color := clInfoBk;
      TargetCanvas.FillRect(CellRect);
    end;
end;

procedure TMainForm.acMatExpCsvExecute(Sender: TObject);
begin
  ResultExportTo(MatrixTable, efrCSV, '.csv', '*.csv');
end;

procedure TMainForm.acMatExpHtmlExecute(Sender: TObject);
begin
  ResultExportTo(MatrixTable, efrHTML, '.html', '*.htm;*.html');
end;

procedure TMainForm.acMatExpRtfExecute(Sender: TObject);
begin
  ResultExportTo(MatrixTable, efrRTF, '.rtf', '*.rtf');
end;

procedure TMainForm.OnMinimize(sender: TObject);
begin
  //ShowWindow(self.Handle, SW_MINIMIZE)
end;

//******************************************************************************
//  ObjectiveSensTable
//******************************************************************************

procedure TMainForm.ObjectiveSensTableGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  row: integer;
  value: TFloat;
begin
  if (Node = nil) or (Column < 0) then
    exit;
  row := PInteger(Sender.GetNodeData(Node))^;
  try
    if Column = 0 then
    begin
      if Node.Index > 0 then
        CellText := trim(LPSolver.ColName[row]) else
        CellText := 'objective';
    end else
    begin
      if row = 0 then
      begin
        //CellText := inttostr(((Column - 1) div 4)+1);
        celltext := FloatToStr(FObjectives[(Column - 1) div 4, 0]);
      end else
      begin
        value := FObjectivesSens[Column-1, row];
        if value <= -LPSolver.Infinite then CellText := '-inf' else
        if value >=  LPSolver.Infinite then CellText := '+inf' else
        CellText := FloatToStr(value);
      end;
    end;
  except
    CellText := 'ERROR'
  end;
end;

procedure TMainForm.ObjectiveSensTableInitNode(Sender: TBaseVirtualTree;
  ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  PInteger(Sender.GetNodeData(Node))^ := Node.Index;
end;

procedure TMainForm.ObjectiveSensTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
begin
  if Node.Index = 0 then
    begin
      TargetCanvas.Brush.Color := clInfoBk;
      TargetCanvas.FillRect(CellRect);
    end
  else
    if (Column > 0) and (((Column - 1) div 4) mod 2 <> 0) then
      begin
        TargetCanvas.Brush.Color := $DFDFDF;
        TargetCanvas.FillRect(CellRect);
      end;
end;

procedure TMainForm.ObjectiveSensTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  with HitInfo do
    if Button = mbLeft then
      with Sender, Treeview do
        begin
          if SortColumn > NoColumn then
            Columns[SortColumn].Options := Columns[SortColumn].Options + [coParentColor];

          if (SortColumn = NoColumn) or (SortColumn <> Column) then
          begin
            SortColumn := Column;
            if Column = 0 then
              SortDirection := sdAscending
            else
              SortDirection := sdDescending;
          end
          else
            if SortDirection = sdAscending then
              SortDirection := sdDescending
            else
              SortDirection := sdAscending;

          Columns[SortColumn].Color := $F7F7F7;
          SortTree(SortColumn, SortDirection, true);
        end;
end;

procedure TMainForm.ObjectiveSensTableCompareNodes(Sender: TBaseVirtualTree; Node1, Node2: PVirtualNode;
  Column: TColumnIndex; var Result: Integer);
var id1, id2: integer;
begin
  id1 := PInteger(Sender.GetNodeData(Node1))^;
  id2 := PInteger(Sender.GetNodeData(Node2))^;

  if id1 = 0 then
  begin
    case ObjectiveSensTable.Header.SortDirection of
      sdAscending  : result := -1;
      sdDescending : result :=  1;
    end;
  end else
  if id2 = 0 then
  begin
    case ObjectiveSensTable.Header.SortDirection of
      sdAscending  : result :=  1;
      sdDescending : result := -1;
    end;
  end else

  if Column = 0 then
    result := CompareText(LPSolver.ColName[id1], LPSolver.ColName[id2]) else
    if FObjectivesSens[Column-1, id1] > FObjectivesSens[Column-1, id2] then result := 1 else
      if FObjectivesSens[Column-1, id1] < FObjectivesSens[Column-1, id2] then result := -1 else
      result := 0;
end;

//******************************************************************************
// RHSSensTable
//******************************************************************************

procedure TMainForm.RHSSensTableInitNode(Sender: TBaseVirtualTree; ParentNode, Node: PVirtualNode;
  var InitialStates: TVirtualNodeInitStates);
begin
  PInteger(Sender.GetNodeData(Node))^ := Node.Index;
end;

procedure TMainForm.RHSSensTableGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  row: integer;
  value: TFloat;
begin
  row := PInteger(Sender.GetNodeData(Node))^;
  try
    if Column = 0 then
    begin
      if Node.Index > 0 then
      begin
        if row > LPSolver.NRows then
          CellText := trim(LPSolver.ColName[row - LPSolver.NRows]) else
          CellText := trim(LPSolver.RowName[row])
      end else
        CellText := 'objective';
    end else
    begin
      if row = 0 then
      begin
        celltext := FloatToStr(FObjectives[(Column - 1) div 3, 0]);
        //CellText := inttostr(((Column - 1) div 3)+1);
      end else
      begin
        value := FRHSSens[Column-1, row];
        if value <= -LPSolver.Infinite then CellText := '-inf' else
        if value >=  LPSolver.Infinite then CellText := '+inf' else
        CellText := FloatToStr(value);
      end;
    end;
  except
    CellText := 'ERROR'
  end;
end;

procedure TMainForm.RHSSensTableBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas;
  Node: PVirtualNode; Column: TColumnIndex; CellPaintMode: TVTCellPaintMode; CellRect: TRect;
  var ContentRect: TRect);
begin
  if Node.Index = 0 then
    begin
      TargetCanvas.Brush.Color := clInfoBk;
      TargetCanvas.FillRect(CellRect);
    end
  else
    if (Column > 0) and (((Column - 1) div 3) mod 2 <> 0) then
      begin
        TargetCanvas.Brush.Color := $DFDFDF;
        TargetCanvas.FillRect(CellRect);
      end;
end;

procedure TMainForm.RHSSensTableHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
begin
  with HitInfo do
    if Button = mbLeft then
      with Sender, Treeview do
        begin
          if SortColumn > NoColumn then
            Columns[SortColumn].Options := Columns[SortColumn].Options + [coParentColor];

          if (SortColumn = NoColumn) or (SortColumn <> Column) then
            begin
              SortColumn := Column;
              if Column = 0 then
                SortDirection := sdAscending
              else
                SortDirection := sdDescending;
            end
          else
            if SortDirection = sdAscending then
              SortDirection := sdDescending
            else
              SortDirection := sdAscending;

          Columns[SortColumn].Color := $F7F7F7;
          SortTree(SortColumn, SortDirection, true);
        end;
end;

procedure TMainForm.RHSSensTableCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  id1, id2: integer;
  txt1, txt2: string;
begin
  id1 := PInteger(Sender.GetNodeData(Node1))^;
  id2 := PInteger(Sender.GetNodeData(Node2))^;

  if id1 = 0 then
  begin
    case RHSSensTable.Header.SortDirection of
      sdAscending  : result := -1;
      sdDescending : result := 1;
    end;
  end else
  if id2 = 0 then
  begin
    case RHSSensTable.Header.SortDirection of
      sdAscending  : result :=  1;
      sdDescending : result := -1;
    end;
  end else

  if Column = 0 then
  begin
    if id1 > LPSolver.NRows then
      txt1 := trim(LPSolver.ColName[id1 - LPSolver.NRows]) else
      txt1 := trim(LPSolver.RowName[id1]);
    if id2 > LPSolver.NRows then
      txt2 := trim(LPSolver.ColName[id2 - LPSolver.NRows]) else
      txt2 := trim(LPSolver.RowName[id2]);
    result := CompareText(txt1, txt2);
  end else
    if FRHSSens[Column-1, id1] > FRHSSens[Column-1, id2] then result := 1 else
      if FRHSSens[Column-1, id1] < FRHSSens[Column-1, id2] then result := -1 else
      result := 0;
end;

procedure TMainForm.acSensObjExpHtmlExecute(Sender: TObject);
begin
  ResultExportTo(ObjectiveSensTable, efrHTML, '.html', '*.htm;*.html');
end;

procedure TMainForm.acSensObjExpRtfExecute(Sender: TObject);
begin
  ResultExportTo(ObjectiveSensTable, efrRTF, '.rtf', '*.rtf');
end;

procedure TMainForm.acSensObjExpCsvExecute(Sender: TObject);
begin
  ResultExportTo(ObjectiveSensTable, efrCSV, '.csv', '*.csv');
end;

procedure TMainForm.acSensDualExpHtmlExecute(Sender: TObject);
begin
  ResultExportTo(RHSSensTable, efrHTML, '.html', '*.htm;*.html');
end;

procedure TMainForm.acSensDualExpRtfExecute(Sender: TObject);
begin
  ResultExportTo(RHSSensTable, efrRTF, '.rtf', '*.rtf');
end;


procedure TMainForm.acSensDualExpCsvExecute(Sender: TObject);
begin
  ResultExportTo(RHSSensTable, efrCSV, '.csv', '*.csv');
end;

//******************************************************************************
// BASIS
//******************************************************************************

procedure TMainForm.acSaveBasisExecute(Sender: TObject);
begin
  if SaveDialogBasis.Execute then
    LPSolver.SaveBasis(SaveDialogBasis.FileName);
end;


procedure TMainForm.acIsNotSolving(Sender: TObject);
begin
  TAction(Sender).Enabled := not FSolving;
end;

procedure TMainForm.acIsSolving(Sender: TObject);
begin
  TAction(Sender).Enabled := FSolving;
end;

procedure TMainForm.acSolveBasisExecute(Sender: TObject);
begin
  try
    if OpenDialogBasis.Execute then
    begin
      FHaveBasis := true;
      acSolve.Execute;
    end;
  finally
    FHaveBasis := false;
  end;
end;

{const           // shellexecute is fine
  HH_DISPLAY_TOPIC        = $0000;
  HH_DISPLAY_TOC          = $0001;
  HH_CLOSE_ALL            = $0012;

function HtmlHelp(hwndCaller: HWND;
  pszFile: PChar; uCommand: UINT;
  dwData: DWORD): HWND; stdcall;
  external 'HHCTRL.OCX' name 'HtmlHelpA';
}
procedure TMainForm.URLshow(const UrlStr: string);
begin
  //shellexecute(Application.Handle, 'open', PChar(UrlStr), nil, nil, SW_SHOW);
  OpenUrl(UrlStr);
end;
procedure TMainForm.acHelpOnlineExecute(Sender: TObject);
begin
//  HtmlHelp(Application.Handle, 'http://lpsolve.sourceforge.net/5.5/', HH_DISPLAY_TOC, 0);
  URLshow('http://lpsolve.sourceforge.net/5.5/')
end;
procedure TMainForm.acHelpExecute(Sender: TObject);
begin
{  HtmlHelp(Application.Handle, PChar(ExtractFilePath(ParamStr(0))+'lp_solve55.chm'),
  HH_DISPLAY_TOC, 0);}
  if FChmFileReader <> '' then
    RunCmdFromPath(FChmFileReader, SLocalHelpFile)
  else
    OpenDocument(ExtractFilePath(Application.ExeName) + SLocalHelpFile);
end;

procedure TMainForm.UpdateVirtualTrees;
var
  i: Integer;
begin
  ObjectiveTable.BeginUpdate;
  with ObjectiveTable, Header.Columns do
    try
      FObjectives.Clear;
      while Count > 1 do
        Delete(1);
      RootNodeCount := LPSolver.NColumns+1;
    finally
      ObjectiveTable.EndUpdate;
    end;

  ObjectiveSensTable.BeginUpdate;
  with ObjectiveSensTable, Header.Columns do
    try
      FObjectivesSens.Clear;
      while Count > 1 do
        Delete(1);
      RootNodeCount := LPSolver.NColumns + 1;
    finally
      ObjectiveSensTable.EndUpdate;
    end;

  RHSSensTable.BeginUpdate;
  with RHSSensTable, Header.Columns do
    try
      FRHSSens.Clear;
      while Count > 1 do
        Delete(1);
      RootNodeCount := LPSolver.NColumns + LPSolver.NRows + 1;
    finally
      RHSSensTable.EndUpdate;
    end;

  ConstraintTable.BeginUpdate;
  with ConstraintTable, Header.Columns do
  try
    FConstraints.Clear;
    while Count > 1 do
      Delete(1);
    RootNodeCount := LPSolver.NRows+1;
  finally
    ConstraintTable.EndUpdate;
  end;

  MatrixTable.BeginUpdate;
  try
    MatrixTable.RootNodeCount := 0;
    MatrixTable.Header.Columns.Clear;
    MatrixTable.RootNodeCount := LPSolver.NRows+1;
    MatrixTable.Header.Columns.Add;
    for i := 1 to LPSolver.NColumns do
      with MatrixTable.Header.Columns.Add do
        Text := trim(LPSolver.ColName[i]);
    MatrixTable.Header.Columns.Add.Text := 'RHS';
  finally
    MatrixTable.EndUpdate;
  end;
end;

procedure TMainForm.ClearVirtualTrees;
begin
  ObjectiveTable.BeginUpdate;
  with ObjectiveTable, Header.Columns do
  try
    FObjectives.Clear;
    RootNodeCount := 0;
    while Count > 1 do Delete(1);
  finally
    ObjectiveTable.EndUpdate;
  end;

  ObjectiveSensTable.BeginUpdate;
  with ObjectiveSensTable, Header.Columns do
  try
    FObjectivesSens.Clear;
    RootNodeCount := 0;
    while Count > 1 do Delete(1);
  finally
    ObjectiveSensTable.EndUpdate;
  end;

  RHSSensTable.BeginUpdate;
  with RHSSensTable, Header.Columns do
  try
    FRHSSens.Clear;
    RootNodeCount := 0;
    while Count > 1 do Delete(1);
  finally
    RHSSensTable.EndUpdate;
  end;

  ConstraintTable.BeginUpdate;
  with ConstraintTable, Header.Columns do
  try
    FConstraints.Clear;
    RootNodeCount := 0;
    while Count > 1 do Delete(1);
  finally
    ConstraintTable.EndUpdate;
  end;

  MatrixTable.BeginUpdate;
  try
    MatrixTable.RootNodeCount := 0;
    MatrixTable.Header.Columns.Clear;
  finally
    MatrixTable.EndUpdate;
  end;
end;

procedure TMainForm.PriorityChange(Sender: TObject);
//const pr: array[-3..2] of Integer = (-15,-2,-1,0,1,2);
const pr: array[-3..2] of TThreadPriority = (
  tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest);
begin
  //SetThreadPriority(GetCurrentThread, pr[Priority.Position]);
  TThread.CurrentThread.Priority := pr[Priority.Position];
end;

procedure TMainForm.acSaveParamsExecute(Sender: TObject);
var
  f: TParamForm;
  prof: string;
begin
  f := Sender as TParamForm;
  try
    begin
      if trim(f.ProfilName.Text) = '' then
        prof := 'default' else
        prof := trim(f.ProfilName.Text);
      LPSolver.WriteParams(f.FileName.Text, format('-h %s', [prof]));
    end;
  finally

  end;
end;

procedure TMainForm.acLoadParamsExecute(Sender: TObject);
var
  f: TParamForm;
  prof: string;
begin       // callback from form button click so is already OK
  f := Sender as TParamForm; //TParamForm.Create(Self);
  try
  //  if f.ShowModal = mrOK then
    begin
      if trim(f.ProfilName.Text) = '' then
        prof := 'default' else
        prof := trim(f.ProfilName.Text);
      if LPSolver.ReadParams(f.FileName.Text, format('-h %s', [prof])) then
      begin
       FLockEvents := true;
        try
          ReadOptions;
        finally
          FLockEvents := false;
        end;
      end;
    end;
  finally
//    f.Free;
  end;
end;

procedure TMainForm.acResetOptionsExecute(Sender: TObject);
begin
  LPSolver.ResetParams;
  FLockEvents := true;
  try
    ReadOptions;
  finally
    FLockEvents := false;
  end;
end;

initialization
  Set8087CW(LP_FPU_CW);
end.



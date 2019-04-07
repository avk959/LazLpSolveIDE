(*
 *  lp_solve v5 component for Delphi v5,6,7 & FPC compiler v1.9.x
 *  Licence LGPL
 *  Author: Henri Gourvest
 *  email: hgourvest@progdigy.com
 *  homepage: http://www.progdigy.com
 *  date: 07/21/2004
 *
 *  modified by avk
 *  date: 04/02/2019
 *)

unit LpObject;

{$I lpsolve.inc}
{$IFDEF FPC}
  {$MODE DELPHI}
{$ENDIF}
{$POINTERMATH ON}
{$INLINE ON}

interface
uses
  Classes, SysUtils, Dialogs, LpSolve, LazFileUtils;

type
  TVerbose       = (vNeutral, vCritical, vSevere, vImportant, vNormal, vDetailed, vFull);
  TConstrType    = (ctLE, ctGE, ctEQ);
  TConstrTypeSet = set of TConstrType;
  TSimplexType   = (stPrimalPrimal, stDualPrimal, stPrimalDual, stDualDual);
  TBasisCrash    = (cNothing, cNonBasicBounds, cMostFeasible, cLeastDegenerate);

  TSolverStatus = (stUnknownError, stDataIgnored, stNoBfp, stNoMemory, stNotRun,
    stOptimal, stSubOptimal, stInfeasible, stUnbounded, stDegenerate, stNumfailure,
    stUserAbort, stTimeout, stRunning, stPresolved, stProcfail, stProcbreak,
    stFeasFound, stNoFeasFound
  {$IFDEF LPS55_UP}
    , stFathomed
  {$ENDIF}
    );

  TMessage = (mPresolve, mIteration, mInvert, mLpFeasible, mLpOptimal,
    mLpEqual, mLpBetter, mMiLpFeasible, mMiLpEqual, mMiLpBetter, mMiLpStrategy,
    mMiLpOptimal, mPerformance, mInitPseudoCost);
  TMessages = set of TMessage;

  TScriptFormat = (sfMPS, sfLP, sfXLI);

  TAntiDegen = (adFixedVars, adColumnCheck, adStalling, adNumFailure, adLostFeas,
    adInfeasible, adDynamic, adDuringBB
  {$IFDEF LPS55_UP}
    ,adRhsPerturb, adBoundFlip
  {$ENDIF}
    );
  TAntiDegens = set of TAntiDegen;

  TPresolve = (prRows, prCols, prLindep, prAggregate, prSparser, prSOS, prReduceMip,
  {$IFDEF LPS55_UP}
    prKnapSack, prElimeq2, prImpliedFree, prReduceGCD, prProbeFix, prProbeReduce,
    prRowDominate, prColDominate, prMergeRows, prImpliedSLK, prColFixDual, prBounds,
  {$ENDIF}
    prDuals, prSensDuals);
  TPresolves = set of TPresolve;

  TMyBool = (mbFalse, mbTrue, mbAutomatic, mbDynamic);

  TBBRuleSelect = (bbFirstSelect, bbGapSelect, bbRangeSelect, bbFractionSelect,
    bbPseudocostSelect, bbPseudoNonIntSelect, bbPseudoRatioSelect, bbUserSelect);

  TBBRuleMode = (bbWeightReverseMode, bbBranchReverseMode, bbGreedyMode,
    bbPseudoCostMode, bbDepthFirstMode, bbRandomizeMode, bbGubMode,
    bbDynamicMode, bbRestartMode, bbBreadthFirstMode, bbAutoOrder
  {$IFDEF LPS55_UP}
    ,bbRCostFixing, bbStrongInit
  {$ENDIF}
    );
  TBBRuleModes = set of TBBRuleMode;
  TBranch      = (bCeiling, bFloor, bAutomatic, bDefault);

  TScaleType   = (sNone, sExtreme, sRange, sMean, sGeometric, sFuture1, sFuture2, sCurtisreId);
  TScaleMode = (sQuadratic, sLogarithmic, sPower2, sEquilibrate, sIntegers, sDynUpdate
  {$IFDEF LPS55_UP}
    ,sRowsOnly ,sColsOnly
  {$ENDIF}
  );
  TScaleModes = set of TScaleMode;

  TImprove = (iNone, iFTran, iBTran, iInverse
  {$IFDEF LPS55_UP}
    ,iBBSimplex
  {$ENDIF}
  );
  TImproves = set of TImprove;

  TPricerRule = (pFirstindex, pDantzig, pDevex, pSteepestedge);
  TPricerMode = (pPrimalFallBack, pMultiple, pPartial, pAdaptive, pHybrid,
    pRandomize, pAutoPartialCols, pAutoPartialRows, pLoopLeft, pLoopAlternate,
  {$IFDEF LPS55_UP}
    pHarrisTwoPass, pForceFull, pTrueNormInit
  {$ELSE}
    pAutoMultiCols, pAutoMultiRows
  {$ENDIF}

    );
  TPricerModes = set of TPricerMode;

  TOnAbort = procedure(sender: TComponent; var return: boolean) of object;
  TOnLog = procedure(sender: TComponent; log: PChar) of object;
  TOnMessage = procedure(sender: TComponent; mesg: TMessage) of object;

  TLPSolver = class(TComponent)
  private
    FLP: TLpHandle;
    FOnAbort: TOnAbort;
    FOnLog: TOnLog;
    FMessages: TMessages;
    FOnMessage: TOnMessage;
    FOnLoad: TNotifyEvent;
    FFreeMPS: boolean;
    FIBMMPS: boolean;
    FNegateObjConstMPS: boolean;
    FIgnoreInteger: boolean;
    FBFP,
    FXLI,
    FXLIDataName,
    FXLIOptions: string;
  class var
    function GetHasBFP: boolean;
    function GetIsNativeBFP: boolean;
    function GetHasXLI: boolean;
    function GetIsNativeXLI: boolean;
    function GetMaximize: boolean;
    function GetMinimize: boolean;
    procedure SetMaximize(const Value: boolean);
    procedure SetMinimize(const Value: boolean);
    function GetAddRowMode: boolean;
    procedure SetAddRowMode(const Value: boolean);
    function GetLagTrace: boolean;
    procedure SetLagTrace(const Value: boolean);
    function GetConstrType(const row: integer): TConstrType;
    procedure SetConstrType(const row: integer;
      const Value: TConstrType);
    function GetRh(const row: integer): TFloat;
    function GetRhRange(const row: integer): TFloat;
    procedure SetRh(const row: integer; const Value: TFloat);
    procedure SetRhRange(const row: integer; const Value: TFloat);
    function GetMat(const row, column: integer): TFloat;
    procedure setMat(const row, column: integer; const Value: TFloat);
    function GetBoundsTighter: boolean;
    function GetIsFree(const column: integer): boolean;
    function GetLowerBound(const column: integer): TFloat;
    function GetUpperBound(const column: integer): TFloat;
    procedure SetBoundsTighter(const Value: boolean);
    procedure SetIsFree(const column: integer; const Value: boolean);
    procedure SetLowerBound(const column: integer; const Value: TFloat);
    procedure SetUpperBound(const column: integer; const Value: TFloat);
    function GetIsBinary(const column: integer): boolean;
    function GetIsInt(const column: integer): boolean;
    function GetIsNegative(const column: integer): boolean;
    function GetIsSemiCont(const column: integer): boolean;
    function GetVarPriority(const column: integer): integer;
    procedure SetIsBinary(const column: integer; const Value: boolean);
    procedure SetIsInt(const column: integer; const Value: boolean);
    procedure SetIsSemiCont(const column: integer; const Value: boolean);
    function GetIsSOSVar(const column: integer): boolean;
    function GetOrigRowName(const row: integer): string;
    function GetRowName(const row: integer): string;
    procedure SetRowName(const row: integer; const Value: string);
    function GetColName(const Col: integer): string;
    function GetOrigColName(const Col: integer): string;
    procedure SetColName(const Col: integer; const Value: string);
    function GetSimplextype: TSimplexType;
    procedure SetSimplextype(const Value: TSimplexType);
    function GetBasisCrash: TBasisCrash;
    procedure SetBasisCrash(const Value: TBasisCrash);
    function getTimeElapsed: TFloat;
    procedure SetOnAbort(const Value: TOnAbort);
    procedure SetOnLog(const Value: TOnLog);
    procedure SetMessages(const Value: TMessages);
    procedure SetOnMessage(const Value: TOnMessage);
    function GetPtrPrimalSolution: PFloatArray;
    function GetPtrLambda: PFloatArray; overload;
    function GetPtrDualSolution: PFloatArray; overload;
    function GetTimeOut: integer;
    function GetVerbose: TVerbose;
    procedure SetTimeOut(const Value: integer);
    procedure SetVerbose(const Value: TVerbose);
    function GetPrintSol: TMyBool;
    procedure SetPrintSol(const Value: TMyBool);
    function ChangeLPHandle(newone: TLpHandle): boolean;
    function GetDebug: boolean;
    procedure SetDebug(const Value: boolean);
    function GetTrace: boolean;
    procedure SetTrace(const Value: boolean);
    function GetAntiDegen: TAntiDegens;
    procedure SetAntiDegen(const Value: TAntiDegens);
    function GetPresolve: TPresolves;
    procedure SetPresolve(const Value: TPresolves);
    function GetLpIndex(const index: integer): integer;
    function GetOrigIndex(const index: integer): integer;
    function GetMaxPivot: integer;
    procedure SetMaxPivot(const Value: integer);
    function GetObjBound: TFloat;
    procedure SetObjBound(const Value: TFloat);
    function GetMipGap(const absolute: boolean): TFloat;
    procedure SetMipGap(const absolute: boolean; const Value: TFloat);
    function GetBBRuleMode: TBBRuleModes;
    function GetBBRuleSelect: TBBRuleSelect;
    procedure SetBBRuleMode(const Value: TBBRuleModes);
    procedure SetBBRuleSelect(const Value: TBBRuleSelect);
    function GetVarBranch(const column: integer): TBranch;
    procedure SetVarBranch(const column: integer; const Value: TBranch);
    function GetEpsb: TFloat;
    function GetEpsd: TFloat;
    function GetEpsel: TFloat;
    function GetInfinite: TFloat;
    procedure SetEpsb(const Value: TFloat);
    procedure SetEpsd(const Value: TFloat);
    procedure SetEpsel(const Value: TFloat);
    procedure SetInfinite(const Value: TFloat);
    function GetScaleMode: TScaleModes;
    function GetScaleType: TScaleType;
    procedure SetScaleMode(const Value: TScaleModes);
    procedure SetScaleType(const Value: TScaleType);
    function GetScaleLimit: TFloat;
    procedure SetScaleLimit(const Value: TFloat);
    function GetIsIntegerScaling: boolean;
    function GetImprove: TImproves;
    procedure SetImprove(const Value: TImproves);
    function GetPivotMode: TPricerModes;
    function GetPivotRule: TPricerRule;
    procedure SetPivotMode(const Value: TPricerModes);
    procedure SetPivotRule(const Value: TPricerRule);
    function getBreakAtFirst: boolean;
    procedure SetBreakAtFirst(const Value: boolean);
    function GetBBFloorFirst: TBranch;
    procedure SetBBFloorFirst(const Value: TBranch);
    function GetBBDepthLimit: integer;
    procedure SetBBDepthLimit(const Value: integer);
    function GetBreakAtValue: TFloat;
    procedure SetBreakAtValue(const Value: TFloat);
    function GetEpsPerturb: TFloat;
    function GetEpsPivot: TFloat;
    function GetNegRange: TFloat;
    procedure SetEpsPerturb(const Value: TFloat);
    procedure SetEpsPivot(const Value: TFloat);
    procedure SetNegRange(const Value: TFloat);
    function GetMaxLevel: integer;
    function GetTotalIter: integer;
    function GetTotalNodes: integer;
    function GetObjective: TFloat;
    function GetWorkingObjective: TFloat;
    function GetVarDualResult(const index: integer): TFloat;
    function GetVarPrimalResult(const index: integer): TFloat;
    function GetPtrVariables: PFloatArray;
    function GetPtrConstraints: PFloatArray;
    function GetSolutionCount: integer;
    function GetSolutionLimit: integer;
    procedure SetSolutionLimit(const Value: integer);
    function GetLRows: integer;
    function GetNOrigRows: integer;
    function GetNRows: integer;
    function GetNColumns: integer;
    function GetNOrigColumns: integer;
    procedure SetLpName(const NewName: string);
    function GetLpName: string; virtual;
    procedure SetBFP(const filename: string);
    procedure SetXLIName(const Value: string);
    function GetNonZeros: integer;
    function GetStatus: TSolverStatus;
    function GetEpsInt: TFloat;
    procedure SetEpsInt(const Value: TFloat);
    class function GetTempFile: string; static; inline;
  protected
    procedure DoOnload; virtual;
  public
    procedure Reset;
    Procedure ResetParams;

    property Handle: TLpHandle read FLP;

    property AddRowMode: boolean read GetAddRowMode write SetAddRowMode;
    property Minimize: boolean read GetMinimize write SetMinimize;

    // BFP suport
    property HasBFP: boolean read GetHasBFP;
    property IsNativeBFP: boolean read GetIsNativeBFP;
    // XLI support
    function WriteXLI(const filename, options: string; results: boolean): boolean;
    function SetXLI(const filename: string): boolean;
    property HasXLI: boolean read GetHasXLI;
    property IsNativeXLI: boolean read GetIsNativeXLI;
    // objective function
    function SetObj(Column: integer; Value: TFloat): boolean;
    function SetObjFn(row: PFloatArray): boolean; overload;
    function SetObjFn(const RowString: string): boolean; overload;
    function SetObjFnEx(count: integer; row: PFloatArray; colno: PIntArray): boolean;
    // Constraints
    function AddConstraint(row: PFloatArray; ConstrType: TConstrType; rh: TFloat): boolean; overload;
    function AddConstraint(const RowString: string; ConstrType: TConstrType; rh: TFloat): boolean; overload;
    function AddConstraintex(count: integer; row: PFloatArray; colno: PIntArray;
      ConstrType: TConstrType; rh: TFloat): boolean;
    function GetRow(RowNr: integer; row: PFloatArray): boolean;
    function DelConstraint(DelRow: integer): boolean;

    // Lagrangian constraints
    function AddLagCon(row: PFloatArray; ConType: TConstrType; rhs: TFloat): boolean; overload;
    function AddLagCon(const RowString: string; ConType: TConstrType; rhs: TFloat): boolean; overload;

    // ConstrType
    property ConstrType[const row: integer]: TConstrType read GetConstrType write SetConstrType;

    property Rh[const row: integer]: TFloat read GetRh write SetRh;
    property RhRange[const row: integer]: TFloat read GetRhRange write SetRhRange;
    procedure SetRhVec(rh: PFloatArray); overload;
    function SetRhVec(const rh: string): boolean; overload;

    function AddColumn(column: PFloatArray): boolean; overload;
    function AddColumn(const ColString: string): boolean; overload;
    function AddColumnEx(count: integer; column: PFloatArray; rowno: PIntArray): boolean;
    function ColumnInLp(column: PFloatArray): integer;
    function GetColumn(colnr: integer; column: PFloatArray): boolean;
    function DelColumn(column: integer): boolean;

    property Mat[const row, column: integer]: TFloat read GetMat write setMat; default;

    // Set the upper and lower bounds of a variable
    function SetBounds(column: integer; lower, upper: TFloat): boolean;
    property UpperBound[const column: integer]: TFloat read GetUpperBound write SetUpperBound;
    property LowerBound[const column: integer]: TFloat read GetLowerBound write SetLowerBound;
    property IsFree[const column: integer]: boolean read GetIsFree write SetIsFree;

    property IsInt[const column: integer]: boolean read GetIsInt write SetIsInt;
    property IsBinary[const column: integer]: boolean read GetIsBinary write SetIsBinary;
    property IsSemiCont[const column: integer]: boolean read GetIsSemiCont write SetIsSemiCont;
    property IsNegative[const column: integer]: boolean read GetIsNegative;

    function SetVarWeights(weights: PFloatArray): boolean;
    property VarPriority[const column: integer]: integer read GetVarPriority;

    // Add SOS constraints
    function AddSOS(const name: string; sostype, priority, count: integer; sosvars: PIntArray;
                    weights: PFloatArray): integer;
    property IsSOSVar[const column: integer]: boolean read GetIsSOSVar;

    property RowName[const row: integer]: string read GetRowName write SetRowName;
    property OrigRowName[const row: integer]: string read GetOrigRowName;

    property ColName[const Col: integer]: string read GetColName write SetColName;
    property OrigColName[const Col: integer]: string read GetOrigColName;

    procedure Unscale;

    procedure SetPreferDual(dodual: boolean);

    procedure DefaultBasis;
    procedure SetBasis(bascolumn: PIntArray; nonbasic: boolean);
    procedure GetBasis(bascolumn: PIntArray; nonbasic: boolean);

    function IsFeasible(Values: PFloatArray; threshold: TFloat): boolean;
    function Solve: TSolverStatus;

    property TimeElapsed: TFloat read getTimeElapsed;

    function GetPrimalSolution(pv: PFloatArray): boolean;
    property PrimalSolution: PFloatArray read GetPtrPrimalSolution;
    function GetDualSolution(rc: PFloatArray): boolean; overload;
    property DualSolution: PFloatArray read GetPtrDualSolution;
    function GetLambda(lambda: PFloatArray): boolean; overload;
    property Lambda: PFloatArray read GetPtrLambda;

    procedure ResetBasis;

    function LoadFromFile(const aFileName: string; verbose: TVerbose; mode: TScriptFormat): boolean;
    function LoadFromStrings(strings: TStrings; verbose: TVerbose; mode: TScriptFormat): boolean;

    function SaveToFile(const filename: string; mode: TScriptFormat): boolean;
    function SaveToStrings(strings: TStrings; mode: TScriptFormat): boolean;

    procedure Print;
    procedure PrintTableau;
    procedure PrintObjective;
    procedure PrintSolution(columns: integer);
    procedure PrintConstraints(columns: integer);
    procedure PrintDuals;
    procedure PrintScales;
    procedure PrintStr(const str: string);


    procedure SetOutputStream(stream: Pointer);
    function SetOutputFile(const filename: string): boolean;

    function PrintDebugDump(const filename: string): boolean;

    property OrigIndex[const index: integer]: integer read GetOrigIndex;
    property LpIndex[const index: integer]: integer read GetLpIndex;

    property MipGap[const absolute: boolean]: TFloat read GetMipGap write SetMipGap;
    property VarBranch[const column: integer]: TBranch read GetVarBranch write SetVarBranch;

    property IsIntegerScaling: boolean read GetIsIntegerScaling;

    property MaxLevel: integer read GetMaxLevel;
    property TotalNodes: integer read GetTotalNodes;
    property TotalIter: integer read GetTotalIter;

    property Objective: TFloat read GetObjective;
    property WorkingObjective: TFloat read GetWorkingObjective;

    property VarPrimalResult[const index: integer]: TFloat read GetVarPrimalResult;
    property VarDualResult[const index: integer]: TFloat read GetVarDualResult;

    function GetVariables(vars: PFloatArray): boolean;
    property Variables: PFloatArray read GetPtrVariables;

    function GetConstraints(constr: PFloatArray): boolean;
    property Constraints: PFloatArray read GetPtrConstraints;

    function GetSensitivityRhs(duals, dualsfrom, dualstill: PFloatArray): boolean;
    function GetPtrSensitivityRhs(var duals, dualsfrom, dualstill: PFloatArray): boolean;

    function GetSensitivityObj(objfrom, objtill: PFloatArray): boolean;
    function GetSensitivityObjEx(objfrom, objtill, objfromvalue, objtillvalue: PFloatArray): boolean;

    function GetPtrSensitivityObj(var objfromn, objtill: PFloatArray): boolean;

    property SolutionCount: integer read GetSolutionCount;

    property NOrigRows: integer read GetNOrigRows;
    property NRows: integer read GetNRows;
    property LRows: integer read GetLRows;

    property NOrigColumns: integer read GetNOrigColumns;
    property NColumns: integer read GetNColumns;

    function GetStatustext(status: TSolverStatus): string;

    // not published
    property Maximize: boolean read GetMaximize write SetMaximize;
    property LpName: string read GetLpName write SetLpName;

    // version 5.1
    property NonZeros: integer read GetNonZeros;
    function IsInfinite(const value: TFloat): boolean;
    property Status: TSolverStatus read GetStatus;

    function SetColumn(colno: Integer; column: PFloatArray): boolean;
    function SetColumnEx(colno, count: Integer; column: PFloatArray; rowno: PIntArray): boolean;
    function SetRow(rowno: Integer; row: PFloatArray): boolean;
    function SetRowex(rowno, count: Integer; row: PFloatArray; colno: PIntArray): boolean;

    function WriteParams(filename, options: string): boolean;
    function ReadParams(filename, options: string): boolean;

    procedure LoadProfile(Stream: TStream);
    procedure SaveProfile(Stream: TStream);

    function SaveBasis(const FileName: string): boolean;
    function LoadBasis(const FileName: string): boolean; overload;
    function LoadBasis(const FileName: string; var info: string): boolean; overload;

    constructor Create(AOwner: TComponent); overload; override;
    destructor Destroy; override;
    property XLI: string read FXLI write SetXLIName;
    class property TempFile: string read GetTempFile;
  published
    // sense
    property LagTrace: boolean read GetLagTrace write SetLagTrace;
    property BoundsTighter: boolean read GetBoundsTighter write SetBoundsTighter;
    property SimplexType: TSimplexType read GetSimplextype write SetSimplextype;
    property BasisCrash: TBasisCrash read GetBasisCrash write SetBasisCrash;
    property OnAbort: TOnAbort read FOnAbort write SetOnAbort;
    property OnLog: TOnLog read FOnLog write SetOnLog;
    property Messages: TMessages read FMessages write SetMessages;
    property OnMessage: TOnMessage read FOnMessage write SetOnMessage;
    property Verbose: TVerbose read GetVerbose write SetVerbose;
    property TimeOut: integer read GetTimeOut write SetTimeOut;
    property PrintSol: TMyBool read GetPrintSol write SetPrintSol;
    property Debug: boolean read GetDebug write SetDebug;
    property Trace: boolean read GetTrace write SetTrace;
    property AntiDegen: TAntiDegens read GetAntiDegen write SetAntiDegen;
    property Presolve: TPresolves read GetPresolve write SetPresolve;
    property MaxPivot: integer read GetMaxPivot write SetMaxPivot;
    property BBRuleSelect: TBBRuleSelect read GetBBRuleSelect write SetBBRuleSelect;
    property BBRuleMode: TBBRuleModes read GetBBRuleMode write SetBBRuleMode;
    property ScaleType: TScaleType read GetScaleType write SetScaleType;
    property ScaleMode: TScaleModes read GetScaleMode write SetScaleMode;
    property Improve: TImproves read GetImprove write SetImprove;
    property PivotRule: TPricerRule read GetPivotRule write SetPivotRule;
    property PivotMode: TPricerModes read GetPivotMode write SetPivotMode;
    property BreakAtFirst: boolean read getBreakAtFirst write SetBreakAtFirst;
    property BBFloorFirst: TBranch read GetBBFloorFirst write SetBBFloorFirst;
    property BBDepthLimit: integer read GetBBDepthLimit write SetBBDepthLimit;
    property SolutionLimit: integer read GetSolutionLimit write SetSolutionLimit;

    property ObjBound: TFloat read GetObjBound write SetObjBound;
    property Infinite: TFloat read GetInfinite write SetInfinite;
    property Epsb: TFloat read GetEpsb write SetEpsb;
    property Epsd: TFloat read GetEpsd write SetEpsd;
    property Epsel: TFloat read GetEpsel write SetEpsel;
    property EpsPerturb: TFloat read GetEpsPerturb write SetEpsPerturb;
    property EpsPivot: TFloat read GetEpsPivot write SetEpsPivot;
    property EpsInt: TFloat read GetEpsInt write SetEpsInt;

    property ScaleLimit: TFloat read GetScaleLimit write SetScaleLimit;
    property BreakAtValue: TFloat read GetBreakAtValue write SetBreakAtValue;
    property NegRange: TFloat read GetNegRange write SetNegRange;

    property FreeMPS: boolean read FFreeMPS write FFreeMPS;
    property IBMMPS: boolean read FIBMMPS write FIBMMPS;
    property NegateObjConstMPS: boolean read FNegateObjConstMPS write FNegateObjConstMPS;
    property IgnoreInteger: boolean read FIgnoreInteger write FIgnoreInteger;
    property BFP: string read FBFP write SetBFP;
    property XLIDataName: string read FXLIDataName write FXLIDataName;
    property XLIOptions: string read FXLIOptions write FXLIOptions;
    property OnLoad: TNotifyEvent read FOnLoad write FOnLoad;
  end;

procedure Register;
{$IFDEF MSWINDOWS}
const MSVCRT = 'msvcrt.dll';

//function std_fclose(p: Pointer): integer; cdecl; external MSVCRT name 'fclose';
//function std_fdopen(handle: integer; r: PChar): Pointer; cdecl; external MSVCRT name '_fdopen';
//function std_fputc(c: integer; p: Pointer): integer; cdecl; external MSVCRT name 'fputc';
//function std_fputs(str: PChar; p: Pointer ): integer; cdecl; external MSVCRT name 'fputs';
//function std_pipe(phandles: PInteger; psize: Cardinal; textmode: integer): integer; cdecl; external MSVCRT name '_pipe';
//function std_fgetc(stream: Pointer): integer; cdecl; external MSVCRT name 'fgetc';
//function std_close(h: integer): integer; cdecl; external MSVCRT name '_close';
function std_system(p: PChar): integer; cdecl; cdecl; external MSVCRT name 'system';
{$ENDIF}

implementation

procedure Register;
begin
  RegisterComponents('LP Solver', [TLPSolver]);
end;

const
  ConstrTypeMap : array[TConstrType] of integer = (LE, GE, EQ);
  SimplexTypeMap: array[TSimplexType] of integer = (SIMPLEX_PRIMAL_PRIMAL,
    SIMPLEX_DUAL_PRIMAL, SIMPLEX_PRIMAL_DUAL, SIMPLEX_DUAL_DUAL);
  MyBoolMap: array[TMyBool] of integer = (_FALSE, _TRUE, _AUTOMATIC, _DYNAMIC);

  function DecodeMyBool(code: integer): TMyBool;
  begin
    case code of
      _FALSE     : result := mbFalse;
      _TRUE      : result := mbTrue;
      _AUTOMATIC : result := mbAutomatic;
      _DYNAMIC   : result := mbDynamic;
    else
      raise Exception.CreateFmt('unexpected TMyBool value: %d', [code]);
    end;
  end;

  function DecodeConstrType(code: integer): TConstrType;
  begin
    case code of
      LE: result := ctLE;
      GE: result := ctGE;
      EQ: result := ctEQ;
    else
      raise Exception.CreateFmt('unexpected constaint sense: %d', [code]);
    end;
  end;

  function DecodeSimplexType(code: integer): TSimplexType;
  begin
    case code of
      SIMPLEX_PRIMAL_PRIMAL : result := stPrimalPrimal;
      SIMPLEX_DUAL_PRIMAL   : result := stDualPrimal;
      SIMPLEX_PRIMAL_DUAL   : result := stPrimalDual;
      SIMPLEX_DUAL_DUAL     : result := stDualDual;
    else
      raise Exception.CreateFmt('Unexpected simplex mode: %d', [code]);
    end;
  end;

  function DecodeMessage(code: integer): TMessage;
  begin
    case code of
      MSG_PRESOLVE       : result := mPresolve;
      MSG_ITERATION      : result := mIteration;
      MSG_INVERT         : result := mInvert;
      MSG_LPFEASIBLE     : result := mLpFeasible;
      MSG_LPOPTIMAL      : result := mLpOptimal;
      MSG_LPEQUAL        : result := mLpEqual;
      MSG_LPBETTER       : result := mLpBetter;
      MSG_MILPFEASIBLE   : result := mMiLpFeasible;
      MSG_MILPEQUAL      : result := mMiLpEqual;
      MSG_MILPBETTER     : result := mMilpBetter;
      MSG_MILPSTRATEGY   : result := mMiLpStrategy;
      MSG_MILPOPTIMAL    : result := mMiLpOptimal;
      MSG_PERFORMANCE    : result := mPerFormance;
      MSG_INITPSEUDOCOST : result := mInitPseudoCost;
    else
      raise Exception.CreateFmt('Unexpected message: %d', [code]);
    end;
  end;

  function AbortHandler(lp: THandle; userhandle: Pointer): integer; stdcall;
  var abrt: boolean;
  begin
     abrt := false;
     if assigned(TLPSolver(userhandle).FOnAbort) then
       TLPSolver(userhandle).FOnAbort(userhandle, abrt);
     result := ord(abrt);
  end;

  procedure LogHandler(lp: THandle; userhandle: Pointer; buf: PChar); stdcall;
  begin
    if assigned(TLPSolver(userhandle).FOnLog) then
      TLPSolver(userhandle).FOnLog(userhandle, buf);
  end;

  procedure MessageHandler(lp: THandle; userhandle: Pointer; message: integer); stdcall;
  begin
    if assigned(TLPSolver(userhandle).FOnMessage) then
      TLPSolver(userhandle).FOnMessage(userhandle, DecodeMessage(message));
  end;

{ TLPSolver }

constructor TLPSolver.Create(AOwner: TComponent);
begin
  FFreeMPS := false;
  FIBMMPS := false;
  FIgnoreInteger := false;
  FNegateObjConstMPS := false;
  FLP := make_lp(0, 0);
  assert(FLP <> 0);
  FBFP := '';
  inherited Create(AOwner);
end;

destructor TLPSolver.Destroy;
begin
  set_BFP(FLP, nil);
  delete_lp(FLP);
  inherited;
end;

function TLPSolver.GetHasBFP: boolean;
begin
  Result := has_BFP(FLP);
end;

function TLPSolver.GetHasXLI: boolean;
begin
  result := has_XLI(FLP);
end;

function TLPSolver.GetIsNativeBFP: boolean;
begin
  result := is_nativeBFP(FLP);
end;

function TLPSolver.GetIsNativeXLI: boolean;
begin
  result := is_nativeXLI(FLP);
end;

function TLPSolver.GetLpName: string;
begin
  result := get_lp_name(FLP);
end;

function TLPSolver.WriteXLI(const filename, options: string;
  results: boolean): boolean;
begin
  result := write_XLI(FLP, Pointer(filename), Pointer(options), results);
end;

procedure TLPSolver.SetBFP(const filename: string);
begin
  if (filename <> FBFP) then
    FBFP := filename;
end;

procedure TLPSolver.SetLpName(const NewName: string);
begin
  set_lp_name(FLP, PChar(NewName));
end;

function TLPSolver.SetXLI(const filename: string): boolean;
begin
  result := set_XLI(FLP, PChar(filename));
end;

function TLPSolver.SetObj(Column: integer; Value: TFloat): boolean;
begin
  result := set_obj(FLP, Column, Value);
end;

function TLPSolver.SetObjFn(row: PFloatArray): boolean;
begin
  result := set_obj_fn(FLP, row);
end;

function TLPSolver.SetObjFnEx(count: integer; row: PFloatArray;
  colno: PIntArray): boolean;
begin
  result := set_obj_fnex(FLP, count, row, colno);
end;

function TLPSolver.SetObjFn(const RowString: string): boolean;
begin
  result := str_set_obj_fn(FLP, PChar(RowString));
end;

function TLPSolver.GetMaximize: boolean;
begin
  result := is_maxim(FLP) = true;
end;

function TLPSolver.GetMinimize: boolean;
begin
  result := is_maxim(FLP) = false;
end;

class function TLPSolver.GetTempFile: string; static;
begin
  //Result := ConfigFolder + '~lpsol55_file';
  Result := GetTempFileNameUTF8('', '~lpsol55_file');
end;

procedure TLPSolver.SetMaximize(const Value: boolean);
begin
  if is_maxim(FLP) <> Value then
  case Value of
    true  : set_maxim(FLP);
    false : set_minim(FLP);
  end;
end;

procedure TLPSolver.SetMinimize(const Value: boolean);
begin
  if is_maxim(FLP) = Value then
  case Value of
    true  : set_minim(FLP);
    false : set_maxim(FLP);
  end;
end;

function TLPSolver.GetAddRowMode: boolean;
begin
  result := is_add_rowmode(FLP);
end;

procedure TLPSolver.SetAddRowMode(const Value: boolean);
begin
  if is_add_rowmode(FLP) <> Value then
    set_add_rowmode(FLP, Value);
end;

function TLPSolver.AddConstraint(row: PFloatArray; ConstrType: TConstrType;
  rh: TFloat): boolean;
begin
  result := add_constraint(FLP, row, ConstrTypeMap[ConstrType], rh)
end;

function TLPSolver.AddConstraintex(count: integer; row: PFloatArray;
  colno: PIntArray; ConstrType: TConstrType; rh: TFloat): boolean;
begin
  result := add_constraintex(FLP, count, row, colno, ConstrTypeMap[ConstrType], rh);
end;

function TLPSolver.AddConstraint(const RowString: string;
  ConstrType: TConstrType; rh: TFloat): boolean;
begin
  result := str_add_constraint(FLP, PChar(RowString), ConstrTypeMap[ConstrType], rh);
end;

function TLPSolver.GetRow(RowNr: integer; row: PFloatArray): boolean;
begin
  result := get_row(FLP, RowNr, row);
end;

function TLPSolver.DelConstraint(DelRow: integer): boolean;
begin
  result := del_constraint(FLP, DelRow);
end;

function TLPSolver.AddLagCon(row: PFloatArray; ConType: TConstrType;
  rhs: TFloat): boolean;
begin
  result := add_lag_con(FLP, row, ConstrTypeMap[ConType], rhs);
end;

function TLPSolver.AddLagCon(const RowString: string;
  ConType: TConstrType; rhs: TFloat): boolean;
begin
  result := str_add_lag_con(FLP, PChar(RowString), ConstrTypeMap[ConType], rhs);
end;

function TLPSolver.GetLagTrace: boolean;
begin
  result := is_lag_trace(FLP);
end;

procedure TLPSolver.SetLagTrace(const Value: boolean);
begin
  if is_lag_trace(FLP) <> Value then
    set_lag_trace(FLP, Value);
end;

function TLPSolver.GetConstrType(const row: integer): TConstrType;
begin
  result := DecodeConstrType(get_constr_type(FLP, row));
end;

procedure TLPSolver.SetConstrType(const row: integer;
  const Value: TConstrType);
begin
  set_constr_type(FLP, row, ConstrTypeMap[Value]);
end;

function TLPSolver.GetRh(const row: integer): TFloat;
begin
  result := get_rh(FLP, row);
end;

function TLPSolver.GetRhRange(const row: integer): TFloat;
begin
  result := get_rh_range(FLP, row);
end;

procedure TLPSolver.SetRh(const row: integer; const Value: TFloat);
begin
  set_rh(FLP, row, Value);
end;

procedure TLPSolver.SetRhRange(const row: integer; const Value: TFloat);
begin
  set_rh_range(FLP, row, Value);
end;

procedure TLPSolver.SetRhVec(rh: PFloatArray);
begin
  set_rh_vec(FLP, rh);
end;

function TLPSolver.SetRhVec(const rh: string): boolean;
begin
  result := str_set_rh_vec(FLP, PChar(rh));
end;

function TLPSolver.AddColumn(const ColString: string): boolean;
begin
  result := str_add_column(FLP, PChar(ColString));
end;

function TLPSolver.AddColumn(column: PFloatArray): boolean;
begin
  result := add_column(FLP, column);
end;

function TLPSolver.AddColumnEx(count: integer; column: PFloatArray;
  rowno: PIntArray): boolean;
begin
  result := add_columnex(FLP, count, column, rowno);
end;

function TLPSolver.ColumnInLp(column: PFloatArray): integer;
begin
  result := column_in_lp(FLP, column);
end;

function TLPSolver.DelColumn(column: integer): boolean;
begin
  result := del_column(FLP, column);
end;

function TLPSolver.GetColumn(colnr: integer; column: PFloatArray): boolean;
begin
  result := get_column(FLP, colnr, column);
end;

function TLPSolver.GetMat(const row, column: integer): TFloat;
begin
  result := get_mat(FLP, row, column);
end;

procedure TLPSolver.setMat(const row, column: integer;
  const Value: TFloat);
begin
  set_mat(FLP, row, column, Value);
end;

function TLPSolver.GetBoundsTighter: boolean;
begin
  result := get_bounds_tighter(FLP);
end;

function TLPSolver.GetIsFree(const column: integer): boolean;
begin
{$IFDEF LPS55_UP}
  result := is_unbounded(FLP, column);
{$ELSE}
  result := is_free(FLP, column);
{$ENDIF}
end;

function TLPSolver.GetLowerBound(const column: integer): TFloat;
begin
  result := get_lowbo(FLP, column);
end;

function TLPSolver.GetUpperBound(const column: integer): TFloat;
begin
  result := get_upbo(FLP, column);
end;

function TLPSolver.SetBounds(column: integer; lower,
  upper: TFloat): boolean;
begin
  result := lpsolve.set_bounds(FLP, column, lower, upper);
end;

procedure TLPSolver.SetBoundsTighter(const Value: boolean);
begin
  if get_bounds_tighter(FLP) <> Value then
    set_bounds_tighter(FLP, Value);
end;

procedure TLPSolver.SetIsFree(const column: integer; const Value: boolean);
begin
{$IFDEF LPS55_UP}
  set_unbounded(FLP, column);
{$ELSE}
  set_free(FLP, column);
{$ENDIF}
end;

procedure TLPSolver.SetLowerBound(const column: integer;
  const Value: TFloat);
begin
  set_lowbo(FLP, column, Value);
end;

procedure TLPSolver.SetUpperBound(const column: integer;
  const Value: TFloat);
begin
  set_upbo(FLP, column, Value);
end;

function TLPSolver.GetIsBinary(const column: integer): boolean;
begin
  result := is_binary(FLP, column);
end;

function TLPSolver.GetIsInt(const column: integer): boolean;
begin
  result := is_int(FLP, column);
end;

function TLPSolver.GetIsNegative(const column: integer): boolean;
begin
  result := is_negative(FLP, column);
end;

function TLPSolver.GetIsSemiCont(const column: integer): boolean;
begin
  result := is_semicont(FLP, column);
end;

function TLPSolver.GetVarPriority(const column: integer): integer;
begin
  result := get_var_priority(FLP, column);
end;

procedure TLPSolver.SetIsBinary(const column: integer;
  const Value: boolean);
begin
  set_binary(FLP, column, Value);
end;

procedure TLPSolver.SetIsInt(const column: integer; const Value: boolean);
begin
  set_int(FLP, column, Value);
end;

procedure TLPSolver.SetIsSemiCont(const column: integer;
  const Value: boolean);
begin
  set_semicont(FLP, column, Value);
end;

function TLPSolver.SetVarWeights(weights: PFloatArray): boolean;
begin
  result := set_var_weights(FLP, weights);
end;

function TLPSolver.AddSOS(const name: string; sostype, priority, count: integer;
  sosvars: PIntArray; weights: PFloatArray): integer;
begin
  result := add_SOS(FLP, PChar(name), sostype, priority, count, sosvars, weights);
end;

function TLPSolver.GetIsSOSVar(const column: integer): boolean;
begin
  result := is_SOS_var(FLP, column);
end;

function TLPSolver.GetOrigRowName(const row: integer): string;
begin
  result := get_origrow_name(FLP, row);
end;

function TLPSolver.GetRowName(const row: integer): string;
begin
  result := get_row_name(FLP, row);
end;

procedure TLPSolver.SetRowName(const row: integer; const Value: string);
begin
  set_row_name(FLP, row, PChar(Value));
end;

function TLPSolver.GetColName(const Col: integer): string;
begin
  result := get_col_name(FLP, col);
end;

function TLPSolver.GetOrigColName(const Col: integer): string;
begin
  result := get_origcol_name(FLP, col);
end;

procedure TLPSolver.SetColName(const Col: integer; const Value: string);
begin
  set_col_name(FLP, Col, PChar(Value));
end;

procedure TLPSolver.Unscale;
begin
  lpsolve.unscale(FLP);
end;

function TLPSolver.GetSimplextype: TSimplexType;
begin
  result := DecodeSimplexType(get_simplextype(FLP));
end;

procedure TLPSolver.SetPreferDual(dodual: boolean);
begin
  set_preferdual(FLP, dodual);
end;

procedure TLPSolver.SetSimplextype(const Value: TSimplexType);
begin
  if get_simplextype(FLP) <> SimplexTypeMap[Value] then
    set_simplextype(FLP, SimplexTypeMap[Value]);
end;

procedure TLPSolver.DefaultBasis;
begin
  default_basis(FLP);
end;

function TLPSolver.GetBasisCrash: TBasisCrash;
begin
  result := TBasisCrash(get_basiscrash(FLP))
end;

procedure TLPSolver.SetBasisCrash(const Value: TBasisCrash);
begin
  if get_basiscrash(FLP) <> ord(Value) then
    set_basiscrash(FLP, ord(Value));
end;

procedure TLPSolver.GetBasis(bascolumn: PIntArray; nonbasic: boolean);
begin
  get_basis(FLP, bascolumn, nonbasic);
end;

procedure TLPSolver.SetBasis(bascolumn: PIntArray; nonbasic: boolean);
begin
  set_basis(FLP, bascolumn, nonbasic);
end;

function TLPSolver.IsFeasible(Values: PFloatArray;
  threshold: TFloat): boolean;
begin
  result := is_feasible(FLP, Values, threshold);
end;

function TLPSolver.Solve: TSolverStatus;
begin
  set_BFP(FLP, PChar(FBFP));
  result := TSolverStatus(lpsolve.solve(FLP) + 5);
end;

function TLPSolver.getTimeElapsed: TFloat;
begin
  result := time_elapsed(FLP);
end;

procedure TLPSolver.SetOnAbort(const Value: TOnAbort);
begin
  FOnAbort := Value;
  if assigned(FOnAbort) then
    put_abortfunc(FLP, @AbortHandler, self) else
    put_abortfunc(FLP, nil, nil);
end;

procedure TLPSolver.SetOnLog(const Value: TOnLog);
begin
  FOnLog := Value;
  if assigned(FOnLog) then
    put_logfunc(FLP, @LogHandler, self) else
    put_logfunc(FLP, nil, nil);
end;

procedure TLPSolver.SetMessages(const Value: TMessages);
var
  msgs: record
   case byte of
    0: (v1: TMessages;);
    1: (v2: integer;);
  end;
begin
  FMessages := Value;
  msgs.v2 := 0;
  msgs.v1 := Value;
  if (FMessages <> []) and (assigned(FOnMessage)) then
    put_msgfunc(FLP, @MessageHandler, self, msgs.v2) else
    put_msgfunc(FLP, nil, self, MSG_NONE);
end;

procedure TLPSolver.SetOnMessage(const Value: TOnMessage);
var
  msgs: record
   case byte of
    0: (v1: TMessages;);
    1: (v2: integer;);
  end;
begin
  msgs.v2 := 0;
  msgs.v1 := FMessages;
  FOnMessage := Value;
  if (FMessages <> []) and (assigned(FOnMessage)) then
    put_msgfunc(FLP, @MessageHandler, self, msgs.v2) else
    put_msgfunc(FLP, nil, self, MSG_NONE);
end;

function TLPSolver.GetPtrDualSolution: PFloatArray;
begin
  get_ptr_dual_solution(FLP, result);
end;

function TLPSolver.GetDualSolution(rc: PFloatArray): boolean;
begin
  result := get_dual_solution(FLP, rc);
end;

function TLPSolver.GetLambda(lambda: PFloatArray): boolean;
begin
  result := get_lambda(FLP, lambda);
end;

function TLPSolver.GetPtrLambda: PFloatArray;
begin
  get_ptr_lambda(FLP, result);
end;

function TLPSolver.GetPtrPrimalSolution: PFloatArray;
begin
  get_ptr_primal_solution(FLP, result);
end;

function TLPSolver.GetPrimalSolution(pv: PFloatArray): boolean;
begin
  result := get_primal_solution(FLP, pv);
end;

procedure TLPSolver.ResetBasis;
begin
  reset_basis(FLP);
end;

function TLPSolver.LoadFromFile(const aFileName: string; verbose: TVerbose; mode: TScriptFormat): boolean;
var
  options: integer;
begin
  case mode of
    sfLP : result := ChangeLPHandle(read_lp(PChar(aFileName), ord(verbose), PChar(name)));
    sfMPS:
      begin
        options := ord(verbose);
        if IBMMPS then
          options := options + 16;
        if NegateObjConstMPS then
          options := options + 32;
        if FFreeMPS then
          result := ChangeLPHandle(read_freeMPS(PChar(aFileName), options))
        else
          result := ChangeLPHandle(read_MPS(PChar(aFileName), options));
      end;
    sfXLI:
      begin
        result := ChangeLPHandle(read_XLI(PChar(FXLI), PChar(aFileName), PChar(FXLIDataName),
                                 PChar(FXLIOptions), ord(verbose)));
        if LpName = TempFile then
          LpName := '';
      end;
  else
    result := false;
  end;
  DoOnload;
end;

function TLPSolver.LoadFromStrings(strings: TStrings; verbose: TVerbose; mode: TScriptFormat): boolean;
var
  TmpFile: string;
begin
  Result := False;
  TmpFile := TempFile;
  try
    strings.SaveToFile(TmpFile);
    result := LoadFromFile(TmpFile, verbose, mode);
  finally
    DeleteFileUtf8(TmpFile);
  end;
end;

function TLPSolver.SaveToFile(const filename: string; mode: TScriptFormat): boolean;
begin
  case mode of
    sfLP : result := write_lp(FLP, PChar(filename));
    sfMPS:
      begin
        if FFreeMPS then
          result := write_freemps(FLP, PChar(filename))
        else
          result := write_mps(FLP, PChar(filename));
      end;
    sfXLI: result := write_XLI(FLP, PChar(filename), PChar(FXLIOptions), false);
  else
    result := false;
  end;
end;

function TLPSolver.SaveToStrings(strings: TStrings; mode: TScriptFormat): boolean;
var
  TmpFile: string;
begin
  TmpFile := TempFile;
  try
    Result := SaveToFile(TmpFile, mode);
    if Result then
      strings.LoadFromFile(TmpFile);
  finally
    DeleteFileUtf8(TmpFile);
  end;
end;

procedure TLPSolver.Print;
begin
  print_lp(FLP);
end;

procedure TLPSolver.PrintTableau;
begin
  print_tableau(FLP);
end;

procedure TLPSolver.PrintConstraints(columns: integer);
begin
  print_constraints(FLP, columns);
end;

procedure TLPSolver.PrintObjective;
begin
  print_objective(FLP);
end;

procedure TLPSolver.PrintSolution(columns: integer);
begin
  print_solution(FLP, columns);
end;

procedure TLPSolver.PrintDuals;
begin
  print_duals(FLP);
end;

procedure TLPSolver.PrintScales;
begin
  print_scales(FLP);
end;

procedure TLPSolver.PrintStr(const str: string);
begin
  print_str(FLP, PChar(str));
end;

function TLPSolver.GetTimeOut: integer;
begin
  result := get_timeout(FLP);
end;

function TLPSolver.GetVerbose: TVerbose;
begin
  result := TVerbose(get_verbose(FLP));
end;

function TLPSolver.SetOutputFile(const filename: string): boolean;
begin
  result := set_outputfile(FLP, PChar(filename));
end;

procedure TLPSolver.SetOutputStream(stream: Pointer);
begin
  set_outputstream(FLP, stream);
end;

procedure TLPSolver.SetTimeOut(const Value: integer);
begin
  if get_timeout(FLP) <> Value then
    set_timeout(FLP, Value);
end;

procedure TLPSolver.SetVerbose(const Value: TVerbose);
begin
  if get_verbose(FLP) <> ord(Value) then
    set_verbose(FLP, ord(Value));
end;

function TLPSolver.GetPrintSol: TMyBool;
begin
  result := DecodeMyBool(get_print_sol(FLP));
end;

procedure TLPSolver.SetPrintSol(const Value: TMyBool);
begin
  if get_print_sol(FLP) <> MyBoolMap[Value] then
    set_print_sol(FLP, MyBoolMap[Value]);
end;

function TLPSolver.ChangeLPHandle(newone: TLpHandle): boolean;
var
  stream: TMemoryStream;
begin
  if newone > 0 then
  begin
    stream := TMemoryStream.Create;
    try
      SaveProfile(stream);
      delete_lp(FLP);
      FLP := newone;
      stream.Seek(0, soFromBeginning);
      LoadProfile(Stream);
    finally
      stream.Free;
    end;
    result := true;
  end else
    result := false;
end;

function TLPSolver.GetDebug: boolean;
begin
  result := is_debug(FLP);
end;

procedure TLPSolver.SetDebug(const Value: boolean);
begin
  if is_debug(FLP) <> Value then
    set_debug(FLP, Value);
end;

function TLPSolver.GetTrace: boolean;
begin
  result := is_trace(FLP);
end;

procedure TLPSolver.SetTrace(const Value: boolean);
begin
  if is_trace(FLP) <> Value then
    set_trace(FLP, Value);
end;

function TLPSolver.PrintDebugDump(const filename: string): boolean;
begin
  result := print_debugdump(FLP, PChar(filename));
end;

function TLPSolver.GetAntiDegen: TAntiDegens;
var
  antideg: record
  case byte of
    0: (v1: integer;);
    1: (v2: TAntiDegens;);
  end;
begin
  antideg.v1 := get_anti_degen(FLP);
  result := antideg.v2;
end;

procedure TLPSolver.SetAntiDegen(const Value: TAntiDegens);
var
  antideg: record
  case byte of
    0: (v1: integer;);
    1: (v2: TAntiDegens;);
  end;
begin
  antideg.v1 := 0;
  antideg.v2 := Value;
  if get_anti_degen(FLP) <> antideg.v1 then
    set_anti_degen(FLP, antideg.v1);
end;

function TLPSolver.GetPresolve: TPresolves;
var
  presolve: record
  case byte of
    0: (v1: integer;);
    1: (v2: TPresolves;);
  end;
begin
  presolve.v1 := get_presolve(FLP);
  result := presolve.v2;
end;

procedure TLPSolver.SetPresolve(const Value: TPresolves);
var
  presolve: record
  case byte of
    0: (v1: integer;);
    1: (v2: TPresolves;);
  end;
begin
  presolve.v1 := 0;
  presolve.v2 := Value;
  if get_presolve(FLP) <> presolve.v1 then
{$IFDEF LPS55_UP}
  set_presolve(FLP, presolve.v1, 0);
{$ELSE}
  set_presolve(FLP, presolve.v1);
{$ENDIF}
end;

function TLPSolver.GetLpIndex(const index: integer): integer;
begin
  result := get_lp_index(FLP, index);
end;

function TLPSolver.GetOrigIndex(const index: integer): integer;
begin
  result := get_orig_index(FLP, index);
end;

function TLPSolver.GetMaxPivot: integer;
begin
  result := get_maxpivot(FLP);
end;

procedure TLPSolver.SetMaxPivot(const Value: integer);
begin
  if (get_maxpivot(FLP) <> Value) then
    set_maxpivot(FLP, Value);
end;

function TLPSolver.GetObjBound: TFloat;
begin
  if Maximize then
    result := -get_obj_bound(FLP) else
    result := get_obj_bound(FLP);
end;

procedure TLPSolver.SetObjBound(const Value: TFloat);
var
  v: TFloat;
begin
  if Maximize then
    v := -Value else
    v := Value;
  if get_obj_bound(FLP) <> v then
    set_obj_bound(FLP, v);
end;

function TLPSolver.GetMipGap(const absolute: boolean): TFloat;
begin
  result := get_mip_gap(FLP, absolute);
end;

procedure TLPSolver.SetMipGap(const absolute: boolean;
  const Value: TFloat);
begin
  set_mip_gap(FLP, absolute, Value);
end;

function TLPSolver.GetBBRuleMode: TBBRuleModes;
var x: Word absolute Result;
begin
  Result := [];
  assert(sizeof(result) = 2);
  x := get_bb_rule(FLP) shr 3;
end;

function TLPSolver.GetBBRuleSelect: TBBRuleSelect;
begin
  result := TBBRuleSelect(get_bb_rule(FLP) and NODE_STRATEGYMASK);
end;

procedure TLPSolver.SetBBRuleMode(const Value: TBBRuleModes);
var
  Flags: Integer;
  x: Word absolute Value;
begin
  Flags := get_bb_rule(FLP) and NODE_STRATEGYMASK or (x shl 3);
  if Flags <> get_bb_rule(FLP) then
    set_bb_rule(FLP, Flags);
end;

procedure TLPSolver.SetBBRuleSelect(const Value: TBBRuleSelect);
var
  Flags: Integer;
begin
  Flags := ord(Value) or (get_bb_rule(FLP) and not NODE_STRATEGYMASK);
  if Flags <> get_bb_rule(FLP) then
    set_bb_rule(FLP, Flags);
end;

function TLPSolver.GetVarBranch(const column: integer): TBranch;
begin
  result := TBranch(get_var_branch(FLP, column));
end;

procedure TLPSolver.SetVarBranch(const column: integer;
  const Value: TBranch);
begin
  set_var_branch(FLP, column, ord(Value));
end;

function TLPSolver.GetEpsb: TFloat;
begin
  result := get_epsb(FLP);
end;

function TLPSolver.GetEpsd: TFloat;
begin
  result := get_epsd(FLP);
end;

function TLPSolver.GetEpsel: TFloat;
begin
  result := get_epsel(FLP);
end;

function TLPSolver.GetInfinite: TFloat;
begin
  result := get_infinite(FLP);
end;

procedure TLPSolver.SetEpsb(const Value: TFloat);
begin
  if get_epsb(FLP) <> Value then
    set_epsb(FLP, Value);
end;

procedure TLPSolver.SetEpsd(const Value: TFloat);
begin
  if get_epsd(FLP) <> Value then
    set_epsd(FLP, Value);
end;

procedure TLPSolver.SetEpsel(const Value: TFloat);
begin
  if get_epsel(FLP) <> Value then
    set_epsel(FLP, Value);
end;

procedure TLPSolver.SetInfinite(const Value: TFloat);
begin
  if get_infinite(FLP) <> Value then
    set_infinite(FLP, Value);
end;

function TLPSolver.GetScaleMode: TScaleModes;
var v: shortint absolute result;
begin
  v := get_scaling(FLP) shr 3;
end;

function TLPSolver.GetScaleType: TScaleType;
var v: shortint absolute result;
begin
  v := get_scaling(FLP) and 7;
end;

procedure TLPSolver.SetScaleMode(const Value: TScaleModes);
var
  v: shortint absolute Value;
begin
  if get_scaling(FLP) <> (get_scaling(FLP) and 7) or (v shl 3) then
    set_scaling(FLP, (get_scaling(FLP) and 7) or (v shl 3));
end;

procedure TLPSolver.SetScaleType(const Value: TScaleType);
begin
  if get_scaling(FLP) <> (get_scaling(FLP) and (not 7)) or ord(Value) then
    set_scaling(FLP, (get_scaling(FLP) and (not 7)) or ord(Value));
end;

function TLPSolver.GetScaleLimit: TFloat;
begin
  result := get_scalelimit(FLP);
end;

procedure TLPSolver.SetScaleLimit(const Value: TFloat);
begin
  if get_scalelimit(FLP) <> Value then
    set_scalelimit(FLP, Value);
end;

function TLPSolver.GetIsIntegerScaling: boolean;
begin
  result := is_integerscaling(FLP);
end;

function TLPSolver.GetImprove: TImproves;
begin
  Result := [];
  case sizeof(TImproves) of
    1: PByte(@Result)^ := get_improve(FLP);
    2: PWord(@Result)^ := get_improve(FLP);
    4: PInteger(@Result)^ := get_improve(FLP);
  end;
end;

procedure TLPSolver.SetImprove(const Value: TImproves);
begin
  if GetImprove <> Value then
    case sizeof(TImproves) of
      1: set_improve(FLP, PByte(@Value)^);
      2: set_improve(FLP, PWord(@Value)^);
      4: set_improve(FLP, PInteger(@Value)^);
    end;
end;

function TLPSolver.GetPivotMode: TPricerModes;
var mode : smallint absolute result;
begin
  mode := get_pivoting(FLP) shr 2;
end;

function TLPSolver.GetPivotRule: TPricerRule;
begin
  result := TPricerRule(get_pivoting(FLP) and 3);
end;

procedure TLPSolver.SetPivotMode(const Value: TPricerModes);
var rule: smallint absolute Value;
begin
  if get_pivoting(FLP) <> (get_pivoting(FLP) and 3) or (integer(rule) shl 2) then
    set_pivoting(FLP, (get_pivoting(FLP) and 3) or (integer(rule) shl 2));
end;

procedure TLPSolver.SetPivotRule(const Value: TPricerRule);
begin
  if get_pivoting(FLP) <> ord(Value) or (get_pivoting(FLP) and (not 3)) then
    set_pivoting(FLP, ord(Value) or (get_pivoting(FLP) and (not 3)));
end;

function TLPSolver.getBreakAtFirst: boolean;
begin
  result := is_break_at_first(FLP);
end;

procedure TLPSolver.SetBreakAtFirst(const Value: boolean);
begin
  if is_break_at_first(FLP) <> Value then
    set_break_at_first(FLP, Value);
end;

function TLPSolver.GetBBFloorFirst: TBranch;
begin
  result := TBranch(get_bb_floorfirst(flp))
end;

procedure TLPSolver.SetBBFloorFirst(const Value: TBranch);
begin
  if get_bb_floorfirst(FLP) <> ord(Value) then
    set_bb_floorfirst(FLP, ord(Value));
end;

function TLPSolver.GetBBDepthLimit: integer;
begin
  result := get_bb_depthlimit(FLP);
end;

procedure TLPSolver.SetBBDepthLimit(const Value: integer);
begin
  if get_bb_depthlimit(FLP) <> Value then
    set_bb_depthlimit(FLP, Value);
end;

function TLPSolver.GetBreakAtValue: TFloat;
begin
  if Maximize then
    result := -get_break_at_value(FLP) else
    result := get_break_at_value(FLP);
end;

procedure TLPSolver.SetBreakAtValue(const Value: TFloat);
var v: TFloat;
begin
  if Maximize then
    v := -Value else
    v := Value;
  if get_break_at_value(FLP) <> v then
    set_break_at_value(FLP, v);
end;

function TLPSolver.GetEpsPerturb: TFloat;
begin
  result := get_epsperturb(FLP);
end;

function TLPSolver.GetEpsPivot: TFloat;
begin
  result := get_epspivot(FLP);
end;

function TLPSolver.GetNegRange: TFloat;
begin
  result := get_negrange(FLP);
end;

procedure TLPSolver.SetEpsPerturb(const Value: TFloat);
begin
  if get_epsperturb(FLP) <> Value then
    set_epsperturb(FLP, Value);
end;

procedure TLPSolver.SetEpsPivot(const Value: TFloat);
begin
  if get_epspivot(FLP) <> Value then
    set_epspivot(FLP, Value);
end;

procedure TLPSolver.SetNegRange(const Value: TFloat);
begin
  if get_negrange(FLP) <> Value then
    set_negrange(FLP, Value);
end;

function TLPSolver.GetMaxLevel: integer;
begin
  result := get_max_level(FLP);
end;

function TLPSolver.GetTotalIter: integer;
begin
  result := get_total_iter(FLP);
end;

function TLPSolver.GetTotalNodes: integer;
begin
  result := get_total_nodes(FLP);
end;

function TLPSolver.GetObjective: TFloat;
begin
  result := get_objective(FLP)
end;

function TLPSolver.GetWorkingObjective: TFloat;
begin
  result := get_working_objective(FLP)
end;

function TLPSolver.GetVarDualResult(const index: integer): TFloat;
begin
  result := get_var_dualresult(FLP, index);
end;

function TLPSolver.GetVarPrimalResult(const index: integer): TFloat;
begin
  result := get_var_primalresult(FLP, index);
end;

function TLPSolver.GetPtrVariables: PFloatArray;
begin
  get_ptr_variables(FLP, result);
end;

function TLPSolver.GetVariables(vars: PFloatArray): boolean;
begin
  result := get_variables(FLP, vars);
end;

function TLPSolver.GetConstraints(constr: PFloatArray): boolean;
begin
  result := get_constraints(FLP, constr);
end;

function TLPSolver.GetPtrConstraints: PFloatArray;
begin
  get_ptr_constraints(FLP, result);
end;

function TLPSolver.GetPtrSensitivityRhs(var duals, dualsfrom,
  dualstill: PFloatArray): boolean;
begin
  result := get_ptr_sensitivity_rhs(FLP, duals, dualsfrom, dualstill)
end;

function TLPSolver.GetSensitivityRhs(duals, dualsfrom,
  dualstill: PFloatArray): boolean;
begin
  result := get_sensitivity_rhs(FLP, duals, dualsfrom, dualstill)
end;

function TLPSolver.GetPtrSensitivityObj(var objfromn,
  objtill: PFloatArray): boolean;
begin
  result := get_ptr_sensitivity_obj(FLP, objfromn, objtill)
end;

function TLPSolver.GetSensitivityObj(objfrom, objtill: PFloatArray): boolean;
begin
  result := get_sensitivity_obj(FLP, objfrom, objtill)
end;

function TLPSolver.GetSolutionCount: integer;
begin
  result := get_solutioncount(FLP);
end;

function TLPSolver.GetSolutionLimit: integer;
begin
  result := get_solutionlimit(FLP);
end;

procedure TLPSolver.SetSolutionLimit(const Value: integer);
begin
  if get_solutionlimit(FLP) <> Value then
    set_solutionlimit(FLP, Value);
end;

function TLPSolver.GetLRows: integer;
begin
  result := get_Lrows(FLP);
end;

function TLPSolver.GetNOrigRows: integer;
begin
  result := get_Norig_rows(FLP);
end;

function TLPSolver.GetNRows: integer;
begin
  result := get_Nrows(FLP);
end;

function TLPSolver.GetNColumns: integer;
begin
  result := get_Ncolumns(FLP);
end;

function TLPSolver.GetNOrigColumns: integer;
begin
  result := get_Norig_columns(FLP);
end;

procedure TLPSolver.LoadProfile(Stream: TStream);
begin
  Stream.ReadComponent(Self);
  SetOnLog(FOnLog);
  SetOnMessage(FOnMessage);
  SetOnAbort(FOnAbort);
end;

procedure TLPSolver.SaveProfile(Stream: TStream);
begin
  Stream.WriteComponent(self);
end;

function TLPSolver.GetStatustext(status: TSolverStatus): string;
begin
  result := get_statustext(FLP, ord(status)-5);
end;

procedure TLPSolver.SetXLIName(const Value: string);
begin
  if set_XLI(FLP, Pointer(Value)) then
    FXLI := Value else
    set_XLI(FLP, Pointer(FXLI));
end;

procedure TLPSolver.DoOnload;
begin
  if Assigned(FOnLoad) then
    FOnLoad(Self);
end;



function TLPSolver.GetNonZeros: integer;
begin
  result := get_nonzeros(FLP);
end;

function TLPSolver.IsInfinite(const value: TFloat): boolean;
begin
  result := is_infinite(FLP, Value)
end;

function TLPSolver.GetStatus: TSolverStatus;
begin
  result := TSolverStatus(get_status(FLP) + 5);
end;

function TLPSolver.SetColumn(colno: Integer; column: PFloatArray): boolean;
begin
  result := set_column(FLP, colno, column);
end;

function TLPSolver.SetColumnEx(colno, count: Integer; column: PFloatArray;
  rowno: PIntArray): boolean;
begin
  result := Set_ColumnEx(FLP, colno, count, column, rowno);
end;

function TLPSolver.SetRow(rowno: Integer; row: PFloatArray): boolean;
begin
  result := Set_Row(FLP, rowno, row);
end;

function TLPSolver.SetRowex(rowno, count: Integer; row: PFloatArray;
  colno: PIntArray): boolean;
begin
  result := set_rowex(FLP, rowno, count, row, colno);
end;

function TLPSolver.GetEpsInt: TFloat;
begin
  result := get_epsint(FLP);
end;

procedure TLPSolver.SetEpsInt(const Value: TFloat);
begin
  if get_epsint(FLP) <> Value then
    set_epsint(FLP, Value);
end;

procedure TLPSolver.Reset;
begin
  delete_lp(FLP);
  FLP := make_lp(0,0);
  SetOnAbort(FOnAbort);
  SetOnLog(FOnLog);
  SetOnMessage(FOnMessage);
end;

function TLPSolver.GetSensitivityObjEx(objfrom, objtill, objfromvalue,
  objtillvalue: PFloatArray): boolean;
begin
  result := get_sensitivity_objex(FLP, objfrom, objtill, objfromvalue, objtillvalue);
end;

function TLPSolver.LoadBasis(const FileName: string; var info: string): boolean;
begin
  result := read_basis(FLP, Pointer(FileName), Pointer(Info));
end;

function TLPSolver.SaveBasis(const FileName: string): boolean;
begin
  result := write_basis(FLP, Pointer(FileName));
end;

function TLPSolver.LoadBasis(const FileName: string): boolean;
begin
  result := read_basis(FLP, Pointer(FileName), nil);
end;

function TLPSolver.ReadParams(filename, options: string): boolean;
begin
  result := read_params(FLP, PChar(filename), PChar(options));
end;

function TLPSolver.WriteParams(filename, options: string): boolean;
begin
  result := write_params(FLP, PChar(filename), PChar(options))
end;

procedure TLPSolver.ResetParams;
begin
  reset_params(FLP);
end;

end.

(*
 *  lp_solve v5.5 API for Delphi 2009 & FPC compiler v1.9.x
 *  Licence LGPL
 *
 *  Author: Henri Gourvest
 *  email: hgourvest@progdigy.com
 *  homepage: http://www.progdigy.com
 *  date: 07/21/2004
 *
 *  Update for Delphi 2009 by:
 *  Thijs Urlings
 *  http://soa.iti.es/thijs
 *  date: 11/01/2010
 *
 *  Important information
 *  Solver library is compiled for a different Control Word, you should change
 *  the Delphi control Word to avoid foating point operation errors.
 *                _control87     Set8087CW
 *  Visual Studio $9001F     ->   639
 *  GCC           $8001F     ->   895
 *
 *  modified by avk
 *  date: 03/31/2019
 *)
unit LpSolve;

{$I lpsolve.inc}
{$ALIGN ON}
{$MINENUMSIZE 4}
{$IFNDEF FPC}
  {$WEAKPACKAGEUNIT}
{$ELSE}
  {$MODE DELPHI}
{$ENDIF}
{$IFDEF LINUX}
  {$DEFINE UNIX}
{$ENDIF}
//comment out this define if LpSolve is compiled in Visual Studio
{$DEFINE GCC_BUILD}
{$POINTERMATH ON}

interface

const
  MAXLONG = $7FFFFFFF;

type
  TFloat    = Double;
  PIntArray = PInteger;
  PFloat    = ^TFloat;
  PFloatArray = PFloat;
  PPtrArray = ^Pointer;
  TLpHandle = type SizeUInt;

{$IFNDEF FPC}
{$IFDEF VER130}
  THandle = LongWord;
  Pinteger = ^integer;
  PDouble = ^double;
{$ENDIF}
{$ENDIF}

(* MYBOOL *)
const
  _FALSE      = 0;
  _TRUE       = 1;
  _AUTOMATIC  = 2;
  _DYNAMIC    = 4;
{$IFDEF GCC_BUILD}
  LP_FPU_CW   = 895;
{$ELSE GCC_BUILD}
  LP_FPU_CW   = 639;
{$ENDIF GCC_BUILD}

(* Prototypes for call-back functions                                        *)
type
{$IFDEF LPS55_UP}
  lphandle_intfunc = function(lp: TLpHandle; userhandle: Pointer): Integer; stdcall;
  lphandlestr_func = procedure(lp: TLpHandle; userhandle: Pointer; buf: PAnsiChar); stdcall;
  lphandleint_func = procedure(lp: TLpHandle; userhandle: Pointer; message: Integer); stdcall;
  lphandleint_intfunc = function(lp: TLpHandle; userhandle: Pointer; message: Integer): Integer; stdcall;
{$ELSE}
  ctrlcfunc = function(lp: TLpHandle; userhandle: Pointer): integer; stdcall;
  logfunc = procedure(lp: TLpHandle; userhandle: Pointer; buf: PAnsiChar); stdcall;
  msgfunc = procedure(lp: TLpHandle; userhandle: Pointer; message: integer); stdcall;
{$ENDIF}

{$IFDEF LPS55_UP}
  COUNTER = Int64;
{$ELSE}
  COUNTER = Integer;
{$ENDIF}

(* Definition of program constants                                          *)
const
  SIMPLEX_UNDEFINED       =  0;
  SIMPLEX_Phase1_PRIMAL   =  1;
  SIMPLEX_Phase1_DUAL     =  2;
  SIMPLEX_Phase2_PRIMAL   =  4;
  SIMPLEX_Phase2_DUAL     =  8;
  SIMPLEX_DYNAMIC         = 16;
{$IFDEF LPS55_UP}
  SIMPLEX_AUTODUALIZE     = 32;
{$ENDIF}

  SIMPLEX_PRIMAL_PRIMAL   = SIMPLEX_Phase1_PRIMAL + SIMPLEX_Phase2_PRIMAL;
  SIMPLEX_DUAL_PRIMAL     = SIMPLEX_Phase1_DUAL   + SIMPLEX_Phase2_PRIMAL;
  SIMPLEX_PRIMAL_DUAL     = SIMPLEX_Phase1_PRIMAL + SIMPLEX_Phase2_DUAL;
  SIMPLEX_DUAL_DUAL       = SIMPLEX_Phase1_DUAL   + SIMPLEX_Phase2_DUAL;
  SIMPLEX_DEFAULT         = SIMPLEX_DUAL_PRIMAL;

(* Presolve defines *)
  PRESOLVE_NONE          =      0;
  PRESOLVE_ROWS          =      1;
  PRESOLVE_COLS          =      2;
  PRESOLVE_LINDEP        =      4;
  PRESOLVE_AGGREGATE     =      8;
  PRESOLVE_SPARSER       =     16;
  PRESOLVE_SOS           =     32;
  PRESOLVE_REDUCEMIP     =     64;
{$IFDEF LPS55_UP}
  PRESOLVE_KNAPSACK      =     128;  // Implementation not tested completely
  PRESOLVE_ELIMEQ2       =     256;
  PRESOLVE_IMPLIEDFREE   =     512;
  PRESOLVE_REDUCEGCD     =    1024;
  PRESOLVE_PROBEFIX      =    2048;
  PRESOLVE_PROBEREDUCE   =    4096;
  PRESOLVE_ROWDOMINATE   =    8192;
  PRESOLVE_COLDOMINATE   =   16384;
  PRESOLVE_MERGEROWS     =   32768;
  PRESOLVE_IMPLIEDSLK    =   65536;
  PRESOLVE_COLFIXDUAL    =  131072;
  PRESOLVE_BOUNDS        =  262144;
  PRESOLVE_DUALS         =  524288;
  PRESOLVE_SENSDUALS     = 1048576;
{$ELSE}
  PRESOLVE_DUALS         =     128;
  PRESOLVE_SENSDUALS     =     256;
{$ENDIF}
  PRESOLVE_LASTMASKMODE  = (PRESOLVE_DUALS - 1);

(* Basis crash options *)
  CRASH_NONE              = 0;
  CRASH_NONBASICBOUNDS    = 1;
  CRASH_MOSTFEASIBLE      = 2;
  CRASH_LEASTDEGENERATE   = 3;

(* Strategy codes to avoid or recover from degenerate pivots,
   infeasibility or numeric errors via randomized bound relaxation *)
  ANTIDEGEN_NONE          =   0;
  ANTIDEGEN_FIXEDVARS     =   1;
  ANTIDEGEN_COLUMNCHECK   =   2;
  ANTIDEGEN_STALLING      =   4;
  ANTIDEGEN_NUMFAILURE    =   8;
  ANTIDEGEN_LOSTFEAS      =  16;
  ANTIDEGEN_INFEASIBLE    =  32;
  ANTIDEGEN_DYNAMIC       =  64;
  ANTIDEGEN_DURINGBB      = 128;
{$IFDEF LPS55_UP}
  ANTIDEGEN_RHSPERTURB    = 256;
  ANTIDEGEN_BOUNDFLIP     = 512;
{$ENDIF}
  ANTIDEGEN_DEFAULT       = (ANTIDEGEN_FIXEDVARS or ANTIDEGEN_STALLING or ANTIDEGEN_INFEASIBLE);

(* Constraint type codes *)
  FR                      = 0;
  LE                      = 1;
  GE                      = 2;
  EQ                      = 3;
  OF_                     = 4;

(* Improvement defines *)
{$IFDEF LPS51}
  IMPROVE_NONE            = 0;
  IMPROVE_FTRAN           = 1;
  IMPROVE_BTRAN           = 2;
  IMPROVE_SOLVE           = (IMPROVE_FTRAN + IMPROVE_BTRAN);
  IMPROVE_INVERSE         = 4;
{$ENDIF}
{$IFDEF LPS55}
  IMPROVE_NONE            = 0;
  IMPROVE_SOLUTION        = 1;
  IMPROVE_DUALFEAS        = 2;
  IMPROVE_THETAGAP        = 4;
  IMPROVE_BBSIMPLEX       = 8;
  IMPROVE_DEFAULT         = (IMPROVE_DUALFEAS + IMPROVE_THETAGAP);
  IMPROVE_INVERSE         = (IMPROVE_SOLUTION + IMPROVE_THETAGAP);
{$ENDIF}

(* Scaling types *)
  SCALE_NONE              = 0;
  SCALE_EXTREME           = 1;
  SCALE_RANGE             = 2;
  SCALE_MEAN              = 3;
  SCALE_GEOMETRIC         = 4;
  SCALE_FUTURE1           = 5;
  SCALE_FUTURE2           = 6;
  SCALE_CURTISREID        = 7;   // Override to Curtis-Reid "optimal" scaling

(* Alternative scaling weights *)
  SCALE_LINEAR           =  0;
  SCALE_QUADRATIC        =  8;
  SCALE_LOGARITHMIC      = 16;
  SCALE_USERWEIGHT       = 31;
  SCALE_MAXTYPE          = (SCALE_QUADRATIC-1);

(* Scaling modes *)
  SCALE_POWER2          =  32;   (* As is or rounded to power of 2 *)
  SCALE_EQUILIBRATE     =  64;   (* Make sure that no scaled number is above 1 *)
  SCALE_INTEGERS        = 128;   (* Apply to integer columns/variables *)
  SCALE_DYNUPDATE       = 256;   (* Apply incrementally every solve() *)
{$IFDEF LPS55_UP}
  SCALE_ROWSONLY        = 512;   (* Override any scaling to only scale the rows *)
  SCALE_COLSONLY       = 1024;   (* Override any scaling to only scale the rows *)
{$ENDIF}

(* Pricing methods *)
  PRICER_FIRSTINDEX       = 0;
  PRICER_DANTZIG          = 1;
  PRICER_DEVEX            = 2;
  PRICER_STEEPESTEDGE     = 3;
  PRICER_LASTOPTION       = PRICER_STEEPESTEDGE;

(* Pricing strategies *)
  PRICE_METHODDEFAULT   =    0;
  PRICE_PRIMALFALLBACK  =    4;    (* In case of Steepest Edge, fall back to DEVEX in primal *)
  PRICE_MULTIPLE        =    8;    (* Enable multiple pricing (primal simplex) *)
  PRICE_PARTIAL         =   16;    (* Enable partial pricing (primal simplex) *)
  PRICE_ADAPTIVE        =   32;    (* Temporarily use First Index if cycling is detected *)
  PRICE_HYBRID          =   64;    (* NOT IMPLEMENTED *)
  PRICE_RANDOMIZE       =  128;    (* Adds a small randomization effect to the selected pricer *)
{$IFDEF LPS55_UP}
  PRICE_AUTOPARTIAL     = 256;    (* Detect and use data on the block structure of the model (primal) *)
  PRICE_AUTOMULTIPLE    = 512;    (* Automatically select multiple pricing (primal simplex) *)
{$ELSE}
  PRICE_AUTOPARTIALCOLS =  256;    (* Detect and use data on the block structure of the model (primal) *)
  PRICE_AUTOPARTIALROWS =  512;    (* Detect and use data on the block structure of the model (dual) *)
{$ENDIF}
  PRICE_LOOPLEFT        = 1024;    (* Scan entering/leaving columns left rather than right *)
  PRICE_LOOPALTERNATE   = 2048;    (* Scan entering/leaving columns alternatingly left/right *)
{$IFDEF LPS55_UP}
  PRICE_HARRISTWOPASS   =  4096;    (* Use Harris' primal pivot logic rather than the default *)
  PRICE_FORCEFULL       =  8192;    (* Non-user option to force full pricing *)
  PRICE_TRUENORMINIT    = 16384;    (* Use true norms for Devex and Steepest Edge initializations *)
{$ELSE}
  PRICE_AUTOMULTICOLS   = 4096;    (* Automatically select multiple pricing (primal) *)
  PRICE_AUTOMULTIROWS   = 8192;    (* Automatically select multiple pricing (dual) *)
{$ENDIF}



{$IFDEF LPS55_UP}
  PRICE_STRATEGYMASK    = (PRICE_METHODDEFAULT + PRICE_PRIMALFALLBACK + PRICE_MULTIPLE + PRICE_PARTIAL +
                            PRICE_ADAPTIVE + PRICE_HYBRID + PRICE_RANDOMIZE + PRICE_AUTOPARTIAL +
                            PRICE_AUTOMULTIPLE +  PRICE_HARRISTWOPASS + PRICE_LOOPLEFT + PRICE_LOOPALTERNATE +
                            PRICE_FORCEFULL + PRICE_TRUENORMINIT);
{$ELSE}
  PRICE_AUTOPARTIAL     = (PRICE_AUTOPARTIALCOLS + PRICE_AUTOPARTIALROWS);
  PRICE_AUTOMULTIPLE    = (PRICE_AUTOMULTICOLS + PRICE_AUTOMULTIROWS);
  PRICE_STRATEGYMASK    = (PRICE_METHODDEFAULT + PRICE_PRIMALFALLBACK + PRICE_MULTIPLE + PRICE_PARTIAL +
                            PRICE_ADAPTIVE + PRICE_HYBRID + PRICE_RANDOMIZE + PRICE_AUTOPARTIAL +
                            PRICE_AUTOMULTIPLE + PRICE_LOOPLEFT + PRICE_LOOPALTERNATE);

{$ENDIF}


  PRICER_RANDFACT       = 0.1;

(* B&B strategies *)
  NODE_FIRSTSELECT         =    0;
  NODE_GAPSELECT           =    1;
  NODE_RANGESELECT         =    2;
  NODE_FRACTIONSELECT      =    3;
  NODE_PSEUDOCOSTSELECT    =    4;
  NODE_PSEUDONONINTSELECT  =    5;    (* Kjell Eikland #1 - Minimize B&B depth *)
  NODE_PSEUDORATIOSELECT   =    6;    (* Kjell Eikland #2 - Minimize a "cost/benefit" ratio *)
  NODE_USERSELECT          =    7;
  NODE_WEIGHTREVERSEMODE   =    8;
  NODE_STRATEGYMASK        = (NODE_WEIGHTREVERSEMODE-1); (* Mask for B&B strategies *)
{$IFDEF LPS55_UP}
  NODE_PSEUDOFEASSELECT    = (NODE_PSEUDONONINTSELECT + NODE_WEIGHTREVERSEMODE);
{$ENDIF}
  NODE_BRANCHREVERSEMODE   =   16;
  NODE_GREEDYMODE          =   32;
  NODE_PSEUDOCOSTMODE      =   64;
  NODE_DEPTHFIRSTMODE      =  128;
  NODE_RANDOMIZEMODE       =  256;
  NODE_GUBMODE             =  512;
  NODE_DYNAMICMODE         = 1024;
  NODE_RESTARTMODE         = 2048;
  NODE_BREADTHFIRSTMODE    = 4096;
  NODE_AUTOORDER           = 8192;
{$IFDEF LPS55_UP}
  NODE_RCOSTFIXING         = 16384;
  NODE_STRONGINIT          = 32768;
{$ELSE}
  NODE_PSEUDOFEASSELECT    = (NODE_PSEUDONONINTSELECT+NODE_WEIGHTREVERSEMODE);
{$ENDIF}

  BRANCH_CEILING          = 0;
  BRANCH_FLOOR            = 1;
  BRANCH_AUTOMATIC        = 2;
  BRANCH_DEFAULT          = 3;

(* Solver status values *)
  UNKNOWNERROR            = -5;
  DATAIGNORED             = -4;
  NOBFP                   = -3;
  NOMEMORY                = -2;
  NOTRUN                  = -1;
  OPTIMAL                 =  0;
  SUBOPTIMAL              =  1;
  INFEASIBLE              =  2;
  UNBOUNDED               =  3;
  DEGENERATE              =  4;
  NUMFAILURE              =  5;
  USERABORT               =  6;
  TIMEOUT                 =  7;
  RUNNING                 =  8;
  PRESOLVED               =  9;

(* Branch & Bound and Lagrangean extra status values *)
  PROCFAIL               = 10;
  PROCBREAK              = 11;
  FEASFOUND              = 12;
  NOFEASFOUND            = 13;
{$IFDEF LPS55_UP}
  FATHOMED               = 14;
{$ENDIF}

(* REPORT defines *)
  NEUTRAL                 = 0;
  CRITICAL                = 1;
  SEVERE                  = 2;
  IMPORTANT               = 3;
  NORMAL                  = 4;
  DETAILED                = 5;
  FULL                    = 6;

(* MESSAGE defines *)
  MSG_NONE             =    0;
  MSG_PRESOLVE         =    1;
  MSG_ITERATION        =    2;
  MSG_INVERT           =    4;
  MSG_LPFEASIBLE       =    8;
  MSG_LPOPTIMAL        =   16;
  MSG_LPEQUAL          =   32;
  MSG_LPBETTER         =   64;
  MSG_MILPFEASIBLE     =  128;
  MSG_MILPEQUAL        =  256;
  MSG_MILPBETTER       =  512;
  MSG_MILPSTRATEGY     = 1024;
  MSG_MILPOPTIMAL      = 2048;
  MSG_PERFORMANCE      = 4096;
  MSG_INITPSEUDOCOST   = 8192;


// Parameters constants for short-cut setting of tolerances
// --------------------------------------------------------------------------------------
  EPS_TIGHT                = 0;
  EPS_MEDIUM               = 1;
  EPS_LOOSE                = 2;
  EPS_BAGGY                = 3;
  EPS_DEFAULT              = EPS_TIGHT;

type

(* Routines with UNIQUE implementations for each XLI engine  *)

  xli_name = function: PAnsiChar; stdcall;
  xli_readmodel = function(lp: TLpHandle; modelname, dataname, options: PAnsiChar; verbose: integer): boolean; stdcall;
  xli_writemodel = function(lp: TLpHandle; filename, options: PAnsiChar; results: boolean): boolean; stdcall;

(* Routines SHARED for all XLI implementations; *)

  xli_compatible = function(lp: TLpHandle; xliversion, lpversion: Integer): boolean; stdcall;


(* User and system function interfaces                                       *)

procedure lp_solve_version(majorversion: Pinteger; minorversion: Pinteger;
  release: Pinteger; build: Pinteger); stdcall;

function make_lp(rows: integer; columns: integer): TLpHandle; stdcall;
function resize_lp(lp: TLpHandle; rows: integer; columns: integer): boolean; stdcall;
function get_status(lp: TLpHandle): integer; stdcall;
function get_statustext(lp: TLpHandle; statuscode: integer): PAnsiChar; stdcall;
// Create and initialise a lprec structure defaults

procedure delete_lp(lp: TLpHandle); stdcall;
procedure free_lp(var plp: TLpHandle); stdcall;
// Remove problem from memory

function set_lp_name(lp: TLpHandle; lpname: PAnsiChar): boolean; stdcall;
function get_lp_name(lp: TLpHandle): PAnsiChar; stdcall;
// Set and get the problem name

function has_BFP(lp: TLpHandle): boolean; stdcall;
function is_nativeBFP(lp: TLpHandle): boolean; stdcall;
function set_BFP(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall;
// Set basis factorization engine


function read_XLI(xliname, modelname, dataname, options: PAnsiChar; verbose: integer): TLpHandle; stdcall;
function write_XLI(lp: TLpHandle; filename, options: PAnsiChar; results: boolean): boolean; stdcall;
function has_XLI(lp: TLpHandle): boolean; stdcall;
function is_nativeXLI(lp: TLpHandle): boolean; stdcall;
function set_XLI(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall;
// Set external language interface

function set_obj(lp: TLpHandle; Column: integer; Value: double): boolean; stdcall;
function set_obj_fn(lp: TLpHandle; row: PFloatArray): boolean; stdcall;
function set_obj_fnex(lp: TLpHandle; count: integer; row: PFloatArray;
  colno: PIntArray): boolean; stdcall;
// set the objective function (Row 0) of the matrix
function str_set_obj_fn(lp: TLpHandle; row_string: PAnsiChar): boolean; stdcall;
// The same, but with string input
procedure set_sense(lp: TLpHandle; maximize: boolean); stdcall;
procedure set_maxim(lp: TLpHandle); stdcall;
procedure set_minim(lp: TLpHandle); stdcall;
function is_maxim(lp: TLpHandle): boolean; stdcall;
// Set optimization direction for the objective function

function add_constraint(lp: TLpHandle; row: PFloatArray; constr_type: integer; rh: double): boolean; stdcall;
function add_constraintex(lp: TLpHandle; count: integer; row: PFloatArray; colno: PIntArray;
  constr_type: integer; rh: double): boolean; stdcall;
function set_add_rowmode(lp: TLpHandle; turnon: boolean): boolean; stdcall;
function is_add_rowmode(lp: TLpHandle): boolean; stdcall;
{ Add a constraint to the problem, row is the constraint row, rh is the right hand side,
   constr_type is the type of constraint (LE (<=), GE(>=), EQ(=)) }
function str_add_constraint(lp: TLpHandle; row_string : PAnsiChar; constr_type: integer; rh: double): boolean; stdcall;
// The same, but with string input

function set_row(lp: TLpHandle; row_no: Integer; row: PFloatArray): boolean; stdcall;
function set_rowex(lp: TLpHandle; row_no, count: Integer; row: PFloatArray; colno: PIntArray): boolean; stdcall;

function get_row(lp: TLpHandle; row_nr: integer; row: PFloatArray): boolean; stdcall;
// Fill row with the row row_nr from the problem

function del_constraint(lp: TLpHandle; del_row: integer): boolean; stdcall;
// Remove constrain nr del_row from the problem

function add_lag_con(lp: TLpHandle; row: PFloatArray; con_type: integer; rhs: double): boolean; stdcall;
// add a Lagrangian constraint of form Row' x contype Rhs
function str_add_lag_con(lp: TLpHandle; row_string: PAnsiChar; con_type: integer; rhs: double): boolean; stdcall;
// The same, but with string input
procedure set_lag_trace(lp: TLpHandle; lag_trace: boolean); stdcall;
function is_lag_trace(lp: TLpHandle): boolean; stdcall;
// Set debugging/tracing mode of the Lagrangean solver

function set_constr_type(lp: TLpHandle; row: integer; con_type: integer): boolean; stdcall;
function get_constr_type(lp: TLpHandle; row: integer): integer; stdcall;
function is_constr_type(lp: TLpHandle; row: integer; mask: integer): boolean; stdcall;
// Set the type of constraint in row Row (LE, GE, EQ)

function set_rh(lp: TLpHandle; row: integer; value: double): boolean; stdcall;
function get_rh(lp: TLpHandle; row: integer): double; stdcall;
// Set and get the right hand side of a constraint row
function set_rh_range(lp: TLpHandle; row: integer; deltavalue: double): boolean; stdcall;
function get_rh_range(lp: TLpHandle; row: integer): double; stdcall;
// Set the RHS range; i.e. the lower and upper bounds of a constraint row
procedure set_rh_vec(lp: TLpHandle; rh: PFloatArray); stdcall;
// Set the right hand side vector
function str_set_rh_vec(lp: TLpHandle; rh_string: PAnsiChar): boolean; stdcall;
// The same, but with string input

function add_column(lp: TLpHandle; column: PFloatArray): boolean; stdcall;
function add_columnex(lp: TLpHandle; count: integer; column: PFloatArray; rowno: PIntArray): boolean; stdcall;
// Add a column to the problem
function str_add_column(lp: TLpHandle; col_string: PAnsiChar): boolean; stdcall;
// The same, but with string input
function set_column(lp: TLpHandle; col_no: Integer; column: PFloatArray): boolean; stdcall;
function set_columnex(lp: TLpHandle; col_no, count: Integer; column: PFloatArray; rowno: PIntArray): boolean; stdcall;

function column_in_lp(lp: TLpHandle; column: PFloatArray): integer; stdcall;
{ Returns the column index if column is already present in lp, otherwise 0.
   (Does not look at bounds and types, only looks at matrix values }
function get_column(lp: TLpHandle; col_nr: integer; column: PFloatArray): boolean; stdcall;
// Fill column with the column col_nr from the problem

function del_column(lp: TLpHandle; column: integer): boolean; stdcall;
// Delete a column

function set_mat(lp: TLpHandle; row: integer; column: integer; value: double): boolean; stdcall;
{ Fill in element (Row,Column) of the matrix
   Row in [0..Rows] and Column in [1..Columns] }
function get_mat(lp: TLpHandle; row: integer; column: integer): double; stdcall;
function get_mat_byindex(lp: TLpHandle; matindex: Integer; isrow, adjustsign: boolean): double; stdcall;
function get_nonzeros(lp: TLpHandle): integer; stdcall;

procedure set_bounds_tighter(lp: TLpHandle; tighten: boolean); stdcall;
function get_bounds_tighter(lp: TLpHandle): boolean; stdcall;
function set_upbo(lp: TLpHandle; column: integer; value: double): boolean; stdcall;
function get_upbo(lp: TLpHandle; column: integer): double; stdcall;
function set_lowbo(lp: TLpHandle; column: integer; value: double): boolean; stdcall;
function get_lowbo(lp: TLpHandle; column: integer): double; stdcall;
function set_bounds(lp: TLpHandle; column: integer; lower: double; upper: double): boolean; stdcall;
//function get_bounds(lp: TLpHandle; column: Integer; lower, upper: PFloatArray): boolean; stdcall;

function set_int(lp: TLpHandle; column: integer; must_be_int: boolean): boolean; stdcall;
function is_int(lp: TLpHandle; column: integer): boolean; stdcall;
function set_binary(lp: TLpHandle; column: integer; must_be_bin: boolean): boolean; stdcall;
function is_binary(lp: TLpHandle; column: integer): boolean; stdcall;
function set_semicont(lp: TLpHandle; column: integer; must_be_sc: boolean): boolean; stdcall;
function is_semicont(lp: TLpHandle; column: integer): boolean; stdcall;
function is_negative(lp: TLpHandle; column: integer): boolean; stdcall;
function set_var_weights(lp: TLpHandle; weights: PFloatArray): boolean; stdcall;
function get_var_priority(lp: TLpHandle; column: integer): integer; stdcall;
// Set the type of variable, if must_be_int = TRUE then the variable must be integer

function add_SOS(lp: TLpHandle; name: PAnsiChar; sostype: integer; priority: integer;
  count: integer; sosvars: PIntArray; weights: PFloatArray): integer; stdcall;
function is_SOS_var(lp: TLpHandle; column: integer): boolean; stdcall;
// Add SOS constraints

function set_row_name(lp: TLpHandle; row: integer; new_name: PAnsiChar): boolean; stdcall;
function get_row_name(lp: TLpHandle; row: integer): PAnsiChar; stdcall;
function get_origrow_name(lp: TLpHandle; row: integer): PAnsiChar; stdcall;
// Set/Get the name of a constraint row - Get added by KE

function set_col_name(lp: TLpHandle; column: integer; new_name: PAnsiChar): boolean; stdcall;
function get_col_name(lp: TLpHandle; column: integer): PAnsiChar; stdcall;
function get_origcol_name(lp: TLpHandle; column: integer): PAnsiChar; stdcall;
// Set/Get the name of a variable column - Get added by KE

procedure unscale(lp: TLpHandle); stdcall;
// Undo previous scaling of the problem

procedure set_preferdual(lp: TLpHandle; dodual: boolean); stdcall;
procedure set_simplextype(lp: TLpHandle; simplextype: integer); stdcall;
function get_simplextype(lp: TLpHandle): integer; stdcall;
// Set/Get if lp_solve should prefer the dual simplex over the primal -- added by KE

procedure default_basis(lp: TLpHandle); stdcall;
procedure set_basiscrash(lp: TLpHandle; mode: integer); stdcall;
function get_basiscrash(lp: TLpHandle): integer; stdcall;
function set_basis(lp: TLpHandle; bascolumn: PIntArray; nonbasic: boolean): boolean; stdcall;

function is_feasible(lp: TLpHandle; values: PFloatArray; threshold: double): boolean; stdcall;
// returns TRUE if the vector in values is a feasible solution to the lp

function solve(lp: TLpHandle): integer; stdcall;
// Solve the problem

function time_elapsed(lp: TLpHandle): double; stdcall;
// Return the number of seconds since start of solution process

function get_primal_solution(lp: TLpHandle; pv: PFloatArray): boolean; stdcall;
function get_ptr_primal_solution(lp: TLpHandle; var pv: PFloatArray): boolean; stdcall;
function get_dual_solution(lp: TLpHandle; rc: PFloatArray): boolean; stdcall;
function get_ptr_dual_solution(lp: TLpHandle; var rc: PFloatArray): boolean; stdcall;
function get_lambda(lp: TLpHandle; lambda: PFloatArray): boolean; stdcall;
function get_ptr_lambda(lp: TLpHandle; var lambda: PFloatArray): boolean; stdcall;
// Get the primal, dual/reduced costs and Lambda vectors

procedure reset_basis(lp: TLpHandle); stdcall;
// Reset the basis of a problem, can be useful in case of degeneracy - JD

// Read an MPS file
function read_MPS(filename: PAnsiChar; options: integer): TLpHandle; stdcall; overload;
function read_mps(stream: PInteger; options: integer): TLpHandle; stdcall; overload;
// Write a MPS file to output
function write_mps(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; overload;
function write_MPS(lp: TLpHandle; output: PInteger): boolean; stdcall; overload;


function read_freeMPS(filename: PAnsiChar; options: Integer): TLpHandle; stdcall; overload;
function read_freemps(filename: Pinteger; options: Integer): TLpHandle; stdcall; overload;
function write_freemps(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; overload;
function write_freeMPS(lp: TLpHandle; output: PInteger): boolean; stdcall; overload;

function guess_basis(lp: TLpHandle; guessvector: PFloatArray; basisvector: PIntArray): boolean; stdcall;
function read_basis(lp: TLpHandle; filename, info: PAnsiChar): boolean; stdcall;
function write_basis(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall;

function write_lp(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; overload;
function write_LP(lp: TLpHandle; filename: PInteger): boolean; stdcall; overload;
// Write a LP file to output

function read_lp(filename: Pinteger; verbose: integer; lp_name: PAnsiChar): TLpHandle; stdcall; overload;
function read_LP(filename: PAnsiChar; verbose: integer; lp_name: PAnsiChar): TLpHandle; stdcall; overload;
// Old-style lp format file parser

procedure print_lp(lp: TLpHandle); stdcall;
procedure print_tableau(lp: TLpHandle); stdcall;
// Print the current problem, only useful in very small (test) problems

procedure print_objective(lp: TLpHandle); stdcall;
procedure print_solution(lp: TLpHandle; columns: integer); stdcall;
procedure print_constraints(lp: TLpHandle; columns: integer); stdcall;
// Print the solution to stdout

procedure print_duals(lp: TLpHandle); stdcall;
// Print the dual variables of the solution

procedure print_scales(lp: TLpHandle); stdcall;
// If scaling is used, print the scaling factors

procedure print_str(lp: TLpHandle; str: PAnsiChar); stdcall;

procedure set_outputstream(lp: TLpHandle; stream: Pointer); stdcall;
function set_outputfile(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall;

procedure set_verbose(lp: TLpHandle; verbose: integer); stdcall;
function get_verbose(lp: TLpHandle): integer; stdcall;

procedure set_timeout(lp: TLpHandle; sectimeout: integer); stdcall;
function get_timeout(lp: TLpHandle): integer; stdcall;

procedure set_print_sol(lp: TLpHandle; print_sol: integer); stdcall;
function get_print_sol(lp: TLpHandle): integer; stdcall;

procedure set_debug(lp: TLpHandle; debug: boolean); stdcall;
function is_debug(lp: TLpHandle): boolean; stdcall;

procedure set_trace(lp: TLpHandle; trace: boolean); stdcall;
function is_trace(lp: TLpHandle): boolean; stdcall;

function print_debugdump(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall;

procedure set_anti_degen(lp: TLpHandle; anti_degen: integer); stdcall;
function get_anti_degen(lp: TLpHandle): integer; stdcall;
function is_anti_degen(lp: TLpHandle; testmask: integer): boolean; stdcall;

function get_presolve(lp: TLpHandle): integer; stdcall;
function is_presolve(lp: TLpHandle; testmask: integer): boolean; stdcall;

function get_orig_index(lp: TLpHandle; lp_index: integer): integer; stdcall;
function get_lp_index(lp: TLpHandle; orig_index: integer): integer; stdcall;

procedure set_maxpivot(lp: TLpHandle; max_num_inv: integer); stdcall;
function get_maxpivot(lp: TLpHandle): integer; stdcall;

procedure set_obj_bound(lp: TLpHandle; obj_bound: double); stdcall;
function get_obj_bound(lp: TLpHandle): double; stdcall;

procedure set_mip_gap(lp: TLpHandle; absolute: boolean; mip_gap: double); stdcall;
function get_mip_gap(lp: TLpHandle; absolute: boolean): double; stdcall;

procedure set_bb_rule(lp: TLpHandle; bb_rule: integer); stdcall;
function get_bb_rule(lp: TLpHandle): integer; stdcall;

function set_var_branch(lp: TLpHandle; column: integer; branch_mode: integer): boolean; stdcall;
function get_var_branch(lp: TLpHandle; column: integer): integer; stdcall;

function is_infinite(lp: TLpHandle; value: double): boolean; stdcall;
procedure set_infinite(lp: TLpHandle; infinite: double); stdcall;
function get_infinite(lp: TLpHandle): double; stdcall;

procedure set_epsint(lp: TLpHandle; epsilon: double); stdcall;
function get_epsint(lp: TLpHandle): double; stdcall;

procedure set_epsb(lp: TLpHandle; epsb: double); stdcall;
function get_epsb(lp: TLpHandle): double; stdcall;

procedure set_epsd(lp: TLpHandle; epsd: double); stdcall;
function get_epsd(lp: TLpHandle): double; stdcall;

procedure set_epsel(lp: TLpHandle; epsel: double); stdcall;
function get_epsel(lp: TLpHandle): double; stdcall;

procedure set_scaling(lp: TLpHandle; scalemode: integer); stdcall;
function get_scaling(lp: TLpHandle): integer; stdcall;
function is_scalemode(lp: TLpHandle; testmask: integer): boolean; stdcall;
function is_scaletype(lp: TLpHandle; scaletype: integer): boolean; stdcall;
function is_integerscaling(lp: TLpHandle): boolean; stdcall;
procedure set_scalelimit(lp: TLpHandle; scalelimit: double); stdcall;
function get_scalelimit(lp: TLpHandle): double; stdcall;

procedure set_improve(lp: TLpHandle; improve: integer); stdcall;
function get_improve(lp: TLpHandle): integer; stdcall;

procedure set_pivoting(lp: TLpHandle; piv_rule: integer); stdcall;
function get_pivoting(lp: TLpHandle): integer; stdcall;

function set_partialprice(lp: TLpHandle; blockcount: Integer; blockstart: PIntArray; isrow: boolean): boolean; stdcall;
procedure get_partialprice(lp: TLpHandle; blockcount: PIntArray; blockstart: PIntArray; isrow: boolean); stdcall;

function set_multiprice(lp: TLpHandle; multiblockdiv: Integer): boolean; stdcall;
function get_multiprice(lp: TLpHandle; getabssize: boolean): Integer; stdcall;

function is_piv_mode(lp: TLpHandle; testmask: integer): boolean; stdcall;
function is_piv_rule(lp: TLpHandle; rule: integer): boolean; stdcall;

procedure set_break_at_first(lp: TLpHandle; break_at_first: boolean); stdcall;
function is_break_at_first(lp: TLpHandle): boolean; stdcall;

procedure set_bb_floorfirst(lp: TLpHandle; bb_floorfirst: integer); stdcall;
function get_bb_floorfirst(lp: TLpHandle): integer; stdcall;

procedure set_bb_depthlimit(lp: TLpHandle; bb_maxlevel: integer); stdcall;
function get_bb_depthlimit(lp: TLpHandle): integer; stdcall;

procedure set_break_at_value(lp: TLpHandle; break_at_value: double); stdcall;
function get_break_at_value(lp: TLpHandle): double; stdcall;

procedure set_negrange(lp: TLpHandle; negrange: double); stdcall;
function get_negrange(lp: TLpHandle): double; stdcall;

procedure set_epsperturb(lp: TLpHandle; epsperturb: double); stdcall;
function get_epsperturb(lp: TLpHandle): double; stdcall;

procedure set_epspivot(lp: TLpHandle; epspivot: double); stdcall;
function get_epspivot(lp: TLpHandle): double; stdcall;

function get_max_level(lp: TLpHandle): integer; stdcall;
function get_total_nodes(lp: TLpHandle): COUNTER; stdcall;
function get_total_iter(lp: TLpHandle): COUNTER; stdcall;

function get_objective(lp: TLpHandle): double; stdcall;
function get_working_objective(lp: TLpHandle): double; stdcall;

function get_var_primalresult(lp: TLpHandle; index: integer): double; stdcall;
function get_var_dualresult(lp: TLpHandle; index: integer): double; stdcall;

function get_variables(lp: TLpHandle; var_: PFloatArray): boolean; stdcall;
function get_ptr_variables(lp: TLpHandle; var var_: PFloatArray): boolean; stdcall;

function get_constraints(lp: TLpHandle; constr: PFloatArray): boolean; stdcall;
function get_ptr_constraints(lp: TLpHandle; var constr: PFloatArray): boolean; stdcall;

function get_sensitivity_rhs(lp: TLpHandle; duals, dualsfrom, dualstill: PFloatArray): boolean; stdcall;
function get_ptr_sensitivity_rhs(lp: TLpHandle; var duals, dualsfrom, dualstill: PFloatArray): boolean; stdcall;

function get_sensitivity_obj(lp: TLpHandle; objfrom, objtill: PFloatArray): boolean; stdcall;
function get_sensitivity_objex(lp: TLpHandle; objfrom, objtill, objfromvalue, objtillvalue: PFloatArray): boolean; stdcall;
function get_ptr_sensitivity_obj(lp: TLpHandle; var objfrom, objtill: PFloatArray): boolean; stdcall;
function get_ptr_sensitivity_objex(lp: TLpHandle; var objfrom, objtill, objfromvalue, objtillvalue: PFloatArray): boolean; stdcall;


procedure set_solutionlimit(lp: TLpHandle; limit: integer); stdcall;
function get_solutionlimit(lp: TLpHandle): integer; stdcall;
function get_solutioncount(lp: TLpHandle): integer; stdcall;

function get_Norig_rows(lp: TLpHandle): integer; stdcall;
function get_Nrows(lp: TLpHandle): integer; stdcall;
function get_Lrows(lp: TLpHandle): integer; stdcall;

function get_Norig_columns(lp: TLpHandle): integer; stdcall;
function get_Ncolumns(lp: TLpHandle): integer; stdcall;

function get_nameindex(lp: TLpHandle; varname: PAnsiChar; isrow: boolean): Integer; stdcall;


{$IFDEF LPS55_UP}
function copy_lp(lp: TLpHandle): TLpHandle; stdcall;
function dualize_lp(lp: TLpHandle): boolean; stdcall;
(* Copy or dualize the lp *)
function get_constr_value(lp: TLpHandle; rownr, count: Integer;
  primsolution: PFloatArray; nzindex: PIntArray): double; stdcall;
function get_columnex(lp: TLpHandle; colnr: Integer; column: PFloatArray;
  nzrow: PIntArray): Integer; stdcall;
function set_unbounded(lp: TLpHandle; colnr: Integer): boolean; stdcall;
function is_unbounded(lp: TLpHandle; colnr: Integer): boolean; stdcall;
function get_basis(lp: TLpHandle; bascolumn: PIntArray; nonbasic: boolean): boolean; stdcall;
function set_basisvar(lp: TLpHandle; basisPos, enteringCol: Integer): Integer; stdcall;
procedure put_bb_nodefunc(lp: TLpHandle; newnode: lphandleint_intfunc; bbnodehandle: Pointer); stdcall;
procedure put_bb_branchfunc(lp: TLpHandle; newbranch: lphandleint_intfunc; bbbranchhandle: Pointer); stdcall;
// Allow the user to override B&B node and branching decisions
procedure put_abortfunc(lp: TLpHandle; newctrlc: lphandle_intfunc; ctrlchandle: Pointer); stdcall;
// Allow the user to define an interruption callback function
procedure put_logfunc(lp: TLpHandle; newlog: lphandlestr_func; loghandle: Pointer); stdcall;
// Allow the user to define a logging function
procedure put_msgfunc(lp: TLpHandle; newmsg: lphandleint_func; msghandle: Pointer; mask: integer); stdcall;
// Allow the user to define an event-driven message/reporting
function write_params(lp: TLpHandle; filename, options: PAnsiChar): boolean; stdcall;
function read_params(lp: TLpHandle; filename, options: PAnsiChar): boolean; stdcall;
procedure reset_params(lp: TLpHandle); stdcall;
// Read and write parameter file
procedure set_presolve(lp: TLpHandle; presolvemode, maxloops: Integer); stdcall;
function get_presolveloops(lp: TLpHandle): Integer; stdcall;
function set_epslevel(lp: TLpHandle; epslevel: Integer): boolean; stdcall;
function get_rowex(lp: TLpHandle; rownr: Integer; row: PFloatArray; colno: PIntArray): integer; stdcall;
function is_use_names(lp: TLpHandle; isrow: boolean): boolean; stdcall;
procedure set_use_names(lp: TLpHandle; isrow, use_names: boolean); stdcall;
function is_obj_in_basis(lp: TLpHandle): boolean; stdcall;
procedure set_obj_in_basis(lp: TLpHandle; obj_in_basis: boolean); stdcall;
{$ELSE}
function set_free(lp: TLpHandle; column: integer): boolean; stdcall;
function is_free(lp: TLpHandle; column: integer): boolean; stdcall;
// Set the upper and lower bounds of a variable
procedure get_basis(lp: TLpHandle; bascolumn: PIntArray; nonbasic: boolean); stdcall;
// Set/Get basis for a re-solved system - Added by KE
procedure put_abortfunc(lp: TLpHandle; newctrlc: ctrlcfunc; ctrlchandle: Pointer); stdcall;
// Allow the user to define an interruption callback function
procedure put_logfunc(lp: TLpHandle; newlog: logfunc; loghandle: Pointer); stdcall;
// Allow the user to define a logging function
procedure put_msgfunc(lp: TLpHandle; newmsg: msgfunc; msghandle: Pointer; mask: integer); stdcall;
// Allow the user to define an event-driven message/reporting
procedure set_presolve(lp: TLpHandle; do_presolve: integer); stdcall;
{$ENDIF}

implementation

const
{$IFDEF UNIX}
  {$IFDEF LPS51}
    LPSOLVELIB = 'liblpsolve51.so';
  {$ENDIF}
  {$IFDEF LPS55}
    LPSOLVELIB = 'liblpsolve55.so';
  {$ENDIF}
{$ELSE}
  {$IFDEF LPS51}
    LPSOLVELIB = 'lpsolve51.dll';
  {$ENDIF}
  {$IFDEF LPS55}
    LPSOLVELIB = 'lpsolve55.dll';
  {$ENDIF}
{$ENDIF}

procedure lp_solve_version(majorversion: Pinteger; minorversion: Pinteger; release: Pinteger; build: Pinteger); stdcall; external LPSOLVELIB name 'lp_solve_version';
function make_lp(rows: integer; columns: integer): TLpHandle; stdcall; external LPSOLVELIB name 'make_lp';
function resize_lp(lp: TLpHandle; rows: integer; columns: integer): boolean; stdcall; external LPSOLVELIB name 'resize_lp';
function get_statustext(lp: TLpHandle; statuscode: integer): PAnsiChar; stdcall; external LPSOLVELIB name 'get_statustext';
procedure delete_lp(lp: TLpHandle); stdcall; external LPSOLVELIB name 'delete_lp';
procedure free_lp(var plp: TLpHandle); stdcall; external LPSOLVELIB name 'free_lp';
function set_lp_name(lp: TLpHandle; lpname: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'set_lp_name';
function get_lp_name(lp: TLpHandle): PAnsiChar; stdcall; external LPSOLVELIB name 'get_lp_name';
function has_BFP(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'has_BFP';
function is_nativeBFP(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_nativeBFP';
function set_BFP(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'set_BFP';
function read_XLI(xliname, modelname, dataname, options: PAnsiChar; verbose: integer): TLpHandle; stdcall; external LPSOLVELIB name 'read_XLI';
function write_XLI(lp: TLpHandle; filename, options: PAnsiChar; results: boolean): boolean; stdcall; external LPSOLVELIB name 'write_XLI';
function has_XLI(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'has_XLI';
function is_nativeXLI(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_nativeXLI';
function set_XLI(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'set_XLI';
function set_obj(lp: TLpHandle; Column: integer; Value: double): boolean; stdcall; external LPSOLVELIB name 'set_obj';
function set_obj_fn(lp: TLpHandle; row: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'set_obj_fn';
function set_obj_fnex(lp: TLpHandle; count: integer; row: PFloatArray; colno: PIntArray): boolean; stdcall; external LPSOLVELIB name 'set_obj_fnex';
function str_set_obj_fn(lp: TLpHandle; row_string: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'str_set_obj_fn';
procedure set_sense(lp: TLpHandle; maximize: boolean); stdcall; external LPSOLVELIB name 'set_sense';
procedure set_maxim(lp: TLpHandle); stdcall; external LPSOLVELIB name 'set_maxim';
procedure set_minim(lp: TLpHandle); stdcall; external LPSOLVELIB name 'set_minim';
function is_maxim(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_maxim';
function add_constraint(lp: TLpHandle; row: PFloatArray; constr_type: integer; rh: double): boolean; stdcall; external LPSOLVELIB name 'add_constraint';
function add_constraintex(lp: TLpHandle; count: integer; row: PFloatArray; colno: PIntArray; constr_type: integer; rh: double): boolean; stdcall; external LPSOLVELIB name 'add_constraintex';
function set_add_rowmode(lp: TLpHandle; turnon: boolean): boolean; stdcall; external LPSOLVELIB name 'set_add_rowmode';
function is_add_rowmode(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_add_rowmode';
function str_add_constraint(lp: TLpHandle; row_string : PAnsiChar;constr_type: integer; rh: double): boolean; stdcall; external LPSOLVELIB name 'str_add_constraint';
function get_row(lp: TLpHandle; row_nr: integer; row: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_row';
function del_constraint(lp: TLpHandle; del_row: integer): boolean; stdcall; external LPSOLVELIB name 'del_constraint';
function add_lag_con(lp: TLpHandle; row: PFloatArray; con_type: integer; rhs: double): boolean; stdcall; external LPSOLVELIB name 'add_lag_con';
function str_add_lag_con(lp: TLpHandle; row_string: PAnsiChar; con_type: integer; rhs: double): boolean; stdcall; external LPSOLVELIB name 'str_add_lag_con';
procedure set_lag_trace(lp: TLpHandle; lag_trace: boolean); stdcall; external LPSOLVELIB name 'set_lag_trace';
function is_lag_trace(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_lag_trace';
function set_constr_type(lp: TLpHandle; row: integer; con_type: integer): boolean; stdcall; external LPSOLVELIB name 'set_constr_type';
function get_constr_type(lp: TLpHandle; row: integer): integer; stdcall; external LPSOLVELIB name 'get_constr_type';
function is_constr_type(lp: TLpHandle; row: integer; mask: integer): boolean; stdcall; external LPSOLVELIB name 'is_constr_type';
function set_rh(lp: TLpHandle; row: integer; value: double): boolean; stdcall; external LPSOLVELIB name 'set_rh';
function get_rh(lp: TLpHandle; row: integer): double; stdcall; external LPSOLVELIB name 'get_rh';
function set_rh_range(lp: TLpHandle; row: integer; deltavalue: double): boolean; stdcall; external LPSOLVELIB name 'set_rh_range';
function get_rh_range(lp: TLpHandle; row: integer): double; stdcall; external LPSOLVELIB name 'get_rh_range';
procedure set_rh_vec(lp: TLpHandle; rh: PFloatArray); stdcall; external LPSOLVELIB name 'set_rh_vec';
function str_set_rh_vec(lp: TLpHandle; rh_string: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'str_set_rh_vec';
function add_column(lp: TLpHandle; column: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'add_column';
function add_columnex(lp: TLpHandle; count: integer; column: PFloatArray; rowno: PIntArray): boolean; stdcall; external LPSOLVELIB name 'add_columnex';
function str_add_column(lp: TLpHandle; col_string: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'str_add_column';
function column_in_lp(lp: TLpHandle; column: PFloatArray): integer; stdcall; external LPSOLVELIB name 'column_in_lp';
function get_column(lp: TLpHandle; col_nr: integer; column: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_column';
function del_column(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'del_column';
function set_mat(lp: TLpHandle; row: integer; column: integer; value: double): boolean; stdcall; external LPSOLVELIB name 'set_mat';
function get_mat(lp: TLpHandle; row: integer; column: integer): double; stdcall; external LPSOLVELIB name 'get_mat';
function get_mat_byindex(lp: TLpHandle; matindex: Integer; isrow, adjustsign: boolean): double; stdcall; external LPSOLVELIB name 'get_mat_byindex';
procedure set_bounds_tighter(lp: TLpHandle; tighten: boolean); stdcall; external LPSOLVELIB name 'set_bounds_tighter';
function get_bounds_tighter(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'get_bounds_tighter';
function set_upbo(lp: TLpHandle; column: integer; value: double): boolean; stdcall; external LPSOLVELIB name 'set_upbo';
function get_upbo(lp: TLpHandle; column: integer): double; stdcall; external LPSOLVELIB name 'get_upbo';
function set_lowbo(lp: TLpHandle; column: integer; value: double): boolean; stdcall; external LPSOLVELIB name 'set_lowbo';
function get_lowbo(lp: TLpHandle; column: integer): double; stdcall; external LPSOLVELIB name 'get_lowbo';
function set_bounds(lp: TLpHandle; column: integer; lower: double; upper: double): boolean; stdcall; external LPSOLVELIB name 'set_bounds';
//function get_bounds(lp: TLpHandle; column: Integer; lower, upper: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_bounds';
function set_int(lp: TLpHandle; column: integer; must_be_int: boolean): boolean; stdcall; external LPSOLVELIB name 'set_int';
function is_int(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'is_int';
function set_binary(lp: TLpHandle; column: integer; must_be_bin: boolean): boolean; stdcall; external LPSOLVELIB name 'set_binary';
function is_binary(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'is_binary';
function set_semicont(lp: TLpHandle; column: integer; must_be_sc: boolean): boolean; stdcall; external LPSOLVELIB name 'set_semicont';
function is_semicont(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'is_semicont';
function is_negative(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'is_negative';
function set_var_weights(lp: TLpHandle; weights: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'set_var_weights';
function get_var_priority(lp: TLpHandle; column: integer): integer; stdcall; external LPSOLVELIB name 'get_var_priority';
function add_SOS(lp: TLpHandle; name: PAnsiChar; sostype: integer; priority: integer; count: integer; sosvars: PIntArray; weights: PFloatArray): integer; stdcall; external LPSOLVELIB name 'add_SOS';
function is_SOS_var(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'is_SOS_var';
function set_row_name(lp: TLpHandle; row: integer; new_name: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'set_row_name';
function get_row_name(lp: TLpHandle; row: integer): PAnsiChar; stdcall; external LPSOLVELIB name 'get_row_name';
function get_origrow_name(lp: TLpHandle; row: integer): PAnsiChar; stdcall; external LPSOLVELIB name 'get_origrow_name';
function set_col_name(lp: TLpHandle; column: integer; new_name: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'set_col_name';
function get_col_name(lp: TLpHandle; column: integer): PAnsiChar; stdcall; external LPSOLVELIB name 'get_col_name';
function get_origcol_name(lp: TLpHandle; column: integer): PAnsiChar; stdcall; external LPSOLVELIB name 'get_origcol_name';
procedure unscale(lp: TLpHandle); stdcall; external LPSOLVELIB name 'unscale';
procedure set_preferdual(lp: TLpHandle; dodual: boolean); stdcall; external LPSOLVELIB name 'set_preferdual';
procedure set_simplextype(lp: TLpHandle; simplextype: integer); stdcall; external LPSOLVELIB name 'set_simplextype';
function get_simplextype(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_simplextype';
procedure default_basis(lp: TLpHandle); stdcall; external LPSOLVELIB name 'default_basis';
procedure set_basiscrash(lp: TLpHandle; mode: integer); stdcall; external LPSOLVELIB name 'set_basiscrash';
function get_basiscrash(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_basiscrash';
function set_basis(lp: TLpHandle; bascolumn: PIntArray; nonbasic: boolean): boolean; stdcall; external LPSOLVELIB name 'set_basis';
function is_feasible(lp: TLpHandle; values: PFloatArray; threshold: double): boolean; stdcall; external LPSOLVELIB name 'is_feasible';
function solve(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'solve';
function time_elapsed(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'time_elapsed';
function get_primal_solution(lp: TLpHandle; pv: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_primal_solution';
function get_ptr_primal_solution(lp: TLpHandle; var pv: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_primal_solution';
function get_dual_solution(lp: TLpHandle; rc: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_dual_solution';
function get_ptr_dual_solution(lp: TLpHandle; var rc: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_dual_solution';
function get_lambda(lp: TLpHandle; lambda: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_lambda';
function get_ptr_lambda(lp: TLpHandle; var lambda: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_lambda';
procedure reset_basis(lp: TLpHandle); stdcall; external LPSOLVELIB name 'reset_basis';
function read_MPS(filename: PAnsiChar; options: integer): TLpHandle; stdcall; external LPSOLVELIB name 'read_MPS';
function read_mps(stream: PInteger; options: integer): TLpHandle; stdcall; external LPSOLVELIB name 'read_mps';
function read_freeMPS(filename: PAnsiChar; options: Integer): TLpHandle; stdcall; external LPSOLVELIB name 'read_freeMPS';
function read_freemps(filename: Pinteger; options: Integer): TLpHandle; stdcall; external LPSOLVELIB name 'read_freemps';
function write_freemps(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'write_freemps';
function write_freeMPS(lp: TLpHandle; output: PInteger): boolean; stdcall; external LPSOLVELIB name 'write_freeMPS';
function guess_basis(lp: TLpHandle; guessvector: PFloatArray; basisvector: PIntArray): boolean; stdcall; external LPSOLVELIB name 'guess_basis';
function read_basis(lp: TLpHandle; filename, info: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'read_basis';
function write_basis(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'write_basis';
function write_mps(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'write_mps';
function write_MPS(lp: TLpHandle; output: PInteger): boolean; stdcall; external LPSOLVELIB name 'write_MPS';
function write_lp(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'write_lp';
function write_LP(lp: TLpHandle; filename: PInteger): boolean; stdcall; external LPSOLVELIB name 'write_LP';
function read_lp(filename: PInteger; verbose: integer; lp_name: PAnsiChar): TLpHandle; stdcall; external LPSOLVELIB name 'read_lp';
function read_LP(filename: PAnsiChar; verbose: integer; lp_name: PAnsiChar): TLpHandle; stdcall; external LPSOLVELIB name 'read_LP';
procedure print_lp(lp: TLpHandle); stdcall; external LPSOLVELIB name 'print_lp';
procedure print_tableau(lp: TLpHandle); stdcall; external LPSOLVELIB name 'print_tableau';
procedure print_objective(lp: TLpHandle); stdcall; external LPSOLVELIB name 'print_objective';
procedure print_solution(lp: TLpHandle; columns: integer); stdcall; external LPSOLVELIB name 'print_solution';
procedure print_constraints(lp: TLpHandle; columns: integer); stdcall; external LPSOLVELIB name 'print_constraints';
procedure print_duals(lp: TLpHandle); stdcall; external LPSOLVELIB name 'print_duals';
procedure print_scales(lp: TLpHandle); stdcall; external LPSOLVELIB name 'print_scales';
procedure print_str(lp: TLpHandle; str: PAnsiChar); stdcall; external LPSOLVELIB name 'print_str';
procedure set_outputstream(lp: TLpHandle; stream: Pointer); stdcall; external LPSOLVELIB name 'set_outputstream';
function set_outputfile(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'set_outputfile';
procedure set_verbose(lp: TLpHandle; verbose: integer); stdcall; external LPSOLVELIB name 'set_verbose';
function get_verbose(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_verbose';
procedure set_timeout(lp: TLpHandle; sectimeout: integer); stdcall; external LPSOLVELIB name 'set_timeout';
function get_timeout(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_timeout';
procedure set_print_sol(lp: TLpHandle; print_sol: integer); stdcall; external LPSOLVELIB name 'set_print_sol';
function get_print_sol(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_print_sol';
procedure set_debug(lp: TLpHandle; debug: boolean); stdcall; external LPSOLVELIB name 'set_debug';
function is_debug(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_debug';
procedure set_trace(lp: TLpHandle; trace: boolean); stdcall; external LPSOLVELIB name 'set_trace';
function is_trace(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_trace';
function print_debugdump(lp: TLpHandle; filename: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'print_debugdump';
procedure set_anti_degen(lp: TLpHandle; anti_degen: integer); stdcall; external LPSOLVELIB name 'set_anti_degen';
function get_anti_degen(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_anti_degen';
function is_anti_degen(lp: TLpHandle; testmask: integer): boolean; stdcall; external LPSOLVELIB name 'is_anti_degen';
function get_presolve(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_presolve';
function is_presolve(lp: TLpHandle; testmask: integer): boolean; stdcall; external LPSOLVELIB name 'is_presolve';
function get_orig_index(lp: TLpHandle; lp_index: integer): integer; stdcall; external LPSOLVELIB name 'get_orig_index';
function get_lp_index(lp: TLpHandle; orig_index: integer): integer; stdcall; external LPSOLVELIB name 'get_lp_index';
procedure set_maxpivot(lp: TLpHandle; max_num_inv: integer); stdcall; external LPSOLVELIB name 'set_maxpivot';
function get_maxpivot(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_maxpivot';
procedure set_obj_bound(lp: TLpHandle; obj_bound: double); stdcall; external LPSOLVELIB name 'set_obj_bound';
function get_obj_bound(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_obj_bound';
procedure set_mip_gap(lp: TLpHandle; absolute: boolean; mip_gap: double); stdcall; external LPSOLVELIB name 'set_mip_gap';
function get_mip_gap(lp: TLpHandle; absolute: boolean): double; stdcall; external LPSOLVELIB name 'get_mip_gap';
procedure set_bb_rule(lp: TLpHandle; bb_rule: integer); stdcall; external LPSOLVELIB name 'set_bb_rule';
function get_bb_rule(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_bb_rule';
function set_var_branch(lp: TLpHandle; column: integer; branch_mode: integer): boolean; stdcall; external LPSOLVELIB name 'set_var_branch';
function get_var_branch(lp: TLpHandle; column: integer): integer; stdcall; external LPSOLVELIB name 'get_var_branch';
procedure set_infinite(lp: TLpHandle; infinite: double); stdcall; external LPSOLVELIB name 'set_infinite';
function get_infinite(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_infinite';
procedure set_epsint(lp: TLpHandle; epsilon: double); stdcall; external LPSOLVELIB name 'set_epsint';
function get_epsint(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_epsint';
procedure set_epsb(lp: TLpHandle; epsb: double); stdcall; external LPSOLVELIB name 'set_epsb';
function get_epsb(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_epsb';
procedure set_epsd(lp: TLpHandle; epsd: double); stdcall; external LPSOLVELIB name 'set_epsd';
function get_epsd(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_epsd';
procedure set_epsel(lp: TLpHandle; epsel: double); stdcall; external LPSOLVELIB name 'set_epsel';
function get_epsel(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_epsel';
procedure set_scaling(lp: TLpHandle; scalemode: integer); stdcall; external LPSOLVELIB name 'set_scaling';
function get_scaling(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_scaling';
function is_scalemode(lp: TLpHandle; testmask: integer): boolean; stdcall; external LPSOLVELIB name 'is_scalemode';
function is_scaletype(lp: TLpHandle; scaletype: integer): boolean; stdcall; external LPSOLVELIB name 'is_scaletype';
function is_integerscaling(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_integerscaling';
procedure set_scalelimit(lp: TLpHandle; scalelimit: double); stdcall; external LPSOLVELIB name 'set_scalelimit';
function get_scalelimit(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_scalelimit';
procedure set_improve(lp: TLpHandle; improve: integer); stdcall; external LPSOLVELIB name 'set_improve';
function get_improve(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_improve';
procedure set_pivoting(lp: TLpHandle; piv_rule: integer); stdcall; external LPSOLVELIB name 'set_pivoting';
function get_pivoting(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_pivoting';
function is_piv_mode(lp: TLpHandle; testmask: integer): boolean; stdcall; external LPSOLVELIB name 'is_piv_mode';
function is_piv_rule(lp: TLpHandle; rule: integer): boolean; stdcall; external LPSOLVELIB name 'is_piv_rule';
procedure set_break_at_first(lp: TLpHandle; break_at_first: boolean); stdcall; external LPSOLVELIB name 'set_break_at_first';
function is_break_at_first(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_break_at_first';
procedure set_bb_floorfirst(lp: TLpHandle; bb_floorfirst: integer); stdcall; external LPSOLVELIB name 'set_bb_floorfirst';
function get_bb_floorfirst(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_bb_floorfirst';
procedure set_bb_depthlimit(lp: TLpHandle; bb_maxlevel: integer); stdcall; external LPSOLVELIB name 'set_bb_depthlimit';
function get_bb_depthlimit(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_bb_depthlimit';
procedure set_break_at_value(lp: TLpHandle; break_at_value: double); stdcall; external LPSOLVELIB name 'set_break_at_value';
function get_break_at_value(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_break_at_value';
procedure set_negrange(lp: TLpHandle; negrange: double); stdcall; external LPSOLVELIB name 'set_negrange';
function get_negrange(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_negrange';
procedure set_epsperturb(lp: TLpHandle; epsperturb: double); stdcall; external LPSOLVELIB name 'set_epsperturb';
function get_epsperturb(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_epsperturb';
procedure set_epspivot(lp: TLpHandle; epspivot: double); stdcall; external LPSOLVELIB name 'set_epspivot';
function get_epspivot(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_epspivot';
function get_max_level(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_max_level';
function get_total_nodes(lp: TLpHandle): COUNTER; stdcall; external LPSOLVELIB name 'get_total_nodes';
function get_total_iter(lp: TLpHandle): COUNTER; stdcall; external LPSOLVELIB name 'get_total_iter';
function get_objective(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_objective';
function get_working_objective(lp: TLpHandle): double; stdcall; external LPSOLVELIB name 'get_working_objective';
function get_var_primalresult(lp: TLpHandle; index: integer): double; stdcall; external LPSOLVELIB name 'get_var_primalresult';
function get_var_dualresult(lp: TLpHandle; index: integer): double; stdcall; external LPSOLVELIB name 'get_var_dualresult';
function get_variables(lp: TLpHandle; var_: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_variables';
function get_ptr_variables(lp: TLpHandle; var var_: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_variables';
function get_constraints(lp: TLpHandle; constr: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_constraints';
function get_ptr_constraints(lp: TLpHandle; var constr: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_constraints';
function get_sensitivity_rhs(lp: TLpHandle; duals, dualsfrom, dualstill: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_sensitivity_rhs';
function get_ptr_sensitivity_rhs(lp: TLpHandle; var duals, dualsfrom, dualstill: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_sensitivity_rhs';
function get_sensitivity_obj(lp: TLpHandle; objfrom, objtill: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_sensitivity_obj';
function get_ptr_sensitivity_obj(lp: TLpHandle; var objfrom, objtill: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_sensitivity_obj';
procedure set_solutionlimit(lp: TLpHandle; limit: integer); stdcall; external LPSOLVELIB name 'set_solutionlimit';
function get_solutionlimit(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_solutionlimit';
function get_solutioncount(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_solutioncount';
function get_Norig_rows(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_Norig_rows';
function get_Nrows(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_Nrows';
function get_Lrows(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_Lrows';
function get_Norig_columns(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_Norig_columns';
function get_Ncolumns(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_Ncolumns';

function get_nonzeros(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_nonzeros';
function get_status(lp: TLpHandle): integer; stdcall; external LPSOLVELIB name 'get_status';
function is_infinite(lp: TLpHandle; value: double): boolean; stdcall; external LPSOLVELIB name 'is_infinite';
function set_column(lp: TLpHandle; col_no: Integer; column: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'set_column';
function set_columnex(lp: TLpHandle; col_no, count: Integer; column: PFloatArray; rowno: PIntArray): boolean; stdcall; external LPSOLVELIB name 'set_columnex';
function set_row(lp: TLpHandle; row_no: Integer; row: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'set_row';
function set_rowex(lp: TLpHandle; row_no, count: Integer; row: PFloatArray; colno: PIntArray): boolean; stdcall; external LPSOLVELIB name 'set_rowex';
function get_ptr_sensitivity_objex(lp: TLpHandle; var objfrom, objtill, objfromvalue, objtillvalue: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_ptr_sensitivity_objex';
function get_sensitivity_objex(lp: TLpHandle; objfrom, objtill, objfromvalue, objtillvalue: PFloatArray): boolean; stdcall; external LPSOLVELIB name 'get_sensitivity_objex';
function get_nameindex(lp: TLpHandle; varname: PAnsiChar; isrow: boolean): Integer; stdcall; external LPSOLVELIB name 'get_nameindex';
function set_partialprice(lp: TLpHandle; blockcount: Integer; blockstart: PIntArray; isrow: boolean): boolean; stdcall; external LPSOLVELIB name 'set_partialprice';
procedure get_partialprice(lp: TLpHandle; blockcount: PIntArray; blockstart: PIntArray; isrow: boolean); stdcall; external LPSOLVELIB name 'get_partialprice';
function set_multiprice(lp: TLpHandle; multiblockdiv: Integer): boolean; stdcall; external LPSOLVELIB name 'set_multiprice';
function get_multiprice(lp: TLpHandle; getabssize: boolean): Integer; stdcall; external LPSOLVELIB name 'get_multiprice';

{$IFDEF LPS55_UP}
function copy_lp(lp: TLpHandle): TLpHandle; stdcall; external LPSOLVELIB name 'copy_lp';
function dualize_lp(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'dualize_lp';
function get_columnex(lp: TLpHandle; colnr: Integer; column: PFloatArray; nzrow: PIntArray): Integer; stdcall; external LPSOLVELIB name 'get_columnex';
function get_constr_value(lp: TLpHandle; rownr, count: Integer; primsolution: PFloatArray; nzindex: PIntArray): double; stdcall; external LPSOLVELIB name 'get_constr_value';
function set_unbounded(lp: TLpHandle; colnr: Integer): boolean; stdcall; external LPSOLVELIB name 'set_unbounded';
function is_unbounded(lp: TLpHandle; colnr: Integer): boolean; stdcall; external LPSOLVELIB name 'is_unbounded';
function get_basis(lp: TLpHandle; bascolumn: PIntArray; nonbasic: boolean): boolean; stdcall; external LPSOLVELIB name 'get_basis';
function set_basisvar(lp: TLpHandle; basisPos, enteringCol: Integer): Integer; stdcall; external LPSOLVELIB name 'set_basisvar';
procedure put_bb_nodefunc(lp: TLpHandle; newnode: lphandleint_intfunc; bbnodehandle: Pointer); stdcall; external LPSOLVELIB name 'put_bb_nodefunc';
procedure put_bb_branchfunc(lp: TLpHandle; newbranch: lphandleint_intfunc; bbbranchhandle: Pointer); stdcall; external LPSOLVELIB name 'put_bb_branchfunc';
function write_params(lp: TLpHandle; filename, options: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'write_params';
function read_params(lp: TLpHandle; filename, options: PAnsiChar): boolean; stdcall; external LPSOLVELIB name 'read_params';
procedure reset_params(lp: TLpHandle); stdcall; external LPSOLVELIB name 'reset_params';
function set_epslevel(lp: TLpHandle; epslevel: Integer): boolean; stdcall; external LPSOLVELIB name 'set_epslevel';
function set_pseudocosts(lp: TLpHandle; clower: PFloatArray; cupper: PFloatArray; updatelimit: PIntArray): boolean; stdcall; external LPSOLVELIB name 'set_pseudocosts';
function get_pseudocosts(lp: TLpHandle; clower: PFloatArray; cupper: PFloatArray; updatelimit: PIntArray): boolean; stdcall; external LPSOLVELIB name 'get_pseudocosts';
procedure set_presolve(lp: TLpHandle; presolvemode, maxloops: Integer); stdcall; external LPSOLVELIB name 'set_presolve';
function get_presolveloops(lp: TLpHandle): Integer; stdcall; external LPSOLVELIB name 'get_presolveloops';
procedure put_abortfunc(lp: TLpHandle; newctrlc: lphandle_intfunc; ctrlchandle: Pointer); stdcall; external LPSOLVELIB name 'put_abortfunc';
procedure put_logfunc(lp: TLpHandle; newlog: lphandlestr_func; loghandle: Pointer); stdcall; external LPSOLVELIB name 'put_logfunc';
procedure put_msgfunc(lp: TLpHandle; newmsg: lphandleint_func; msghandle: Pointer; mask: integer); stdcall; external LPSOLVELIB name 'put_msgfunc';
function get_rowex(lp: TLpHandle; rownr: Integer; row: PFloatArray; colno: PIntArray): integer; stdcall; external LPSOLVELIB name 'get_rowex';
function is_use_names(lp: TLpHandle; isrow: boolean): boolean; stdcall; external LPSOLVELIB name 'is_use_names';
procedure set_use_names(lp: TLpHandle; isrow, use_names: boolean); stdcall; external LPSOLVELIB name 'set_use_names';
function is_obj_in_basis(lp: TLpHandle): boolean; stdcall; external LPSOLVELIB name 'is_obj_in_basis';
procedure set_obj_in_basis(lp: TLpHandle; obj_in_basis: boolean); stdcall; external LPSOLVELIB name 'set_obj_in_basis';
{$ELSE}
function set_free(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'set_free';
function is_free(lp: TLpHandle; column: integer): boolean; stdcall; external LPSOLVELIB name 'is_free';
procedure set_presolve(lp: TLpHandle; do_presolve: integer); stdcall; external LPSOLVELIB name 'set_presolve';
procedure put_abortfunc(lp: TLpHandle; newctrlc: ctrlcfunc; ctrlchandle: Pointer); stdcall; external LPSOLVELIB name 'put_abortfunc';
procedure put_logfunc(lp: TLpHandle; newlog: logfunc; loghandle: Pointer); stdcall; external LPSOLVELIB name 'put_logfunc';
procedure put_msgfunc(lp: TLpHandle; newmsg: msgfunc; msghandle: Pointer; mask: integer); stdcall; external LPSOLVELIB name 'put_msgfunc';
procedure get_basis(lp: TLpHandle; bascolumn: PIntArray; nonbasic: boolean); stdcall; external LPSOLVELIB name 'get_basis';
{$ENDIF}

end.


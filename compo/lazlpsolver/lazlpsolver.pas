{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lazlpsolver;

{$warn 5023 off : no warning about unused units}
interface

uses
  LpObject, LpSolve, LPSynEdit, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('LpObject', @LpObject.Register);
  RegisterUnit('LPSynEdit', @LPSynEdit.Register);
end;

initialization
  RegisterPackage('lazlpsolver', @Register);
end.

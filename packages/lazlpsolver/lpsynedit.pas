unit LPSynEdit;

{$MODE DELPHI}

interface

uses
  Classes, SysUtils, Controls, SynEdit, Graphics;

type

  TLPSynEdit = class(TSynEdit)
  private
    FColEdgeColor: TColor;
    FEnableMPS: Boolean;
    procedure SetColEdgeColor(aValue: TColor);
    procedure SetEnableMPS(Value: Boolean);
  protected
    procedure Paint; override;
  public
    constructor Create(aOwner: TComponent); override;
    property EnableMPS: Boolean read FEnableMPS write SetEnableMPS;
  published
    property ColEdgeColor: TColor read FColEdgeColor write SetColEdgeColor default $00E0E0E0;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LP Solver', [TLPSynedit]);
end;

{ TLPSynedit }

procedure TLPSynEdit.Paint;
var
  AClip: TRect;
  nRightEdge, fTextOffSet, I: Integer;
const
  cols: array[0..11] of Integer = (1,3,4,12,14,22,24,36,39,47,49,61);
begin
  inherited;
  if EnableMPS and not (csDesigning in ComponentState) then
    begin
      AClip := Canvas.ClipRect;
      fTextOffset := Gutter.Width + 2 - (LeftChar - 1) * CharWidth;
      for I in cols do
        begin
          nRightEdge := fTextOffset + I * CharWidth; // pixel value
          if (nRightEdge >= AClip.Left) and (nRightEdge <= AClip.Right) then
            begin
              Canvas.Pen.Color := ColEdgeColor;
              Canvas.Pen.Width := 1;
              Canvas.MoveTo(nRightEdge, AClip.Top);
              Canvas.LineTo(nRightEdge, AClip.Bottom + 1);
            end;
        end;
    end;
end;

constructor TLPSynEdit.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FColEdgeColor := $00E0E0E0;
end;

procedure TLPSynEdit.SetEnableMPS(Value: Boolean);
begin
  if FEnableMPS <> Value then
    begin
      FEnableMPS := Value;
      if not (csDesigning in ComponentState) then
        Invalidate;
    end;
end;

procedure TLPSynEdit.SetColEdgeColor(aValue: TColor);
begin
  if FColEdgeColor = aValue then
    exit;
  FColEdgeColor := aValue;
  if EnableMPS and not (csDesigning in ComponentState) then
    Invalidate;
end;

end.

unit LPSynEdit;

{$MODE DELPHI}

interface

uses
  Classes, SysUtils, Controls, SynEdit, Graphics;

type
  TLPSynEdit = class(TSynEdit)
  private
    FEnableMPS: Boolean;
    procedure SetEnableMPS(Value: Boolean);
  protected
    //procedure PaintTextLines(AClip: TRect; const aFirstRow, aLastRow, FirstCol, LastCol: Integer); override;
    procedure PaintTextLines(Sender: TObject; ACanvas: TCanvas);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property EnableMPS: Boolean read FEnableMPS write SetEnableMPS;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LP Solver', [TLPSynedit]);
end;

{ TLPSynedit }

constructor TLPSynEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEnableMPS := False;
  OnPaint := PaintTextLines;
end;

//procedure TLPSynEdit.PaintTextLines(AClip: TRect; const aFirstRow, aLastRow, FirstCol, LastCol: integer);
procedure TLPSynEdit.PaintTextLines(Sender: TObject; ACanvas: TCanvas);
var
  AClip: TRect;
  nRightEdge, fTextOffSet, I: Integer;
const
  cols: array[0..11] of Integer = (1,3,4,12,14,22,24,36,39,47,49,61);
begin
  inherited;
  if csDesigning in ComponentState then
    exit;
  AClip := ACanvas.ClipRect;
  if FEnableMPS then
    begin
      fTextOffset := Gutter.Width + 2 - (LeftChar - 1) * CharWidth;
      for I := low(cols) to high(cols) do
        begin
          nRightEdge := fTextOffset + (cols[I]) * CharWidth; // pixel value
          if (nRightEdge >= AClip.Left) and (nRightEdge <= AClip.Right) then
            begin
              Canvas.Pen.Color := $00E0E0E0;
              Canvas.Pen.Width := 1;
              Canvas.MoveTo(nRightEdge, AClip.Top);
              Canvas.LineTo(nRightEdge, AClip.Bottom + 1);
            end;
        end;
    end;
end;

procedure TLPSynEdit.SetEnableMPS(Value: Boolean);
begin
  if FEnableMPS <> Value then
  begin
    FEnableMPS := Value;
    Invalidate;
  end;
end;

end.

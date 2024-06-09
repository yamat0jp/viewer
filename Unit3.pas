unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Ani;

type
  TForm3 = class(TForm)
    Image1: TImage;
    FloatAnimation1: TFloatAnimation;
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { private êÈåæ }
  public
    { public êÈåæ }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.FormHide(Sender: TObject);
begin
  FloatAnimation1.Stop;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  FloatAnimation1.Start;
end;

end.

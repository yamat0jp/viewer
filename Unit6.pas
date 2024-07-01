unit Unit6;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit;

type
  TForm6 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
  private
    { private êÈåæ }
    pwd: string;
  public
    { public êÈåæ }
  end;

var
  Form6: TForm6;

implementation

{$R *.fmx}

uses Unit4;

procedure TForm6.Edit1ChangeTracking(Sender: TObject);
begin
  if Edit1.Text = pwd then
    ModalResult:=mrOK;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
  pwd := DataModule4.pwd;
  Edit1.SetFocus;
end;

end.

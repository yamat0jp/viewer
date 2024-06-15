unit Unit5;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, System.IOUtils,
  FMX.Layouts, FMX.ListBox;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    ListBox1: TListBox;
    Label1: TLabel;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
  private
    { private �錾 }
  public
    { public �錾 }
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

uses Unit1;

procedure TForm5.Edit1ChangeTracking(Sender: TObject);
begin
  if (ListBox1.Count > 0) and (Form1.ImageList1.Source.IndexOf(Edit1.Text) = -1)
  then
  begin
    Edit1.TextSettings.FontColor := TAlphaColors.Black;
    Label1.Visible := false;
    Button1.Enabled := true;
  end
  else
  begin
    Edit1.TextSettings.FontColor := TAlphaColors.Red;
    Label1.Visible := true;
    Button1.Enabled := false;
  end;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  Edit1.Text := '';
  ListBox1.Items.Clear;
  Button1.Enabled := false;
end;

procedure TForm5.SpeedButton1Click(Sender: TObject);
var
  s: string;
begin
  if OpenDialog1.Execute then
  begin
    for var name in OpenDialog1.Files do
    begin
      s := LowerCase(ExtractFileExt(name));
      if (s = '.jpg') or (s = '.jpeg') then
        ListBox1.Items.Add(name);
    end;
    Edit1.Text := ChangeFileExt(ExtractFileName(ListBox1.Items[0]), '');
    Edit1ChangeTracking(nil);
  end;
end;

end.

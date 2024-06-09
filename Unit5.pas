unit Unit5;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Edit, System.IOUtils;

type
  TForm5 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private éŒ¾ }
  public
    { public éŒ¾ }
    FileList: TStringList;
  end;

var
  Form5: TForm5;

implementation

{$R *.fmx}

procedure TForm5.FormCreate(Sender: TObject);
begin
  FileList := TStringList.Create;
end;

procedure TForm5.FormDestroy(Sender: TObject);
begin
  FileList.Free;
end;

procedure TForm5.FormShow(Sender: TObject);
begin
  Edit1.Text := '';
  Button1.Enabled := false;
end;

procedure TForm5.SpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    FileList.Clear;
    for var name in OpenDialog1.Files do
      if TDirectory.Exists(name) then
      begin
        for var s in TDirectory.GetFiles(name, '*.jpg',
          TSearchOption.soAllDirectories) do
          FileList.Add(s);
      end
      else if LowerCase(ExtractFileExt(name)) = '.jpg' then
        FileList.Add(name);
    if FileList.Count > 0 then
    begin
      Edit1.Text := ChangeFileExt(ExtractFileName(FileList[0]), '');
      Button1.Enabled := true;
    end;
  end;
end;

end.

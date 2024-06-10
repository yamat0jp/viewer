unit Unit4;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBLiteDef, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Graphics, System.ZLib, System.Types, FMX.Objects;

type
  TDataModule4 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable2: TFDTable;
    FDConnection2: TFDConnection;
    FDTable2ID: TIntegerField;
    FDTable2NAME: TWideStringField;
    FDTable3: TFDTable;
    FDTable3STAY: TBooleanField;
    FDTable3PWD: TStringField;
    FDTable2FILE: TWideStringField;
    FDTable4: TFDTable;
    FDTable4DOUBLE: TBooleanField;
    FDTable4PAGE: TIntegerField;
    FDTable1PAGE: TIntegerField;
    FDTable1IMAGE: TBlobField;
    FDTable2JPEG: TBlobField;
    FDTable1SUB: TBooleanField;
    FDQuery2: TFDQuery;
    FDTable3INTERVAL: TFloatField;
    FDTable3REVERSE: TBooleanField;
    FDQuery1: TFDQuery;
    procedure FDTable1AfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function randomName: string;
    function resizeImg(img: TBitmap): TPoint;
    { Private êÈåæ }
  public
    { Public êÈåæ }
    image: TBitmap;
    function LoadAllFile: Boolean;
  end;

var
  DataModule4: TDataModule4;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Unit1, Unit5;
{$R *.dfm}

procedure TDataModule4.DataModuleCreate(Sender: TObject);
begin
  image := TBitmap.Create;
  if Assigned(Form1) then
    Form1.Action3Execute(Sender)
end;

procedure TDataModule4.DataModuleDestroy(Sender: TObject);
begin
  image.Free;
end;

procedure TDataModule4.FDTable1AfterScroll(DataSet: TDataSet);
const
  size = 100;
var
  st, zs: TStream;
begin
  if FDTable1.State = dsBrowse then
  begin
    st := FDTable1.CreateBlobStream(FDTable1.FieldByName('image'), bmRead);
    zs := TZDeCompressionStream.Create(st);
    try
      image.LoadFromStream(zs);
//      image.CreateThumbnail(size, size);
    finally
      st.Free;
      zs.Free;
    end;
  end;
end;

function TDataModule4.LoadAllFile: Boolean;
var
  id: integer;
  bmp, jpg: TBitmap;
  sub: Boolean;
  fn, nm: string;
  st, zs: TStream;
  rect: TRectF;
begin
  repeat
    fn := randomName;
  until not FDTable2.Locate('file', fn);
  FDConnection1.Close;
  FDConnection1.Params.Database := fn;
  FDConnection1.Open;
  FDQuery1.ExecSQL('CREATE TABLE MAIN("PAGE" INTEGER,IMAGE BLOB,SUB BOOLEAN);');
  FDQuery1.ExecSQL
    ('CREATE TABLE INFO("DOUBLE" BOOLEAN,"PAGE" INTEGER);');
  FDTable1.Open;
  FDTable4.Open;
  id := 1;
  jpg := TBitmap.Create;
  bmp := TBitmap.Create;
  try
    for var s in Form5.FileList do
    begin
      jpg.LoadFromFile(s);
      rect := RectF(0, 0, jpg.Width, jpg.Height);
      bmp.Width := jpg.Width;
      bmp.Height := jpg.Height;
      bmp.Canvas.BeginScene;
      bmp.Canvas.DrawBitmap(jpg, rect, rect, 1.0);
      bmp.Canvas.EndScene;
      sub := bmp.Width < bmp.Height;
      FDTable1.Append;
      st := FDTable1.CreateBlobStream(FDTable1.Fields[1], bmWrite);
      zs := TZCompressionStream.Create(clMax, st);
      try
        bmp.SaveToStream(zs);
        FDTable1.Fields[0].AsInteger := id;
        FDTable1.Fields[2].AsBoolean := sub;
      finally
        st.Free;
        zs.Free;
        FDTable1.Post;
      end;
      inc(id);
    end;
    result := Form5.FileList.Count > 0;
    if result then
    begin
      FDTable1.First;
      FDTable2.AppendRecord([id, nm, fn, image]);
    end;
  finally
    bmp.Free;
    jpg.Free;
    Form5.FileList.Clear;
  end;
end;

function TDataModule4.randomName: string;
begin
  Randomize;
  result := '';
  for var i := 1 to 5 do
    result := result + Random(10).ToString;
  result := ExtractFilePath(ParamStr(0)) + result + '.ib';
end;

function TDataModule4.resizeImg(img: TBitmap): TPoint;
var
  wid, hei, a, b, r: integer;
  sub: Boolean;
begin
  wid := img.Width;
  hei := img.Height;
  result := Point(0, 0);
  if not Assigned(img) then
    Exit;
  if wid > hei then
  begin
    a := wid;
    b := hei;
    sub := false;
  end
  else
  begin
    a := hei;
    b := wid;
    sub := true;
  end;
  while a div b > 1 do
  begin
    r := a mod b;
    a := b;
    b := r;
  end;
  if sub then
  begin
    result.X := b;
    result.Y := a;
  end
  else
  begin
    result.X := a;
    result.Y := b;
  end;
end;

end.

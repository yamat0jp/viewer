unit Unit4;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBLiteDef, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Graphics, System.ZLib, System.Types, FMX.Objects,
  System.Generics.Collections, System.Threading, FireDAC.Phys.IBDef;

type
  TMap = record
    Left, Right: integer;
  end;

  TDataModule4 = class(TDataModule)
    FDConnection1: TFDConnection;
    FDTable1: TFDTable;
    FDTable2: TFDTable;
    FDConnection2: TFDConnection;
    FDTable2ID: TIntegerField;
    FDTable2NAME: TWideStringField;
    FDTable2FILE: TWideStringField;
    FDTable1PAGE: TIntegerField;
    FDTable1IMAGE: TBlobField;
    FDTable2JPEG: TBlobField;
    FDTable1SUB: TBooleanField;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    FDTable2double: TBooleanField;
    FDTable2page: TIntegerField;
    FDTable2toppage: TBooleanField;
    procedure FDTable1AfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function randomName: string;
    { Private êÈåæ }
  public
    { Public êÈåæ }
    image: TBitmap;
    mapList: TList<TMap>;
    pwd: string;
    procedure map(toppage: Boolean);
    procedure selected(fname: string);
    function LoadAllFile: Boolean;
    function doublePage(index: integer): integer;
    function singlePage(index: integer; Left: Boolean = true): integer;
  end;

var
  DataModule4: TDataModule4;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses Unit1, Unit5, Thread;
{$R *.dfm}

procedure TDataModule4.DataModuleCreate(Sender: TObject);
begin
  mapList := TList<TMap>.Create;
  image := TBitmap.Create;
  FDConnection2.Params.Database := ExtractFilePath(ParamStr(0)) + 'LITE.IB';
  FDConnection2.Open;
  if not FDTable2.Exists then
    FDTable2.CreateTable(false);
  FDTable2.Open;
  if Assigned(Form1) then
  begin
    Form1.ScrollBox1.Repaint;
    Form1.CheckBox1.IsChecked := FDTable2.FieldByName('stay').AsBoolean;
    Form1.Timer1.Interval := 1000 * FDTable2.FieldByName('interval').AsInteger;
    Form1.SpinBox1.Value := Form1.SpinBox1.Value;
    Form1.RadioButton2.IsChecked := FDTable2.FieldByName('reverse').AsBoolean;
  end;
end;

procedure TDataModule4.DataModuleDestroy(Sender: TObject);

begin
  mapList.Free;
  image.Free;
  if Assigned(Form1) then
  begin
    FDTable2.Edit;
    FDTable2.FieldByName('stay').AsBoolean := Form1.CheckBox1.IsChecked;
    FDTable2.FieldByName('reverse').AsBoolean := Form1.RadioButton2.IsChecked;
    FDTable2.Post;
  end;
end;

function TDataModule4.doublePage(index: integer): integer;
begin
  result := 1;
  for var i := 0 to mapList.Count - 1 do
    if (mapList[i].Left = index) or (mapList[i].Right = index) then
    begin
      result := i + 1;
      break;
    end;
end;

procedure TDataModule4.FDTable1AfterScroll(DataSet: TDataSet);
var
  st, zs: TStream;
begin
  if FDTable1.State = dsBrowse then
  begin
    st := FDTable1.CreateBlobStream(FDTable1.FieldByName('image'), bmRead);
    zs := TZDeCompressionStream.Create(st);
    try
      image.LoadFromStream(zs);
    finally
      st.Free;
      zs.Free;
    end;
  end;
end;

function TDataModule4.LoadAllFile: Boolean;
var
  id: integer;
  fn, nm: string;
  jpg: TBitmap;
  DB, tp: Boolean;
begin
  result := Form5.ListBox1.Count > 0;
  if not result then
    Exit;
  repeat
    fn := randomName;
  until not FDTable2.Locate('file', fn);
  FDConnection1.Close;
  FDConnection1.Params.Database := fn;
  FDConnection1.Open;
  FDQuery1.ExecSQL('CREATE TABLE MAIN("PAGE" INTEGER,IMAGE BLOB,SUB BOOLEAN);');
  FDQuery1.ExecSQL
    ('CREATE TABLE INFO("DOUBLE" BOOLEAN,"PAGE" INTEGER, TOPPAGE BOOLEAN);');
  FDTable1.Open;
  FDQuery1.SQL.Text :=
    'insert into main("PAGE", image, sub) values(:page_id, :image, :subimage)';
  FDQuery1.Params.ArraySize := Form5.ListBox1.Count;
  TParallel.For(0, Form5.ListBox1.Count - 1,
    procedure(i: integer)
    var
      th: TMyThread;
    begin
      th := TMyThread.Create(Form5.ListBox1.Items[i]);
      FDQuery1.Params[0].AsIntegers[i] := i + 1;
      FDQuery1.Params[1].LoadFromStream(th.Stream, ftBlob, i);
      FDQuery1.Params[2].AsBooleans[i] := th.Sub;
      th.Free;
    end);
  FDQuery1.Execute(FDQuery1.Params.ArraySize);
  jpg := TBitmap.Create;
  try
    FDQuery2.Open('select max(id) from "TABLE";');
    id := FDQuery2.Fields[0].AsInteger + 1;
    jpg.LoadThumbnailFromFile(Form5.ListBox1.Items[0], 100, 100, false);
    nm := Form5.Edit1.Text;
    FDTable1.First;
    DB := Form1.SpeedButton2.IsPressed;
    tp := Form1.CheckBox2.IsChecked;
    FDTable2.AppendRecord([id, nm, fn, jpg, DB, 1, tp]);
  finally
    jpg.Free;
  end;
end;

procedure TDataModule4.map(toppage: Boolean);
var
  rec: TMap;
begin
  mapList.Clear;
  FDQuery1.Open('select "PAGE", sub from main;');
  rec.Left := 0;
  rec.Right := 0;
  if toppage then
  begin
    rec.Left := 1;
    mapList.Add(rec);
    rec.Left := 0;
    FDQuery1.Next;
  end;
  while not FDQuery1.Eof do
  begin
    if rec.Left = 0 then
      rec.Left := FDQuery1.Fields[0].AsInteger
    else
    begin
      if FDQuery1.Fields[1].AsBoolean then
        rec.Right := FDQuery1.Fields[0].AsInteger
      else
      begin
        mapList.Add(rec);
        rec.Left := FDQuery1.Fields[0].AsInteger;
      end;
      mapList.Add(rec);
      rec.Left := 0;
      rec.Right := 0;
      FDQuery1.Next;
      continue;
    end;
    if not FDQuery1.Fields[1].AsBoolean then
    begin
      mapList.Add(rec);
      rec.Left := 0;
    end;
    FDQuery1.Next;
  end;
  if rec.Left <> 0 then
    mapList.Add(rec);
  FDQuery1.Close;
end;

function TDataModule4.randomName: string;
begin
  Randomize;
  result := '';
  for var i := 1 to 5 do
    result := result + Random(10).ToString;
  result := ExtractFilePath(ParamStr(0)) + result + '.ib';
end;

procedure TDataModule4.selected(fname: string);
begin
  if FDTable2.Locate('name', fname) then
  begin
    FDConnection1.Close;
    FDConnection1.Params.Database := FDTable2.FieldByName('file').AsString;
    FDConnection1.Open;
    FDTable1.Open;
    FDTable1.Prepare;
    FDTable1.Locate('page', FDTable2.FieldByName('page').AsInteger);
    map(FDTable2.FieldByName('toppage').AsBoolean);
  end;
end;

function TDataModule4.singlePage(index: integer; Left: Boolean): integer;
begin
  if Left then
    result := mapList[index - 1].Left
  else
    result := mapList[index - 1].Right;
end;

end.

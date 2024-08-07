unit Unit4;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.IB,
  FireDAC.Phys.IBLiteDef, FireDAC.FMXUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FMX.Graphics, System.ZLib, System.Types, FMX.Objects,
  System.Generics.Collections, System.Threading, FireDAC.Phys.IBDef,
  System.Win.Registry;

type
  TMap = record
    Left, Right: integer;
  end;

  TDataModule4 = class(TDataModule)
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
    FDQuery2: TFDQuery;
    FDTable2double: TBooleanField;
    FDTable2page: TIntegerField;
    FDTable2toppage: TBooleanField;
    procedure FDTable1AfterScroll(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    function randomName: string;
    { Private �錾 }
  public
    { Public �錾 }
    image: TBitmap;
    mapList: TList<TMap>;
    pwd: string;
    procedure map(toppage: Boolean);
    function selected(fname: string): integer;
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
var
  ini: TRegistryIniFile;
  num: integer;
begin
  mapList := TList<TMap>.Create;
  image := TBitmap.Create;
  if not FDConnection2.Connected then
  begin
    FDConnection2.Params.Database := ExtractFilePath(ParamStr(0)) + 'LITE.IB';
    FDConnection2.Open;
  end;
  if not FDTable2.Exists then
    FDTable2.CreateTable(false);
  FDTable2.Open;
  if Assigned(Form1) then
  begin
    Form1.ScrollBox1.Repaint;
    ini := TRegistryIniFile.Create('Software\Viewer');
    try
      Form1.CheckBox1.IsChecked := ini.ReadBool('view', 'stay', false);
      num := ini.ReadInteger('view', 'interval', 10);
      Form1.Timer1.Interval := 1000 * num;
      Form1.SpinBox1.Value := num;
      Form1.RadioButton2.IsChecked := ini.ReadBool('view', 'reverse', false);
    finally
      ini.Free;
    end;
  end;
end;

procedure TDataModule4.DataModuleDestroy(Sender: TObject);
var
  ini: TRegistryIniFile;
begin
  mapList.Free;
  image.Free;
  if Assigned(Form1) then
  begin
    ini := TRegistryIniFile.Create('Software\Viewer');
    try
      ini.WriteBool('view', 'stay', Form1.CheckBox1.IsChecked);
      ini.WriteBool('view', 'reverse', Form1.RadioButton2.IsChecked);
      ini.WriteInteger('view', 'interval', Round(Form1.SpinBox1.Value));
    finally
      ini.Free;
    end;
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
  FDQuery2.ExecSQL
    (Format('CREATE TABLE %s("PAGE" INTEGER,IMAGE BLOB,SUB BOOLEAN);', [fn]));
  FDTable1.Close;
  FDTable1.TableName := fn;
  FDTable1.Open;
  FDQuery2.SQL.Text :=
    Format('insert into %s("PAGE", image, sub) values(:page_id, :image, :subimage)',
    [fn]);
  FDQuery2.Params.ArraySize := Form5.ListBox1.Count;
  TParallel.For(0, Form5.ListBox1.Count - 1,
    procedure(i: integer)
    var
      th: TMyThread;
    begin
      th := TMyThread.Create(Form5.ListBox1.Items[i]);
      FDQuery2.Params[0].AsIntegers[i] := i + 1;
      FDQuery2.Params[1].LoadFromStream(th.Stream, ftBlob, i);
      FDQuery2.Params[2].AsBooleans[i] := th.Sub;
      th.Free;
    end);
  FDQuery2.Execute(FDQuery2.Params.ArraySize);
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
  FDQuery2.Open('select "PAGE", sub from ' + FDTable2.FieldByName('file')
    .AsString);
  rec.Left := 0;
  rec.Right := 0;
  if toppage then
  begin
    rec.Left := 1;
    mapList.Add(rec);
    rec.Left := 0;
    FDQuery2.Next;
  end;
  while not FDQuery2.Eof do
  begin
    if rec.Left = 0 then
      rec.Left := FDQuery2.Fields[0].AsInteger
    else
    begin
      if FDQuery2.Fields[1].AsBoolean then
        rec.Right := FDQuery2.Fields[0].AsInteger
      else
      begin
        mapList.Add(rec);
        rec.Left := FDQuery2.Fields[0].AsInteger;
      end;
      mapList.Add(rec);
      rec.Left := 0;
      rec.Right := 0;
      FDQuery2.Next;
      continue;
    end;
    if not FDQuery2.Fields[1].AsBoolean then
    begin
      mapList.Add(rec);
      rec.Left := 0;
    end;
    FDQuery2.Next;
  end;
  if rec.Left <> 0 then
    mapList.Add(rec);
  FDQuery2.Close;
end;

function TDataModule4.randomName: string;
begin
  Randomize;
  result := '';
  for var i := 1 to 5 do
    result := result + Random(10).ToString;
  result := 'tb' + result;
end;

function TDataModule4.selected(fname: string): integer;
begin
  if FDTable2.Locate('name', fname) then
  begin
    FDTable1.Close;
    FDTable1.TableName := FDTable2.FieldByName('file').AsString;
    FDTable1.Open;
    FDTable1.Prepare;
    map(FDTable2.FieldByName('toppage').AsBoolean);
    result := FDTable2.FieldByName('id').AsInteger;
  end
  else
    result := 0;
end;

function TDataModule4.singlePage(index: integer; Left: Boolean): integer;
begin
  if Left then
    result := mapList[index - 1].Left
  else
    result := mapList[index - 1].Right;
end;

end.

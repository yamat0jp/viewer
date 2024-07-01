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
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, IniFiles, System.Variants;

type
  TMap = record
    Left, Right: integer;
  end;

  TDataModule4 = class(TDataModule)
    FDTable1: TFDTable;
    FDTable2: TFDTable;
    FDConnection2: TFDConnection;
    FDTable2ID: TIntegerField;
    FDTable1PAGE: TIntegerField;
    FDTable1IMAGE: TBlobField;
    FDTable2JPEG: TBlobField;
    FDQuery2: TFDQuery;
    FDTable1sub: TIntegerField;
    FDTable2page: TIntegerField;
    FDTable2double: TIntegerField;
    FDTable2toppage: TIntegerField;
    FDTable2name: TWideStringField;
    FDTable2file: TWideStringField;
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
var
  ini: TIniFile;
  num: integer;
begin
  mapList := TList<TMap>.Create;
  image := TBitmap.Create;
  FDConnection2.Params.Database := ExtractFilePath(ParamStr(0)) +
    'template.sdb';
  FDConnection2.Open;
  FDQuery2.ExecSQL
    ('create table if not exists "TABLE"(id integer, name varchar(255), file varchar(255), jpeg blob, "DOUBLE" integer, "PAGE" integer, toppage integer);');
  FDTable2.Open;
  if Assigned(Form1) then
  begin
    Form1.ScrollBox1.Repaint;
    ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'template.ini');
    try
      Form1.CheckBox1.IsChecked := ini.ReadBool('View', 'Stay', false);
      num := ini.ReadInteger('View', 'Interval', 10);
      Form1.Timer1.Interval := 1000 * num;
      Form1.SpinBox1.Value := num;
      Form1.RadioButton2.IsChecked := ini.ReadBool('View', 'Reverse', false);
    finally
      ini.Free;
    end;
  end;
end;

procedure TDataModule4.DataModuleDestroy(Sender: TObject);
var
  ini: TIniFile;
begin
  mapList.Free;
  image.Free;
  if Assigned(Form1) then
  begin
    ini := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'template.ini');
    try
      ini.WriteBool('View', 'Stay', Form1.CheckBox1.IsChecked);
      ini.WriteInteger('View', 'Interval', Round(Form1.SpinBox1.Value));
      ini.WriteBool('View', 'Reverse', Form1.RadioButton2.IsChecked);
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
  id, DB, toppage: integer;
  fn, nm: string;
  jpg: TBitmap;
begin
  result := Form5.ListBox1.Count > 0;
  if not result then
    Exit;
  repeat
    fn := randomName;
  until VarIsNull(FDTable2.Lookup('file', fn, 'name'));
  FDTable1.Close;
  FDTable1.TableName := fn;
  FDQuery2.ExecSQL
    (Format('CREATE TABLE %s("PAGE" INTEGER,IMAGE BLOB,SUB integer)', [fn]));
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
      if th.Sub then
        FDQuery2.Params[2].AsIntegers[i] := 1
      else
        FDQuery2.Params[2].AsIntegers[i] := 0;
      th.Free;
    end);
  FDQuery2.Execute(FDQuery2.Params.ArraySize);
  jpg := TBitmap.Create;
  try
    id := 1;
    FDQuery2.Open('select max(id) from "TABLE"');
    if FDTable2.RecordCount > 0 then
      inc(id, FDQuery2.Fields[0].AsInteger);
    jpg.LoadThumbnailFromFile(Form5.ListBox1.Items[0], 100, 100, false);
    nm := Form5.Edit1.Text;
    if Form1.SpeedButton2.IsPressed then
      DB := 1
    else
      DB := 0;
    if Form1.CheckBox2.IsChecked then
      toppage := 1
    else
      toppage := 0;
    FDTable2.AppendRecord([id, nm, fn, jpg, DB, 1, toppage]);
  finally
    jpg.Free;
  end;
end;

procedure TDataModule4.map(toppage: Boolean);
var
  rec: TMap;
begin
  mapList.Clear;
  FDQuery2.Open('select "PAGE", sub from main;');
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
      if FDQuery2.Fields[1].AsInteger = 1 then
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
    if FDQuery2.Fields[1].AsInteger = 0 then
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

procedure TDataModule4.selected(fname: string);
var
  bool: Boolean;
begin
  if FDTable2.Locate('name', fname) then
  begin
    FDTable1.TableName := FDTable2.FieldByName('file').AsString;
    FDTable1.CreateTable;
    FDTable1.Open;
    FDTable1.Prepare;
    FDTable1.Locate('page', FDTable2.FieldByName('page').AsInteger);
    bool := FDTable2.FieldByName('toppage').AsInteger = 1;
    map(bool);
    Form1.CheckBox2.IsChecked := bool;
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

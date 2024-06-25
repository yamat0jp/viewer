unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus, FMX.TabControl,
  FMX.Layouts, FMX.ListBox, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo,
  FMX.Edit,
  FMX.EditBox, FMX.SpinBox, FMX.Ani, FMX.Objects, System.Actions,
  FMX.ActnList,
  System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB,
  System.ImageList, FMX.ImgList;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem9: TMenuItem;
    MenuItem12: TMenuItem;
    PopupMenu1: TPopupMenu;
    ListBox1: TListBox;
    TrackBar1: TTrackBar;
    ScrollBox1: TScrollBox;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    ToolBar1: TToolBar;
    TabItem4: TTabItem;
    Memo1: TMemo;
    PassWord: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    SpinBox1: TSpinBox;
    MenuItem15: TMenuItem;
    Timer1: TTimer;
    Memo2: TMemo;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    Action3: TAction;
    Button1: TButton;
    LinkControlToField2: TLinkControlToField;
    Image4: TImage;
    BindSourceDB4: TBindSourceDB;
    LinkControlToField5: TLinkControlToField;
    LinkPropertyToFieldEnabled: TLinkPropertyToField;
    ToolBar2: TToolBar;
    SpeedButton2: TSpeedButton;
    Label1: TLabel;
    Label3: TLabel;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    ImageList1: TImageList;
    SpeedButton1: TSpeedButton;
    LinkControlToField1: TLinkControlToField;
    LinkPropertyToFieldEnabled2: TLinkPropertyToField;
    Label4: TLabel;
    Action7: TAction;
    Action8: TAction;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox2: TCheckBox;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    procedure TabControl1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar1KeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Action4Execute(Sender: TObject);
    procedure TrackBar1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure Action6Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure ScrollBox1Paint(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure ScrollBox1Resize(Sender: TObject);
    procedure ScrollBox1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Image3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Image3DblClick(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure TabItem2Resize(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure Action10Execute(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
  private
    { private êÈåæ }
    rects: TArray<TRectF>;
    rectIndex: Integer;
    grab: Boolean;
    posCur: TPointF;
    process: Boolean;
  public
    { public êÈåæ }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.Surface.fmx MSWINDOWS}
{$R *.Windows.fmx MSWINDOWS}

uses Unit3, Unit4, Unit5;

procedure TForm1.Action10Execute(Sender: TObject);
var
  rec: TMap;
  cnt: Integer;
begin
  cnt := Integer(Sender);
  if not SpeedButton2.IsPressed then
  begin
    DataModule4.FDTable1.Locate('page', cnt);
    Image3.Bitmap.Assign(DataModule4.image);
  end
  else
  begin
    rec := DataModule4.mapList[cnt - 1];
    DataModule4.FDTable1.Locate('page', rec.Left);
    if rec.Right = 0 then
    begin
      Panel1.Visible := false;
      Image3.Visible := true;
      Image3.Bitmap.Assign(DataModule4.image);
      Label3.Text := rec.Left.ToString
    end
    else
    begin
      Panel1.Visible := true;
      Image3.Visible := false;
      Label3.Text := rec.Left.ToString + ' , ' + rec.Right.ToString;
      Action6Execute(nil);
    end;
  end;
end;

procedure TForm1.Action11Execute(Sender: TObject);
begin
  TabControl1.TabIndex := 0;
end;

procedure TForm1.Action1Execute(Sender: TObject);
begin
  if (Form5.ShowModal = mrOK) and (DataModule4.LoadAllFile) then
    Action3Execute(Sender);
end;

procedure TForm1.Action2Execute(Sender: TObject);
var
  s: string;
  id: Integer;
  tmp: TArray<TRectF>;
begin
  with DataModule4 do
  begin
    FDConnection1.Close;
    s := ListBox1.Items[ListBox1.ItemIndex];
    id := ImageList1.Source.IndexOf(s);
    ListBox1.Items.Delete(ListBox1.ItemIndex);
    ImageList1.Source.Delete(id);
    ImageList1.Destination.Delete(id);
    FDTable2.Locate('name', s);
    DeleteFile(FDTable2.FieldByName('file').AsString);
    FDTable2.Delete;
  end;
  tmp := [];
  for var rect in rects do
    if rect <> rects[id] then
      tmp := tmp + [rect];
  Finalize(rects);
  SetLength(rects, Length(tmp));
  rects := tmp;
  ScrollBox1.Repaint;
end;

procedure TForm1.Action3Execute(Sender: TObject);
var
  cnt: Integer;
  s: string;
  max: Single;
  src, dst: TRectF;
  item: TCustomSourceItem;
  layer: TLayer;
begin
  max := 0.0;
  ListBox1.Items.Clear;
  ImageList1.Source.Clear;
  ImageList1.Destination.Clear;
  cnt := 0;
  dst := RectF(0, 50, 0, 0);
  with DataModule4.FDTable2 do
  begin
    SetLength(rects, RecordCount);
    First;
    while not Eof do
    begin
      s := FieldByName('name').AsString;
      ListBox1.Items.Add(s);
      item := ImageList1.Source.Add;
      item.Name := s;
      item.MultiResBitmap.Assign(Image4.MultiResBitmap);
      layer := ImageList1.Destination.Add.Layers.Add;
      layer.Name := s;
      layer.SourceRect.rect := RectF(0, 0, 100, 100);
      src := RectF(0, 0, 100, 100);
      dst.Left := dst.Right + 50;
      dst.Right := dst.Left + src.Width;
      dst.Bottom := dst.Top + src.Height;
      if max < dst.Bottom then
        max := dst.Bottom;
      if dst.Right + 50 > ScrollBox1.Width then
      begin
        dst.TopLeft := PointF(50, max + 50);
        dst.Width := 100;
        dst.Height := 100;
      end;
      rects[cnt] := dst;
      Next;
      inc(cnt);
    end;
  end;
  ScrollBox1.Repaint;
end;

procedure TForm1.Action4Execute(Sender: TObject);
begin
  Form3.Show;
  try
    Application.ProcessMessages;
    DataModule4.selected(PChar(Sender));
  finally
    Form3.Hide;
  end;
  TabControl1.TabIndex := 1;
end;

procedure TForm1.Action5Execute(Sender: TObject);
var
  ch: Integer;
begin
  ch := DataModule4.FDTable1.FieldByName('page').AsInteger;
  with DataModule4.FDTable4 do
    if DataModule4.FDTable1.Active then
    begin
      Edit;
      FieldByName('page').AsInteger := ch;
      if SpeedButton2.IsPressed then
        FieldByName('double').AsInteger := 1
      else
        FieldByName('double').AsInteger := 0;
      if CheckBox2.IsChecked then
        FieldByName('toppage').AsInteger := 1
      else
        FieldByName('toppage').AsInteger := 0;
      Post;
    end;
end;

procedure TForm1.Action6Execute(Sender: TObject);
begin
  with DataModule4 do
    if RadioButton2.IsChecked then
    begin
      Image2.Bitmap.Assign(image);
      FDTable1.Next;
      Image1.Bitmap.Assign(image);
    end
    else
    begin
      Image1.Bitmap.Assign(image);
      FDTable1.Next;
      Image2.Bitmap.Assign(image);
    end;
end;

procedure TForm1.Action7Execute(Sender: TObject);
begin
  if RadioButton1.IsChecked then
    TrackBar1.Value := TrackBar1.Value + 1
  else
    TrackBar1.Value := TrackBar1.Value - 1;
end;

procedure TForm1.Action8Execute(Sender: TObject);
begin
  if RadioButton1.IsChecked then
    TrackBar1.Value := TrackBar1.Value - 1
  else
    TrackBar1.Value := TrackBar1.Value + 1;
end;

procedure TForm1.Action9Execute(Sender: TObject);
var
  ch, max: Integer;
begin
  ch := Integer(Sender);
  if SpeedButton2.IsPressed then
  begin
    ch := DataModule4.doublePage(ch);
    max := DataModule4.mapList.Count;
  end
  else
    max := DataModule4.FDTable1.RecordCount;
  if RadioButton2.IsChecked then
    ch := max - ch + 1;
  TrackBar1.Value := ch;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  with DataModule4.FDTable3 do
    if (Edit1.Text <> Edit2.Text) and (Edit1.Text = FieldByName('pwd').AsString)
    then
    begin
      Edit;
      FieldByName('pwd').AsString := Edit2.Text;
      Post;
      Showmessage('Assigned New Password');
      Edit1.Text := '';
    end;
  Edit2.Text := '';
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
var
  cnt: Integer;
  bool: Boolean;
begin
  with DataModule4.FDTable4 do
  begin
    Edit;
    if CheckBox2.IsChecked then
      FieldByName('toppage').AsInteger := 1
    else
      FieldByName('toppage').AsInteger := 0;
    Post;
  end;
  DataModule4.map(CheckBox2.IsChecked);
  if SpeedButton2.IsPressed then
  begin
    bool := RadioButton1.IsChecked;
    TrackBar1.max := DataModule4.mapList.Count;
    cnt := DataModule4.singlePage(Round(TrackBar1.Value), bool);
    if not bool then
      cnt := DataModule4.FDTable1.RecordCount - cnt;
    Action10Execute(Pointer(DataModule4.doublePage(cnt)));
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TabControl1.TabIndex := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Width := Panel1.Width / 2;
  Image2.Position.X := Panel1.Width / 2;
  rectIndex := -1;
  process := false;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  if grab and (WindowState <> TWindowState.wsMaximized) then
  begin
    Left := Left + Round(X - posCur.X);
    Top := Top + Round(Y - posCur.Y);
  end
  else if (X < 2 * Image1.Width / 3) then
    Image1.Cursor := crUpArrow
  else
    Image1.Cursor := crDefault;
end;

procedure TForm1.Image2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  if grab and (WindowState <> TWindowState.wsMaximized) then
  begin
    Left := Left + Round(X - posCur.X);
    Top := Top + Round(Y - posCur.Y);
  end
  else if (X > Image2.Width / 3) then
    Image2.Cursor := crVSplit
  else
    Image2.Cursor := crDefault;
end;

procedure TForm1.Image3DblClick(Sender: TObject);
var
  obj: TControl;
begin
  obj := Sender as TControl;
  case WindowState of
    TWindowState.wsMaximized:
      WindowState := TWindowState.wsNormal;
    TWindowState.wsNormal:
      if obj.Cursor = crDefault then
        WindowState := TWindowState.wsMaximized;
  end;
  grab := false;
end;

procedure TForm1.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
var
  bool: Boolean;
begin
  Timer1.Enabled := false;
  Timer1.Enabled := CheckBox1.IsChecked;
  case TImage(Sender).Cursor of
    crUpArrow:
      bool := RadioButton1.IsChecked;
    crVSplit:
      bool := not RadioButton1.IsChecked;
  else
    grab := true;
    posCur := PointF(X, Y);
    Exit;
  end;
  if bool then
    Action8Execute(nil)
  else
    Action7Execute(nil);
end;

procedure TForm1.Image3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
var
  obj: TControl;
begin
  obj := Sender as TControl;
  if grab and (WindowState <> TWindowState.wsMaximized) then
  begin
    Left := Left + Round(X - posCur.X);
    Top := Top + Round(Y - posCur.Y);
  end
  else if X < obj.Width / 3 then
    obj.Cursor := crUpArrow
  else if X > 2 * obj.Width / 3 then
    obj.Cursor := crVSplit
  else
    obj.Cursor := crDefault;
end;

procedure TForm1.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  if Sender = Image1 then
    Image1MouseMove(Sender, Shift, X, Y)
  else if Sender = Image2 then
    Image2MouseMove(Sender, Shift, X, Y)
  else
    Image3MouseMove(Sender, Shift, X, Y);
  grab := false;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  Action4Execute(Pointer(ListBox1.Items[ListBox1.ItemIndex]));
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  TabControl1.TabIndex := 2;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  with DataModule4.FDTable3 do
  begin
    Edit;
    if Sender = RadioButton2 then
      FieldByName('reverse').AsInteger := 1
    else
      FieldByName('reverse').AsInteger := 0;
    Post;
  end;
  with DataModule4 do
    if FDTable1.Active then
    begin
      FDTable4.Edit;
      FDTable4.FieldByName('page').AsInteger := FDTable1.FieldByName('page')
        .AsInteger;
      FDTable4.Post;
    end;
end;

procedure TForm1.ScrollBox1Click(Sender: TObject);
var
  s: string;
begin
  if rectIndex > -1 then
  begin
    s := ImageList1.Source.Items[rectIndex].Name;
    Action4Execute(Pointer(s));
  end;
end;

procedure TForm1.ScrollBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
var
  s: string;
begin
  for var i := 0 to Length(rects) - 1 do
    if (rects[i].Left < X) and (rects[i].Right > X) and (rects[i].Top < Y) and
      (rects[i].Bottom > Y) then
    begin
      s := ImageList1.Source.Items[i].Name;
      rectIndex := i;
      ListBox1.ItemIndex := ListBox1.Items.IndexOf(s);
      ScrollBox1.Hint := s;
      ScrollBox1.Repaint;
      Exit;
    end;
  if rectIndex > -1 then
  begin
    rectIndex := -1;
    ListBox1.ItemIndex := -1;
    ScrollBox1.Hint := '';
    ScrollBox1.Repaint;
  end;
end;

procedure TForm1.ScrollBox1Paint(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  for var i := 0 to ImageList1.Count - 1 do
    ImageList1.Draw(Canvas, rects[i], i);
end;

procedure TForm1.ScrollBox1Resize(Sender: TObject);
begin
  if Assigned(DataModule4.FDTable2) then
    Action3Execute(nil);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  ScrollBox1.Repaint;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var
  ch: Integer;
begin
  with DataModule4.FDTable4 do
  begin
    Edit;
    if SpeedButton2.IsPressed then
      FieldByName('double').AsInteger := 1
    else
      FieldByName('double').AsInteger := 0;
    Post;
  end;
  Panel1.Visible := SpeedButton2.IsPressed;
  Image3.Visible := not Panel1.Visible;
  ch := Round(TrackBar1.Value);
  if SpeedButton2.IsPressed then
  begin
    TrackBar1.Value := DataModule4.doublePage(ch);
    TrackBar1.max := DataModule4.mapList.Count;
  end
  else
  begin
    TrackBar1.max := DataModule4.FDTable1.RecordCount;
    TrackBar1.Value := DataModule4.singlePage(ch, RadioButton1.IsChecked);
  end;
  if ch = TrackBar1.Value then
    Action10Execute(Pointer(ch));
end;

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex = 1 then
  begin
    if not DataModule4.FDTable1.Active then
    begin
      TabControl1.TabIndex := 0;
      Exit;
    end;
    Action9Execute(Pointer(DataModule4.FDTable1.RecNo));
    TrackBar1.SetFocus;
  end
  else
  begin
    Form3.Hide;
    Timer1.Enabled := false;
    Action5Execute(nil);
  end;
end;

procedure TForm1.TabItem2Resize(Sender: TObject);
begin
  Image1.Position.X := Panel1.Width / 2 - Image1.Width;
  Image2.Position.X := Panel1.Width / 2;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if TabControl1.TabIndex = 1 then
    Action7Execute(nil);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  num, cnt: Integer;
begin
  if process then
    Exit;
  if Sender = TrackBar1 then
    cnt := Round(TrackBar1.Value)
  else
    cnt := DataModule4.FDTable1.RecNo;
  if not SpeedButton2.IsPressed then
  begin
    if RadioButton1.IsChecked then
      num := cnt
    else
      num := DataModule4.FDTable1.RecordCount - cnt + 1;
    Label3.Text := num.ToString;
    TrackBar1.max := DataModule4.FDTable1.RecordCount;
  end
  else
  begin
    if RadioButton1.IsChecked then
      num := cnt
    else
      num := DataModule4.mapList.Count - cnt + 1;
    TrackBar1.max := DataModule4.mapList.Count;
  end;
  Action10Execute(Pointer(num));
  Label4.Text := ' / ' + DataModule4.FDTable1.RecordCount.ToString;
  process := true;
  try
    TrackBar1.Value := cnt;
  finally
    process := false;
  end;
  Timer1.Enabled := false;
  Timer1.Enabled := CheckBox1.IsChecked;
end;

procedure TForm1.TrackBar1KeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkEscape then
    TabControl1.TabIndex := 0;
end;

procedure TForm1.TrackBar1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
var
  bool: Boolean;
begin
  bool := ((WheelDelta > 0) and RadioButton1.IsChecked) or
    ((WheelDelta < 0) and RadioButton2.IsChecked);
  if not bool then
    Action7Execute(nil)
  else
    Action8Execute(nil);
end;

end.

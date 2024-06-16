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
    BindSourceDB2: TBindSourceDB;
    Action3: TAction;
    Button1: TButton;
    BindSourceDB3: TBindSourceDB;
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
    procedure TabControl1Resize(Sender: TObject);
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
    procedure RadioButton2Click(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
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
    DeleteFile(FDTable2.Lookup('name', s, 'file'));
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
var
  cnt: Single;
begin
  with DataModule4 do
  begin
    FDConnection1.Params.Database := FDTable2.FieldByName('file').AsString;
    FDConnection1.Open;
    FDTable1.Open;
    FDTable4.Open;
    cnt := FDTable1.RecordCount;
    TrackBar1.max := cnt;
    TrackBar1Change(nil);
    Label4.Text := '/ ' + cnt.ToString;
  end;
end;

procedure TForm1.Action5Execute(Sender: TObject);
begin
  with DataModule4 do
    if FDTable1.Active then
    begin
      FDTable4.Edit;
      FDTable4.FieldByName('page').AsInteger := FDTable1.FieldByName('page')
        .AsInteger;
      FDTable4.Post;
    end;
end;

procedure TForm1.Action6Execute(Sender: TObject);
begin
  with DataModule4 do
    if RadioButton1.IsChecked then
    begin
      Image2.Bitmap.Assign(image);
      FDTable1.Next;
      Image1.Bitmap.Assign(image);
      FDTable1.Next;
    end
    else
    begin
      Image1.Bitmap.Assign(image);
      FDTable1.Next;
      Image2.Bitmap.Assign(image);
      FDTable1.Next;
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

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TabControl1.TabIndex := 0;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image2.Position.X := Panel1.Width / 2;
  Image1.Align := TAlignLayout.Client;
  rectIndex := -1;
  process := false;
end;

procedure TForm1.Image3DblClick(Sender: TObject);
begin
  case WindowState of
    TWindowState.wsMaximized:
      WindowState := TWindowState.wsNormal;
    TWindowState.wsNormal:
      if Image3.Cursor = crDefault then
        WindowState := TWindowState.wsMaximized;
  end;
  grab := false;
end;

procedure TForm1.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  Timer1.Enabled := false;
  Timer1.Enabled := CheckBox1.IsChecked;
  if X < Image3.Width / 3 then
    Action8Execute(nil)
  else if X > 2 * Image3.Width / 3 then
    Action7Execute(nil)
  else
  begin
    grab := true;
    posCur := PointF(X, Y);
  end;
end;

procedure TForm1.Image3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Single);
begin
  if grab and (WindowState <> TWindowState.wsMaximized) then
  begin
    Left := Left + Round(X - posCur.X);
    Top := Top + Round(Y - posCur.Y);
  end
  else if (X < Image3.Width / 3) or (X > 2 * Image3.Width / 3) then
    Image3.Cursor := crUpArrow
  else
    Image3.Cursor := crDefault;
end;

procedure TForm1.Image3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  grab := false;
end;

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  if DataModule4.FDTable2.Locate('name', ListBox1.Items[ListBox1.ItemIndex])
  then
  begin
    Action4Execute(nil);
    TabControl1.TabIndex := 1;
  end;
end;

procedure TForm1.MenuItem12Click(Sender: TObject);
begin
  TabControl1.TabIndex := 2;
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  with DataModule4.FDTable3 do
  begin
    Edit;
    FieldByName('reverse').AsBoolean := Sender = RadioButton2;
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
    DataModule4.FDTable2.Locate('name', s);
    Action4Execute(nil);
    TabControl1.TabIndex := 1;
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
  cnt: Integer;
begin
  with DataModule4.FDTable4 do
  begin
    Edit;
    FieldByName('double').AsBoolean := SpeedButton2.IsPressed;
    Post;
  end;
  Panel1.Visible := SpeedButton2.IsPressed;
  Image3.Visible := not Panel1.Visible;
  if SpeedButton2.IsPressed then
  begin
    cnt := DataModule4.FDTable1.RecordCount;
    TrackBar1.Value := TrackBar1.Value / 2;
    TrackBar1.max := (cnt div 2) + cnt mod 2;
  end
  else
  begin
    TrackBar1.Value := 2 * TrackBar1.Value;
    TrackBar1.max := DataModule4.FDTable1.RecordCount;
  end;
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
    if not DataModule4.FDTable1.Prepared then
      Form3.Show;
    DataModule4.FDTable1.Prepare;
    Form3.Hide;
    TrackBar1.SetFocus;
  end
  else
  begin
    Form3.Hide;
    Timer1.Enabled := false;
    Action5Execute(nil);
  end;
end;

procedure TForm1.TabControl1Resize(Sender: TObject);
begin
  Image1.BoundsRect := RectF(0, 0, Panel1.Width / 2, Panel1.Height);
  Image2.BoundsRect := RectF(Panel1.Width / 2, 0, Panel1.Width, Panel1.Height);
  Panel1.InvalidateRect(Panel1.BoundsRect);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if TabControl1.TabIndex = 1 then
    Action7Execute(nil);
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
var
  num: Integer;
begin
  if process then
    Exit;
  if Sender = TrackBar1 then
    num := Round(TrackBar1.Value)
  else
    num := DataModule4.FDTable4.FieldByName('page').AsInteger;
  Label3.Text := num.ToString;
  if DataModule4.FDTable1.Locate('page', num) then
  begin
    if not Panel1.Visible then
      Image3.Bitmap.Assign(DataModule4.image)
    else
      Action6Execute(Sender);
  end;
  process := true;
  try
    if Sender = TrackBar1 then
      TrackBar1.Value := num
    else if RadioButton1.IsChecked then
      TrackBar1.Value := num
    else
      TrackBar1.Value := TrackBar1.max - num + 1;
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
  bool := ((WheelDelta < 0) and RadioButton1.IsChecked) or
    ((WheelDelta > 0) and RadioButton2.IsChecked);
  if not bool then
    Action7Execute(nil)
  else
    Action8Execute(nil);
end;

end.

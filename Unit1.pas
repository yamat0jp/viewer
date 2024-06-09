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
  FMX.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Data.DB;

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
    MenuItem13: TMenuItem;
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
    LinkControlToField1: TLinkControlToField;
    BindSourceDB2: TBindSourceDB;
    Action3: TAction;
    Button1: TButton;
    BindSourceDB3: TBindSourceDB;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    SpeedButton1: TSpeedButton;
    Image4: TImage;
    BindSourceDB4: TBindSourceDB;
    LinkControlToField5: TLinkControlToField;
    LinkPropertyToFieldEnabled: TLinkPropertyToField;
    ToolBar2: TToolBar;
    SpeedButton2: TSpeedButton;
    LinkPropertyToFieldIsPressed: TLinkPropertyToField;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    LinkPropertyToFieldVisible: TLinkPropertyToField;
    procedure TabControl1Change(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { private éŒ¾ }
  public
    { public éŒ¾ }
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
    ListBox1.Items.Add(Form5.Edit1.Text);
end;

procedure TForm1.Action2Execute(Sender: TObject);
begin
  with DataModule4 do
  begin
    FDConnection1.Close;
    DeleteFile(FDTable2.Lookup('name',
      ListBox1.Items[ListBox1.ItemIndex], 'file'));
    FDTable2.Delete;
    ListBox1.Items.Delete(ListBox1.ItemIndex);
  end;
end;

procedure TForm1.Action3Execute(Sender: TObject);
var
  bmp: TBitmap;
  src, dst: TRect;
  max: integer;
begin
  ListBox1.Items.Clear;
  dst := Rect(0, 0, 0, 0);
  max := 0;
  with DataModule4.FDTable2 do
  begin
    bmp := TBitmap.Create;
    try
      First;
      while not Eof do
      begin
        ListBox1.Items.Add(FieldByName('name').AsString);
        bmp.Assign(FieldByName('jpeg'));
        src := Rect(0, 0, bmp.Width, bmp.Height);
        dst.Left := dst.Left + 10;
        if dst.Left + 10 > ScrollBox1.Width then
          dst.TopLeft := Point(10, max + 10);
        dst.Right := dst.Left + src.Width;
        dst.Bottom := dst.Top + src.Height;
        ScrollBox1.Canvas.DrawBitmap(bmp, src, dst, 1.0);
        if max < dst.Bottom then
          max := dst.Bottom;
        Next;
      end;
    finally
      bmp.Free;
    end;
  end;
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

procedure TForm1.ListBox1DblClick(Sender: TObject);
begin
  with DataModule4 do
    if FDTable2.Locate('name', ListBox1.Items[ListBox1.ItemIndex]) then
    begin
      FDConnection2.Open(FDTable2.FieldByName('file').AsString);
      TabControl1.TabIndex := 1;
      TrackBar1.max := FDTable4.RecordCount - 1;
      TrackBar1.value := FDTable4.FieldByName('page').AsInteger;
      // TrackBar1Change(Sender);
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

procedure TForm1.TabControl1Change(Sender: TObject);
begin
  if TabControl1.TabIndex = 1 then
  begin
    Form3.Show;
    if CheckBox1.IsChecked then
    begin
      Timer1.Interval := 1000 * Trunc(SpinBox1.value);
      Timer1.Enabled := true;
    end;
  end
  else
    Form3.Hide;
  with DataModule4 do
    if TabControl1.TabIndex = 2 then
      FDTable3.Edit
    else if FDTable3.State = dsEdit then
    begin
      FDTable3.FieldByName('reverse').AsBoolean := RadioButton2.IsChecked;
      FDTable3.Post;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if TabControl1.TabIndex = 1 then
    TrackBar1.value := TrackBar1.value + 1;
end;

procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  with DataModule4 do
    if not Panel1.Visible then
      Image3.Bitmap.Assign(image)
    else
    begin
      if RadioButton1.IsPressed then
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
end;

end.

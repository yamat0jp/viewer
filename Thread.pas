unit Thread;

interface

uses
  System.Classes, Zlib, System.SysUtils, System.Types, FMX.Graphics;

type
  TMyThread = class(TThread)
  private
    { Private 宣言 }
    FImg: TBitmap;
    FStream: TMemoryStream;
    FSub: Boolean;
    function GetStream: TMemoryStream;
  protected
    procedure Execute; override;
  public
    constructor Create(AImg: TBitmap); overload;
    constructor Create(const FileName: string); overload;
    destructor Destroy; override;
    property Stream: TMemoryStream read GetStream;
    property Sub: Boolean read FSub write FSub;
  end;

implementation

{
  重要: ビジュアル コンポーネントにおけるオブジェクトのメソッドとプロパティは、Synchronize を使って
  呼び出されるメソッドでのみ使用できます。たとえば、次のようになります。

  Synchronize(UpdateCaption);

  UpdateCaption は、たとえば次のようなコードになります。

  procedure TMyThread.UpdateCaption;
  begin
  Form1.Caption := 'スレッドで更新されました';
  end;

  あるいは

  Synchronize(
  procedure
  begin
  Form1.Caption := '無名メソッドを通じてスレッドで更新されました'
  end
  )
  );

  ここでは、無名メソッドが渡されています。

  同様に、開発者は上記と同じようなパラメータで Queue メソッドを呼び出すことができます。
  ただし、別の TThread クラスを第 1 パラメータとして渡し、呼び出し元のスレッドを
  もう一方のスレッドでキューに入れます。

}

{ TMyThread }

constructor TMyThread.Create(AImg: TBitmap);
begin
  inherited Create(false);
  FreeOnTerminate := false;
  FImg := TBitmap.Create;
  FImg.Assign(AImg);
  FStream := TMemoryStream.Create;
end;

constructor TMyThread.Create(const FileName: string);
var
  pic: TBitmap;
  rect: TRectF;
begin
  inherited Create(false);
  FreeOnTerminate := false;
  FStream := TMemoryStream.Create;
  FImg := TBitmap.Create;
  pic := TBitmap.Create;
  try
    pic.LoadFromFile(FileName);
    rect:=pic.BoundsF;
    FImg.Width := pic.Width;
    FImg.Height := pic.Height;
    FImg.Canvas.BeginScene;
    FImg.Canvas.DrawBitmap(pic,rect,rect,1.0);
    FImg.Canvas.EndScene;
  finally
    pic.Free;
  end;
  FSub:=FImg.Width < FImg.Height;
end;

destructor TMyThread.Destroy;
begin
  FStream.Free;
  FImg.Free;
  inherited;
end;

procedure TMyThread.Execute;
var
  zs: TStream;
begin
  { スレッドとして実行したいコードをここに記述してください }
  zs := TZCompressionStream.Create(clMax, FStream);
  try
    FImg.SaveToStream(zs);
  finally
    zs.Free;
  end;
end;

function TMyThread.GetStream: TMemoryStream;
begin
  if not Finished then
    WaitFor;
  result := FStream;
end;

end.

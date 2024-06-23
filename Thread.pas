unit Thread;

interface

uses
  System.Classes, Zlib, System.SysUtils, System.Types, FMX.Graphics;

type
  TMyThread = class(TThread)
  private
    { Private �錾 }
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
  �d�v: �r�W���A�� �R���|�[�l���g�ɂ�����I�u�W�F�N�g�̃��\�b�h�ƃv���p�e�B�́ASynchronize ���g����
  �Ăяo����郁�\�b�h�ł̂ݎg�p�ł��܂��B���Ƃ��΁A���̂悤�ɂȂ�܂��B

  Synchronize(UpdateCaption);

  UpdateCaption �́A���Ƃ��Ύ��̂悤�ȃR�[�h�ɂȂ�܂��B

  procedure TMyThread.UpdateCaption;
  begin
  Form1.Caption := '�X���b�h�ōX�V����܂���';
  end;

  ���邢��

  Synchronize(
  procedure
  begin
  Form1.Caption := '�������\�b�h��ʂ��ăX���b�h�ōX�V����܂���'
  end
  )
  );

  �����ł́A�������\�b�h���n����Ă��܂��B

  ���l�ɁA�J���҂͏�L�Ɠ����悤�ȃp�����[�^�� Queue ���\�b�h���Ăяo�����Ƃ��ł��܂��B
  �������A�ʂ� TThread �N���X��� 1 �p�����[�^�Ƃ��ēn���A�Ăяo�����̃X���b�h��
  ��������̃X���b�h�ŃL���[�ɓ���܂��B

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
  { �X���b�h�Ƃ��Ď��s�������R�[�h�������ɋL�q���Ă������� }
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

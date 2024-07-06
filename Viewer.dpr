program Viewer;

uses
  System.StartUpCopy,
  System.UITypes,
  System.SysUtils,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1} ,
  Unit3 in 'Unit3.pas' {Form3} ,
  Unit4 in 'Unit4.pas' {DataModule4: TDataModule} ,
  Unit5 in 'Unit5.pas' {Form5} ,
  Unit6 in 'Unit6.pas' {Form6} ,
  Thread in 'Thread.pas';

{$R *.res}

procedure main;
begin
  FreeAndNil(DataModule4);
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TDataModule4, DataModule4);
  Application.CreateForm(TForm5, Form5);
  Application.Run;
end;

begin
  DataModule4 := TDataModule4.Create(nil);
  if DataModule4.pwd = '' then
    main
  else
  begin
    Form6 := TForm6.Create(nil);
    if Form6.ShowModal = mrOK then
      main
    else
      DataModule4.Free;
    Form6.Free;
  end;

end.

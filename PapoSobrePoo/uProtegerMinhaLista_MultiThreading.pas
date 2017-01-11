unit uProtegerMinhaLista_MultiThreading;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TForm43 = class(TForm)
    Memo1: TMemo;
    Iniciar: TButton;
    procedure IniciarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FConnection: TFDConnection;
    procedure SetConnection(const Value: TFDConnection);
    { Private declarations }
  public
    { Public declarations }
    property Connection: TFDConnection read FConnection write SetConnection;
  end;

var
  Form43: TForm43;

implementation

{$R *.dfm}

Uses System.Threading, System.SyncObjs, System.ThreadSafe  ;


(*
type

  TStringListThreadSafe = class
    private
      FList:TStringlist;
      //FLock:TObject;
      FCritico:TCriticalSection;
    public
      constructor create;
      destructor destroy;override;
      function LockList:TStringList;
      procedure UnLockList;
      procedure add( const text:string );
      procedure Delete(idx:integer);
  end;


  TMinhaThreadList = class(TThreadList)

  end;
*)
var
  FLista: TThreadSafeStringList;


procedure TForm43.FormCreate(Sender: TObject);
begin
  FLista := TThreadSafeStringList.create;
  // abrir tabela.  -  local errado

end;

procedure TForm43.FormDestroy(Sender: TObject);
begin
  FLista.free;
end;

procedure TForm43.FormShow(Sender: TObject);
begin
  // abrir tabela   - aqui local correto.
end;

procedure TForm43.IniciarClick(Sender: TObject);
begin
  tthread.Queue(nil,
    procedure
    begin
      Memo1.Lines.Add('tste, protegido.....      TThreadSafe')
    end);

  TParallel.&For(1, 1000,
    procedure(i: integer)
    begin

        FLista.add( {DateTimeToStr(now)+'-'+} i.ToString );

        TThread.Queue(nil, procedure begin
           memo1.Lines.Add( {DateTimeToStr(now)+'-'+} i.ToString );
        end);

    end);




end;

procedure TForm43.SetConnection(const Value: TFDConnection);
begin
  FConnection := Value;
end;

// exemplo
{
  with TForm43.create(nil) do
  try
  connection := xxxx;
  show;
  finally
  free;
  end;
}

{ TStringListThreadSafe }
(*
procedure TStringListThreadSafe.add(const text: string);
begin
    try
      LockList.add(text);
    finally
      UnLockList;
    end;
end;

constructor TStringListThreadSafe.create;
begin
   FList := TStringList.Create;
   //FLock:=TObject.create;
   FCritico:=TCriticalSection.create;
end;

procedure TStringListThreadSafe.Delete(idx: integer);
begin
   try
    LockList.Delete(idx);
   finally
     UnLockList;
   end;
end;

destructor TStringListThreadSafe.destroy;
begin
  FList.Free;
  //FLock.Free;
  FCritico.Free;
  inherited;
end;

function TStringListThreadSafe.LockList: TStringList;
begin
    //System.TMonitor.Enter(FLock);
    FCritico.Acquire;
    result := FList;
end;

procedure TStringListThreadSafe.UnLockList;
begin
   //System.TMonitor.Exit(FLock);
   FCritico.Release;
end;
*)
end.

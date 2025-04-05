unit AsyncThreadFnkExc;

interface

uses
  {Delphi}
  System.SysUtils
  , System.Classes
  {Project}
  ;

type
  TAwaitProc<T> = reference to procedure(const Result: T; const E: Exception);

  // Generic async interface that passes a result
  IAsync<T> = interface
    ['{65813BBC-12B6-4EF7-ABD2-E3B17576C66E}']
    procedure Await(const AAwaitProc: TAwaitProc<T>);
  end;

  TAsyncFunc<T> = reference to function: T;

  TAsync<T> = class(TInterfacedObject, IAsync<T>)
  strict private
    FSelf: IAsync<T>;
    FAsyncFunc: TAsyncFunc<T>;
    FAwaitProc: TAwaitProc<T>;

    procedure Run;
  public
    constructor Create(const AAsyncFunc: TAsyncFunc<T>);
    procedure Await(const AAwaitProc: TAwaitProc<T>);
  end;

{*
  Usage:
  TAsyncHelper.Run<Integer>(
    function: Integer
    var
      zero: Integer;
    begin
      zero := 0;
      Sleep(3100);
      Result := 10 div zero; // Will cause an exception
    end).Await(
    procedure(const Result: Integer; const E: Exception)
    begin
      if Assigned(E) then
        ShowMessage(E.ClassName + ': ' + E.Message)
      else
        ShowMessage('Result: ' + IntToStr(Result));
    end);
*}

  TAsyncHelper = class
  public
    class function Run<T>(const AAsyncFunc: TAsyncFunc<T>): IAsync<T>;
  end;

implementation

class function TAsyncHelper.Run<T>(const AAsyncFunc: TAsyncFunc<T>): IAsync<T>;
begin
  Result := TAsync<T>.Create(AAsyncFunc);
end;

procedure TAsync<T>.Await(const AAwaitProc: TAwaitProc<T>);
begin
  FSelf := Self;
  FAwaitProc := AAwaitProc;
  TThread.CreateAnonymousThread(Run).Start;
end;

constructor TAsync<T>.Create(const AAsyncFunc: TAsyncFunc<T>);
begin
  inherited Create;
  FAsyncFunc := AAsyncFunc;
end;

procedure TAsync<T>.Run;
var
  _Result: T;
  _Exception: Exception;
begin
  _Exception := nil;
  try
    _Result := FAsyncFunc();
  except
    on E: Exception do
    begin
      _Exception := E.ClassType.Create as Exception;
      _Exception.Message := E.Message;
    end;
  end;

  TThread.Queue(nil,
    procedure
    begin
      if Assigned(FAwaitProc) then
        FAwaitProc(_Result, _Exception);
      FSelf := nil;
    end);
end;

end.

unit Task.ProgressFormUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Threading, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Task.ProgressControllerUnit;

type
  TProgressForm = class(TForm, IProgressController)
    pbTask: TProgressBar;
    btnCancel: TButton;
    mmoLog: TMemo;
    procedure btnCancelClick(Sender: TObject);
  strict private
    FTask: ITask;
    FCancellationPending: Boolean;
    FTaskName: String;
    /// <summary>IProgressController.Cancel
    /// Запрос прерывания выполнения задачи
    /// </summary>
    procedure Cancel; stdcall;
    /// <summary>IProgressController.CancellationPending
    /// Определить запрошено ли прерывание выполнения задачи
    /// </summary>
    /// <returns> Boolean
    /// </returns>
    function CancellationPending: Boolean; stdcall;
    class function CreateAndStartTask(vForm: TProgressForm; AProc: TProc<
      IProgressController>): ITask;
    class function CreateNewTaskForm(ATaskName: string): TProgressForm;
      /// <summary>IProgressController.ReportTaskCompleted Метод оповещения о завершении задачи
    /// </summary>
    procedure ReportTaskCompleted; stdcall;
    /// <summary>IProgressController.ShowPercent
    /// Отобразить процент выполнения задачи
    /// </summary>
    /// <param name="APercent"> (Double) Процент выполнения задачи</param>
    procedure ShowPercent(APercent: Double); stdcall;
    /// <summary>IProgressController.ShowText
    /// Отобразить текстовое сооющение от задачи
    /// </summary>
    /// <param name="AText"> (String) Шаблон текста</param>
    /// <param name="AParams"> (array of const) Параметры заполнения шаблона</param>
    procedure ShowText(AText: string; AParams: array of const); stdcall;
  private
  public
    class function RunTask(AProc: TProc<IProgressController>; ATaskName: string):
        ITask;
    class procedure RunTaskModal(AProc: TProc<IProgressController>; ATaskName:
        string);
  end;

implementation

{$R *.dfm}

procedure TProgressForm.btnCancelClick(Sender: TObject);
begin
  if FTask = nil then
    Close
  else
    Cancel;
end;

procedure TProgressForm.Cancel;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      FCancellationPending := True;
      btnCancel.Caption := 'Ожидаем прерывание задачи ...'
    end);
end;

function TProgressForm.CancellationPending: Boolean;
var
  vResult: Boolean;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      vResult := FCancellationPending;
    end);
  Result := vResult;
end;

class function TProgressForm.CreateAndStartTask(vForm: TProgressForm; AProc: TProc<
  IProgressController>): ITask;
begin
  Result := TTask.Run(
    procedure
    begin
      vForm.ShowText('Начато выполнение задачи "%s"', [vForm.FTaskName]);
      try
        try
          AProc(vForm);
        except
          on E: Exception do
            vForm.ShowText('ОШИБКА: %s', [E.Message]);
        end;
      finally
        vForm.ReportTaskCompleted();
      end;
    end);
end;

class function TProgressForm.CreateNewTaskForm(ATaskName: string): TProgressForm;
begin
  Result := TProgressForm.Create(Application);
  Result.FTaskName := ATaskName;
  Result.Caption := Result.Caption + ' "' + ATaskName + '"';
end;

procedure TProgressForm.ReportTaskCompleted;
begin
  TThread.Synchronize(nil,
    procedure
    begin
      btnCancel.Caption := 'Закрыть';
      FTask := nil;
      Application.ProcessMessages;
    end);
end;

class function TProgressForm.RunTask(AProc: TProc<IProgressController>; ATaskName:
    string): ITask;
var
  vForm: TProgressForm;
begin
  vForm := CreateNewTaskForm(ATaskName);
  vForm.Show();
  Application.ProcessMessages;
  vForm.FTask := CreateAndStartTask(vForm, AProc);
  Result := vForm.FTask;
end;

class procedure TProgressForm.RunTaskModal(AProc: TProc<IProgressController>;
    ATaskName: string);
var
  vForm: TProgressForm;
begin
  vForm := CreateNewTaskForm(ATaskName);
  try
    vForm.FTask := CreateAndStartTask(vForm, AProc);
    vForm.ShowModal();
  finally
    vForm.Free;
  end;
end;

procedure TProgressForm.ShowPercent(APercent: Double);
begin
  TThread.Synchronize(nil,
    procedure
    begin
      pbTask.Position := Trunc(APercent);
      Application.ProcessMessages;
    end);
end;

procedure TProgressForm.ShowText(AText: string; AParams: array of const);
begin
  var vText := DateTimeToStr(Now) + ' ' + Format(AText, AParams);
  TThread.Synchronize(nil,
    procedure
    begin
      mmoLog.Lines.Insert(0, vText);
      Application.ProcessMessages;
    end);
end;

end.


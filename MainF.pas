unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Sound, MMSystem, ExtCtrls, Menus, ImgList;

type
  TMainForm = class(TForm)
    LeftTrackBar: TTrackBar;
    LeftHeadingLabel: TLabel;
    SetVolumeButton: TButton;
    RightTrackBar: TTrackBar;
    RightHeadingLabel: TLabel;
    GetVolumeButton: TButton;
    LeftCurrentLabel: TLabel;
    RightCurrentLabel: TLabel;
    PlayButton: TButton;
    PlayFileNameEdit: TButtonedEdit;
    ResultHeadingLabel: TLabel;
    PresetComboBox: TComboBox;
    PresetHeadingLabel: TLabel;
    ResultMemo: TMemo;
    PlayImageList: TImageList;
    PlayFileNameOpenDialog: TOpenDialog;
    procedure SetVolumeButtonClick(Sender: TObject);
    procedure GetVolumeButtonClick(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure PresetComboBoxChange(Sender: TObject);
    procedure PlayFileNameEditRightButtonClick(Sender: TObject);
  private
    function CallWithErrorHandling(const AOperation: string; AReturnCode: Cardinal): Boolean;
    procedure Log(const AMessage: string);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.PresetComboBoxChange(Sender: TObject);
begin
  case PresetComboBox.ItemIndex of
    0: begin
      // L:0% R:100%
      LeftTrackBar.Position := 100;
      RightTrackBar.Position := 0;
    end;
    1: begin
      // L:25% R:50%
      LeftTrackBar.Position := 75;
      RightTrackBar.Position := 50;
    end;
    2: begin
      // L:100% R:0%
      LeftTrackBar.Position := 0;
      RightTrackBar.Position := 100;
    end;
    3: begin
      // L:100% R:100%
      LeftTrackBar.Position := 0;
      RightTrackBar.Position := 0;
    end;
  end;
  SetVolumeButtonClick(Sender);
  PlayButtonClick(Sender);
end;

procedure TMainForm.SetVolumeButtonClick(Sender: TObject);
begin
  CallWithErrorHandling('SetVolume', WaveOutSetVolumePercentage(100-LeftTrackBar.Position, 100-RightTrackBar.Position));
  GetVolumeButtonClick(Sender);
end;

procedure TMainForm.GetVolumeButtonClick(Sender: TObject);
var
  LeftVolume:  TPercentage;
  RightVolume: TPercentage;
begin
  if (CallWithErrorHandling('GetVolume', WaveOutGetVolumePercentage(LeftVolume, RightVolume))) then begin
    LeftCurrentLabel.Caption := IntToStr(LeftVolume) + '%';
    RightCurrentLabel.Caption := IntToStr(RightVolume) + '%';
  end;
end;

procedure TMainForm.PlayButtonClick(Sender: TObject);
begin
  if (PlaySound(PWideChar(PlayFileNameEdit.Text), 0, SND_FILENAME or SND_ASYNC)) then begin
    Log('Play: Success');
  end else begin
    Log('Play: Failure');
  end;
end;

procedure TMainForm.PlayFileNameEditRightButtonClick(Sender: TObject);
begin
  PlayFileNameOpenDialog.FileName := PlayFileNameEdit.Text;
  if (PlayFileNameOpenDialog.Execute) then begin
    PlayFileNameEdit.Text := PlayFileNameOpenDialog.FileName;
  end;
end;

function TMainForm.CallWithErrorHandling(const AOperation: string; AReturnCode: Cardinal): Boolean;
begin
  Result := AReturnCode = MMSYSERR_NOERROR;
  if (not Result) then begin
    Log(Format('%s: Error %d', [AOperation, AReturnCode]));
  end else begin
    Log(Format('%s: Success', [AOperation]));
  end;
end;

procedure TMainForm.Log(const AMessage: string);
begin
  ResultMemo.Lines.Add(FormatDateTime('hh:mm:ss ', Now) + AMessage);
end;

end.

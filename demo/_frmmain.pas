unit _frmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, DateTimePicker, rxpickdate, rxtooledit, EditBtn;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    calMonthly: TRxCalendarGrid;
    calEdit: TRxDateEdit;
    cbxMonths: TComboBox;
    cgrCalendarOptions: TCheckGroup;
    dateMax: TDateTimePicker;
    dateMin: TDateTimePicker;
    edtYear: TSpinEdit;
    procedure calEditChange(Sender: TObject);
    procedure calMonthlyChange(Sender: TObject);
    procedure cbxMonthsSelect(Sender: TObject);
    procedure cgrCalendarOptionsItemClick(Sender: TObject; Index: integer);
    procedure dateMaxChange(Sender: TObject);
    procedure dateMinChange(Sender: TObject);
    procedure edtYearChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormShow(Sender: TObject);
var
  C: TCalendarOption;
  P: TPoint;
  I: Integer;
begin
  // initial values
  for I := Low(DefaultFormatSettings.LongMonthNames) to
    High(DefaultFormatSettings.LongMonthNames) do
    cbxMonths.Items.Add(DefaultFormatSettings.LongMonthNames[I]);
  for C := Low(TCalendarOption) to High(TCalendarOption) do
    cgrCalendarOptions.Checked[Ord(C)] := C in calMonthly.CalendarOptions;
  dateMin.Date := calMonthly.MinDate;
  dateMax.Date := calMonthly.MaxDate;

  // appearance
  P := cgrCalendarOptions.ClientToParent(Point(0, 0));
  dateMin.Top := cgrCalendarOptions.Controls[Ord(cloUseMinDate)].Top +
    (cgrCalendarOptions.Controls[Ord(cloUseMinDate)].Height - dateMin.Height)
    div 2 + P.Y;
  dateMax.Top := cgrCalendarOptions.Controls[Ord(cloUseMaxDate)].Top +
    (cgrCalendarOptions.Controls[Ord(cloUseMaxDate)].Height - dateMax.Height)
    div 2 + P.Y;

  // init years and months
  calMonthly.OnChange(calMonthly);
end;

procedure TfrmMain.cgrCalendarOptionsItemClick(Sender: TObject; Index: integer);
begin
  if (Sender as TCheckGroup).Checked[Index] then
    calMonthly.CalendarOptions := calMonthly.CalendarOptions +
      [TCalendarOption(Index)]
  else
    calMonthly.CalendarOptions := calMonthly.CalendarOptions -
      [TCalendarOption(Index)]
end;

procedure TfrmMain.calMonthlyChange(Sender: TObject);
begin
  cbxMonths.ItemIndex := (Sender as TRxCalendarGrid).Month - 1;
  edtYear.Value := (Sender as TRxCalendarGrid).Year;
  calEdit.Date := (Sender as TRxCalendarGrid).CalendarDate;
end;

procedure TfrmMain.calEditChange(Sender: TObject);
begin
  calMonthly.CalendarDate := (Sender as TRxDateEdit).Date;
end;

procedure TfrmMain.cbxMonthsSelect(Sender: TObject);
begin
  calMonthly.Month := (Sender as TComboBox).ItemIndex + 1;
  // if the MinDate / MaxDate properties prevents the month changing...
  if calMonthly.Month <> (Sender as TComboBox).ItemIndex + 1 then
    (Sender as TComboBox).ItemIndex := calMonthly.Month - 1
end;

procedure TfrmMain.dateMaxChange(Sender: TObject);
begin
  calMonthly.MaxDate := (Sender as TDateTimePicker).Date;
end;

procedure TfrmMain.dateMinChange(Sender: TObject);
begin
  calMonthly.MinDate := (Sender as TDateTimePicker).Date;
end;

procedure TfrmMain.edtYearChange(Sender: TObject);
begin
  try
    calMonthly.Year := (Sender as TSpinEdit).Value;
    // if the MinDate / MaxDate properties prevents the year changing...
    if calMonthly.Year <> (Sender as TSpinEdit).Value then
      (Sender as TSpinEdit).Value := calMonthly.Year;
  except
    // user entered something wrong
    (Sender as TSpinEdit).Value := calMonthly.Year;
  end;
end;

end.


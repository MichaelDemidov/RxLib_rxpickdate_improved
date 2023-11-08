unit _frmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Spin, DateTimePicker, rxpickdate, rxtooledit, EditBtn;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    btnBackgroundDate1: TColorButton;
    btnBackgroundDate2: TColorButton;
    btnBackgroundDate3: TColorButton;
    btnBackgroundDate4: TColorButton;
    btnBackgroundDate5: TColorButton;
    btnFontDate1: TColorButton;
    btnFontDate2: TColorButton;
    btnFontDate3: TColorButton;
    btnFontDate4: TColorButton;
    btnFontDate5: TColorButton;
    calMonthly: TRxCalendarGrid;
    calEdit: TRxDateEdit;
    cbxMonths: TComboBox;
    cgrCalendarOptions: TCheckGroup;
    chkBoldDate1: TCheckBox;
    chkBoldDate2: TCheckBox;
    chkBoldDate3: TCheckBox;
    chkBoldDate4: TCheckBox;
    chkBoldDate5: TCheckBox;
    chkItalicDate1: TCheckBox;
    chkItalicDate2: TCheckBox;
    chkItalicDate3: TCheckBox;
    chkItalicDate4: TCheckBox;
    chkItalicDate5: TCheckBox;
    chkUnderlineDate1: TCheckBox;
    chkUnderlineDate2: TCheckBox;
    chkUnderlineDate3: TCheckBox;
    chkUnderlineDate4: TCheckBox;
    chkUnderlineDate5: TCheckBox;
    date2: TDateTimePicker;
    date3: TDateTimePicker;
    date4: TDateTimePicker;
    date5: TDateTimePicker;
    dateMax: TDateTimePicker;
    dateMin: TDateTimePicker;
    date1: TDateTimePicker;
    edtHintDate1: TEdit;
    edtHintDate2: TEdit;
    edtHintDate3: TEdit;
    edtHintDate4: TEdit;
    edtHintDate5: TEdit;
    edtYear: TSpinEdit;
    grpDateProps: TGroupBox;
    lblDate2: TLabel;
    lblDate3: TLabel;
    lblDate4: TLabel;
    lblDate5: TLabel;
    lblMaxDate: TLabel;
    lblMinDate: TLabel;
    lblDate1: TLabel;
    procedure calEditChange(Sender: TObject);
    procedure calMonthlyChange(Sender: TObject);
    procedure cbxMonthsSelect(Sender: TObject);
    procedure cgrCalendarOptionsItemClick(Sender: TObject; Index: integer);
    procedure date1Change(Sender: TObject);
    procedure dateMaxChange(Sender: TObject);
    procedure dateMinChange(Sender: TObject);
    procedure edtYearChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure calMonthlyGetDateInfo(Sender: TObject; ADate: TDate; ADay: Word;
      ANotInThisMonth: Boolean; var ADayColor: TColor; var ADayBackground:
      TColor; var AFontStyle: TFontStyles; var ADisabled: Boolean; var AHint:
      string);
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

  for I := 1 to 5 do
    (FindComponent(Format('date%d', [I])) as TDateTimePicker).Date := Date + I -
    1;
  calMonthly.ShowHint := True;
  calMonthly.OnGetDateInfo := @calMonthlyGetDateInfo;
  calMonthly.UpdateCalendar;

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

procedure TfrmMain.date1Change(Sender: TObject);
begin
  calMonthly.UpdateCalendar;
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

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

procedure TfrmMain.calMonthlyGetDateInfo(Sender: TObject; ADate: TDate; ADay:
  Word; ANotInThisMonth: Boolean; var ADayColor: TColor; var ADayBackground:
  TColor; var AFontStyle: TFontStyles; var ADisabled: Boolean; var AHint:
  string);
var
  I: Integer;
  D: TDateTimePicker;
  FS: TFontStyles;
begin
  for I := 1 to 5 do
  begin
    D := FindComponent(Format('date%d', [I])) as TDateTimePicker;
    if D.Date = ADate then
    begin
      ADayColor := (FindComponent(Format('btnFontDate%d', [I])) as
        TColorButton).ButtonColor;
      ADayBackground := (FindComponent(Format('btnBackgroundDate%d', [I])) as
        TColorButton).ButtonColor;
      AHint := (FindComponent(Format('edtHintDate%d', [I])) as TEdit).Text;
      FS := [];
      if (FindComponent(Format('chkBoldDate%d', [I])) as TCheckBox).Checked then
        Include(FS, fsBold);
      if (FindComponent(Format('chkItalicDate%d', [I])) as TCheckBox).Checked
        then
        Include(FS, fsItalic);
      if (FindComponent(Format('chkUnderlineDate%d', [I])) as TCheckBox).Checked
        then
        Include(FS, fsUnderline);
      AFontStyle := FS;
    end;
  end;
end;

end.


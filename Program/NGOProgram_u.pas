unit NGOProgram_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Data.DB, Vcl.Buttons, Vcl.Samples.Spin,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, dmHospital_u, clsMedicine_u, Math;

type
  TfrmMainProgram = class(TForm)
    pgcMain: TPageControl;
    tbLogin: TTabSheet;
    tbHome: TTabSheet;
    tbStockLevels: TTabSheet;
    tbReports: TTabSheet;
    tbPatientsAndStaff: TTabSheet;
    mmProgram: TMainMenu;
    Logi1: TMenuItem;
    Help1: TMenuItem;
    Quit1: TMenuItem;
    Logout1: TMenuItem;
    Close1: TMenuItem;
    imgLoginBG: TImage;
    btnLoginStock: TButton;
    imgMainMenuBG: TImage;
    btnStockLevels: TButton;
    btnInfo: TButton;
    btnPatientAndStaffInfo: TButton;
    pnlStockLevels: TPanel;
    lblStockLevelHeading: TLabel;
    lblHeadingLogin: TLabel;
    tmrHeading: TTimer;
    lblHomeHeading: TLabel;
    btnOrderStock: TButton;
    pnlInfoSheet: TPanel;
    lblInformation: TLabel;
    btnPatientGenderQuery: TBitBtn;
    btnVolunteerDocters: TBitBtn;
    btnNumPatientsPerDoc: TBitBtn;
    dbgPatients: TDBGrid;
    dbgDocters: TDBGrid;
    dbNavPatients: TDBNavigator;
    dbNavDocters: TDBNavigator;
    rbgSortPatients: TRadioGroup;
    rbgSortDoctor: TRadioGroup;
    btnPatientSearch: TButton;
    btnRemovePatientSorting: TBitBtn;
    btnAddPatient: TBitBtn;
    btnDischargePatients: TBitBtn;
    btnSearchDocterID: TButton;
    sedDocID: TSpinEdit;
    btnPatientAmount: TButton;
    Label10: TLabel;
    dbgQuery: TDBGrid;
    redReport: TRichEdit;
    lblMedicineHeading: TLabel;
    pnlStockChanges: TPanel;
    lblSummaryHeading: TLabel;
    btnPrint: TBitBtn;
    btnIncCost: TButton;
    btnIncSold: TButton;
    btnConfirmMedName: TBitBtn;
    imgStockLevel: TImage;
    btnLoginStaff: TButton;
    btnRemoveDocterSorting: TBitBtn;
    btnTotalStock: TBitBtn;
    btnAverageCostPerBottle: TBitBtn;
    btnDates: TBitBtn;
    cmbComboBoxNames: TComboBox;
    lblIDNumbers: TLabel;
    cmbMedName: TComboBox;

    procedure tmrHeadingTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbgSortPatientsClick(Sender: TObject);
    procedure btnRemovePatientSortingClick(Sender: TObject);
    procedure rbgSortDoctorClick(Sender: TObject);
    procedure btnPatientSearchClick(Sender: TObject);
    procedure btnSearchDocterIDClick(Sender: TObject);
    procedure btnPatientAmountClick(Sender: TObject);
    procedure btnDischargePatientsClick(Sender: TObject);
    procedure btnAddPatientClick(Sender: TObject);
    procedure btnConfirmMedNameClick(Sender: TObject);
    procedure btnOrderStockClick(Sender: TObject);
    procedure btnIncCostClick(Sender: TObject);
    procedure btnIncSoldClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnPatientGenderQueryClick(Sender: TObject);
    procedure btnVolunteerDoctersClick(Sender: TObject);
    procedure btnNumPatientsPerDocClick(Sender: TObject);
    procedure btnDatesClick(Sender: TObject);
    procedure btnAverageCostPerBottleClick(Sender: TObject);
    procedure btnTotalStockClick(Sender: TObject);
    procedure btnLoginStockClick(Sender: TObject);
  private
    { Private declarations }
    function IsValidID(sID: string): Boolean;
    function IsValidString(sString: String): Boolean;
    function ValidateDate(sDate: String): Boolean;
    function IsValidBoolean(sBoolean: String): Boolean;
    function IsValidGender(sGender: String): Boolean;
    function IsValidInteger(sInteger: String): Boolean;
    function IsValidReal(sReal: String): Boolean;

    procedure ExecuteSQL(sSQL: String);
    procedure PopulateComboBox;
    procedure PopulateMedNames;

  var

    bLoggedIn: Boolean;
    sMedReportName: String;
    objDrugStock: TMedicine;

    arrPatientInfo: Array of String;
    // declaration of dynamic array to hold patient information adding to combobox
    arrMedicineInfo: Array of String;
    // declaration of dynamic array to hold medicines information to add to combobox

  public
    { Public declarations }

  end;

var
  frmMainProgram: TfrmMainProgram;

implementation

{$R *.dfm}

procedure TfrmMainProgram.btnRemovePatientSortingClick(Sender: TObject);
begin
  with dmHospital do
  begin
    tblDocters.Sort := ''; // remove all sorting from table docters
  end;
end;

procedure TfrmMainProgram.btnSearchDocterIDClick(Sender: TObject);
var
  bFound: Boolean;
  iSearchNum: Integer;
begin
  bFound := False;
  iSearchNum := sedDocID.Value;
  with dmHospital do
  begin
    tblDocters.First;

    while not tblDocters.Eof do
    begin

      if tblDocters['DocterID'] = iSearchNum then
      begin
        bFound := True;
        ShowMessage('Docter found was ' + tblDocters['DocterName'] + ' ' +
          tblDocters['DocterSurname']);
        exit;
      end;

      tblDocters.Next;
    end;
    if bFound = False then
    begin
      ShowMessage('Doctor not found!');
      exit;
    end;
  end;

end;

procedure TfrmMainProgram.btnTotalStockClick(Sender: TObject);
var
  sSQL: String;
begin
  sSQL := 'SELECT SUM(AmountInStock) AS TotalAmountInStock FROM tblDrugStock';
  ExecuteSQL(sSQL);
end;

procedure TfrmMainProgram.ExecuteSQL(sSQL: String);
begin
  with dmHospital do
  begin
    qryHospital.Close;
    qryHospital.SQL.Clear;
    qryHospital.SQL.Add(sSQL);
    qryHospital.Open;

  end;
end;

procedure TfrmMainProgram.btnConfirmMedNameClick(Sender: TObject);
var
  iMedID, iAmountSold, iAmountInStock: Integer;
  rCostPerBottle: Real;
  bFound: Boolean;
begin
  redReport.Lines.Clear;
  bFound := False;
  with dmHospital do
  begin

    sMedReportName := cmbMedName.Items[cmbMedName.ItemIndex];

    tblDrugStock.First;
    while not(tblDrugStock.Eof) do
    begin

      if ((UPPERCASE(tblDrugStock['MedicineName']))
        = (UPPERCASE(sMedReportName))) then
      begin
        bFound := True;
        Break;
      end;
      tblDrugStock.Next;
    end;

    if bFound = True then
    begin
      pnlStockChanges.Visible := True;
      iMedID := tblDrugStock['MedicineID'];
      rCostPerBottle := tblDrugStock['CostPerBottle (R)'];
      iAmountSold := tblDrugStock['AmountSold'];
      iAmountInStock := tblDrugStock['AmountInStock'];

      objDrugStock := TMedicine.create(sMedReportName, iMedID, iAmountInStock,
        iAmountSold, rCostPerBottle);
      redReport.Lines.Add(objDrugStock.GenerateSummary);
    end
    else
    begin
      ShowMessage
        ('That medicine does not exist in our database, please make sure you select one from the combobox');
      cmbMedName.SetFocus;
      exit;
    end;

  end;
end;

procedure TfrmMainProgram.btnIncCostClick(Sender: TObject);
var
  rIncrease: Real;
  sIncrease: String;
begin
  sIncrease := InputBox('Please enter by how much you would like to increase ' +
    sMedReportName + 's price',
    'Enter amount below using a fullstop as a decimal delimeter', '1.4');
  // get integer or real number that the user wants to increase
  // the cost per bottle by
  if NOT IsValidReal(sIncrease) then
  begin
    exit;
  end
  else
  begin
    rIncrease := StrToFloat(sIncrease);
  end;

  objDrugStock.IncreaseMedicinePrice(rIncrease);
  redReport.Lines.Clear;
  redReport.Lines.Add(objDrugStock.GenerateSummary);
end;

procedure TfrmMainProgram.btnIncSoldClick(Sender: TObject);
var
  iIncrease: Integer;
  sAdd: String;
begin
  sAdd := InputBox('Please enter how much more ' + sMedReportName +
    ' has been sold', 'Enter amount sold below', '');

  if NOT IsValidInteger(sAdd) then
  begin
    exit;
  end
  else
  begin
    iIncrease := StrToInt(sAdd);
  end;

  objDrugStock.IncAmountSold(iIncrease);
  redReport.Lines.Clear;
  redReport.Lines.Add(objDrugStock.GenerateSummary);

end;

procedure TfrmMainProgram.btnLoginStockClick(Sender: TObject);
var
  sPassWord, I: String;
begin
bLoggedIn := False;

  if NOT(sPassWord = 'Lavender') then
  begin
  ShowMessage('Please enter a valid password');
  Exit;
  bLoggedIn := False;
  end
  else
  begin
    bLoggedIn := True;
    ShowMessage('Logging in as Stock Manager!');
    Exit;
  end;

end;

procedure TfrmMainProgram.btnOrderStockClick(Sender: TObject);
var
  iIncrease: Integer;
  sAdd: String;
begin
  sAdd := InputBox('Please enter how much more ' + sMedReportName +
    ' you would like to order', 'Enter amount below', '');

  if NOT IsValidInteger(sAdd) then
  begin
    exit;
  end
  else
  begin
    iIncrease := StrToInt(sAdd);
  end;

  objDrugStock.IncreaseStockLevel(iIncrease);
  redReport.Lines.Clear;
  redReport.Lines.Add(objDrugStock.GenerateSummary);
end;

procedure TfrmMainProgram.btnPrintClick(Sender: TObject);
var
  tFile: Textfile;
  sLine, sTitle, sRandomCode: String;
begin
  sLine := objDrugStock.GenerateSummary;

  Randomize;
  sRandomCode := IntToStr(RandomRange(1, 1001));
  sTitle := sMedReportName + sRandomCode;

  AssignFile(tFile, sTitle);
  Rewrite(tFile);
  if FileExists(sTitle) then
  begin
    Writeln(tFile, sLine);
  end;

  CloseFile(tFile);

  with dmHospital do
  begin
    tblDrugStock.First;
    while not tblDrugStock.Eof do
    begin

      if tblDrugStock['MedicineName'] = sMedReportName then
      begin
        tblDrugStock.Edit;
        tblDrugStock['CostPerBottle (R)'] := objDrugStock.GetPrice;
        tblDrugStock['AmountSold'] := objDrugStock.GetAmountSold;
        tblDrugStock['AmountInStock'] := objDrugStock.GetNumMedicine;
        tblDrugStock.Post;
        ShowMessage('Summary Generated with name: ' + sTitle);
      end;
      tblDrugStock.Next;
    end;

  end;
  pnlStockChanges.Visible := False;
  redReport.Lines.Clear;
  objDrugStock.Free;
end;

procedure TfrmMainProgram.btnAverageCostPerBottleClick(Sender: TObject);
var
  sSQL: String;

begin
  with dmHospital do
  begin
    sSQL := 'SELECT AVG([CostPerBottle (R)]) AS [AveragePrice] FROM tblDrugStock  ';
    ExecuteSQL(sSQL);
  end;
end;

procedure TfrmMainProgram.btnPatientGenderQueryClick(Sender: TObject);
var
  sSQL: String;
begin

  with dmHospital do
  begin
    sSQL := 'SELECT (COUNT(PatientFirstName)) AS NumPatients ,Gender FROM tblPatients GROUP BY Gender ';
    ExecuteSQL(sSQL);
  end;

end;

procedure TfrmMainProgram.btnVolunteerDoctersClick(Sender: TObject);
var
  sSQL: string;
begin
  with dmHospital do
  begin
    sSQL := 'SELECT DocterName,Volunteer FROM tblDocters WHERE (Volunteer = Yes)';
    ExecuteSQL(sSQL);

  end;
end;

procedure TfrmMainProgram.btnNumPatientsPerDocClick(Sender: TObject);
var
  sSQL: string;

begin

  with dmHospital do
  begin
    sSQL := ' SELECT DocterName,DocterSurname,COUNT(PatientFirstName) AS NumPatients FROM tblDocters,tblPatients WHERE tblPatients.AssignedDocterID = tblDocters.DocterID GROUP By DocterName,DocterSurname  ';
    ExecuteSQL(sSQL);

  end;

end;

procedure TfrmMainProgram.btnDatesClick(Sender: TObject);
var
  sSQL: String;
  tToday: tDate;
begin
  with dmHospital do
  begin
    tToday := Now;
    sSQL := 'SELECT PatientFirstName,Gender,DateBookedIn FROM tblPatients WHERE ((#'
      + FormatDateTime('mm/dd/yyyy', tToday) +
      '# - DateBookedIn) >14) AND Gender = "M" ';
    ExecuteSQL(sSQL);
  end;
end;

procedure TfrmMainProgram.btnAddPatientClick(Sender: TObject);
var
  sFirstName, sSurname, sDate, sGender, sID, sDocNum, sTemporary: String;
  iDocNum: Integer;
  tDateBookedIn: tDate;
begin

  sID := InputBox('Please enter the patients ID number',
    'Enter 13 digit ID number below', '');

  if Not(IsValidID(sID)) then
  begin // use function to check if ID is valid
    exit;
  end;

  sFirstName := InputBox('Please enter the patients first name',
    'Enter first name below', ''); // receive input for persons name

  if Not(IsValidString(sFirstName)) then
  begin // use function to check name is valid
    exit;
  end;

  sSurname := InputBox('Please enter the patients surname',
    'Enter surname below', ''); // get input

  if Not(IsValidString(sSurname)) then
  begin // check if valid string
    exit;
  end;

  sGender := InputBox('Please enter the patients gender',
    'Enter Either M or F below', 'F'); // get input

  if Not(IsValidGender(sGender)) then
  begin // check if valid gender
    exit;
  end;

  sDocNum := InputBox('Please enter the Assigned Docters ID Number',
    'Enter Docters ID number below', ''); // get input

  if Not(IsValidInteger(sDocNum)) then
  begin // check if valid integer
    exit;
  end
  else
  begin
    iDocNum := StrToInt(sDocNum);
    // if it is valid then convert to integer for posting to database
  end;

  sTemporary := InputBox
    ('Please indicate whether the patient is temporary or not',
    'Enter True or False below', 'True'); // get input

  if Not(IsValidBoolean(sTemporary)) then
  begin // check if valid boolean value is given
    exit;
  end;

  sDate := InputBox('Please the date the patient was booked in on',
    'Enter in the following format MM/DD/YY', '27/12/2001'); // get input

  if Not(ValidateDate(sDate)) then
  begin // check if valid date was given
    exit;
  end
  else
  begin
    tDateBookedIn := StrToDate(sDate);
  end;

  with dmHospital do
  begin

    tblPatients.Last;
    tblPatients.Insert;

    tblPatients['PatientIDNumber'] := sID;
    tblPatients['PatientFirstName'] := sFirstName;
    tblPatients['PatientSurname'] := sSurname;
    tblPatients['Gender'] := sGender;
    tblPatients['AssignedDocterID'] := iDocNum;
    tblPatients['Temporary'] := sTemporary;
    tblPatients['DateBookedIn'] := tDateBookedIn;
    tblPatients.Post;

  end;
end;

procedure TfrmMainProgram.btnDischargePatientsClick(Sender: TObject);
begin

  with dmHospital do
  begin
    if MessageDlg('Are you sure that you want to discharge ' + tblPatients
      ['PatientFirstName'] + ' ' + tblPatients['PatientSurname'] +
      ' from the hospital?', mtWarning, [mbOk, mbCancel], 0) = mrOK then
    // set up messege dialogue box for dischargeing the patient
    begin
      tblPatients.Delete;
      ShowMessage('Patient discharged!');
      // if the user selects mbOk then this code will run and the patient will be removed

    end
    else
    begin
      ShowMessage('Patient not discharged');
      // if they click no, this will run and no patient will be removed from database
      exit;

    end;
  end;

end;

procedure TfrmMainProgram.btnPatientAmountClick(Sender: TObject);
var
  bFound: Boolean;
  iDocID, iCount: Integer;
  sPatients: String;
begin
  bFound := False;
  iCount := 0;
  iDocID := 0;
  sPatients := '';

  with dmHospital do
  begin
    iDocID := tblDocters['DocterID'];

    tblPatients.First;
    while not tblPatients.Eof do
    begin
      if tblPatients['AssignedDocterID'] = iDocID then
      begin
        bFound := True;
        Inc(iCount);
        sPatients := sPatients + tblPatients['PatientFirstName'] + ' ' +
          tblPatients['PatientSurname'] + #13;
      end;
      tblPatients.Next;
    end;

    if bFound = True then
    begin
      ShowMessage(tblDocters['DocterName'] + ' ' + tblDocters['DocterSurname'] +
        ' had ' + IntToStr(iCount) + ' patient/s.' + #13 + 'And they were: ' +
        #13 + sPatients);
    end
    else
      ShowMessage('Doctor does not have any patients!');
  end;

end;

procedure TfrmMainProgram.btnPatientSearchClick(Sender: TObject);
var
  sID: String;
  iPos: Integer;
begin
  with dmHospital do
  begin

    sID := cmbComboBoxNames.Items[cmbComboBoxNames.ItemIndex];
    // get ID number of patient

    if IsValidID(sID) = True then // check that it is a valid ID number
    begin
      tblPatients.First;
      while not tblPatients.Eof do
      begin
        if tblPatients['PatientIDNumber'] = sID then
        begin
          ShowMessage('Patient found was ' + tblPatients['PatientFirstName'] +
            ' ' + tblPatients['PatientSurname']);
          exit;
        end;
        tblPatients.Next;
      end;

    end;
  end;

end;

procedure TfrmMainProgram.FormActivate(Sender: TObject);
begin
  with dmHospital do
  begin
    tmrHeading.Enabled := True;

    // code to set up spin edit
    tblDocters.Sort := 'DocterID ASC';
    // sort table by IDs to ensure largest number is last
    tblDocters.Last;
    sedDocID.MaxValue := tblDocters['DocterID'];
    // make max value for spin edit the largest ID in table

    tblDocters.First; // reset table
    tblDocters.Sort := '';
    // end code for spin edit
    PopulateComboBox;
    PopulateMedNames;
  end;

end;

function TfrmMainProgram.IsValidBoolean(sBoolean: String): Boolean;
begin
  if (UPPERCASE(sBoolean) = 'TRUE') OR (UPPERCASE(sBoolean) = 'FALSE') then
  begin
    Result := True;
    // is a valid boolean
  end
  else
  begin
    Result := False; // is not a valid boolean
    ShowMessage('Please only enter a valid True/False Value');
    exit;
  end;
end;

function TfrmMainProgram.IsValidGender(sGender: String): Boolean;
begin
  sGender := UPPERCASE(sGender);

  if Length(sGender) = 1 then
  // ensure only one character is entered for gender , also acts as presence check
  begin
    if (sGender = 'M') OR (sGender = 'F') then
    // check gender is in correct format, either M or F
    begin
      Result := True;

    end
    else
    begin
      ShowMessage('Please only enter M or F to indicate gender');
      // if incorrect format, tell the user
      Result := False;
      exit;
    end;

  end
  else
  begin
    ShowMessage('Please only enter 1 character');
    // tell user that this field cannot be left open
    Result := False;
    exit;
  end;
end;

function TfrmMainProgram.IsValidID(sID: string): Boolean;
var
  I: Integer;
begin

  if sID = '' then // validate for empty value
  begin
    ShowMessage('Please enter a value for the ID Number');
    Result := False;
    exit;
  end;

  if Length(sID) <> 13 then
  // ensure 13 numbers are entered so that no database errors occur
  begin
    ShowMessage('ID Number must be exactly 13 numbers long');
    Result := False;
    exit;
  end;

  for I := 1 to Length(sID) do
  // make sure each string character entered is a number
  begin
    if sID[I] IN ['0' .. '9'] then
    begin
      Result := True
    end
    else
    begin
      ShowMessage('ID number can only contain numbers');
      // display error if anything other than a number is entered
      Result := False;
      exit;
    end;

  end;

end;

function TfrmMainProgram.IsValidInteger(sInteger: String): Boolean;
var
  I: Integer;
begin
  if NOT(sInteger = '') then
  // ensure that something was entered for the assigned docter number
  begin

    for I := 1 to Length(sInteger) do
    // loop through the doctor number and check that it is a valid integer
    begin
      if sInteger[I] IN ['0' .. '9'] then
      begin
        Result := True;
      end
      else
      begin
        ShowMessage('Please only enter integers for the docter number');
        // if anything other than a number was entered, show this messege and make result false
        Result := False;
        exit;
      end;
    end;

  end
  else
  begin
    Result := False;
    ShowMessage('Please do not leave the AssignedDoctorNumber Field empty');
    // if nothing was entered show this messege and make result false
    exit;
  end;

end;

function TfrmMainProgram.IsValidReal(sReal: String): Boolean;
var
  rReal: Real;
  iCode: Integer;
begin
  Val(sReal, rReal, iCode);

  if iCode <> 0 then
  begin
    ShowMessage('Please enter a valid number and no string values');
    Result := False;
    exit;
  end
  else
  begin
    Result := True;
  end;

end;

function TfrmMainProgram.IsValidString(sString: String): Boolean;
var
  I: Integer;
begin

  if sString = '' then
  // make sure that that the string value is not left empty / validate for null
  begin
    ShowMessage('Please do not leave the persons name/surname field blank');
    Result := False;
    exit;
  end;

  for I := 1 to Length(sString) do
  begin

    if (sString[I] IN ['A' .. 'Z', 'a' .. 'z']) OR (sString = ' ') then
    // make sure each character is either a string value or a space value
    begin
      Result := True;
    end
    else
    begin
      Result := False;
      ShowMessage('Please only enter valid letters of the alphabet');
      exit;
    end;

  end;

end;

procedure TfrmMainProgram.PopulateComboBox;
var
  iNumPatients, I, J, K, O: Integer;
  sTemp, sInfo: String;
begin
  // this procedure poplates the combo box with patients ID numbers
  iNumPatients := 0;
  with dmHospital do
  begin
    tblPatients.First;
    while not tblPatients.Eof do
    begin
      Inc(iNumPatients);
      // determine the amount of patients in database
      tblPatients.Next;
    end;

    SetLength(arrPatientInfo, iNumPatients);
    // set dynamic array's new length to amount of patients

    tblPatients.First;

    for I := 1 to iNumPatients do
    begin
      arrPatientInfo[I] := tblPatients['PatientIDNumber'];
      tblPatients.Next;
    end;

    for J := 0 to Length(arrPatientInfo) - 1 do
    begin
      for K := 0 to Length(arrPatientInfo) - 2 do
      begin

        if arrPatientInfo[K] > arrPatientInfo[K + 1] then
        begin
          sTemp := arrPatientInfo[K];
          arrPatientInfo[K] := arrPatientInfo[K + 1];
          arrPatientInfo[K + 1] := sTemp;
        end;

      end;

    end;

    for O := 1 to Length(arrPatientInfo) do
    begin
      sInfo := arrPatientInfo[O];
      cmbComboBoxNames.Items.Add(sInfo);
    end;

  end;

end;

procedure TfrmMainProgram.PopulateMedNames;
var
  iNumMeds, I, J, K, O: Integer;
  sTemp, sInfo: string;
begin
  // this procedure poplates the combo box with patients ID numbers
  iNumMeds := 0;
  with dmHospital do
  begin
    tblDrugStock.First;
    while not tblDrugStock.Eof do
    begin
      Inc(iNumMeds);
      // determine the amount of medicine enteries in database
      tblDrugStock.Next;
    end;

    SetLength(arrMedicineInfo, iNumMeds);
    // set dynamic array's new length to amount of medicine in database

    tblDrugStock.First;

    for I := 1 to iNumMeds do
    begin
      arrMedicineInfo[I] := tblDrugStock['MedicineName'];
      tblDrugStock.Next;
    end;

    for J := 0 to Length(arrMedicineInfo) - 1 do
    begin
      for K := 0 to Length(arrMedicineInfo) - 2 do
      begin

        if arrMedicineInfo[K] > arrMedicineInfo[K + 1] then
        begin
          sTemp := arrMedicineInfo[K];
          arrMedicineInfo[K] := arrMedicineInfo[K + 1];
          arrMedicineInfo[K + 1] := sTemp;
        end;

      end;

    end;

    for O := 1 to Length(arrMedicineInfo) do
    begin
      sInfo := arrMedicineInfo[O];
      cmbMedName.Items.Add(sInfo);
    end;
  end;
end;

procedure TfrmMainProgram.rbgSortDoctorClick(Sender: TObject);
begin
  with dmHospital do
  begin

    case rbgSortDoctor.ItemIndex of
      0:
        tblDocters.Sort := 'DocterSurname ASC'; // sort by surname ascending
      1:
        tblDocters.Sort := 'DocterName ASC';
      // sort by first name ascending

    end;

  end;
end;

procedure TfrmMainProgram.rbgSortPatientsClick(Sender: TObject);
begin
  with dmHospital do
  begin

    case rbgSortPatients.ItemIndex of
      0:
        tblPatients.Sort := 'PatientSurname ASC'; // sort by surname ascending
      1:
        tblPatients.Sort := 'PatientFirstName ASC';
      // sort by first name ascending
      2:
        tblPatients.Sort := 'DateBookedIn ASC'; // sort by date ascending

    end;

  end;
end;

procedure TfrmMainProgram.tmrHeadingTimer(Sender: TObject);
var
  sCaption, sLetter: string;
begin
  sCaption := lblHeadingLogin.Caption;
  sLetter := Copy(sCaption, Length(sCaption), 1);

  Delete(sCaption, Length(sCaption), 1);
  sCaption := sLetter + sCaption;

  lblHeadingLogin.Caption := sCaption;
end;

function TfrmMainProgram.ValidateDate(sDate: String): Boolean;
var
  I, iPos: Integer;
  sDays, sMonth, sYear: String;

begin

  iPos := Pos('/', sDate);
  sMonth := Copy(sDate, 1, iPos - 1);
  Delete(sDate, 1, iPos);

  iPos := Pos('/', sDate);
  sDays := Copy(sDate, 1, iPos - 1);
  Delete(sDate, 1, iPos);

  sYear := sDate;

  for I := 1 to Length(sDays) do
  begin
    if NOT(sDays[I] IN ['0' .. '9']) then
    begin
      ShowMessage('Date can only be numbers, please re-enter');
      Result := False;
      exit;
    end;

  end;

  for I := 1 to Length(sMonth) do
  begin
    if NOT(sMonth[I] IN ['0' .. '9']) then
    begin
      ShowMessage('Date can only be numbers, please re-enter');
      Result := False;
      exit;
    end;

  end;

  for I := 1 to Length(sYear) do
  begin
    if NOT(sYear[I] IN ['0' .. '9']) then
    begin
      ShowMessage('Date can only be numbers, please re-enter');
      Result := False;
      exit;
    end;

  end;

  if (StrToInt(sDays) > 31) then
  begin
    ShowMessage('Number of days cannot exceed 31, please re-enter');
    Result := False;
    exit;
  end;

  if StrToInt(sMonth) > 12 then
  begin
    ShowMessage('Month cannot exceed 12, please re-enter');
    Result := False;
    exit;
  end;

  Result := True;
end;

end.

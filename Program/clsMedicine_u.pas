unit clsMedicine_u;

interface

uses System.SysUtils, dmHospital_u;

type
  TMedicine = class(TObject)

  private
    fMedicineName: String;
    fMedicineCode: Integer;
    fNumMedicine: Integer;
    fPrice: Real;
    fAmountSold: Integer;

  public

    constructor create(sMedicineName: String; iMedicineCode, iNumMedicine,
      iAmountSold: Integer; rPrice: Real);
    // getters
    function GetNumMedicine: Integer;

    function GetPrice: Real;
    function GetAmountSold: Integer;
    // setters
    procedure IncAmountSold(iSold: Integer);
    // auxillary functions
    function CalcTotal: Real;
    Function CalcPossiblesales: Real;
    procedure IncreaseMedicinePrice(rIncrease: Real);
    procedure IncreaseStockLevel(iIncrease: Integer);
    // to string
    Function GenerateSummary: String;
  end;

implementation

function TMedicine.GenerateSummary: String;
var
  sOutput: String;
begin
  sOutput := fMedicineName + ' Summary' + #13 + '------------------------' + #13
    + 'Medicine Metadata:' + #13 + 'Medicine Code: ' + IntToStr(fMedicineCode) +
    #13 + 'Medicine Name: ' + fMedicineName + #13 +
    'The current cost per bottle is ' + FloatToStrF(fPrice, ffCurrency, 8, 2) +
    #13 + 'The Current amount sold is ' + IntToStr(fAmountSold) + #13 +
    'The current stock level is ' + IntToStr(fNumMedicine) + #13 +
    '------------------------' + #13 + 'Sales Data:' + #13 +
    'The total amount made from sales is :' + FloatToStrF(CalcTotal, ffCurrency,
    8, 2) + #13 + 'If the remaining stock is sold, an extra amount of ' +
    FloatToStrF(CalcPossiblesales, ffCurrency, 8, 2) + ' would be made ' + #13 +
    'Therefor the total possible amount to be made is ' +
    FloatToStrF(CalcTotal + CalcPossiblesales, ffCurrency, 10, 2);

  Result := sOutput;
end;

function TMedicine.GetAmountSold: Integer;
begin
  Result := fAmountSold;
end;

function TMedicine.GetNumMedicine: Integer;
begin
  Result := fNumMedicine;
end;

function TMedicine.GetPrice: Real;
begin
  Result := fPrice;
end;

procedure TMedicine.IncreaseMedicinePrice(rIncrease: Real);
begin
  fPrice := fPrice + rIncrease;

end;

procedure TMedicine.IncreaseStockLevel(iIncrease: Integer);
begin
  fNumMedicine := fNumMedicine + iIncrease;
end;

procedure TMedicine.IncAmountSold(iSold: Integer);
begin
  fAmountSold := fAmountSold + iSold;
end;

function TMedicine.CalcPossiblesales: Real;
begin
  Result := fNumMedicine * fPrice
end;

function TMedicine.CalcTotal: Real;
begin
  Result := fAmountSold * fPrice;
end;

constructor TMedicine.create(sMedicineName: String;
  iMedicineCode, iNumMedicine, iAmountSold: Integer; rPrice: Real);
begin
  fMedicineName := sMedicineName;
  fMedicineCode := iMedicineCode;
  fNumMedicine := iNumMedicine;
  fAmountSold := iAmountSold;
  fPrice := rPrice;
end;

end.

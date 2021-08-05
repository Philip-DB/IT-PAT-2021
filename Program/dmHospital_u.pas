unit dmHospital_u;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Data.Win.ADODB;

type
  TdmHospital = class(TDataModule)
    conHospital: TADOConnection;
    tblDocters: TADOTable;
    tblDrugStock: TADOTable;
    tblPatients: TADOTable;
    qryHospital: TADOQuery;
    dscDocters: TDataSource;
    dscDrugStock: TDataSource;
    dscPatients: TDataSource;
    dscQuery: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmHospital: TdmHospital;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.

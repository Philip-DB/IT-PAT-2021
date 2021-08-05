object dmHospital: TdmHospital
  OldCreateOrder = False
  Height = 461
  Width = 672
  object conHospital: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=NGOMedicalCampDatab' +
      'ase.mdb;Mode=ReadWrite;Persist Security Info=False'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 328
    Top = 64
  end
  object tblDocters: TADOTable
    Active = True
    Connection = conHospital
    CursorType = ctStatic
    TableName = 'tblDocters'
    Left = 160
    Top = 152
  end
  object tblDrugStock: TADOTable
    Active = True
    Connection = conHospital
    CursorType = ctStatic
    TableName = 'tblDrugStock'
    Left = 280
    Top = 152
  end
  object tblPatients: TADOTable
    Active = True
    Connection = conHospital
    CursorType = ctStatic
    TableName = 'tblPatients'
    Left = 392
    Top = 152
  end
  object qryHospital: TADOQuery
    Connection = conHospital
    Parameters = <>
    Left = 496
    Top = 152
  end
  object dscDocters: TDataSource
    DataSet = tblDocters
    Left = 160
    Top = 240
  end
  object dscDrugStock: TDataSource
    DataSet = tblDrugStock
    Left = 280
    Top = 240
  end
  object dscPatients: TDataSource
    DataSet = tblPatients
    Left = 392
    Top = 240
  end
  object dscQuery: TDataSource
    DataSet = qryHospital
    Left = 496
    Top = 240
  end
end

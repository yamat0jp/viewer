object DataModule4: TDataModule4
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 152
    Top = 128
  end
  object FDTable1: TFDTable
    AfterScroll = FDTable1AfterScroll
    IndexFieldNames = 'PAGE'
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'MAIN'
    Left = 152
    Top = 216
    object FDTable1PAGE: TIntegerField
      FieldName = 'PAGE'
      Origin = '"PAGE"'
    end
    object FDTable1IMAGE: TBlobField
      FieldName = 'IMAGE'
      Origin = 'IMAGE'
    end
    object FDTable1sub: TIntegerField
      FieldName = 'sub'
    end
  end
  object FDTable2: TFDTable
    IndexFieldNames = 'ID'
    Connection = FDConnection2
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = '"TABLE"'
    Left = 152
    Top = 304
    object FDTable2ID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
    end
    object FDTable2name: TWideStringField
      FieldName = 'name'
      Size = 0
    end
    object FDTable2file: TWideStringField
      FieldName = 'file'
      Size = 0
    end
    object FDTable2JPEG: TBlobField
      FieldName = 'JPEG'
      Origin = 'JPEG'
    end
  end
  object FDConnection2: TFDConnection
    Params.Strings = (
      'OpenMode=CreateUTF16'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 264
    Top = 128
  end
  object FDTable3: TFDTable
    Connection = FDConnection2
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'PROFILE'
    Left = 152
    Top = 384
    object FDTable3stay: TIntegerField
      FieldName = 'stay'
    end
    object FDTable3interval: TIntegerField
      FieldName = 'interval'
    end
    object FDTable3reverse: TIntegerField
      FieldName = 'reverse'
    end
    object FDTable3PWD: TStringField
      FieldName = 'PWD'
      Origin = 'PWD'
      Size = 25
    end
  end
  object FDTable4: TFDTable
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'INFO'
    Left = 264
    Top = 216
    object FDTable4double: TIntegerField
      FieldName = 'double'
    end
    object FDTable4PAGE: TIntegerField
      FieldName = 'PAGE'
      Origin = '"PAGE"'
    end
    object FDTable4toppage: TIntegerField
      FieldName = 'toppage'
    end
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 64
    Top = 224
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection2
    Left = 64
    Top = 304
  end
end

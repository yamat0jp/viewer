object DataModule4: TDataModule4
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 322
  Width = 336
  object FDTable1: TFDTable
    AfterScroll = FDTable1AfterScroll
    IndexFieldNames = 'PAGE'
    Connection = FDConnection2
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    Left = 136
    Top = 112
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
    Left = 136
    Top = 200
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
    object FDTable2double: TIntegerField
      FieldName = 'double'
    end
    object FDTable2page: TIntegerField
      FieldName = 'page'
    end
    object FDTable2toppage: TBooleanField
      FieldName = 'toppage'
    end
  end
  object FDConnection2: TFDConnection
    Params.Strings = (
      'OpenMode=CreateUTF16'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 248
    Top = 24
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection2
    Left = 48
    Top = 200
  end
end

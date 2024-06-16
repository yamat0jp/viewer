object DataModule4: TDataModule4
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object FDConnection1: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'OpenMode=OpenOrCreate'
      'Database=C:\Users\yamat\Documents\GitHub\form\TEMPLATE.IB'
      'CharacterSet=UTF8'
      'DriverID=IBLite')
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
    object FDTable1SUB: TBooleanField
      FieldName = 'SUB'
      Origin = 'SUB'
    end
  end
  object FDTable2: TFDTable
    Active = True
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
    object FDTable2NAME: TWideStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 1020
    end
    object FDTable2FILE: TWideStringField
      FieldName = 'FILE'
      Origin = '"FILE"'
      Size = 512
    end
    object FDTable2JPEG: TBlobField
      FieldName = 'JPEG'
      Origin = 'JPEG'
    end
  end
  object FDConnection2: TFDConnection
    Params.Strings = (
      'User_Name=sysdba'
      'Password=masterkey'
      'Database=C:\Users\yamat\Documents\GitHub\form\LITE.IB'
      'CharacterSet=UTF8'
      'DriverID=IBLite')
    Connected = True
    LoginPrompt = False
    Left = 264
    Top = 128
  end
  object FDTable3: TFDTable
    Active = True
    Connection = FDConnection2
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'PROFILE'
    Left = 152
    Top = 384
    object FDTable3STAY: TBooleanField
      FieldName = 'STAY'
      Origin = 'STAY'
    end
    object FDTable3INTERVAL: TFloatField
      FieldName = 'INTERVAL'
      Origin = 'INTERVAL'
    end
    object FDTable3REVERSE: TBooleanField
      FieldName = 'REVERSE'
      Origin = 'REVERSE'
    end
    object FDTable3PWD: TStringField
      FieldName = 'PWD'
      Origin = 'PWD'
      Size = 25
    end
  end
  object FDTable4: TFDTable
    Active = True
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'INFO'
    Left = 264
    Top = 216
    object FDTable4DOUBLE: TBooleanField
      FieldName = 'DOUBLE'
      Origin = '"DOUBLE"'
    end
    object FDTable4PAGE: TIntegerField
      FieldName = 'PAGE'
      Origin = '"PAGE"'
    end
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection2
    Left = 64
    Top = 304
  end
  object FDQuery1: TFDQuery
    Connection = FDConnection1
    Left = 64
    Top = 224
  end
end

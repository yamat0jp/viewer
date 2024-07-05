object DataModule4: TDataModule4
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 279
  Width = 287
  object FDTable1: TFDTable
    AfterScroll = FDTable1AfterScroll
    IndexFieldNames = 'PAGE'
    Connection = FDConnection2
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    Left = 152
    Top = 104
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
    IndexFieldNames = 'ID'
    Connection = FDConnection2
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = '"TABLE"'
    Left = 152
    Top = 192
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
    object FDTable2double: TBooleanField
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
      'User_Name=sysdba'
      'Password=masterkey'
      'CharacterSet=UTF8'
      'OpenMode=OpenOrCreate'
      'Port=3050'
      'Protocol=TCPIP'
      'DriverID=IB')
    LoginPrompt = False
    Left = 72
    Top = 32
  end
  object FDQuery2: TFDQuery
    Connection = FDConnection2
    Left = 64
    Top = 192
  end
end

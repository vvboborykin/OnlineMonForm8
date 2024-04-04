inherited ReportBuilderModule: TReportBuilderModule
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  inherited conMain: TUniConnection
    EncryptedPassword = '9BFF9DFF8FFF9EFF8CFF8CFF88FF90FF8DFF9BFF'
  end
  object MySQLUniProvider: TMySQLUniProvider
    Left = 40
    Top = 72
  end
  object qryContract: TUniQuery
    Connection = conMain
    SQL.Strings = (
      'SELECT'
      '  c.id,'
      '  c.number,'
      '  c.endDate'
      'FROM Contract c'
      '  JOIN Organisation o'
      '    ON o.id = c.payer_id'
      'WHERE c.deleted = 0'
      'AND YEAR(c.endDate) = YEAR(:ReportDate)'
      'AND o.isTFOMS = 1'
      'AND (:UseInogorAccounts = 1 OR c.number LIKE '#39'%'#1089#1074#1086#1076'%'#39')')
    ReadOnly = True
    BeforeOpen = qryContractBeforeOpen
    Left = 136
    Top = 16
    ParamData = <
      item
        DataType = ftDateTime
        Name = 'ReportDate'
        Value = 45379d
      end
      item
        DataType = ftUnknown
        Name = 'UseInogorAccounts'
        Value = nil
      end>
    object qryContractid: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
    end
    object qryContractnumber: TWideStringField
      FieldName = 'number'
      Required = True
      Size = 64
    end
    object qryContractendDate: TDateField
      FieldName = 'endDate'
      Required = True
    end
  end
  object dsContract: TDataSource
    DataSet = qryContract
    Left = 136
    Top = 72
  end
  object qryAccount: TUniQuery
    Connection = conMain
    SQL.Strings = (
      'SELECT'
      '  a.id,'
      '  a.contract_id,'
      '  a.number,'
      '  a.settleDate,'
      '  a.sum'
      'FROM Account a'
      'WHERE a.deleted = 0'
      'AND a.number NOT LIKE '#39'-%'#39
      'AND YEAR(a.settleDate) = YEAR(:ReportDate)')
    MasterSource = dsContract
    MasterFields = 'id'
    DetailFields = 'contract_id'
    ReadOnly = True
    BeforeOpen = qryAccountBeforeOpen
    Left = 216
    Top = 16
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ReportDate'
        Value = nil
      end
      item
        DataType = ftInteger
        Name = 'id'
        ParamType = ptInput
        Value = 129
      end>
    object qryAccountid: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
    end
    object qryAccountcontract_id: TIntegerField
      FieldName = 'contract_id'
      Required = True
    end
    object qryAccountnumber: TWideStringField
      FieldName = 'number'
      Size = 64
    end
    object qryAccountsettleDate: TDateField
      FieldName = 'settleDate'
      Required = True
    end
    object qryAccountsum: TFloatField
      FieldName = 'sum'
      Required = True
    end
  end
  object dsAccount: TDataSource
    DataSet = qryAccount
    Left = 216
    Top = 72
  end
  object qryEty: TUniQuery
    Connection = conMain
    SQL.Strings = (
      'SELECT'
      '  ai.master_id,'
      '  et.code AS eventTypeCode,'
      '  et.name AS eventTypeName,'
      '  e.execDate,'
      '  acc.settleDate,'
      '  COUNT(DISTINCT e.id) AS kol,'
      '  SUM(ai.sum) AS summa'
      'FROM Account_Item ai'
      '  JOIN Account acc '
      '    ON acc.id = ai.master_id'
      '  JOIN Event e'
      '    ON ai.event_id = e.id'
      '  JOIN EventType et'
      '    ON e.eventType_id = et.id'
      '  LEFT OUTER JOIN Action a'
      '    ON ai.action_id = a.id'
      '  LEFT OUTER JOIN ActionType aty'
      '    ON a.actionType_id = aty.id'
      
        'WHERE ai.deleted = 0  AND DATE(&EndDateField) BETWEEN :BegDate A' +
        'ND :EndDate'
      'AND ai.master_id = :AccountId'
      '&WhereFilter'
      'GROUP BY et.id')
    ReadOnly = True
    BeforeOpen = qryEtyBeforeOpen
    Left = 288
    Top = 16
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'BegDate'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EndDate'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'AccountId'
        Value = nil
      end>
    MacroData = <
      item
        Name = 'EndDateField'
        Value = 'execDate'
      end
      item
        Name = 'WhereFilter'
      end>
    object qryEtymaster_id: TIntegerField
      FieldName = 'master_id'
      Required = True
    end
    object qryEtyeventTypeCode: TWideStringField
      FieldName = 'eventTypeCode'
      ReadOnly = True
      Required = True
      Size = 8
    end
    object qryEtyeventTypeName: TWideStringField
      FieldName = 'eventTypeName'
      ReadOnly = True
      Required = True
      Size = 64
    end
    object qryEtykol: TLargeintField
      FieldName = 'kol'
      ReadOnly = True
      Required = True
    end
    object qryEtysumma: TFloatField
      FieldName = 'summa'
      ReadOnly = True
    end
    object qryEtyexecDate: TDateTimeField
      FieldName = 'execDate'
      ReadOnly = True
    end
    object qryEtysettleDate: TDateField
      FieldName = 'settleDate'
      ReadOnly = True
      Required = True
    end
  end
  object dsEty: TDataSource
    DataSet = qryEty
    Left = 288
    Top = 72
  end
  object qryAty: TUniQuery
    Connection = conMain
    SQL.Strings = (
      'SELECT'
      '  ai.master_id,'
      '  ai.event_id,'
      '  et.code AS eventTypeCode,'
      '  et.name AS eventTypeName,'
      '  aty.code AS actionTypeCode,'
      '  aty.name AS actionTypeName,'
      '  e.execDate,'
      '  IF(a.KSG <> '#39#39', a.KSG, aty.code) AS serviceCode,'
      '  COUNT(DISTINCT a.id) AS kol,'
      '  SUM(ai.sum) AS summa,'
      '  acc.settleDate'
      'FROM Account_Item ai'
      '  JOIN Account acc '
      '    ON acc.id = ai.master_id'
      '  JOIN Event e'
      '    ON ai.event_id = e.id'
      '  JOIN EventType et'
      '    ON e.eventType_id = et.id'
      '  LEFT OUTER JOIN Action a'
      '    ON ai.action_id = a.id'
      '  LEFT OUTER JOIN ActionType aty'
      '    ON a.actionType_id = aty.id'
      
        'WHERE ai.deleted = 0 AND DATE(&EndDateField) BETWEEN :BegDate AN' +
        'D :EndDate'
      'AND ai.master_id = :AccountId'
      '&WhereFilter'
      'GROUP BY serviceCode')
    DetailFields = 'master_id'
    ReadOnly = True
    BeforeOpen = qryAtyBeforeOpen
    Left = 344
    Top = 16
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'BegDate'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'EndDate'
        Value = nil
      end
      item
        DataType = ftUnknown
        Name = 'AccountId'
        Value = nil
      end>
    MacroData = <
      item
        Name = 'EndDateField'
        Value = 'execDate'
      end
      item
        Name = 'WhereFilter'
      end>
    object qryAtymaster_id: TIntegerField
      FieldName = 'master_id'
      Required = True
    end
    object qryAtyevent_id: TIntegerField
      FieldName = 'event_id'
    end
    object qryAtyeventTypeCode: TWideStringField
      FieldName = 'eventTypeCode'
      ReadOnly = True
      Required = True
      Size = 8
    end
    object qryAtyeventTypeName: TWideStringField
      FieldName = 'eventTypeName'
      ReadOnly = True
      Required = True
      Size = 64
    end
    object qryAtyactionTypeCode: TWideStringField
      FieldName = 'actionTypeCode'
      ReadOnly = True
      Size = 31
    end
    object qryAtyactionTypeName: TWideStringField
      FieldName = 'actionTypeName'
      ReadOnly = True
      Size = 255
    end
    object qryAtyserviceCode: TWideStringField
      FieldName = 'serviceCode'
      ReadOnly = True
      Size = 64
    end
    object qryAtykol: TLargeintField
      FieldName = 'kol'
      ReadOnly = True
      Required = True
    end
    object qryAtysumma: TFloatField
      FieldName = 'summa'
      ReadOnly = True
    end
    object qryAtyexecDate: TDateTimeField
      FieldName = 'execDate'
      ReadOnly = True
    end
    object qryAtysettleDate: TDateField
      FieldName = 'settleDate'
      ReadOnly = True
      Required = True
    end
  end
  object dsAty: TDataSource
    DataSet = qryAty
    Left = 344
    Top = 72
  end
end

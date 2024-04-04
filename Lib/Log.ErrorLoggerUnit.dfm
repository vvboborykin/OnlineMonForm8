object ErrorLogger: TErrorLogger
  Height = 480
  Width = 640
  object apeMain: TApplicationEvents
    OnException = apeMainException
    Left = 40
    Top = 24
  end
end

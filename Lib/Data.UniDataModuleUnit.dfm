object UniDataModule: TUniDataModule
  Height = 480
  Width = 640
  object conMain: TUniConnection
    ProviderName = 'MySQL'
    Database = 's11'
    SpecificOptions.Strings = (
      'MySQL.Charset=utf-8'
      'MySQL.UseUnicode=True')
    Options.AllowImplicitConnect = False
    Options.KeepDesignConnected = False
    Username = 'dbuser'
    Server = 'MySqlServer'
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 16
    EncryptedPassword = '9BFF9DFF8FFF9EFF8CFF8CFF88FF90FF8DFF9BFF'
  end
end

object Form1: TForm1
  Left = 225
  Top = 126
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'ProgressBar in ListView'
  ClientHeight = 363
  ClientWidth = 545
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object ListView1: TListView
    Left = 8
    Top = 8
    Width = 529
    Height = 345
    Columns = <>
    FullDrag = True
    TabOrder = 0
    OnCustomDrawItem = ListView1CustomDrawItem
  end
end

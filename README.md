
# AutoExec UX302NC-R

NCXX社のUSBドングル型LTE通信端末（UX302NC-R）を自動で接続するスクリプトです。

- AutoExecUX302NCR.bat の中身（.ps1ファイルのパス）は書き換え必須です。
  - .ps1ファイルを置いた場所に書き換えてください。
- USBドングルはPCに刺した状態で実行してください。
  - 最小化状態では動かないので、Connection Managerが見える状態で利用してください。
- 適宜、スタートアップに入れるなりして使用してください。
- 例外処理などは甘いので、何かあっても責任は取れません。
- Batファイルで実行する前提ですので、エンコードはShiftJISなのはご注意ください。
  - PowerShell ISEなどで手動実行する場合は、.ps1ファイルをUTF8にエンコードし直してください。

## テスト環境

- Windows 11 Pro 23H2
- PowerShell 7.2.23

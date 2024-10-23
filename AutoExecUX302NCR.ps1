# Connection Manager のインストール場所が違う場合は、ここを変更する。
$app = "C:\Program Files (x86)\UX302NC Data Connection Manager\Main\USB Modem.exe"

# 起動しているかの確認
$process = Get-Process -Name "USB Modem" -ErrorAction SilentlyContinue
if ($process) {   
    Write-Host "USB MODEM が実行中です。"
} else {   
    # 起動していないなら、Connection Manager の起動
    Start-Process $app

    # 起動後の確認
    $process = Get-Process -Name "USB Modem" -ErrorAction SilentlyContinue
    if ($process) {
        # 初期化の時間待ち。端末の処理スピードに寄っては
        # もっと時間がかかるかも知れないので、要調整。
        for ($i = 0; $i -lt 30; $i++) {
            Start-Sleep -Seconds 1
            Write-Host "初期化待機中($i)"
        }
    } else {
        #起動しなかった場合は何かしら問題があったとして、処理を抜ける。
        Write-Host "USB MODEM は実行されていません。"
        exit -1
    }
}


###################################################################################################
# 以下はこちらのページを参照。https://qiita.com/mima_ita/items/3f2aa49fceca7496c587
###################################################################################################

# UI オートメーション関連のアセンブリを読み込む
Add-Type -AssemblyName "UIAutomationClient"  # UIAutomationClientアセンブリを追加
Add-Type -AssemblyName "UIAutomationTypes"   # UIAutomationTypesアセンブリを追加

# C#にて、UIAutomationClientsideProviders を定義。
$source = @"
using System;
using System.Windows.Automation;
namespace UIAutTools
{
    public class Element
    {
        public static AutomationElement RootElement
        {
            get
            {
                return AutomationElement.RootElement;
            }
        }
        public static AutomationElement GetMainWindowByTitle(string title) {
            PropertyCondition cond = new System.Windows.Automation.PropertyCondition(System.Windows.Automation.AutomationElement.NameProperty, title);
            return RootElement.FindFirst(TreeScope.Element | TreeScope.Children, cond);
        }
    }
}
"@

# UIAutomationClientsideProviders を読み込ませる。
Add-Type -TypeDefinition $source -ReferencedAssemblies("UIAutomationClient", "UIAutomationTypes")

# ターゲットのウィンドウを指定。
$mainForm = [UIAutTools.Element]::GetMainWindowByTitle("Connection Manager")

# UI検索用コンディションの定義
$cond = New-Object -TypeName System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::NameProperty, "接続")
# 接続ボタンを検索
$button = $mainForm.FindFirst([System.Windows.Automation.TreeScope]::Element -bor [System.Windows.Automation.TreeScope]::Descendants, $cond)
$button.Current
$pattern = $button.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
# 検索ボタンを押す
$pattern.invoke()

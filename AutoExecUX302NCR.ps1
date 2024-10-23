# Connection Manager �̃C���X�g�[���ꏊ���Ⴄ�ꍇ�́A������ύX����B
$app = "C:\Program Files (x86)\UX302NC Data Connection Manager\Main\USB Modem.exe"

# �N�����Ă��邩�̊m�F
$process = Get-Process -Name "USB Modem" -ErrorAction SilentlyContinue
if ($process) {   
    Write-Host "USB MODEM �����s���ł��B"
} else {   
    # �N�����Ă��Ȃ��Ȃ�AConnection Manager �̋N��
    Start-Process $app

    # �N����̊m�F
    $process = Get-Process -Name "USB Modem" -ErrorAction SilentlyContinue
    if ($process) {
        # �������̎��ԑ҂��B�[���̏����X�s�[�h�Ɋ���Ă�
        # �����Ǝ��Ԃ������邩���m��Ȃ��̂ŁA�v�����B
        for ($i = 0; $i -lt 30; $i++) {
            Start-Sleep -Seconds 1
            Write-Host "�������ҋ@��($i)"
        }
    } else {
        #�N�����Ȃ������ꍇ�͉��������肪�������Ƃ��āA�����𔲂���B
        Write-Host "USB MODEM �͎��s����Ă��܂���B"
        exit -1
    }
}


###################################################################################################
# �ȉ��͂�����̃y�[�W���Q�ƁBhttps://qiita.com/mima_ita/items/3f2aa49fceca7496c587
###################################################################################################

# UI �I�[�g���[�V�����֘A�̃A�Z���u����ǂݍ���
Add-Type -AssemblyName "UIAutomationClient"  # UIAutomationClient�A�Z���u����ǉ�
Add-Type -AssemblyName "UIAutomationTypes"   # UIAutomationTypes�A�Z���u����ǉ�

# C#�ɂāAUIAutomationClientsideProviders ���`�B
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

# UIAutomationClientsideProviders ��ǂݍ��܂���B
Add-Type -TypeDefinition $source -ReferencedAssemblies("UIAutomationClient", "UIAutomationTypes")

# �^�[�Q�b�g�̃E�B���h�E���w��B
$mainForm = [UIAutTools.Element]::GetMainWindowByTitle("Connection Manager")

# UI�����p�R���f�B�V�����̒�`
$cond = New-Object -TypeName System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::NameProperty, "�ڑ�")
# �ڑ��{�^��������
$button = $mainForm.FindFirst([System.Windows.Automation.TreeScope]::Element -bor [System.Windows.Automation.TreeScope]::Descendants, $cond)
$button.Current
$pattern = $button.GetCurrentPattern([System.Windows.Automation.InvokePattern]::Pattern)
# �����{�^��������
$pattern.invoke()

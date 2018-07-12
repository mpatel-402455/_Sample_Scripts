
function ConfirmMessageBox {
    param(
        [parameter(
        Mandatory=$False)]
        [String]$WinTitle='PowerShell Script',
        [parameter(
        Mandatory=$False)]     
        $MsgText='Do you really want to continue ?'
    )
    $result = [Windows.Forms.MessageBox]::Show($MsgText, $WinTitle, [Windows.Forms.MessageBoxButtons]::YesNo, [Windows.Forms.MessageBoxIcon]::Question)
    If ($result -eq [Windows.Forms.DialogResult]::Yes) {
        #Return $true

        "This is yes"
    }
    Else {
        #Return $false

        "This is NO"
    }
}


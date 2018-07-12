<#
Script checks which snapshots are available on your VCenter or ESX servers.
By Maxzor1908 20-7-16
#>

add-pssnapin VMware.VimAutomation.Core

$Report = "c:\temp\snap.txt"
$Server1 = "server1"
$Server2 = "server2"
$Server3 = "server3"
$Server4 = "server4"
$Server5 = "server5"

Connect-VIServer $Server1
Get-VM | Get-Snapshot | Format-List Created,vm | Out-file $Report -Append
Disconnect-VIServer -Confirm:$False

Connect-VIServer $Server2
Get-VM | Get-Snapshot | Format-List Created,vm | Out-file $Report -Append
Disconnect-VIServer -Confirm:$False

Connect-VIServer $Server3
Get-VM | Get-Snapshot | Format-List Created,vm | Out-file $Report -Append
Disconnect-VIServer -Confirm:$False

Connect-VIServer $Server4
Get-VM | Get-Snapshot | Format-List Created,vm | Out-file $Report -Append
Disconnect-VIServer -Confirm:$False

Connect-VIServer $Server5
Get-VM | Get-Snapshot | Format-List Created,vm | Out-file $Report -Append
Disconnect-VIServer -Confirm:$False

If (!(Get-Content "c:\temp\snap.txt")) {
 "No snapshots"
}

Else
{
$MailBody= (Get-Content $Report) -join '<BR>'
$MailSubject= "VMware Snapshots on all ESX Servers"
$SmtpClient = New-Object system.net.mail.smtpClient
$SmtpClient.host = "smtp.fil_in_yourself.com"
$MailMessage = New-Object system.net.mail.mailmessage
$MailMessage.from = "vmware_snapshots@fill_in_yourself.com"
$MailMessage.To.add("fill_in@yourself.com")
$MailMessage.Subject = $MailSubject
$MailMessage.IsBodyHtml = 1
$MailMessage.Body = $MailBody
$SmtpClient.Send($MailMessage)
}
Remove-Item $Report
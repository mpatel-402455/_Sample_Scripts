
$smtpServer = 'mail.bellmedia.ca'
$from = "VeeamBackup-QS@BellMedia.ca"
$recipients = 'manish.patel@bellmedia.ca'
$Subject = "TESTING  ..."
$body = "This is an automated email message"


Send-MailMessage -To $recipients -Subject $Subject -Body $body -From $from -SmtpServer $smtpServer
   

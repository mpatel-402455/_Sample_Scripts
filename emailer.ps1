Function Mailer ($emailTo)
<# This is a simple function that that sends a message.
The variables defined below can be passed as parameters by taking them out 
and putting then in the parentheseis above.

i.e. "Function Mailer ($subject)"

#>

{
   $message = @"
                                
This is a test.... 

Thank you,
Name
"@       

$emailFrom = "VeeamBackup@mylab.ca"
$emailTo = "user.mp@mylab.ca"
$subject="Test email..."
$smtpserver="mail.mylab.ca"
$smtp=new-object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($emailFrom, $emailTo, $subject, $message)
}

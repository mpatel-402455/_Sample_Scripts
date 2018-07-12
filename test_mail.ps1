# Author: Simon Rowe
# Created: 6th Feb 2014
# Description: 1. Sends an e-mail informing relevant parties that the service is about to restart.
#              2. Stops the service and confirms the status as stopped.
#              3. Starts the service and confirms the status as Running.
#              4. Sends an e-mail informing support that the service has restarted successfully.

# Send e-mail to alert users of Apache service restart

$hostname = localhost
$smtpServer = 'mail.domain.local'
$from = "Service.manish.patel@ctv.ca"
$recipients = 'manish.patel@bellmedia.ca'
$Subject = "TESTING Service on ..."
$body = "This is an automated message to confirm that the msiserver service on $hostname 
is about to be restarted as part of scheduled maintenance, please ignore any alerts 
for the next 10 minutes from this service."


Send-MailMessage -To $recipients -Subject $Subject -Body $body -From $from -SmtpServer $smtpServer


# Stop service

$service = 'poweshell'

    get-Service	-name $service -Verbose

    
# Send confirmation that service has restarted successfully

$Subject = "msiserver Service Restarted Successfully on $hostname"
$body = "This mail confirms that the msiserver service on $hostname is now running.
Operations, please restart your IXP GUI on your monitoring workstations to confirm they are showing correct information"

Start-Sleep -s 5

Send-MailMessage -To $recipients -Subject $Subject -Body $body -From $from -SmtpServer $smtpServer

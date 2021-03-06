$rfilename = "c:\script\filesrv-disk*.xlsx"
remove-item $rfilename
$excel = New-Object -comobject Excel.Application
$excel.visible = $false
$workbook = $excel.Workbooks.Add()
$ws1 = $workbook.Worksheets.Item(1)
$row = 2
$cell = 1
$ws1.name = "VM's Details"
$ws1.Cells.Item(1,1) = "Host Name"
$ws1.Cells.Item(1,2) = "Drive name"
$ws1.Cells.Item(1,3) = "Disk & Partition #"
$ws1.Cells.Item(1,4) = "Volume Name"
$ws1.Cells.Item(1,5) = "Total Size (GB)"
$ws1.Cells.Item(1,6) = "Free Space (GB)"
$ws1.Cells.Item(1,7) = "Free Space (%)"
$ws1.Cells.Item(1,8) = "Date"
$ws1.Cells.Item(1,9) = "Share Name"
for ($i=1;$i -lt 10;$i++)
            {
            $ws1.Cells.Item(1,$i).Interior.ColorIndex = 33
            $ws1.cells.item(1,$i).HorizontalAlignment = -4108
            $ws1.cells.item(1,$i).font.bold = $true 
            }
$sharename = ""
$outpart = ""
foreach ($server in get-content "c:\script\hostlist.txt")
    {
    $diskparts = Get-WmiObject -computername $server -Class Win32_LogicalDiskToPartition 
    $volumes = Get-WmiObject -ComputerName $server -Class win32_share
    $disks = Get-WmiObject -ComputerName $server -Class Win32_LogicalDisk -Filter "DriveType = 3";
        foreach($disk in $disks) 
        { 
            $deviceID = $disk.DeviceID; 
            $size = $disk.Size; 
            $freespace = $disk.FreeSpace;
            $volume = $disk.volumeName;
            $percentFree = [Math]::Round(($freespace / $size) * 100, 2); 
            $sizeGB = [Math]::Round($size / 1073741824, 2); 
            $freeSpaceGB = [Math]::Round($freespace / 1073741824, 2);
            $freespaceper = [Math]::Round(($freespacegb/$sizegb)*100 , 2)
            foreach($vol in $volumes)
                {
                    if ($vol.name -ne "IPC$" -and $vol.Description -ne "Default share")
                        {
                            $path = $vol.path
                            $drivename = $path.substring(0,2)
                            if ($drivename -eq $deviceID)
                                {
                                    $sharename = $sharename +","+ $path
                                }
                        }
                        foreach ($diskpart in $diskparts)
                            {
                                $partlgth = ($diskpart.Antecedent).Length
                                $partnam = ($diskpart.Dependent).Length
                                $a = $diskpart.Dependent
                                $drivename1=($diskpart.Dependent).Substring(($partnam-3),2)
                                if ($drivename1 -eq $Deviceid)
                                    {
                                        $outpart = ($diskpart.Antecedent).Substring(($partlgth-22),21)
                                    } 
                            } 
                }
                                                      
                    
                # Out Put Section #
                $ws1.Cells.Item($row,1) = $server
                $ws1.Cells.Item($row,2) = $deviceID
                $ws1.Cells.Item($row,3) = $outpart
                $ws1.Cells.Item($row,4) = $volume
                $ws1.Cells.Item($row,5) = $sizegb
                $ws1.Cells.Item($row,6) = $freespacegb
                $ws1.Cells.Item($row,7) = ("{0:P}" -f ($freespacegb/$sizegb))
		        $ws1.Cells.Item($row,8) = get-date -f yyyy-MM-dd
                $ws1.Cells.Item($row,9) = $Sharename
                if ($freespaceper -lt 5)
                    {
                        $ws1.Cells.Item($Row,7).Interior.ColorIndex = 3
                    }
                elseif ($freespaceper -lt 10 -and $freespaceper -gt 5)
                    {
                        $ws1.Cells.Item($Row,7).Interior.ColorIndex = 44
                    }
                $row++
                $sharename = ""
                $outpart = ""
        }
    }
$dataRange = $ws1.Range(("A{0}"  -f 1),("I{0}"  -f $row))
7..12 | ForEach {
    $dataRange.Borders.Item($_).LineStyle = 1
    $dataRange.Borders.Item($_).Weight = 2
}
$workbook.ActiveSheet.UsedRange.EntireColumn.AutoFit()
$filename = "c:\script\filesrv-disk-report $(get-date -f yyyy-MM-dd).xlsx"
$workbook.saveas($filename)
$excel.quit()
Start-sleep -s 30
$recp = "user1@domain.ca,user2.heine@domain.ca,user3@domain.ca"
####################### E-mail send ################################
$smtpServer = "mail.domain.ca"
$att = new-object Net.Mail.Attachment $filename
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "user1@domain.ca"
$msg.To.Add($recp)
$msg.Subject = "Report for Disk space on File servers."
$msg.Body = "Attached is the Report of Disk Space on File servers."
$msg.Attachments.Add($att)
#$smtp.Send($msg)
$att.Dispose()
####################### E-mail send ################################


    
    


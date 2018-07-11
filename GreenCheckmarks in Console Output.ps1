#In a previous tip you have seen that the PowerShell console supports all characters available in a TrueType font. You just need to convert the character code to the type "Char".

# Here is a more advanced example that uses splatting to insert a green checkmark into your console output:

$greenCheck = @{
  Object = [Char] 8730             #AUM: 2768# 0x0AD0
#
  ForegroundColor = 'Green'
  NoNewLine = $true
  }

Write-Host "Status check... " -NoNewline
Start-Sleep -Seconds 1
Write-Host @greenCheck
Write-Host " (Done)"

# So whenever you need a green checkmark, use this line:

Write-Host @greenCheck 


#---------------
<#
function prompt
{

  $specialChar1 = [Char]0x25ba
  
  Write-Host 'PS ' -NoNewline
  Write-Host $specialChar1 -ForegroundColor Green -NoNewline
  ' '
  
  $host.UI.RawUI.WindowTitle = Get-Location
}
#>

#---------------
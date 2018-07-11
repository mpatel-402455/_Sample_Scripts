$items = 356..5000

foreach ($item in $items)
    {
        $item
        $greenCheck = @{
        Object = [Char] $item           #AUM: 2768# 0x0AD0
        ForegroundColor = 'Green'
        NoNewLine = $true
            }

Write-Host "Status check... " -NoNewline
#Start-Sleep -Seconds 1
Write-Host @greenCheck
Write-Host " (Done)"
    }


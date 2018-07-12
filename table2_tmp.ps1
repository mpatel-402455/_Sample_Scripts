$Table = $null
$Table = New-Object System.Data.DataTable "MY_Table"

$Col1 = New-Object System.Data.DataColumn Computer,([string])
$Col2 = New-Object System.Data.DataColumn ScopeName,([string])
$Col3 = New-Object System.Data.DataColumn ScopeValue,([int])
$Col4 = New-Object System.Data.DataColumn CombinedValue,([int])

$Table.Columns.Add($Col1)
$Table.Columns.Add($Col2)
$Table.Columns.Add($Col3)
$Table.Columns.Add($Col4)

$Row = $Table.NewRow()
$Row.Computer = "SRV1"
$Row.ScopeName = "1A"
$Row.ScopeValue = 100
$Row.CombinedValue = 200

$Table.Rows.Add($row)

$Row = $Table.NewRow()
$Row = $Table.NewRow()
$Row.Computer = "SRV2"
$Row.ScopeName = "1A"
$Row.ScopeValue = 50
$Row.CombinedValue = 300

$Table.Rows.Add($row)

$Row = $Table.NewRow()
$Row = $Table.NewRow()
$Row.Computer = "SRV2"
$Row.ScopeName = "1B"
$Row.ScopeValue = 55
$Row.CombinedValue = 400

$Table.Rows.Add($row)

$Table | ft -AutoSize

  #$table | Format-Table -GroupBy Files -AutoSize
    #$Table | Out-GridView
    #$Table | Format-Table -AutoSize | Out-File table.txt



# http://blogs.msdn.com/b/rkramesh/archive/2012/02/02/creating-table-using-powershell.aspx

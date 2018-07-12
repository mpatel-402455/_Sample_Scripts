$Hash = @{
    LibraryA=345
    LibraryB=867
    LibraryC=858
}
$Hash.GetEnumerator() | Sort-Object -Property Name -Descending |
Select-Object -Property @{n='Library';e={$_.Name}},Value |
Export-Csv -Path Ordered.csv -NoTypeInformation


## FOLLOWING works locally 
# 
([WMIClass]"Win32_NetworkAdapterConfiguration").SetDNSSuffixSearchOrder(("prod.lab.ca", "lab.root", "lab.ca", "int.lab.ca", "dev.lab.ca", "production.lab.ca", "qalab.ca"))
$a = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True"
$a.DNSDomainSuffixSearchOrder



#2 
([WMIClass]"Win32_NetworkAdapterConfiguration").SetDNSSuffixSearchOrder(("prod.lab.ca", "domain.root", "lab.ca", "int.lab.ca", "dev.lab.ca", "production.lab.ca", "qalab.ca"))
$a = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled = True"
$a.DNSDomainSuffixSearchOrder



#following are DOS command to change dns suffix on Windows 2003

reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "SearchList"

reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "SearchList" /d "prod.lab.ca,lab.root,lab.ca,int.lab.ca,dev.lab.ca" /f


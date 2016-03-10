function LogMessage($msg) {
	$d = get-date -format g
	$msg = "$($d) $msg"
	write $msg | out-file -Append -FilePath $logfile
	write $msg
}

$logfile = "C:\Scripts\CyberArk\executeCyberArkScript.log"
$fqdn = $machineName_PS + ".testcloud.prod"
$username = $userName_PS.Split("@")[0]

cd C:\Scripts\CyberArk\

If ( $OSType_PS -eq "rhel6_64Guest" ) {
	$o = "Executing CyberArk Script C:\Perl64\bin\perl.exe C:\Scripts\CyberArk\main_linux.pl {0} {1}" -f $userName,$fqdn
	LogMessage $o
	& C:\Perl64\bin\perl.exe C:\Scripts\CyberArk\main_linux.pl $userName $fqdn 2>&1 >> C:\Scripts\CyberArk\main_linux.pl.log
} else {
	$o = "Executing CyberArk Script C:\Perl64\bin\perl.exe C:\Scripts\CyberArk\main_windows.pl {0} {1}" -f $userName,$fqdn
	LogMessage $o
	& C:\Perl64\bin\perl.exe C:\Scripts\CyberArk\main_windows.pl $userName $fqdn 2>&1 >> C:\Scripts\CyberArk\main_windows.pl.log
}
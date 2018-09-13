#GP 9/12/2018 Used to Fix Registry entry that broke REDACTED

$Computers = Get-Content "C:\Powershell\computerlist.txt"
$Path = "HKLM:\SOFTWARE\Wow6432Node\REDACTED"
$Property = "UpdateURI"
$Value = "REDACTED"

$results = foreach ($computer in $Computers)
{
    If (test-connection -ComputerName $computer -Count 1 -Quiet)
    {
        Try {
			Set-ItemProperty -name $Property -path $Path -value $Value -ErrorAction Stop
			$status = "Success"
			} 
			Catch	{
					$status = "Failed"
					}
	}
	else
	{
		$status = "Unreachable"
	}
	
	New-Object -TypeName PSObject -Property @{
        'Computer'=$computer
        'Status'=$status
	}
}

$results |
Export-Csv -NoTypeInformation -Path "./out.csv"

Read-Host -Prompt 'Press Enter to exit'

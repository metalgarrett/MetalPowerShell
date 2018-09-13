#GP 9/12/2018 Used to Fix Registry entry that broke REDACTED

# This only works if the $Path already exists in the registry.
$Computers = Get-Content "C:\Powershell\computerlist.txt"
$Path = "HKLM:\SOFTWARE\Wow6432Node\REDACTED"
$Property = "UpdateURI"
$Value = "REDACTED"

$results = foreach ($computer in $Computers)
{
	If (test-connection -ComputerName $computer -Count 1 -Quiet)
	{
		Try
		{
			Invoke-Command -ComputerName $computer -ArgumentList $Path,$Property,$Value {
				param($remotePath, $remoteProperty, $remoteValue)
				Set-ItemProperty  -path $remotePath -name $remoteProperty -value $remoteValue -ErrorAction Stop
			}
			$status = "Success"
		} 
		Catch
		{
			$ErrorMessage = $_.Exception.Message			
			$status = "Failed: $ErrorMessage"
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

$results | Export-Csv -NoTypeInformation -Path "./out.csv"
Read-Host -Prompt 'Press Enter to exit'

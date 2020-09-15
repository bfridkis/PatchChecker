Clear-Host

Write-Output "`n`t`t`t`t`t*^*!*% ICS Scorecard Utility - PatchChecker Only (L3.5) *^*!*% "

<#$patchCheckerJob = Start-Job {  
                                C:\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerV2.4.ps1 -Option 3 `
                                -CompsFilePath "C:\Users\admbfridkis\Desktop\PatchChecker\nodes4patchcheck.txt" -OutputMode 1 `
                                -OutputFile "C:\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })" `
                                -CheckComplianceAsOfDate Today
                             } -Name PatchCheckerJob 


Write-Output "`nWaiting for PatchCheckerJob..."
$finishedJobs = New-Object System.Collections.Generic.List[System.Object]
$finishedJobs.Add($(Wait-Job -Id $patchCheckerJob.Id))
$finishedJobs | Format-Table -AutoSize
#>

$patcheckerOutputFileName = "\\PCNSMS03\c$\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-$($env:COMPUTERNAME).csv"

$wmiHash = Get-WmiObject -Class 'Win32_QuickFixEngineering' -ErrorAction Stop
$wmiHash | Select-Object -Property Description, HotFixID, InstalledBy, InstalledOn |
	       Sort-Object InstalledOn | Select-Object -Last 1 -Property @{ n = 'Computer Name' ; e = {$env:COMPUTERNAME}},
																	 @{ n = 'Most Recent Patch' ; e = {$_.HotfixID}},
																	 @{ n = 'Installed On' ; e = {$_.InstalledOn}}, 
																	 @{ n = 'Compliant? (Installed in Last 180 Days?)' ; e = {(Get-Date).adddays(-180) -lt $_.InstalledOn}} | 
           Export-CSV -Path $patcheckerOutputFileName -NoTypeInformation

<# if (Test-Path -Path "$($patcheckerOutputFileName)_ERRORS.csv") {
    Send-MailMessage -From PCNSMS04@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "PatchCheckerResults_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-$($env:COMPUTERNAME)"  `
                     -Attachments "$patcheckerOutputFileName.csv", "$($patcheckerOutputFileName)_ERRORS.csv" -SmtpServer 164.123.219.98
}
else {
    Send-MailMessage -From PCNSMS04@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "PatchCheckerResults_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-$($env:COMPUTERNAME)"  `
                    -Attachments "$patcheckerOutputFileName" -SmtpServer 164.123.219.98
} #>
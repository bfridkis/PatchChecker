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

$patcheckerOutputFileNameEES = "C:\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNEES01.csv"
$patcheckerOutputFileNameRES = "C:\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRES01.csv"
$patcheckerOutputFileNameRDP = "C:\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRDP01.csv"

<# 
$wmiHash = Get-WmiObject -Class 'Win32_QuickFixEngineering' -ErrorAction Stop
$wmiHash | Select-Object -Property PSComputerName, Description, HotFixID, InstalledBy, InstalledOn |
	       Sort-Object InstalledOn | Select-Object -Last 1 -Property PSComputerName,
																	           @{ n = 'Most Recent Patch' ; e = {$_.HotfixID}},
																	           @{ n = 'Installed On' ; e = {$_.InstalledOn}}, 
																	           @{ n = 'Compliant? (Installed in Last 180 Days?)' ; e = {(Get-Date).adddays(-180) -lt $_.InstalledOn}} > $patcheckerOutputFileName
#> 

$patchCheckerResults3dot5 = "C:\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerOutputL3.5_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

Get-Content -Path $patcheckerOutputFileNameEES | Add-Content $patchCheckerResults3dot5
#Get-Content -Path $patcheckerOutputFileNameRES -Tail 1 | Add-Content $patchCheckerResults3dot5
(Get-Content -Path $patcheckerOutputFileNameRES -TotalCount 2)[-1] | Add-Content $patchCheckerResults3dot5
#Get-Content -Path $patcheckerOutputFileNameRDP -Tail 1 | Add-Content $patchCheckerResults3dot5
(Get-Content -Path $patcheckerOutputFileNameRDP -TotalCount 2)[-1] | Add-Content $patchCheckerResults3dot5


Send-MailMessage -From PCNSMS03@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "PatchCheckerResultsL3.5_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
     -Attachments $patchCheckerResults3dot5 -SmtpServer 164.123.219.98

Remove-Item C:\Users\admbfridkis\Desktop\PatchChecker\PatchCheckerOUtput_*

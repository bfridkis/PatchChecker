Clear-Host

Write-Output "`n`t`t`t`t`t*^*!*% Patch Checker for Corporate Dashboard *^*!*% "

Remove-Item E:\PatchCheckerForCorporateDashboard\PatchCheckerForCorporateDashboard_ErrorLog*

$patcheckerOutputFileName = "E:\PatchCheckerForCorporateDashboard\PatchCheckerOutput_CorporateDashboard_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year - 1)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"
#$patcheckerOutputFileName = "E:\PatchCheckerForCorporateDashboard\PatchCheckerOutput_CorporateDashboard_$(Get-Date -Format MMddyyyy_HHmmss)"

E:\PatchCheckerForCorporateDashboard\PatchCheckerV2.5.ps1 -Option 3 -AllNodes TRUE -OutputMode 1 `
-OutputFile "$patcheckerOutputFileName" -CheckComplianceAsOfDate Today -ForCorporateDashboard "TRUE"

#Send-MailMessage -From PCNSMS04@wmgpcn.local -To ben.j.fridkis@p66.com -Subject "PatchCheckerOutput_CorporateDashboard_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year - 1)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })"  `
#                 -Attachments $patcheckerOutputFileName -SmtpServer 164.123.219.98
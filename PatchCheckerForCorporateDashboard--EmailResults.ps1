Clear-Host

Write-Output "`n`t*^*!*^ PatchCheckerForCorporateDashboard *^*!*^`n"


$PatchCheckerForCorporateDashboardOutputFileNameEES = "E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNEES01.csv"
$PatchCheckerForCorporateDashboardOutputFileNameRES = "E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRES01.csv"
$PatchCheckerForCorporateDashboardOutputFileNameRDP = "E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-PCNRDP01.csv"
$PatchCheckerForCorporateDashboardOutputFileNameVIDSVR = "\\PCNGAS01\E$\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-VIDCCRSVR01.csv"
$PatchCheckerForCorporateDashboardOutputFileNameVIDWK = "\\PCNGAS01\E$\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" })-VIDCCRWK01.csv"

$PatchCheckerForCorporateDashboardResults = "E:\AVandPatchChecker_CentralNode\WRR-PatchCheckerForCorporateDashboardOutput-$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

#Add-Content -Path $PatchCheckerForCorporateDashboardResults -Value "** Patch Checker Results **"
Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameEES -TotalCount 2 | Add-Content $PatchCheckerForCorporateDashboardResults
(Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameRES -TotalCount 2)[-1] | Add-Content $PatchCheckerForCorporateDashboardResults
(Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameRDP -TotalCount 2)[-1] | Add-Content $PatchCheckerForCorporateDashboardResults
(Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameVIDSVR -TotalCount 2)[-1] | Add-Content $PatchCheckerForCorporateDashboardResults
(Get-Content -Path $PatchCheckerForCorporateDashboardOutputFileNameVIDWK -TotalCount 2)[-1] | Add-Content $PatchCheckerForCorporateDashboardResults

$L3PatchCheckerForCorporateDashboardOutputFile = "\\PCNSMS04\e$\PatchCheckerForCorporateDashboard\PatchCheckerOutput_CorporateDashboard_$(if ((Get-Date).Month -eq 1) { "12_$((Get-Date).Year)" } else { "$($(Get-Date).Month - 1)_$((Get-Date).Year)" }).csv"

Get-Content -Path $L3PatchCheckerForCorporateDashboardOutputFile | Select-Object -Skip 1 | Add-Content $PatchCheckerForCorporateDashboardResults

$emailedFileName = "E:\AVandPatchChecker_CentralNode\Solarwinds Nodes w_Latest Patch-WRR-1.csv"

Rename-Item -Path $PatchCheckerForCorporateDashboardResults -NewName $emailedFileName

Send-MailMessage -From PCNSMS03@wmgpcn.local -To Functional.ICSScorecardFunctionalAcct@p66.com `
     -Cc ben.j.fridkis@p66.com -Subject "SolarWinds Nodes w_Latest Patch-WRR-1"  `
     -Attachments $emailedFileName -SmtpServer 10.100.95.35

Rename-Item -Path $emailedFileName -NewName $PatchCheckerForCorporateDashboardResults

Remove-Item E:\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_*
Remove-Item \\PCNGAS01\E$\AVandPatchChecker_CentralNode\PatchCheckerForCorporateDashboardOutput_*

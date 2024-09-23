. ~\Documents\PowerShell\Microsoft.PowerShell_profile_local.ps1

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

function prompt {
    $gitStatus = if ($(git status 2> $null)) { "`e[91m:" + (git rev-parse --abbrev-ref HEAD) }
    Write-Host "`e[92m$env:username@$(($env:computername).ToLower()) `e[93m$($pwd.Path)$gitStatus `e[36m$LastExitCode"
    return "`e[92m$ `e[37m"
}

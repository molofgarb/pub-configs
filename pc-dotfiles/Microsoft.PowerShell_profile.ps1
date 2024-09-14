Set-Location ~

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

function prompt {
    Write-Host "`e[92m$env:username@$(($env:computername).ToLower()) `e[93m$($pwd.Path) `e[36m$LastExitCode"
    return "`e[92m$ `e[37m"
}
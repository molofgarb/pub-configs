$LASTEXITCODE = 0
if (-not $env:USERNAME -and $env:USER) { $env:USERNAME = $env:USER }

[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

Import-Module PSReadLine
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab       -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -Colors @{
    Parameter = [System.ConsoleColor]::DarkRed
    Operator  = [System.ConsoleColor]::DarkRed
}

# Default to Windows, have this to make Linux environment compatible
if ($IsLinux) {
    $env:COMPUTERNAME = (Get-Content -Raw '/etc/hostname').trim()
    $env:USERNAME = $env:USER
    $env:HISTORY = '~/.local/share/powershell/PSReadLine/ConsoleHost_history.txt'
}

# TODO: SEt-PSReadlineKeyHandler for fzf here
# TODO: show history as you type thing

function Prompt {
    $gitStatus = if (git status 2> $null) { git rev-parse --abbrev-ref HEAD }
    Write-Host (
        "`e[32m$env:USERNAME@$(($env:COMPUTERNAME).ToLower())`e[31m:pwsh " +
        "`e[33m$($pwd.Path) " + 
        "`e[36m$LastExitCode " + 
        "`e[35m$(Get-Date -Format hh:mm:ss) " +
        "`e[34m$gitStatus"
    )
    return "`e[92m$ `e[37m"
}

function Update-Profile {
    $profileUri = 'https://raw.githubusercontent.com/molofgarb/molofgarb-system-scripts/refs/heads/main/dotfiles-pc/Microsoft.PowerShell_profile.ps1'
    $result = Invoke-WebRequest -Uri $profileUri
    if ($result.StatusCode -eq 200) {
        $result.Content > $profile
        . $profile
    }
}

# TODO: add this
# . ~\Documents\PowerShell\Microsoft.PowerShell_profile_local.ps1

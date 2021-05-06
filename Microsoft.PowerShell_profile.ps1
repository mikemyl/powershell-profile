function gogo { Set-Location "C:/Users/mike/GolandProjects" }
function gojava { Set-Location "C:/Users/mike/IdeaProjects" }
function gopython { Set-Location "C:/Users/mike/PycharmProjects" }
function goweb { Set-Location "C:/Users/mike/WebStormProjects" }
function gomike { Set-Location "C:/Users/mike/WebStormProjects/mikemylonakis.com" }
function which($name) { Get-Command $name | Select-Object -ExpandProperty Definition }

Set-Alias -Name vi -Value gvim.exe
Set-Alias -Name vim -Value gvim.exe

if (-Not (Get-Module -ListAvailable -Name PowerShellGet)) {
    Install-Module -Name PowerShellGet -Force
} 

if (-Not (Get-Module -ListAvailable -Name PSReadLine)) {
    Install-Module -Name PSReadLine -Force
} 


if (-Not (Get-Module -ListAvailable -Name posh-git)) {
    Install-Module -Name posh-git -Force
} 


Import-Module PSReadLine

# https://rkeithhill.wordpress.com/2013/10/18/psreadline-a-better-line-editing-experience-for-the-powershell-console/
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key Ctrl+C -Function Copy
Set-PSReadLineKeyHandler -Key Ctrl+v -Function Paste
Set-PSReadLineKeyHandler -Key Ctrl+u -Function BackwardDeleteLine
Set-PSReadLineKeyHandler -Key Ctrl+q -Function TabCompleteNext
Set-PSReadLineKeyHandler -Key Ctrl+Q -Function TabCompletePrevious
Set-PSReadLineKeyHandler -Key Alt+d -Function ShellKillWord
Set-PSReadLineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineKeyHandler -Key Alt+b -Function ShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+f -Function ShellForwardWord
Set-PSReadLineKeyHandler -Key Alt+B -Function SelectShellBackwardWord
Set-PSReadLineKeyHandler -Key Alt+F -Function SelectShellForwardWord

Set-PSReadlineKeyHandler Alt+F4 -ScriptBlock { 
  (New-Object -ComObject WScript.Shell).SendKeys('%{F4}')
}

Set-PSReadlineKeyHandler Ctrl+f -ScriptBlock { 
  (New-Object -ComObject WScript.Shell).SendKeys('^f')
}

Set-PSReadlineKeyHandler Ctrl+F4 -ScriptBlock { 
  (New-Object -ComObject WScript.Shell).SendKeys('^{F4}')
}

Set-PSReadlineKeyHandler Ctrl+m -ScriptBlock { 
  (New-Object -ComObject WScript.Shell).SendKeys('^m')
}

Set-PSReadlineKeyHandler F11 -ScriptBlock { 
  (New-Object -ComObject WScript.Shell).SendKeys('{F11}')
}

Set-PSReadlineKeyHandler Ctrl+a -ScriptBlock { 
  $length = 0; $line = ''
  [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref] $line, [ref] $null)
  [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref] $null, [ref] $length)
  if ($length -eq $line.Length) { # whole line already selected -> select whole scroll-back buffer
    (New-Object -ComObject WScript.Shell).SendKeys('^a')
  } else { # select whole line
    [Microsoft.PowerShell.PSConsoleReadLine]::SelectAll()
  }
}

Import-Module posh-git

[System.Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", $null)
[System.Environment]::SetEnvironmentVariable("SSH_AGENT_PID", $null)
git config --global core.sshCommand C:/Windows/System32/OpenSSH/ssh.exe

$GitPromptSettings.DefaultPromptWriteStatusFirst = $true
$GitPromptSettings.DefaultPromptBeforeSuffix.Text = '`n$([DateTime]::now.ToString("MM-dd HH:mm:ss"))'
# $GitPromptSettings.DefaultPromptBeforeSuffix.Test = '`n$([DateTime]::now.ToString("MM-dd HH:mm:ss"))'

function Reload-Profile {
    @(
        $Profile.AllUsersAllHosts,
        $Profile.AllUsersCurrentHost,
        $Profile.CurrentUserAllHosts,
        $Profile.CurrentUserCurrentHost
     ) | % {
         if(Test-Path $_){
            Write-Verbose "Running $_"
            . $_
         }
     }
}

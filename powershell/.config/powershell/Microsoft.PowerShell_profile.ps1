oh-my-posh init pwsh --config "$PSScriptRoot/powerline.omp.json" | Invoke-Expression
Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -MaxTriggerCount 1 -Action {
    Set-PSReadLineKeyHandler -Chord Ctrl+d -Function ViExit
} | Out-Null

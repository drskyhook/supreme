$Date = Get-Date -Format "yyyy-MM-dd"
$Changelog = ".\CHANGELOG.md"

$Locks = @(
    @{
        Label = "Server Mods"
        ModsPath = ".\SUPREME_SERVER\mods"
        LockPath = "SUPREME_SERVER/mods/mods.lock.txt"
    },
    @{
        Label = "Client Mods"
        ModsPath = ".\SUPREME_CLIENT\mods"
        LockPath = "SUPREME_CLIENT/mods/mods.lock.txt"
    }
)

function Get-PreviousFile($path) {
    git show "HEAD:$path" 2>$null
}

function Get-CurrentFile($path) {
    if (Test-Path $path) { Get-Content $path } else { @() }
}

$entry = "`n# $Date`n"
$hasChanges = $false

foreach ($lock in $Locks) {
    $old = @(Get-PreviousFile $lock.LockPath)

    Get-ChildItem $lock.ModsPath -File -Filter "*.jar" |
        Sort-Object Name |
        ForEach-Object { $_.Name } |
        Set-Content $lock.LockPath

    $new = @(Get-CurrentFile $lock.LockPath)

    $added = $new | Where-Object { $_ -and ($_ -notin $old) }
    $removed = $old | Where-Object { $_ -and ($_ -notin $new) }

    if ($added.Count -gt 0 -or $removed.Count -gt 0) {
        $hasChanges = $true
        $entry += "`n## $($lock.Label)`n"

        if ($added.Count -gt 0) {
            $entry += "`n### Added`n"
            foreach ($m in $added) { $entry += "- $m`n" }
        }

        if ($removed.Count -gt 0) {
            $entry += "`n### Removed`n"
            foreach ($m in $removed) { $entry += "- $m`n" }
        }
    }
}

if ($hasChanges) {
    Add-Content $Changelog $entry
    Write-Host "Changelog updated."
} else {
    Write-Host "No mod changes detected."
}
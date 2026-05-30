$Root = Split-Path -Parent $MyInvocation.MyCommand.Path

$Targets = @(
    "$Root\SUPREME_SERVER\mods",
    "$Root\SUPREME_CLIENT\mods"
)

foreach ($ModsPath in $Targets) {
    if (Test-Path $ModsPath) {
        Get-ChildItem $ModsPath -File -Filter "*.jar" |
            Sort-Object Name |
            ForEach-Object { $_.Name } |
            Set-Content "$ModsPath\mods.lock.txt"
    }
}
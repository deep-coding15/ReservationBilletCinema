# Libere les ports 8081, 8090, 9083 (Serverpod) en arretant les processus qui les utilisent.
# Lancer avant "dart bin/main.dart" si vous avez "Failed to bind socket, port may already be in use".
# Usage: powershell -ExecutionPolicy Bypass -File stop_server_ports.ps1
#    ou: .\stop_server_ports.ps1

$ports = @(8081, 8090, 9083)
$pidsToKill = [System.Collections.Generic.HashSet[int]]::new()

$netstatOut = netstat -ano 2>$null
foreach ($line in $netstatOut) {
    if ($line -notmatch "LISTENING") { continue }
    foreach ($port in $ports) {
        if ($line -match ":$port\s") {
            # PID est le dernier nombre sur la ligne (format Windows: ... LISTENING 12345)
            if ($line -match "LISTENING\s+(\d+)\s*$") {
                [void]$pidsToKill.Add([int]$Matches[1])
            }
        }
    }
}

$pidsToKill = $pidsToKill | Where-Object { $_ -gt 0 }
if ($pidsToKill.Count -eq 0) {
    Write-Host "Aucun processus sur les ports 8081, 8090, 9083. Vous pouvez lancer: dart run bin/main.dart"
    exit 0
}

foreach ($procId in $pidsToKill) {
    $proc = Get-Process -Id $procId -ErrorAction SilentlyContinue
    $name = if ($proc) { $proc.ProcessName } else { "?" }
    Write-Host "Arret PID $procId ($name)..."
    Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
}
Write-Host "Ports liberes. Vous pouvez lancer: dart run bin/main.dart"

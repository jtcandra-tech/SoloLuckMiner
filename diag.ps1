$ErrorActionPreference = 'SilentlyContinue'
$eng = 'C:\Users\Public\sl-build\engine'
function Probe($name) {
  $exe = Join-Path $eng $name
  $out = Join-Path $env:TEMP ("diag_" + $name + ".txt")
  if (Test-Path $out) { Remove-Item $out -Force }
  $p = Start-Process -FilePath $exe -ArgumentList '-a','sha256d','--benchmark','-t','1' `
        -PassThru -WindowStyle Hidden -RedirectStandardOutput $out -RedirectStandardError ($out + '.err')
  Start-Sleep -Seconds 6
  $alive = -not $p.HasExited
  $code = if ($p.HasExited) { $p.ExitCode } else { 'running' }
  if ($alive) { $p.Kill() }
  Write-Host ("=== {0}: alive={1} exit={2}" -f $name, $alive, $code)
  $txt = Get-Content $out -ErrorAction SilentlyContinue
  $err = Get-Content ($out + '.err') -ErrorAction SilentlyContinue
  if ($txt) { Write-Host '  stdout:'; $txt | Select-Object -First 12 | ForEach-Object { Write-Host ('   ' + $_) } }
  if ($err) { Write-Host '  stderr:'; $err | Select-Object -First 12 | ForEach-Object { Write-Host ('   ' + $_) } }
}
Probe 'cpuminer-aes-sse42.exe'
Probe 'cpuminer-sse2.exe'

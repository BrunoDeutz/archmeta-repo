# ArchMeta launcher (Windows).
# Usage: .\archmeta.ps1 [repo-folder]
param([string]$Repo = $PWD)

$ErrorActionPreference = "Stop"
$version = if ($env:ARCHMETA_VERSION) { $env:ARCHMETA_VERSION } else { "2.0.0" }
$image   = "archmeta/archmeta:$version"
$port    = if ($env:ARCHMETA_HOST_PORT) { $env:ARCHMETA_HOST_PORT } else { "7777" }

$runtime = @("docker","podman","nerdctl") |
  Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } |
  Select-Object -First 1

if (-not $runtime) {
  Write-Error "No container runtime found. Install Podman Desktop, Rancher Desktop or Docker Desktop."
  exit 1
}

$repoPath = (Resolve-Path $Repo).Path

& $runtime image inspect $image *> $null
if ($LASTEXITCODE -ne 0) { & $runtime pull $image }

# Windows containers run under the image's own user; no UID mapping is needed
# because the runtime's VM handles ownership translation.
$args = @(
  "run","--rm","-it","--name","archmeta",
  "-p","127.0.0.1:${port}:7777",
  "-v","${repoPath}:/repo"
)

$gitconfig = Join-Path $HOME ".gitconfig"
if (Test-Path $gitconfig) { $args += @("-v","${gitconfig}:/home/archmeta/.gitconfig:ro") }

$args += $image

Write-Host "ArchMeta starting on http://127.0.0.1:$port  (repo: $repoPath)"
Start-Job { Start-Sleep 12; Start-Process "http://127.0.0.1:$using:port" } | Out-Null
& $runtime @args

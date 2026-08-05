[CmdletBinding()]
param(
  [string]$Repository = 'https://git.gay/CatAnnaDev/nvim-config.git',
  [string]$Branch = 'windows',
  [switch]$SkipDependencies,
  [switch]$SkipOptional,
  [switch]$Force
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (Test-Path 'variable:PSNativeCommandUseErrorActionPreference') {
  $PSNativeCommandUseErrorActionPreference = $false
}

$ConfigPath = Join-Path $env:LOCALAPPDATA 'nvim'
$DataPath = Join-Path $env:LOCALAPPDATA 'nvim-data'

$RequiredPackages = [ordered]@{
  'Git.Git'                  = 'git'
  'Neovim.Neovim'            = 'nvim'
  'BurntSushi.ripgrep.MSVC'  = 'rg'
  'sharkdp.fd'               = 'fd'
  'zig.zig'                  = 'zig'
  'OpenJS.NodeJS.LTS'        = 'node'
  'Rustlang.Rustup'          = 'rustup'
}

$OptionalPackages = [ordered]@{
  'Neovide.Neovide'                = 'neovide'
  'JesseDuffield.lazygit'          = 'lazygit'
  'ImageMagick.ImageMagick'        = 'magick'
  'Python.Python.3.12'             = 'python'
  'Microsoft.DotNet.SDK.9'         = 'dotnet'
  'Kitware.CMake'                  = 'cmake'
  'EclipseAdoptium.Temurin.21.JDK' = ''
  'EclipseAdoptium.Temurin.25.JDK' = ''
  'DEVCOM.JetBrainsMonoNerdFont'   = ''
}

function Write-Step { param([string]$Message) Write-Host ''; Write-Host "==> $Message" -ForegroundColor Magenta }
function Write-Detail { param([string]$Message) Write-Host "    $Message" -ForegroundColor DarkGray }
function Write-Ok { param([string]$Message) Write-Host "    $Message" -ForegroundColor Green }
function Write-Warn { param([string]$Message) Write-Host "    $Message" -ForegroundColor Yellow }

function Test-Command {
  param([string]$Name)
  return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Update-SessionPath {
  $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
  $user = [Environment]::GetEnvironmentVariable('Path', 'User')
  $env:Path = (@($machine, $user) | Where-Object { $_ }) -join ';'
}

function Install-WingetPackage {
  param([string]$Id, [string]$CommandName, [switch]$Optional)

  if ($CommandName -and (Test-Command $CommandName)) {
    Write-Detail "$Id deja installe"
    return $true
  }

  Write-Detail "installation de $Id"
  $level = if ($Optional) { 'optionnel' } else { 'REQUIS' }

  try {
    $output = winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements 2>&1
  }
  catch {
    Write-Warn "echec sur $Id ($level) : $($_.Exception.Message)"
    return $false
  }

  if ($LASTEXITCODE -eq 0) {
    Update-SessionPath
    Write-Ok "$Id installe"
    return $true
  }

  if ($output -match 'No newer package versions|already installed|No available upgrade') {
    Write-Detail "$Id deja a jour"
    return $true
  }

  Write-Warn "echec sur $Id ($level, code $LASTEXITCODE)"
  return $false
}

function Install-PackageSet {
  param([System.Collections.Specialized.OrderedDictionary]$Packages, [switch]$Optional)
  $failed = @()
  foreach ($id in $Packages.Keys) {
    $command = $Packages[$id]
    $ok = Install-WingetPackage -Id $id -CommandName $command -Optional:$Optional
    if (-not $ok) { $failed += $id }
  }
  return , $failed
}

function Backup-ExistingConfig {
  param([string]$Path)
  if (-not (Test-Path $Path)) { return }

  if (Test-Path (Join-Path $Path '.git')) {
    Write-Detail 'depot git existant detecte'
    return
  }

  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $backup = "$Path.backup-$stamp"
  Write-Warn "config existante sauvegardee vers $backup"
  Move-Item -LiteralPath $Path -Destination $backup
}

function Sync-Repository {
  param([string]$Path, [string]$Url, [string]$BranchName)

  if (Test-Path (Join-Path $Path '.git')) {
    Write-Detail "mise a jour de $Path"
    git -C $Path fetch origin $BranchName
    git -C $Path checkout $BranchName
    git -C $Path pull --ff-only origin $BranchName
    return
  }

  Write-Detail "clone de $Url ($BranchName)"
  git clone --branch $BranchName $Url $Path
}

function Invoke-Neovim {
  param([string]$Arguments, [string]$Description, [int]$TimeoutSeconds = 900)

  Write-Detail $Description
  $process = Start-Process -FilePath 'nvim' -ArgumentList $Arguments -NoNewWindow -PassThru
  if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
    $process.Kill()
    Write-Warn "$Description : delai depasse ($TimeoutSeconds s)"
    return $false
  }
  if ($process.ExitCode -ne 0) {
    Write-Warn "$Description : code de sortie $($process.ExitCode)"
    return $false
  }
  Write-Ok "$Description : ok"
  return $true
}

function Test-Toolchain {
  $checks = [ordered]@{
    'nvim'     = 'Neovim'
    'git'      = 'Git'
    'rg'       = 'ripgrep (recherche projet, strip-comments)'
    'fd'       = 'fd (pickers snacks)'
    'zig'      = 'zig (compilation des parsers treesitter)'
    'node'     = 'Node (serveurs LSP bases sur npm)'
    'cargo'    = 'Rust toolchain (rust-analyzer, codesnap)'
    'neovide'  = 'Neovide (requis pour les raccourcis Ctrl+Shift et Ctrl+/)'
    'lazygit'  = 'lazygit (Alt+9)'
    'magick'   = 'ImageMagick (previsualisation image)'
    'chafa'    = 'chafa (rendu image en terminal, non fourni par winget)'
    'dotnet'   = '.NET SDK (C# / Unity)'
    'java'     = 'JDK (Hytale / gradle)'
  }
  Write-Step 'Verification de la chaine d outils'
  foreach ($name in $checks.Keys) {
    if (Test-Command $name) {
      Write-Ok "$name - $($checks[$name])"
    }
    else {
      Write-Warn "$name absent - $($checks[$name])"
    }
  }
}

Write-Host ''
Write-Host '  Installation de la config Neovim (branche Windows)' -ForegroundColor Magenta
Write-Host "  config : $ConfigPath" -ForegroundColor DarkGray
Write-Host "  donnees: $DataPath" -ForegroundColor DarkGray

if (-not (Test-Command 'winget')) {
  throw 'winget est introuvable. Installez App Installer depuis le Microsoft Store, puis relancez.'
}

if (-not $SkipDependencies) {
  Write-Step 'Dependances requises'
  $failedRequired = Install-PackageSet -Packages $RequiredPackages
  if ($failedRequired.Count -gt 0 -and -not $Force) {
    throw "Paquets requis en echec : $($failedRequired -join ', '). Relancez avec -Force pour ignorer."
  }

  if (-not $SkipOptional) {
    Write-Step 'Dependances optionnelles'
    Install-PackageSet -Packages $OptionalPackages -Optional | Out-Null
  }

  Update-SessionPath
}

if (-not (Test-Command 'nvim')) {
  throw 'nvim reste introuvable dans le PATH. Ouvrez un nouveau terminal et relancez le script.'
}

Write-Step 'Recuperation de la configuration'
Backup-ExistingConfig -Path $ConfigPath
Sync-Repository -Path $ConfigPath -Url $Repository -BranchName $Branch
Write-Ok "configuration en place dans $ConfigPath"

Write-Step 'Installation des plugins'
Invoke-Neovim -Arguments '--headless "+Lazy! sync" +qa' -Description 'lazy.nvim (telechargement)' | Out-Null
Invoke-Neovim -Arguments '--headless "+Lazy! restore" +qa' -Description 'lazy.nvim (versions du lock)' | Out-Null

Write-Step 'Installation des outils Mason'
Invoke-Neovim -Arguments '--headless +MasonToolsInstallSync +qa' -Description 'mason-tool-installer' | Out-Null

Write-Step 'Compilation des parsers treesitter'
Invoke-Neovim -Arguments '--headless +TSUpdateSync +qa' -Description 'nvim-treesitter' | Out-Null

if (Test-Command 'rustup') {
  Write-Step 'Composants Rust'
  rustup component add rust-analyzer rust-src *>&1 | Out-Null
  if ($LASTEXITCODE -eq 0) {
    Write-Ok 'rust-analyzer et rust-src ajoutes au toolchain'
  }
  else {
    Write-Warn 'rustup component add a echoue - rustaceanvim utilisera le rust-analyzer du PATH'
  }
}

Test-Toolchain

Write-Host ''
Write-Host '  Termine.' -ForegroundColor Magenta
Write-Host '  Lancez neovide (recommande) ou nvim.' -ForegroundColor DarkGray
Write-Host '  La touche Cmd de macOS est remappee : voir README-windows.md.' -ForegroundColor DarkGray
Write-Host '  Alt+? affiche la cheatsheet avec les raccourcis Windows.' -ForegroundColor DarkGray
Write-Host ''

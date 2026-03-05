# Project Standards Installer
#
# Windows PowerShell:
#   irm https://raw.githubusercontent.com/antonkoetzler/project-standards/main/install.ps1 | iex
#
# Or download and run directly:
#   .\install.ps1 [--dry-run]
#
# Dry-run via environment variable (works with iex):
#   $env:DRY_RUN = "1"; irm ... | iex

$ErrorActionPreference = 'Stop'
$REPO = 'https://raw.githubusercontent.com/antonkoetzler/project-standards/main'
$DryRun = ($args -contains '--dry-run') -or ($args -contains '-n') -or ($env:DRY_RUN -eq '1')

# Require an interactive console
if (-not [Environment]::UserInteractive) {
  Write-Host 'Error: This script requires an interactive PowerShell console.' -ForegroundColor Red
  Write-Host 'Run: irm <url> | iex   (in a real PowerShell window, not piped)' -ForegroundColor DarkGray
  exit 1
}

function script:Safe-Clear   { try { [Console]::Clear()        } catch { Write-Host '' } }
function script:Safe-ReadKey { try { [Console]::ReadKey($true) } catch { Read-Host | Out-Null; return $null } }

# ── Safe name: strip languages/ or practices/ prefix, replace / with _ ────────
function Get-SafeName {
  param([string]$Path)
  $p = $Path -replace '^(languages|practices)/', ''
  return $p -replace '/', '_'
}

# ── Language data ─────────────────────────────────────────────────────────────
# @(Label, RepoPath, Glob)
$LangItems = @(
  @('CSS / Tailwind',           'languages/css/tailwind',     '**/*.css,**/*.html,**/*.tsx'),
  @('Dart (general)',            'languages/dart',             '**/*.dart'),
  @('Dart / Flutter',           'languages/dart/flutter',     '**/*.dart'),
  @('TypeScript (general)',     'languages/typescript',       '**/*.ts,**/*.tsx'),
  @('TypeScript / React',       'languages/typescript/react', '**/*.tsx'),
  @('TypeScript / Node.js',     'languages/typescript/node',  '**/*.ts'),
  @('JavaScript',               'languages/javascript',       '**/*.js,**/*.mjs'),
  @('Python',                   'languages/python',           '**/*.py'),
  @('Go',                       'languages/go',               '**/*.go'),
  @('Rust',                     'languages/rust',             '**/*.rs'),
  @('Java',                     'languages/java',             '**/*.java'),
  @('C',                        'languages/c',                '**/*.c,**/*.h'),
  @('C++',                      'languages/cpp',              '**/*.cpp,**/*.hpp'),
  @('C#',                       'languages/csharp',           '**/*.cs')
)

# ── Practice data ─────────────────────────────────────────────────────────────
# @(Label, RepoPath, Glob, AlwaysApply)  AlwaysApply: $true/$false
$PracticeItems = @(
  @('Engineering (SOLID, clean code, DRY)', 'practices/engineering',   '**/*',                                  $true),
  @('Workflow (Makefile, DAP, no IDE)',      'practices/workflow',      '**/*',                                  $true),
  @('Git & version control',                'practices/git',           '**/*',                                  $true),
  @('API design',                           'practices/api',           '**/*',                                  $true),
  @('Security',                             'practices/security',      '**/*',                                  $true),
  @('SQL / Database',                       'practices/sql',           '**/*.sql,**/*.prisma,**/*.graphql',      $false),
  @('Design (UI/UX)',                       'practices/design',        '**/*.css,**/*.html,**/*.tsx,**/*.vue',   $false),
  @('Observability',                        'practices/observability', '**/*',                                  $true),
  @('Testing strategy',                     'practices/testing',       '**/*.test.*,**/*.spec.*',               $false)
)

$ToolItems = @(
  @('Claude Code / Antigravity', 'claude'),
  @('Cursor',                    'cursor'),
  @('Windsurf',                  'windsurf'),
  @('GitHub Copilot',            'copilot')
)

$LangSel     = @($LangItems     | ForEach-Object { $false })
$PracticeSel = @($PracticeItems | ForEach-Object { $false })
$ToolSel     = @($ToolItems     | ForEach-Object { $false })

# ── Shared menu state ─────────────────────────────────────────────────────────
$script:MenuLabels  = @()
$script:MenuSel     = @()
$script:MenuCursor  = 0

# ── Drawing ───────────────────────────────────────────────────────────────────
function Draw-Menu {
  param([string]$Title)
  Safe-Clear

  Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan
  Write-Host '  |     Project Standards Installer           |' -ForegroundColor Cyan
  Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan
  Write-Host ''
  Write-Host "  $Title" -ForegroundColor White
  Write-Host '  up/dn navigate   Space toggle   Enter confirm   Ctrl+C abort' -ForegroundColor DarkGray
  Write-Host ''

  $n = $script:MenuLabels.Count
  for ($i = 0; $i -lt $n; $i++) {
    $label = $script:MenuLabels[$i]
    $sel   = $script:MenuSel[$i]
    $cur   = ($i -eq $script:MenuCursor)

    if ($cur) {
      Write-Host -NoNewline '  > ' -ForegroundColor Yellow
    } else {
      Write-Host -NoNewline '    '
    }

    if ($sel) {
      Write-Host -NoNewline '[' -ForegroundColor Green
      Write-Host -NoNewline (([char]0x2713).ToString()) -ForegroundColor Green
      Write-Host -NoNewline '] ' -ForegroundColor Green
    } else {
      Write-Host -NoNewline '[ ] ' -ForegroundColor DarkGray
    }

    if ($cur) {
      Write-Host $label -ForegroundColor Yellow
    } elseif ($sel) {
      Write-Host $label
    } else {
      Write-Host $label -ForegroundColor DarkGray
    }
  }
  Write-Host ''
}

function Invoke-Menu {
  param([string]$Title)
  $script:MenuCursor = 0
  $n = $script:MenuLabels.Count

  while ($true) {
    Draw-Menu -Title $Title
    $key = Safe-ReadKey

    switch ($key.Key) {
      'UpArrow'   { $script:MenuCursor = (($script:MenuCursor - 1 + $n) % $n) }
      'DownArrow' { $script:MenuCursor = (($script:MenuCursor + 1) % $n) }
      'Spacebar'  { $script:MenuSel[$script:MenuCursor] = -not $script:MenuSel[$script:MenuCursor] }
      'Enter'     { return }
      default     {
        if ($key.Key -eq 'C' -and ($key.Modifiers -band [ConsoleModifiers]::Control)) {
          Safe-Clear; Write-Host 'Aborted.'; exit 1
        }
      }
    }
  }
}

# ── Fetch helper ──────────────────────────────────────────────────────────────
function Get-RemoteText {
  param([string]$Url)
  try {
    return (Invoke-RestMethod -Uri $Url -UseBasicParsing -ErrorAction Stop)
  } catch {
    return $null
  }
}

# ── Write file (respects dry-run) ─────────────────────────────────────────────
function Write-ProjectFile {
  param([string]$Path, [string]$Content)
  if ($DryRun) {
    Write-Host "  [dry-run] $Path" -ForegroundColor DarkGray
    return
  }
  $dir = Split-Path -Path $Path -Parent
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }
  Set-Content -Path $Path -Value $Content -Encoding UTF8 -Force
}

# ── Write once (only if file does not already exist) ─────────────────────────
function Write-ProjectFileOnce {
  param([string]$Path, [string]$Content)
  if ($DryRun) {
    if (Test-Path $Path) {
      Write-Host "  [dry-run] $Path (already exists -- skipped)" -ForegroundColor DarkGray
    } else {
      Write-Host "  [dry-run] $Path (would create)" -ForegroundColor DarkGray
    }
    return
  }
  if (Test-Path $Path) { return }
  $dir = Split-Path -Path $Path -Parent
  if ($dir -and -not (Test-Path $dir)) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
  }
  Set-Content -Path $Path -Value $Content -Encoding UTF8 -Force
}

# ── Main installer ────────────────────────────────────────────────────────────
function Start-Install {
  # Collect selections
  $selPaths   = @(); $selLabels  = @(); $selGlobs  = @(); $selAlways = @()
  $selTools   = @()

  for ($i = 0; $i -lt $LangItems.Count; $i++) {
    if ($LangSel[$i]) {
      $selPaths  += $LangItems[$i][1]
      $selLabels += $LangItems[$i][0]
      $selGlobs  += $LangItems[$i][2]
      $selAlways += $false
    }
  }
  for ($i = 0; $i -lt $PracticeItems.Count; $i++) {
    if ($PracticeSel[$i]) {
      $selPaths  += $PracticeItems[$i][1]
      $selLabels += $PracticeItems[$i][0]
      $selGlobs  += $PracticeItems[$i][2]
      $selAlways += $PracticeItems[$i][3]
    }
  }
  for ($i = 0; $i -lt $ToolItems.Count; $i++) {
    if ($ToolSel[$i]) { $selTools += $ToolItems[$i][1] }
  }

  if ($selPaths.Count -eq 0 -and $selTools.Count -eq 0) {
    Safe-Clear; Write-Host '  Nothing selected.' -ForegroundColor Yellow; exit 0
  }

  # ── Confirmation ─────────────────────────────────────────────────────────
  Safe-Clear
  Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan
  Write-Host '  |     Project Standards Installer           |' -ForegroundColor Cyan
  Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan
  Write-Host ''

  if ($DryRun) { Write-Host '  DRY RUN -- no files will be written' -ForegroundColor Yellow; Write-Host '' }

  Write-Host '  Install into:' -ForegroundColor White
  Write-Host "  $(Get-Location)" -ForegroundColor Cyan
  Write-Host ''

  if ($selLabels.Count -gt 0) {
    Write-Host '  Selected:' -ForegroundColor White
    foreach ($lbl in $selLabels) { Write-Host "    [+] $lbl" -ForegroundColor Green }
    Write-Host ''
  }

  if ($selTools.Count -gt 0) {
    Write-Host '  AI tools:' -ForegroundColor White
    foreach ($t in $selTools) {
      switch ($t) {
        'claude'   { Write-Host '    [+] Claude Code  ->  CLAUDE.md'              -ForegroundColor Green }
        'cursor'   { Write-Host '    [+] Cursor        ->  .cursor\rules\'        -ForegroundColor Green }
        'windsurf' { Write-Host '    [+] Windsurf      ->  .windsurf\rules\'      -ForegroundColor Green }
        'copilot'  { Write-Host '    [+] Copilot       ->  .github\instructions\' -ForegroundColor Green }
      }
    }
    Write-Host ''
  }

  Write-Host '  WARNING: The following will be completely replaced if they exist:' -ForegroundColor Yellow
  Write-Host '    CLAUDE.md' -ForegroundColor Yellow
  Write-Host '    .cursor\rules\       (entire directory)' -ForegroundColor Yellow
  Write-Host '    .windsurf\rules\     (entire directory)' -ForegroundColor Yellow
  Write-Host '    .github\instructions\(entire directory)' -ForegroundColor Yellow
  Write-Host '    .github\copilot-instructions.md' -ForegroundColor Yellow
  Write-Host '    docs\*.md            (managed files -- docs\custom\ is never touched)' -ForegroundColor Yellow
  Write-Host ''

  Write-Host '  Is this correct? [y/N] ' -ForegroundColor White -NoNewline
  $confirm = Read-Host
  Write-Host ''

  if ($confirm -notmatch '^[Yy]$') {
    Safe-Clear; Write-Host 'Aborted.'; exit 0
  }

  # ── Clear AI tool config directories ─────────────────────────────────────
  if (-not $DryRun -and $selTools.Count -gt 0) {
    foreach ($t in $selTools) {
      switch ($t) {
        'cursor'   { if (Test-Path '.cursor\rules')   { Remove-Item '.cursor\rules'   -Recurse -Force } }
        'windsurf' { if (Test-Path '.windsurf\rules') { Remove-Item '.windsurf\rules' -Recurse -Force } }
        'copilot'  {
          if (Test-Path '.github\instructions')           { Remove-Item '.github\instructions' -Recurse -Force }
          if (Test-Path '.github\copilot-instructions.md') { Remove-Item '.github\copilot-instructions.md' -Force }
        }
        'claude'   { if (Test-Path 'CLAUDE.md') { Remove-Item 'CLAUDE.md' -Force } }
      }
    }
  }

  # ── Fetch into docs\ ──────────────────────────────────────────────────────
  $okPaths  = @(); $okLabels = @(); $okGlobs = @(); $okAlways = @()

  for ($i = 0; $i -lt $selPaths.Count; $i++) {
    $path   = $selPaths[$i]
    $label  = $selLabels[$i]
    $glob   = $selGlobs[$i]
    $always = $selAlways[$i]
    $safe   = Get-SafeName $path

    Write-Host "  Fetching $label... " -NoNewline
    $content = Get-RemoteText "$REPO/$path/RULES.md"

    if ($null -ne $content) {
      Write-ProjectFile "docs\$safe.md" $content
      $okPaths  += $path
      $okLabels += $label
      $okGlobs  += $glob
      $okAlways += $always
      Write-Host 'done' -ForegroundColor Green
    } else {
      Write-Host 'failed (skipped)' -ForegroundColor Red
    }
  }

  if ($okPaths.Count -eq 0 -and $selTools.Count -gt 0) {
    Write-Host ''
    Write-Host '  No standards fetched -- nothing to write.' -ForegroundColor Red
    exit 1
  }

  # ── docs\custom\ ─────────────────────────────────────────────────────────
  $customReadme = @"
# docs/custom/

This folder is yours. The installer never touches it.

Create <safe_name>.md files here to add project-specific rules on top of the
upstream standards. File names must match the safe names used in docs/:

  dart.md, dart_flutter.md, typescript.md, engineering.md, git.md, etc.

All AI tool configs include a comment pointing here so you know where to extend.
"@
  Write-ProjectFileOnce 'docs\custom\README.md' $customReadme

  Write-Host ''

  # ── Generate AI tool configs ───────────────────────────────────────────────
  foreach ($tool in $selTools) {
    Write-Host "  Generating $tool config... " -NoNewline

    switch ($tool) {

      'claude' {
        $md = "# Project Rules`n`nStandards are stored in ``docs/``. Files below are auto-loaded into context.`n"
        for ($i = 0; $i -lt $okPaths.Count; $i++) {
          $safe = Get-SafeName $okPaths[$i]
          $md  += "`n@docs/$safe.md"
          $md  += "`n# @docs/custom/$safe.md (create to extend)"
        }
        Write-ProjectFile 'CLAUDE.md' $md
      }

      'cursor' {
        for ($i = 0; $i -lt $okPaths.Count; $i++) {
          $path   = $okPaths[$i]; $label = $okLabels[$i]; $glob = $okGlobs[$i]; $always = $okAlways[$i]
          $safe   = Get-SafeName $path
          $alwaysStr = if ($always) { 'true' } else { 'false' }
          $mdc    = "---`ndescription: $label standards`nglobs: $glob`nalwaysApply: $alwaysStr`n---`n`n@docs/$safe.md`n# Custom additions: create docs/custom/$safe.md to extend"
          Write-ProjectFile ".cursor\rules\$safe.mdc" $mdc
        }
      }

      'windsurf' {
        for ($i = 0; $i -lt $okPaths.Count; $i++) {
          $path = $okPaths[$i]; $glob = $okGlobs[$i]; $always = $okAlways[$i]
          $safe = Get-SafeName $path
          $ws   = if ($always) {
            "---`ntrigger: always_on`n---`n`n@docs/$safe.md`n# Custom additions: create docs/custom/$safe.md to extend"
          } else {
            "---`ntrigger: glob`nglobs: $glob`n---`n`n@docs/$safe.md`n# Custom additions: create docs/custom/$safe.md to extend"
          }
          Write-ProjectFile ".windsurf\rules\$safe.md" $ws
        }
      }

      'copilot' {
        $idx = "# Copilot Instructions`n`nPer-language and practice rules in ``.github\instructions\`` -- each references ``docs\``.`n"
        for ($i = 0; $i -lt $okPaths.Count; $i++) {
          $path = $okPaths[$i]; $glob = $okGlobs[$i]
          $safe = Get-SafeName $path
          $inst = "---`napplyTo: `"$glob`"`n---`n`n@docs/$safe.md`n# Custom additions: create docs/custom/$safe.md to extend"
          Write-ProjectFile ".github\instructions\$safe.instructions.md" $inst
          $idx += "`n- ``$safe`` -> ``.github\instructions\$safe.instructions.md``"
        }
        Write-ProjectFile '.github\copilot-instructions.md' $idx
      }
    }

    Write-Host 'done' -ForegroundColor Green
  }

  # ── Done ─────────────────────────────────────────────────────────────────
  Write-Host ''
  if ($DryRun) {
    Write-Host '  Dry run complete -- no files written.' -ForegroundColor Yellow
  } else {
    Write-Host '  Done!' -ForegroundColor Green
    Write-Host ''
    Write-Host '  docs\              standards content (overwritten on re-run)' -ForegroundColor White
    Write-Host '  docs\custom\       your permanent zone (never touched by installer)' -ForegroundColor White
    Write-Host '  AI tool configs    reference docs\ -- use docs\custom\ to extend.' -ForegroundColor DarkGray
  }
  Write-Host ''
}

# ── Entry point ───────────────────────────────────────────────────────────────
Safe-Clear
Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan
Write-Host '  |     Project Standards Installer           |' -ForegroundColor Cyan
Write-Host '  +-------------------------------------------+' -ForegroundColor Cyan
Write-Host ''
Write-Host "  Installing into: $(Get-Location)" -ForegroundColor Cyan
if ($DryRun) { Write-Host '  Mode: dry run' -ForegroundColor Yellow }
Write-Host ''
Write-Host '  Press any key to start...' -ForegroundColor DarkGray
$null = Safe-ReadKey

# Step 1 — Languages
$script:MenuLabels = @($LangItems | ForEach-Object { $_[0] })
$script:MenuSel    = @($LangSel)
Invoke-Menu -Title 'Step 1 of 3 -- Languages / frameworks'
for ($i = 0; $i -lt $script:MenuSel.Count; $i++) { $LangSel[$i] = $script:MenuSel[$i] }

# Step 2 — Practices
$script:MenuLabels = @($PracticeItems | ForEach-Object { $_[0] })
$script:MenuSel    = @($PracticeSel)
Invoke-Menu -Title 'Step 2 of 3 -- Practices'
for ($i = 0; $i -lt $script:MenuSel.Count; $i++) { $PracticeSel[$i] = $script:MenuSel[$i] }

# Step 3 — Tools
$script:MenuLabels = @($ToolItems | ForEach-Object { $_[0] })
$script:MenuSel    = @($ToolSel)
Invoke-Menu -Title 'Step 3 of 3 -- AI tools to configure'
for ($i = 0; $i -lt $script:MenuSel.Count; $i++) { $ToolSel[$i] = $script:MenuSel[$i] }

Start-Install

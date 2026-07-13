$ErrorActionPreference = "Stop"

$workflowPath = ".github/workflows/deploy-pages.yml"
if (Test-Path -LiteralPath $workflowPath) {
  $workflow = Get-Content -Raw -Encoding UTF8 -LiteralPath $workflowPath
  $requiredContent = @(
    "push:",
    "branches: [main]",
    "workflow_dispatch:",
    "actions/checkout@v4",
    "actions/setup-node@v4",
    "node-version: 20",
    "npm ci",
    "npm test",
    "actions/configure-pages@v5",
    "actions/upload-pages-artifact@v3",
    "path: dist",
    "actions/deploy-pages@v4",
    "contents: read",
    "pages: write",
    "id-token: write",
    "group: pages",
    "needs: build",
    "name: github-pages",
    'url: ${{ steps.deployment.outputs.page_url }}'
  )

  foreach ($needle in $requiredContent) {
    if ($workflow.IndexOf($needle, [System.StringComparison]::Ordinal) -lt 0) {
      throw "GitHub Pages workflow is missing: $needle"
    }
  }

  if ($workflow -notmatch '(?ms)^permissions:\s*\r?\n\s+contents:\s*read\s*\r?\n\s*\r?\nconcurrency:') {
    throw "Top-level workflow permissions must be limited to contents: read"
  }

  if ($workflow -notmatch '(?ms)^\s{2}deploy:\s*\r?\n(?:.*\r?\n)*?\s{4}permissions:\s*\r?\n\s{6}pages:\s*write\s*\r?\n\s{6}id-token:\s*write') {
    throw "Deploy job must own pages and id-token write permissions"
  }
} else {
  Write-Host "Skipping GitHub Pages workflow checks because $workflowPath is not present."
}

$package = Get-Content -Raw -Encoding UTF8 -LiteralPath "package.json"
if ($package.IndexOf('node scripts/run-powershell-tests.mjs', [System.StringComparison]::Ordinal) -lt 0) {
  throw "npm test must use the cross-platform PowerShell runner"
}

$runnerPath = "scripts/run-powershell-tests.mjs"
if (-not (Test-Path -LiteralPath $runnerPath)) {
  throw "Missing cross-platform PowerShell runner: $runnerPath"
}

$runner = Get-Content -Raw -Encoding UTF8 -LiteralPath $runnerPath
foreach ($needle in @('process.platform === "win32"', '"powershell"', '"pwsh"')) {
  if ($runner.IndexOf($needle, [System.StringComparison]::Ordinal) -lt 0) {
    throw "PowerShell runner is missing: $needle"
  }
}

Write-Host "Deployment config checks passed."

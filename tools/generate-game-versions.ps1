[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$InputCsv,

    [Parameter(Mandatory = $false)]
    [string]$OutputJson = "manifest/game-versions.json",

    [Parameter(Mandatory = $false)]
    [string]$BossRushManifestId = "9199065605303375081",

    [Parameter(Mandatory = $false)]
    [string]$SteamAppId = "2226280",

    [Parameter(Mandatory = $false)]
    [string]$SteamDepotId = "2226283"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (!(Test-Path $InputCsv)) {
    throw "Input CSV not found: $InputCsv"
}

$rows = Import-Csv -Path $InputCsv
if (-not $rows -or $rows.Count -eq 0) {
    throw "Input CSV is empty."
}

$normalRows = @()
$bossRows = @()

foreach ($row in $rows) {
    $manifestId = "$($row.manifestId)".Trim()
    $date = "$($row.releaseDateUtc)".Trim()
    if (-not $manifestId -or -not $date) {
        continue
    }

    $track = "$($row.track)".Trim().ToLowerInvariant()
    if (-not $track) {
        if ($manifestId -eq $BossRushManifestId) {
            $track = "boss-rush"
        } else {
            $track = "bapbap"
        }
    }

    $item = [PSCustomObject]@{
        manifestId = $manifestId
        releaseDateUtc = $date
        displayName = "$($row.displayName)".Trim()
        gameVersion = "$($row.gameVersion)".Trim()
        imagePath = "$($row.imagePath)".Trim()
        track = $track
    }

    if ($track -eq "boss-rush") {
        $bossRows += $item
    } else {
        $normalRows += $item
    }
}

if ($bossRows.Count -lt 1) {
    throw "No boss-rush row found. Provide one row with track=boss-rush or manifestId=$BossRushManifestId."
}

$normalSorted = $normalRows | Sort-Object { [DateTime]::Parse($_.releaseDateUtc) } -Descending
$bossSorted = $bossRows | Sort-Object { [DateTime]::Parse($_.releaseDateUtc) } -Descending

$versions = @()
$order = 0

foreach ($row in $normalSorted) {
    $id = if ($order -eq 0) { "latest" } else { "build-$($row.releaseDateUtc.Substring(0,10))" }
    $display = if ($order -eq 0) { "BAPBAP" } elseif ($row.displayName) { $row.displayName } else { "BAPBAP Build $($row.releaseDateUtc.Substring(0,10))" }
    $gameVersion = if ($row.gameVersion) { $row.gameVersion } else { "build-$($row.releaseDateUtc.Substring(0,10))" }
    $image = if ($row.imagePath) { $row.imagePath } else { "manifest/assets/instances/latest.png" }

    $versions += [ordered]@{
        id = $id
        track = "bapbap"
        gameVersion = $gameVersion
        displayName = $display
        description = if ($order -eq 0) { "Latest official BAPBAP release." } else { "Official snapshot from $($row.releaseDateUtc.Substring(0,10))." }
        imagePath = $image
        steamManifestId = $row.manifestId
        releaseDateUtc = $row.releaseDateUtc
        recommended = ($order -eq 0)
        order = $order
    }
    $order++
}

$boss = $bossSorted[0]
$versions += [ordered]@{
    id = "boss-rush"
    track = "boss-rush"
    gameVersion = if ($boss.gameVersion) { $boss.gameVersion } else { "boss-rush" }
    displayName = if ($boss.displayName) { $boss.displayName } else { "Boss Rush" }
    description = "Boss Rush branch snapshot."
    imagePath = if ($boss.imagePath) { $boss.imagePath } else { "manifest/assets/instances/boss-rush.png" }
    steamManifestId = $boss.manifestId
    releaseDateUtc = $boss.releaseDateUtc
    order = 0
}

$doc = [ordered]@{
    schemaVersion = 2
    steamAppId = $SteamAppId
    steamDepotId = $SteamDepotId
    versions = $versions
}

$outputDir = Split-Path -Parent $OutputJson
if ($outputDir -and !(Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$doc | ConvertTo-Json -Depth 10 | Set-Content -Path $OutputJson -Encoding UTF8
Write-Host "Wrote $OutputJson with $($versions.Count) version entries."

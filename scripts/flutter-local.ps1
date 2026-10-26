param(
    [switch]$CheckOnly,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FlutterArgs
)

$ErrorActionPreference = 'Stop'
$ticklyRoot = Split-Path -Parent $PSScriptRoot
$ticklyTemp = Join-Path $ticklyRoot '.dart_tool/tickly-temp'
$ticklyGradleCache = 'E:/GradleCache/tickly'
$ticklyJavaTemp = 'E:/FlutterTemp'
$ticklyAndroidHome = Join-Path $ticklyRoot '.dart_tool/android-user-home'
foreach ($ticklyDirectory in @($ticklyTemp, $ticklyGradleCache, $ticklyJavaTemp, $ticklyAndroidHome)) {
    New-Item -ItemType Directory -Path $ticklyDirectory -Force | Out-Null
}

# Preserve the existing debug signing identity after flutter clean.
$ticklyOriginalKey = Join-Path $env:USERPROFILE '.android/debug.keystore'
$ticklyLocalKey = Join-Path $ticklyAndroidHome 'debug.keystore'
if ((Test-Path -LiteralPath $ticklyOriginalKey) -and -not (Test-Path -LiteralPath $ticklyLocalKey)) {
    Copy-Item -LiteralPath $ticklyOriginalKey -Destination $ticklyLocalKey
}
# Scope TEMP/TMP to this command; preserve the caller's environment.
$ticklyPreviousTemp = $env:TEMP
$ticklyPreviousTmp = $env:TMP
$ticklyPreviousGradleHome = $env:GRADLE_USER_HOME
$ticklyPreviousJavaOptions = $env:JAVA_TOOL_OPTIONS
$ticklyPreviousAndroidHome = $env:ANDROID_USER_HOME
$ticklyExitCode = 0
Push-Location -LiteralPath $ticklyRoot
try {
    $env:TEMP = $ticklyTemp
    $env:TMP = $ticklyTemp
    $env:GRADLE_USER_HOME = $ticklyGradleCache
    $env:ANDROID_USER_HOME = $ticklyAndroidHome
    $env:JAVA_TOOL_OPTIONS = "$ticklyPreviousJavaOptions -Djava.io.tmpdir=$ticklyJavaTemp".Trim()
    $ticklyProbe = Join-Path $ticklyTemp ([guid]::NewGuid().ToString() + '.tmp')
    [System.IO.File]::WriteAllText($ticklyProbe, 'Tickly temp check')
    Remove-Item -LiteralPath $ticklyProbe
    Write-Host "Flutter temporary directory: $ticklyTemp"
    Write-Host "Gradle cache: $ticklyGradleCache"
    Write-Host "Java temporary directory: $ticklyJavaTemp"

    if (-not $CheckOnly) {
        if (-not $FlutterArgs -or $FlutterArgs.Count -eq 0) {
            $FlutterArgs = @('run', '--flavor', 'development')
        }
        & flutter @FlutterArgs
        $ticklyExitCode = $LASTEXITCODE
    }
}
finally {
    $env:TEMP = $ticklyPreviousTemp
    $env:TMP = $ticklyPreviousTmp
    $env:GRADLE_USER_HOME = $ticklyPreviousGradleHome
    $env:JAVA_TOOL_OPTIONS = $ticklyPreviousJavaOptions
    $env:ANDROID_USER_HOME = $ticklyPreviousAndroidHome
    Pop-Location
}
exit $ticklyExitCode

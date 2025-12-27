# SvcHostSplitThresholdInKB - AUTO-DETECT RAM (Consumer/Professional)
# Supports up to 256GB RAM
# Automatically detects your system RAM and applies matching registry value
# Accounts for ~400MB system reserved memory
# Real-world observation: Matching RAM size appears to improve system responsiveness

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SvcHost Memory Optimization" -ForegroundColor Cyan
Write-Host "CONSUMER/PROFESSIONAL - AUTO-DETECT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Administrator privilege
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as administrator'" -ForegroundColor Red
    Exit 1
}

Write-Host "✓ Running as Administrator" -ForegroundColor Green
Write-Host ""

# Step 1: Detect RAM and account for system reserve
Write-Host "[STEP 1/3] Detecting System RAM..." -ForegroundColor Yellow
$totalMemoryBytes = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
$ramGBExact = $totalMemoryBytes / 1GB

# Account for ~400MB system reserve (GPU, BIOS, etc.)
$systemReservedMB = 400
$usableRAMBytes = $totalMemoryBytes - ($systemReservedMB * 1MB)
$usableRAMGB = [math]::Floor($usableRAMBytes / 1GB)

Write-Host "✓ Installed RAM: $([math]::Round($ramGBExact, 1)) GB" -ForegroundColor Green
Write-Host "✓ Usable RAM (minus ~400MB reserve): $usableRAMGB GB" -ForegroundColor Green
Write-Host ""

# Step 2: Look up registry value based on usable RAM
Write-Host "[STEP 2/3] Finding matching registry value..." -ForegroundColor Yellow

# COMPLETE RAM to registry mapping (Consumer/Professional - up to 256GB)
# These values are for USABLE RAM (after system reserve)
# For example: 12GB installed = 11GB usable = use 11GB mapping
$ramMap = @{
    3   = @{dec=3145728;      hex='0x00300000'; installed='4GB'}
    5   = @{dec=5242880;      hex='0x00500000'; installed='6GB'}
    7   = @{dec=7340032;      hex='0x00700000'; installed='8GB'}
    11  = @{dec=11534336;     hex='0x00B00000'; installed='12GB'}
    15  = @{dec=15728640;     hex='0x00F00000'; installed='16GB'}
    23  = @{dec=24117248;     hex='0x01700000'; installed='24GB'}
    31  = @{dec=32505856;     hex='0x01F00000'; installed='32GB'}
    47  = @{dec=49283072;     hex='0x02F00000'; installed='48GB'}
    63  = @{dec=66060288;     hex='0x03F00000'; installed='64GB'}
    95  = @{dec=99614720;     hex='0x05F00000'; installed='96GB'}
    127 = @{dec=133169152;    hex='0x07F00000'; installed='128GB'}
    191 = @{dec=200278016;    hex='0x0BF00000'; installed='192GB'}
    255 = @{dec=267386880;    hex='0x0FF00000'; installed='256GB'}
}

# Find the matching configuration
$selectedValue = $null
$selectedRAM = $null
$installedRAM = $null

# First, try to find exact match for usable RAM
foreach ($ramSize in $ramMap.Keys) {
    if ($ramSize -eq $usableRAMGB) {
        $selectedValue = $ramMap[$ramSize]
        $selectedRAM = $usableRAMGB
        $installedRAM = $selectedValue.installed
        Write-Host "✓ Exact match found: $usableRAMGB GB usable (from $installedRAM installed)" -ForegroundColor Green
        break
    }
}

# If no exact match, find closest match below
if ($null -eq $selectedValue) {
    $sortedKeys = $ramMap.Keys | Sort-Object -Descending
    foreach ($ramSize in $sortedKeys) {
        if ($ramSize -lt $usableRAMGB) {
            $selectedValue = $ramMap[$ramSize]
            $selectedRAM = $ramSize
            $installedRAM = $selectedValue.installed
            Write-Host "⚠ No exact match for $usableRAMGB GB" -ForegroundColor Yellow
            Write-Host "   Using closest match: $selectedRAM GB usable (from $installedRAM installed)" -ForegroundColor Yellow
            break
        }
    }
}

# If still no match, error out
if ($null -eq $selectedValue) {
    Write-Host "ERROR: System RAM exceeds maximum supported (256GB)" -ForegroundColor Red
    Write-Host "For enterprise datacenter systems, use the Enterprise Auto-Detect script" -ForegroundColor Yellow
    Exit 1
}

Write-Host "   Registry Value (Decimal): $($selectedValue.dec)" -ForegroundColor Green
Write-Host "   Hex Value: $($selectedValue.hex)" -ForegroundColor Green
Write-Host ""

# Step 3: Apply to registry
Write-Host "[STEP 3/3] Applying registry change..." -ForegroundColor Yellow
$regPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control"

try {
    reg add $regPath /v SvcHostSplitThresholdInKB /t REG_DWORD /d $selectedValue.dec /f | Out-Null
    Write-Host "✓ Registry updated successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to update registry" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ OPTIMIZATION APPLIED" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Configuration Summary:" -ForegroundColor Cyan
Write-Host "  Installed RAM: $([math]::Round($ramGBExact, 1)) GB" -ForegroundColor Green
Write-Host "  Usable RAM: $usableRAMGB GB (after ~400MB system reserve)" -ForegroundColor Green
Write-Host "  Registry Mapping: $installedRAM installed = $selectedRAM GB usable" -ForegroundColor Green
Write-Host "  Applied Value: $($selectedValue.dec) ($($selectedValue.hex))" -ForegroundColor Green
Write-Host "  Registry Key: SvcHostSplitThresholdInKB" -ForegroundColor Green
Write-Host ""
Write-Host "Possible Improvements (User-Reported):" -ForegroundColor Cyan
Write-Host "  • Improved system startup responsiveness" -ForegroundColor Green
Write-Host "  • Smoother application launching" -ForegroundColor Green
Write-Host "  • Better handling of multiple running services" -ForegroundColor Green
Write-Host ""
Write-Host "⚠ RESTART REQUIRED!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Restarting in 10 seconds (press Ctrl+C to cancel)..." -ForegroundColor Yellow
Write-Host "Restarting in:" -ForegroundColor Yellow

for ($i = 10; $i -gt 0; $i--) {
    Write-Host "  $i seconds..." -ForegroundColor Yellow -NoNewline
    Start-Sleep -Seconds 1
    Write-Host "`r" -NoNewline
}

Write-Host ""
Write-Host "Initiating restart now..." -ForegroundColor Green
Start-Sleep -Seconds 1
Restart-Computer -Force
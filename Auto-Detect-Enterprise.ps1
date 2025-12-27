# SvcHostSplitThresholdInKB - AUTO-DETECT RAM (Enterprise/Datacenter)
# Automatically detects RAM and applies matching registry value
# Accounts for ~400MB system reserved memory
# Supports: Windows Server 2019/2022/2025, 256GB to 256TB+ RAM

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "SvcHost Memory Optimization" -ForegroundColor Cyan
Write-Host "ENTERPRISE/DATACENTER - AUTO-DETECT" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Exit 1
}

Write-Host "✓ Running as Administrator" -ForegroundColor Green
Write-Host ""

# Step 1: Detect RAM and account for system reserve
Write-Host "[STEP 1/4] Detecting System RAM..." -ForegroundColor Yellow
$totalMemoryBytes = (Get-WmiObject -Class Win32_ComputerSystem).TotalPhysicalMemory
$ramGBExact = $totalMemoryBytes / 1GB
$ramTBExact = $totalMemoryBytes / 1TB

# Account for ~400MB system reserve (scales proportionally for large systems)
# For enterprise, we use proportional reserve: 400MB + 100MB per TB
$systemReservedMB = 400 + ([math]::Floor($ramTBExact) * 100)
$usableRAMBytes = $totalMemoryBytes - ($systemReservedMB * 1MB)
$usableRAMGB = [math]::Floor($usableRAMBytes / 1GB)
$usableRAMTB = $usableRAMBytes / 1TB

Write-Host "✓ Installed RAM: $([math]::Round($ramGBExact, 1)) GB ($([math]::Round($ramTBExact, 2)) TB)" -ForegroundColor Green
Write-Host "✓ Usable RAM (minus reserve): $usableRAMGB GB ($([math]::Round($usableRAMTB, 2)) TB)" -ForegroundColor Green
Write-Host ""

# Step 2: Look up registry value based on usable RAM
Write-Host "[STEP 2/4] Finding matching registry value..." -ForegroundColor Yellow

# Enterprise/Datacenter mapping - values for USABLE RAM
# These are calculated assuming ~400MB base + 100MB per TB reserve
$ramMap = @{
    255 = @{dec=267386880;     hex='0x0FF00000'; installed='256GB'}
    511 = @{dec=536608768;     hex='0x1FF00000'; installed='512GB'}
    1022 = @{dec=1072668672;   hex='0x3FF00000'; installed='1TB'}
    2047 = @{dec=2147450880;   hex='0x7FF00000'; installed='2TB'}
    4095 = @{dec=4295032832;   hex='0xFFF00000'; installed='4TB'}
    8191 = @{dec=8589869056;   hex='0x1FFF00000'; installed='8TB'}
    16383 = @{dec=17179869184; hex='0x3FFF00000'; installed='16TB'}
    32767 = @{dec=34359607296; hex='0x7FFF00000'; installed='32TB'}
    65535 = @{dec=68719083520; hex='0xFFFF00000'; installed='64TB'}
    131071 = @{dec=137438036992; hex='0x1FFFF00000'; installed='128TB'}
    262143 = @{dec=274876941312; hex='0x3FFFF00000'; installed='256TB'}
}

# Find the matching configuration
$selectedValue = $null
$selectedRAM = $null
$installedRAM = $null

# First, try to find exact match
foreach ($ramSize in $ramMap.Keys) {
    if ($ramSize -eq $usableRAMGB) {
        $selectedValue = $ramMap[$ramSize]
        $selectedRAM = $usableRAMGB
        $installedRAM = $selectedValue.installed
        Write-Host "✓ Exact match found: $usableRAMGB GB usable (from $installedRAM installed)" -ForegroundColor Green
        break
    }
}

# If no exact match, find closest below
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

# Check if exceeds practical limit
if ($usableRAMGB -gt 262143) {
    Write-Host "⚠ WARNING: System exceeds 256TB (practical limit)" -ForegroundColor Yellow
}

if ($null -eq $selectedValue) {
    Write-Host "ERROR: Could not find suitable configuration" -ForegroundColor Red
    Exit 1
}

Write-Host "   Registry Value (Decimal): $($selectedValue.dec)" -ForegroundColor Green
Write-Host "   Hex Value: $($selectedValue.hex)" -ForegroundColor Green
Write-Host ""

# Step 3: Verify Windows Server
Write-Host "[STEP 3/4] Verifying Windows Server..." -ForegroundColor Yellow
$osInfo = Get-WmiObject -Class Win32_OperatingSystem
if ($osInfo.Caption -notlike "*Server*") {
    Write-Host "⚠ WARNING: Not Windows Server detected" -ForegroundColor Yellow
    $proceed = Read-Host "   Continue anyway? (Y/N)"
    if ($proceed -ne "Y" -and $proceed -ne "y") {
        Exit 0
    }
} else {
    Write-Host "✓ Windows Server detected: $($osInfo.Caption)" -ForegroundColor Green
}

Write-Host ""

# Step 4: Apply to registry
Write-Host "[STEP 4/4] Applying registry change..." -ForegroundColor Yellow
$regPath = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control"

try {
    reg add $regPath /v SvcHostSplitThresholdInKB /t REG_DWORD /d $selectedValue.dec /f | Out-Null
    Write-Host "✓ Registry updated successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Failed to update registry: $_" -ForegroundColor Red
    Exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "✓ ENTERPRISE OPTIMIZATION APPLIED" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Configuration Summary:" -ForegroundColor Cyan
Write-Host "  Installed RAM: $([math]::Round($ramGBExact, 1)) GB ($([math]::Round($ramTBExact, 2)) TB)" -ForegroundColor Green
Write-Host "  Usable RAM: $usableRAMGB GB ($([math]::Round($usableRAMTB, 2)) TB) after system reserve" -ForegroundColor Green
Write-Host "  Registry Mapping: $installedRAM installed = $selectedRAM GB usable" -ForegroundColor Green
Write-Host "  Applied Value: $($selectedValue.dec) ($($selectedValue.hex))" -ForegroundColor Green
Write-Host "  Registry Key: SvcHostSplitThresholdInKB" -ForegroundColor Green
Write-Host ""
Write-Host "Expected Improvements:" -ForegroundColor Cyan
Write-Host "  • Optimized service distribution across available memory" -ForegroundColor Green
Write-Host "  • Reduced memory fragmentation in service processes" -ForegroundColor Green
Write-Host "  • Better handling of large-scale workloads" -ForegroundColor Green
Write-Host ""
Write-Host "⚠ RESTART REQUIRED!" -ForegroundColor Yellow
Write-Host "Coordinate with cluster management if applicable" -ForegroundColor Yellow
Write-Host ""
Write-Host "Press any key to restart in 10 seconds (or Ctrl+C to cancel)..." -ForegroundColor Yellow
Write-Host "Restarting in:" -ForegroundColor Yellow

# Countdown timer - user can Ctrl+C to cancel
for ($i = 10; $i -gt 0; $i--) {
    Write-Host "  $i seconds..." -ForegroundColor Yellow -NoNewline
    Start-Sleep -Seconds 1
    Write-Host "`r" -NoNewline
}

Write-Host ""
Write-Host "Initiating restart now..." -ForegroundColor Green
Start-Sleep -Seconds 1
Restart-Computer -Force

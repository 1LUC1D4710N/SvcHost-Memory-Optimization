# SvcHost Memory Optimization
## Complete Registry Tuning Guide - Consumer to Enterprise Datacenter

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Windows](https://img.shields.io/badge/Windows-10%2F11%2FServer-0078D4?logo=windows)](https://www.microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-0078D4?logo=powershell)](https://learn.microsoft.com/en-us/powershell/)

**Version:** 1.1 Enterprise Extended - FIX  
**Testing Approach:** User-reported system responsiveness on personal test system  
**Scope:** Windows 10/11/Server 2019/2022/2025 (4GB to 256TB+ systems)

---

## Table of Contents

- [Overview](#overview)
- [Quick Start](#quick-start)
- [Installation Methods](#installation-methods)
- [Consumer](#consumer)
- [Enterprise](#enterprise)
- [Verification](#verification)
- [Rollback](#rollback)
- [FAQ](#faq)
- [Contributing](#contributing)



This repository provides registry optimization techniques for Windows systems of all sizes, from consumer gaming PCs to enterprise datacenter deployments.

**What is SvcHostSplitThresholdInKB?**

Service Host (svchost.exe) manages Windows services. This registry value controls how Windows distributes these service processes across available system memory.

**Registry Location:**
```
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control
```

**What This Optimization Does:**

By default, Windows uses a fixed 3.5GB threshold for splitting service processes. This repository demonstrates that **matching this value to your actual USABLE RAM** (after system reserves) can:

- ✅ **Improve system startup responsiveness** - Services initialize faster
- ✅ **Smoother application launching** - Apps start with less lag
- ✅ **Better multitasking performance** - More efficient service distribution
- ✅ **Enhanced memory management** - Services grouped more intelligently based on your RAM capacity

**Key Finding:** Real-world testing shows matching your registry value to your **actual usable RAM** appears to improve system responsiveness better than the "use half your RAM" approach often recommended online.

---

## Important Disclaimer

⚠️ **Before proceeding, please read this carefully:**

This guide is based on **subjective personal testing** on a single test system (Samsung SSD + custom RAM configuration). Results may vary significantly based on your specific hardware, Windows configuration, and usage patterns.

**What this IS:**
- A documented registry optimization technique
- Safe-to-apply configuration with easy rollback
- User-reported subjective improvement in responsiveness
- Complete reference covering consumer through enterprise configurations

**What this is NOT:**
- Formally benchmarked testing with statistical analysis
- Guaranteed performance improvement for all users
- A substitute for proper system diagnostics or professional IT consulting
- Applicable to all systems (results vary by configuration)

---

## Quick Start

### ⚠️ CRITICAL: Create System Restore Point First

**Before applying ANY changes:**

#### GUI Method (Easiest)
1. Press `Win+R`, type `rstrui.exe`, press Enter
2. Click "Create a restore point..."
3. Select your system drive
4. Click "Create..." and name it `SvcHost-Before`
5. Wait for confirmation

#### PowerShell Method
```powershell
# Run as Administrator
Checkpoint-Computer -Description "SvcHost-Before" -RestorePointType "MODIFY_SETTINGS"
```

---

## Installation Methods

### Method 1: PowerShell Auto-Detect (Recommended - Easiest)

**Best choice for most users.** Automatically detects your RAM and applies the correct value:

1. Download the appropriate auto-detect script (see sections below)
2. Right-click PowerShell, select "Run as administrator"
3. Run: `.\script-name.ps1`
4. Script detects your RAM → applies matching registry value
5. Follow the restart prompt

**Why this method?**
- ✅ No manual selection needed
- ✅ Auto-detects your actual RAM
- ✅ Applies the matching value automatically
- ✅ Shows you exactly what it did

### Method 2: Registry Files (.REG)

**Use this if you prefer manual control or can't run PowerShell:**

1. Find your RAM size in the mapping table below
2. Click the download link for your RAM size
3. Right-click the `.reg` file, select "Merge"
4. Confirm the Windows Registry Editor dialog
5. Restart your computer

---

## Consumer

### Professional (4GB-256GB)

**For:** Windows 10/11 with 4GB-256GB RAM

**Use this version if you have:**
- Gaming PC (32-64GB)
- Professional workstation (128GB)
- High-end desktop/HEDT (256GB)
- Windows 10 or Windows 11

### RAM Size Mapping

| RAM Size | Usable RAM | Hex Value | Decimal | Use Case | Download |
|----------|-----------|-----------|---------|----------|----------|
| Default | 3.5GB | 0x00380000 | 3,670,016 | Windows default | [⬇ default.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/1.%20Default%20setting/SvcHostSplitThresholdInKB_default.reg) |
| 4 GB | 3GB | 0x00300000 | 3,145,728 | Entry-level systems | [⬇ 4GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/2.%204%20GB%20setting/SvcHostSplitThresholdInKB_4GB.reg) |
| 6 GB | 5GB | 0x00500000 | 5,242,880 | Older gaming PCs | [⬇ 6GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/3.%206%20GB%20setting/SvcHostSplitThresholdInKB_6GB.reg) |
| 8 GB | 7GB | 0x00700000 | 7,340,032 | Common baseline | [⬇ 8GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/4.%208%20GB%20setting/SvcHostSplitThresholdInKB_8GB.reg) |
| 12 GB | 11GB | 0x00B00000 | 11,534,336 | Mid-range | [⬇ 12GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/5.%2012%20GB%20setting/SvcHostSplitThresholdInKB_12GB.reg) |
| 16 GB | 15GB | 0x00F00000 | 15,728,640 | Gaming/content creation | [⬇ 16GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/6.%2016%20GB%20setting/SvcHostSplitThresholdInKB_16GB.reg) |
| 24 GB | 23GB | 0x01700000 | 24,117,248 | Professional workstations | [⬇ 24GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/7.%2024%20GB%20setting/SvcHostSplitThresholdInKB_24GB.reg) |
| 32 GB | 31GB | 0x01F00000 | 32,505,856 | Serious gaming/streaming | [⬇ 32GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/8.%2032%20GB%20setting/SvcHostSplitThresholdInKB_32GB.reg) |
| 64 GB | 63GB | 0x03F00000 | 66,060,288 | High-end workstations | [⬇ 64GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/9.%2064%20GB%20setting/SvcHostSplitThresholdInKB_64GB.reg) |
| 128 GB | 127GB | 0x07F00000 | 133,169,152 | Professional video/AI | [⬇ 128GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/10.%20128%20GB%20setting/SvcHostSplitThresholdInKB_128GB.reg) |
| 256 GB | 255GB | 0x0FF00000 | 267,386,880 | HEDT/specialized workstations | [⬇ 256GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/11.%20256%20GB%20setting/SvcHostSplitThresholdInKB_256GB.reg) |

**Note:** 256GB .reg files are not pre-generated. For systems with 256GB+ RAM, use the **Auto-Detect Script** which will calculate the correct value automatically.

### Auto-Detect Script (Consumer)

```powershell
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
Write-Host "Restart now? (Y/N)" -ForegroundColor Yellow
$restart = Read-Host

if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 10 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Remember to restart manually to apply changes!" -ForegroundColor Yellow
}
```
Write-Host ""
Write-Host "Possible Improvements (User-Reported):" -ForegroundColor Cyan
Write-Host "  • Improved system startup responsiveness" -ForegroundColor Green
Write-Host "  • Smoother application launching" -ForegroundColor Green
Write-Host "  • Better handling of multiple running services" -ForegroundColor Green
Write-Host ""
Write-Host "⚠ RESTART REQUIRED!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Restart now? (Y/N)" -ForegroundColor Yellow
$restart = Read-Host

if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 10 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Remember to restart manually to apply changes!" -ForegroundColor Yellow
}
```

---

## Enterprise

### Datacenter (256GB-256TB+)

**For:** Windows Server 2019/2022/2025 with 256GB-256TB+ RAM

**Use this version if you have:**
- Enterprise servers with 256GB+ RAM
- Windows Server 2019, 2022, or 2025
- Datacenter environments
- Intel Xeon or AMD EPYC processors

### RAM Size Mapping

| RAM Size | Usable RAM | Hex Value | Decimal | Use Case | Download |
|----------|-----------|-----------|---------|----------|----------|
| 256 GB | 255GB | 0x0FF00000 | 267,386,880 | High-end HEDT/enterprise | [⬇ 256GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/11.%20256%20GB%20setting/SvcHostSplitThresholdInKB_256GB.reg) |
| 512 GB | 511GB | 0x1FF00000 | 536,608,768 | Enterprise servers | [⬇ 512GB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/12.%20512%20GB%20setting/SvcHostSplitThresholdInKB_512GB.reg) |
| 1 TB | 1022GB | 0x3FF00000 | 1,072,668,672 | Large datacenter nodes | [⬇ 1TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/13.%201%20TB%20setting/SvcHostSplitThresholdInKB_1TB.reg) |
| 2 TB | 2047GB | 0x7FF00000 | 2,147,450,880 | High-memory clusters | [⬇ 2TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/14.%202%20TB%20setting/SvcHostSplitThresholdInKB_2TB.reg) |
| 4 TB | 4095GB | 0xFFF00000 | 4,295,032,832 | Specialized workloads | [⬇ 4TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/15.%204%20TB%20setting/SvcHostSplitThresholdInKB_4TB.reg) |
| 8 TB | 8191GB | 0x1FFF00000 | 8,589,869,056 | Large-scale data processing | [⬇ 8TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/16.%208%20TB%20setting/SvcHostSplitThresholdInKB_8TB.reg) |
| 16 TB | 16383GB | 0x3FFF00000 | 17,179,869,184 | Enterprise-grade systems | [⬇ 16TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/17.%2016%20TB%20setting/SvcHostSplitThresholdInKB_16TB.reg) |
| 32 TB | 32767GB | 0x7FFF00000 | 34,359,607,296 | Datacenter scale | [⬇ 32TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/18.%2032%20TB%20setting/SvcHostSplitThresholdInKB_32TB.reg) |
| 64 TB | 65535GB | 0xFFFF00000 | 68,719,083,520 | Large memory nodes | [⬇ 64TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/19.%2064%20TB%20setting/SvcHostSplitThresholdInKB_64TB.reg) |
| 128 TB | 131071GB | 0x1FFFF00000 | 137,438,036,992 | Virtualization hosts | [⬇ 128TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/20.%20128%20TB%20setting/SvcHostSplitThresholdInKB_128TB.reg) |
| 256 TB | 262143GB | 0x3FFFF00000 | 274,876,941,312 | Maximum (four-level paging) | [⬇ 256TB.reg](https://github.com/1LUC1D4710N/SvcHost-Memory-Optimization/blob/main/21.%20256%20TB%20setting/SvcHostSplitThresholdInKB_256TB.reg) |

**Recommendation:** For Enterprise/Datacenter systems (256GB+), you now have both ready-to-use .reg files OR the **Auto-Detect Script** for dynamic calculation based on detected RAM.

**Note:** Windows Server 2025 theoretically supports up to 4 petabytes with five-level paging, but practical deployments rarely exceed 256TB on single nodes.

### Auto-Detect Script (Enterprise)

```powershell
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
```
    262144 = @{dec=274877906944; hex='0x4000000000'; platform='Maximum (256TB)'}
}

$selectedValue = $null
if ($ramMap.ContainsKey($ramGB)) {
    $selectedValue = $ramMap[$ramGB]
    Write-Host "✓ Exact match found: $ramGB GB" -ForegroundColor Green
} else {
    $closestRAM = ($ramMap.Keys | Where-Object {$_ -lt $ramGB} | Measure-Object -Maximum).Maximum
    if ($null -ne $closestRAM) {
        $selectedValue = $ramMap[$closestRAM]
        Write-Host "⚠ No exact match - using closest: $closestRAM GB" -ForegroundColor Yellow
    }
}

if ($null -eq $selectedValue) {
    Write-Host "ERROR: Could not find suitable configuration" -ForegroundColor Red
    Exit 1
}

Write-Host "   Registry Value: $($selectedValue.dec)" -ForegroundColor Green
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
Write-Host "  Detected RAM: $ramGB GB ($ramTB TB)" -ForegroundColor Green
Write-Host "  Applied Value: $($selectedValue.dec) ($($selectedValue.hex))" -ForegroundColor Green
Write-Host ""
Write-Host "⚠ RESTART REQUIRED!" -ForegroundColor Yellow
Write-Host "Coordinate with cluster management if applicable" -ForegroundColor Yellow
Write-Host ""
Write-Host "Restart now? (Y/N)" -ForegroundColor Yellow
$restart = Read-Host

if ($restart -eq "Y" -or $restart -eq "y") {
    Write-Host "Restarting in 30 seconds..." -ForegroundColor Yellow
    Start-Sleep -Seconds 30
    Restart-Computer -Force
} else {
    Write-Host "Remember to restart manually!" -ForegroundColor Yellow
}
```

---

---

## Verification

### Check Applied Settings
```powershell
# PowerShell command to verify
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB"
```

### Via Registry Editor
1. Press `Win+R`, type `regedit`, press Enter
2. Navigate to: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control`
3. Look for `SvcHostSplitThresholdInKB`
4. Value should match your RAM size

---

## Rollback

### Using System Restore (Fastest)
1. Press `Win+R`, type `rstrui.exe`
2. Select your "SvcHost-Before" restore point
3. Click "Restore"
4. System restarts and reverts instantly

### Using PowerShell
```powershell
# Remove the custom setting
reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control" /v SvcHostSplitThresholdInKB /f
```

---

## FAQ

### Q: Will this improve my performance?
**A:** Results are based on subjective testing. You may notice improved responsiveness, but results vary by system configuration. Always test with a restore point first.

### Q: Is it safe?
**A:** Yes. The change is a single registry value, and you have a restore point to instantly revert if needed.

### Q: What if I don't see improvement?
**A:** Use System Restore to revert. The optimization may not be noticeable on all systems depending on workload and hardware.

### Q: Which script should I use?
**A:** Consumer/Professional for Windows 10/11 up to 256GB. Enterprise for Windows Server with 256GB+.

### Q: Do I need to restart?
**A:** Yes. Changes take effect after restart.

### Q: What about 256TB or higher?
**A:** This guide covers practical deployments up to 256TB. Contact your system architect for specialized configurations beyond that.

---

## Testing Methodology

This guide is based on personal testing on a single system:
- **Hardware:** Samsung SSD + custom RAM configuration
- **Approach:** Subjective assessment of system responsiveness
- **Sample Size:** Single test system
- **Result:** Observed improvement in perceived responsiveness

For formal benchmarking across multiple systems, professional tools like Windows Performance Analyzer would be required.

---

## Contributing

Found an issue? Have feedback? Please open an Issue or Pull Request.

**How to contribute:**
1. Test on your system
2. Document your configuration and results
3. Share feedback via Issues
4. Suggest improvements

---

## License

MIT License - See LICENSE file for details

---

## Disclaimer

This software is provided "as-is" without warranty. The authors are not responsible for any damage or data loss resulting from the use of this guide. Always create a system restore point before making registry changes.

---

## Author

Created by an IT professional transitioning to IT Technologist role. Built with care for the entire Windows ecosystem, from entry-level consumer systems to enterprise datacenters.

**Tested on:** Windows 11 with Samsung SSD + Custom RAM Configuration

---

## Support

If you have questions or issues:
1. Check the FAQ section
2. Review the scripts' output for error messages
3. Use System Restore if anything goes wrong
4. Open an Issue on GitHub for bugs or suggestions
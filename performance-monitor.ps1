<#
.SYNOPSIS
    System Performance Monitor GUI

.DESCRIPTION
    This script displays a GUI for monitoring system performance, including disk space, CPU usage, memory usage, and network utilization.

.AUTHOR
    Chris Spradlin
#>



Add-Type -AssemblyName PresentationFramework

function Show-PerformanceGUI {
    $window = New-Object System.Windows.Window
    $window.Title = "System Performance Monitor"
    $window.Width = 500
    $window.Height = 600

    $grid = New-Object System.Windows.Controls.Grid
    $window.Content = $grid

    # Define columns for labels
    $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
    $grid.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))

    $rowIndex = 0

    # Disk Space Monitoring
    $drives = Get-PSDrive -PSProvider FileSystem

    foreach ($drive in $drives) {
        $rowDefinition = New-Object System.Windows.Controls.RowDefinition
        $grid.RowDefinitions.Add($rowDefinition)

        $totalSpaceGB = ($drive.Used + $drive.Free) / 1GB
        $usedSpaceGB = $drive.Used / 1GB
        $freeSpaceGB = $drive.Free / 1GB

        $usedPercentage = ($usedSpaceGB / $totalSpaceGB) * 100
        $freePercentage = ($freeSpaceGB / $totalSpaceGB) * 100

        $driveLabel = New-Object System.Windows.Controls.Label
        $driveLabel.Content = "Drive $($drive.Name):"
        [System.Windows.Controls.Grid]::SetRow($driveLabel, $rowIndex)
        [System.Windows.Controls.Grid]::SetColumn($driveLabel, 0)
        $grid.Children.Add($driveLabel)

        $detailsLabel = New-Object System.Windows.Controls.Label
        $detailsLabel.Content = "Total: $([math]::Round($totalSpaceGB, 2)) GB`nUsed: $([math]::Round($usedSpaceGB, 2)) GB ($([math]::Round($usedPercentage, 2))%)`nFree: $([math]::Round($freeSpaceGB, 2)) GB ($([math]::Round($freePercentage, 2))%)"
        [System.Windows.Controls.Grid]::SetRow($detailsLabel, $rowIndex)
        [System.Windows.Controls.Grid]::SetColumn($detailsLabel, 1)
        $grid.Children.Add($detailsLabel)

        $rowIndex++
    }

    # CPU Usage Monitoring
    $cpuCounter = Get-Counter -Counter "\Processor(_Total)\% Processor Time" -SampleInterval 1 -MaxSamples 1
    $cpuUsage = [math]::Round($cpuCounter.CounterSamples.CookedValue, 2)

    $rowDefinition = New-Object System.Windows.Controls.RowDefinition
    $grid.RowDefinitions.Add($rowDefinition)

    $cpuLabel = New-Object System.Windows.Controls.Label
    $cpuLabel.Content = "CPU Usage:"
    [System.Windows.Controls.Grid]::SetRow($cpuLabel, $rowIndex)
    [System.Windows.Controls.Grid]::SetColumn($cpuLabel, 0)
    $grid.Children.Add($cpuLabel)

    $cpuDetailsLabel = New-Object System.Windows.Controls.Label
    $cpuDetailsLabel.Content = "$cpuUsage %"
    [System.Windows.Controls.Grid]::SetRow($cpuDetailsLabel, $rowIndex)
    [System.Windows.Controls.Grid]::SetColumn($cpuDetailsLabel, 1)
    $grid.Children.Add($cpuDetailsLabel)

    $rowIndex++

    # Memory Usage Monitoring
    $memory = Get-CimInstance -ClassName Win32_OperatingSystem
    $totalMemory = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
    $freeMemory = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
    $usedMemory = $totalMemory - $freeMemory
    $memoryUsage = ($usedMemory / $totalMemory) * 100

    $rowDefinition = New-Object System.Windows.Controls.RowDefinition
    $grid.RowDefinitions.Add($rowDefinition)

    $memoryLabel = New-Object System.Windows.Controls.Label
    $memoryLabel.Content = "Memory Usage:"
    [System.Windows.Controls.Grid]::SetRow($memoryLabel, $rowIndex)
    [System.Windows.Controls.Grid]::SetColumn($memoryLabel, 0)
    $grid.Children.Add($memoryLabel)

    $memoryDetailsLabel = New-Object System.Windows.Controls.Label
    $memoryDetailsLabel.Content = "Used: $usedMemory GB ($([math]::Round($memoryUsage, 2))%)`nFree: $freeMemory GB`nTotal: $totalMemory GB"
    [System.Windows.Controls.Grid]::SetRow($memoryDetailsLabel, $rowIndex)
    [System.Windows.Controls.Grid]::SetColumn($memoryDetailsLabel, 1)
    $grid.Children.Add($memoryDetailsLabel)

    $rowIndex++

    # Network Utilization Monitoring
    $netAdapter = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
    $netStats = Get-NetAdapterStatistics -Name $netAdapter.Name

    $rowDefinition = New-Object System.Windows.Controls.RowDefinition
    $grid.RowDefinitions.Add($rowDefinition)

    $networkLabel = New-Object System.Windows.Controls.Label
    $networkLabel.Content = "Network Utilization:"
    [System.Windows.Controls.Grid]::SetRow($networkLabel, $rowIndex)
    [System.Windows.Controls.Grid]::SetColumn($networkLabel, 0)
    $grid.Children.Add($networkLabel)

    $networkDetailsLabel = New-Object System.Windows.Controls.Label
    $networkDetailsLabel.Content = "Bytes Sent: $([math]::Round($netStats.OutboundBytes / 1MB, 2)) MB`nBytes Received: $([math]::Round($netStats.InboundBytes / 1MB, 2)) MB"
    [System.Windows.Controls.Grid]::SetRow($networkDetailsLabel, $rowIndex)
    [System.Windows.Controls.Grid]::SetColumn($networkDetailsLabel, 1)
    $grid.Children.Add($networkDetailsLabel)

    $window.ShowDialog() | Out-Null
}

# Show the performance GUI
Show-PerformanceGUI

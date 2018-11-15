Set-Location "C:\vwocmbb_ps"
Import-Module .\modules\ps-menu-master\PS-Menu
Import-Module .\modules\VWOCMBB-ValidateXmlFile -WarningAction SilentlyContinue
Import-Module .\modules\VWOCMBB-updater\VWOCMBB-updater -WarningAction SilentlyContinue

foreach ($extension in (Get-ChildItem (".\extension\") -Name -attributes D)){
    Import-Module .\extension\$extension\$extension -WarningAction SilentlyContinue
}

$global:adbpath = ""
$global:devicelist = New-Object System.Collections.ArrayList
$global:emutype = ""
$global:vld = ""
$global:smcd = ""
$global:tbl = ""
$global:ct = ""
$global:esd = ""
$global:Nox = ""
$global:MEmu = ""
$global:emulatorpath = ""
$global:adbname = ""
$global:running_acc = ""
$global:active_bot = ""
$global:emumode = ""
$global:logname = ""
$global:ai_path = (Get-Item -Path ".\").FullName + "\data\AI\ICompare\convert.exe"
$global:botversion = ""
$global:nsp = ""
$global:msp = ""
$global:usb_mode =""
$global:active_emulator = ""
$global:emu_mode = ""
[int]$global:minms = "200"
[int]$global:maxms = "350"
[int]$global:failclicks = 0
$global:qst_mode = ""
$global:qst_time = ""
$global:qst_emul = ""
[int]$global:delayed = 0
$global:whereami = ""
[int]$global:tbreak = 5
$global:deb_start
$global:deb_bot_name = ""
$global:loop_start_time = ""
<#
Check running process (MEmu, Nox or usb) and set path to adb.exe file
#>
function set-adb-path{
  $NoxActive = Get-Process Nox -ErrorAction SilentlyContinue
  $MemuActive = Get-Process MEmu -ErrorAction SilentlyContinue
  if($NoxActive -ne $null){
    $path = $NoxActive[0] | Select-Object Path | Split-path
    $global:adbpath = $path + "\adb.exe"
  }
  if($MemuActive -ne $null){
    $path = $NoxActive[0] | Select-Object Path | Split-path
    $global:adbpath = $path + "\adb.exe"
  }
}

<#
Get list of attached adb devices
#>
function list-adb-devices{
  $global:devicelist = New-Object System.Collections.ArrayList
  foreach ($device in (.$global:adbpath devices)) {
     if($device -like '*device'){
     $global:devicelist.Add(($device -replace "device", "")) | out-null
   }
 }
}

<#
Check if application is installed
#>
function Is-Installed( $program ) {
    $x86 = ((Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall") |
        Where-Object { $_.GetValue( "DisplayName" ) -like "*$program*" } ).Length -gt 0;
    $x64 = ((Get-ChildItem "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall") |
        Where-Object { $_.GetValue( "DisplayName" ) -like "*$program*" } ).Length -gt 0;
    return $x86 -or $x64;
}

<#
Prepare emulator device list
#>
function prepare-emulator-list($preparemode){
  $emulist = New-Object System.Collections.ArrayList
  if((Is-Installed "Nox")){
    $emulist.Add("Nox") | out-null
  }
  if((Is-Installed "MEmu")){
    $emulist.Add("MEmu") | out-null
  }
  if($preparemode -eq "bot"){
    $emulist.Add("USB") | out-null
  }
  return $emulist
}

<#
Show settings menu | change settings
#>
function show-settings-menu{
  cls
  $xml = new-object System.Xml.XmlDocument
  $path = '.\data\settings.xml'
  $xml = [xml](Get-Content $path)
  Write-host ""
  Write-host "Settings"
  Write-host ""
  $settingsmenu = menu @("Function Settings","Vikings launch duration", "Switch to map,city duration", "Time between loops", "Click timeout","MS Timeout range", "Emulator start duration","Emulator Path","Share Path","Auto update","USB Mode", "go back")
  if($settingsmenu -eq "Vikings launch duration"){
    cls
    Write-host ""
    Write-host $settingsmenu
    $node = $xml.OPT.Time | Where-Object {$_.Name -eq 'vld'}
    Write-host "Current value is: " $node.Value
    Write-host ""
    $imput = Read-Host -Prompt "Type duration in seconds"
    $node.Value = "$imput"
    $xml.Save((Get-Item -Path ".\").FullName + $path)
    show-settings-menu
  }
  if($settingsmenu -eq "Function Settings"){
    cls
    Write-host ""
    Write-host $settingsmenu
    write-host ""
    $fun_opt = menu @("opentaskwindow","go back")
    if($fun_opt -eq "opentaskwindow"){
      cls
      Write-host ""
      Write-host $fun_opt
      write-host ""
      $task_opt = menu @("Task Break","go back")
      if($task_opt -eq "Task Break"){
        cls
        Write-host ""
        Write-host $fun_opt
        write-host ""
        $node = $xml.OPT.OTW | Where-Object {$_.Name -eq 'tbreak'}
        Write-host "Current value in hour is: "$node.Value
        Write-host ""
        $imput = Read-Host -Prompt "Type Taskbreak in hours. eg. 5"
        if($node -ne $null){
          $node.Value = "$imput"
          $xml.Save((Get-Item -Path ".\").FullName + $path)
        } else {
          $newrun = $xml.CreateElement("OTW")
          $xml.OPT.AppendChild($newrun) | out-null
          $newrun.SetAttribute("Name","tbreak");
          $newrun.SetAttribute("Value","$imput");
          $xml.Save((Get-Item -Path ".\").FullName + $path)
        }
        show-settings-menu
      }
      if($task_opt -eq "go back"){
        show-settings-menu
      }
      if([string]::IsNullOrEmpty($task_opt)){
        show-settings-menu
      }
    }
    if($fun_opt -eq "go back"){
      show-settings-menu
    }
    if([string]::IsNullOrEmpty($fun_opt)){
      show-settings-menu
    }
  }
  if($settingsmenu -eq "MS Timeout range"){
    cls
    Write-host ""
    Write-host $settingsmenu
    write-host ""
    $msmenu = menu @("min ms","max ms")
    if($msmenu -eq "min ms"){
      $node = $xml.OPT.MSOPT | Where-Object {$_.Name -eq 'minms'}
      Write-host "Current value is: "$node.Value
      Write-host ""
      $imput = Read-Host -Prompt "Type min ms. eg. 20"
      if($node -ne $null){
        $node.Value = "$imput"
        $xml.Save((Get-Item -Path ".\").FullName + $path)
      } else {
        $newrun = $xml.CreateElement("MSOPT")
        $xml.OPT.AppendChild($newrun) | out-null
        $newrun.SetAttribute("Name","minms");
        $newrun.SetAttribute("Value","$imput");
        $xml.Save((Get-Item -Path ".\").FullName + $path)
      }
      show-settings-menu
    }
    if($msmenu -eq "max ms"){
      $node = $xml.OPT.MSOPT | Where-Object {$_.Name -eq 'maxms'}
      Write-host "Current value is: "$node.Value
      Write-host ""
      $imput = Read-Host -Prompt "Type max ms. eg. 800"
      if($node -ne $null){
        $node.Value = "$imput"
        $xml.Save((Get-Item -Path ".\").FullName + $path)
      } else {
        $newrun = $xml.CreateElement("MSOPT")
        $xml.OPT.AppendChild($newrun) | out-null
        $newrun.SetAttribute("Name","maxms");
        $newrun.SetAttribute("Value","$imput");
        $xml.Save((Get-Item -Path ".\").FullName + $path)
      }
      show-settings-menu
    }
  }
  if($settingsmenu -eq "Auto update"){
    cls
    Write-host ""
    Write-host $settingsmenu
    write-host ""
    $node = $xml.OPT.Update | Where-Object {$_.Name -eq 'update'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = menu @("yes","No")
    if($node -ne $null){
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    } else {
      $newrun = $xml.CreateElement("Update")
      $xml.OPT.AppendChild($newrun) | out-null
      $newrun.SetAttribute("Name","update");
      $newrun.SetAttribute("Value","$imput");
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    }
    show-settings-menu
  }
  if($settingsmenu -eq "USB Mode"){
    cls
    Write-host ""
    Write-host $settingsmenu
    write-host ""
    $node = $xml.OPT.USB | Where-Object {$_.Name -eq 'usb-mode'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = menu @("On","Off")
    if($node -ne $null){
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    } else {
      $newrun = $xml.CreateElement("USB")
      $xml.OPT.AppendChild($newrun) | out-null
      $newrun.SetAttribute("Name","usb-mode");
      $newrun.SetAttribute("Value","$imput");
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    }
    show-settings-menu
  }
  if($settingsmenu -eq "Switch to map,city duration"){
    cls
    Write-host ""
    Write-host $settingsmenu
    $node = $xml.OPT.Time | Where-Object {$_.Name -eq 'smcd'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = Read-Host -Prompt "Type duration in seconds"
    $node.Value = "$imput"
    $xml.Save((Get-Item -Path ".\").FullName + $path)
    show-settings-menu
  }
  if($settingsmenu -eq "Time between loops"){
    cls
    Write-host ""
    Write-host $settingsmenu
    $node = $xml.OPT.Time | Where-Object {$_.Name -eq 'tbl'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = Read-Host -Prompt "Type duration in seconds"
    $node.Value = "$imput"
    $xml.Save((Get-Item -Path ".\").FullName + $path)
    show-settings-menu
  }
  if($settingsmenu -eq "Click timeout"){
    cls
    Write-host ""
    Write-host $settingsmenu
    $node = $xml.OPT.Time | Where-Object {$_.Name -eq 'ct'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = Read-Host -Prompt "Type duration in seconds or type ms for random millisecons time"
    $node.Value = "$imput"
    $xml.Save((Get-Item -Path ".\").FullName + $path)
    show-settings-menu
  }
  if($settingsmenu -eq "Emulator start duration"){
    cls
    Write-host ""
    Write-host $settingsmenu
    $node = $xml.OPT.Time | Where-Object {$_.Name -eq 'esd'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = Read-Host -Prompt "Type duration in seconds"
    $node.Value = "$imput"
    $xml.Save((Get-Item -Path ".\").FullName + $path)
    show-settings-menu
  }
  if($settingsmenu -eq "Emulator Path"){
    cls
    Write-host ""
    Write-host $settingsmenu
    Write-host ""
    $emulatormenu = menu @("Nox","MEmu","go back")
    if($emulatormenu -eq "Nox"){
      cls
      Write-host ""
      Write-host $emulatormenu
      Write-host "Example: C:\Program Files (x86)\Nox\bin"
      Write-host ""
      $node = $xml.OPT.Path | Where-Object {$_.Name -eq 'Nox'}
      Write-host "Current value is: "$node.Value
      Write-host ""
      $imput = Read-Host -Prompt "Install path"
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
      show-settings-menu
    }
    if($emulatormenu -eq "MEmu"){
      cls
      Write-host ""
      Write-host $emulatormenu
      Write-host "Example: C:\Program Files (x86)\Microvirt\MEmu"
      Write-host ""
      $node = $xml.OPT.Path | Where-Object {$_.Name -eq 'MEmu'}
      Write-host "Current value is: "$node.Value
      Write-host ""
      $imput = Read-Host -Prompt "Install path"
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
      show-settings-menu
    }

    if($emulatormenu -eq "go back"){
      show-settings-menu
    }
  }
  if($settingsmenu -eq "Share Path"){
    cls
    Write-host ""
    Write-host $settingsmenu
    Write-host ""
    $emulatormenu = menu @("Nox","MEmu","go back")
    if($emulatormenu -eq "Nox"){
      cls
      Write-host ""
      Write-host $emulatormenu
      Write-host "Example: C:\Users\MyUserName\Nox_share"
      Write-host ""
      $node = $xml.OPT.Path | Where-Object {$_.Name -eq 'nsp'}
      Write-host "Current value is: "$node.Value
      Write-host ""
      $imput = Read-Host -Prompt "Share path"
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
      show-settings-menu
    }
    if($emulatormenu -eq "MEmu"){
      cls
      Write-host ""
      Write-host $emulatormenu
      Write-host "Example: C:\Program Files (x86)\Microvirt\MEmu"
      Write-host ""
      $node = $xml.OPT.Path | Where-Object {$_.Name -eq 'msp'}
      Write-host "Current value is: "$node.Value
      Write-host ""
      $imput = Read-Host -Prompt "Share path"
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
      show-settings-menu
    }

    if($emulatormenu -eq "go back"){
      show-settings-menu
    }
  }
  if($settingsmenu -eq "go back"){
    loadxmlsettings
    show-main-menu
  }
  if([string]::IsNullOrEmpty($settingsmenu)){
    loadxmlsettings
    show-main-menu
  }
}

<#
show main menu
#>
function show-main-menu{
  cls
  Write-host ""
  Write-host "Vikings War Of Clans MB Bot"
  Write-host ""
  if($global:usb_mode -eq "On"){
    $mainmenu = menu @("Start Bot","Release USB Device","Quickstart","Setup ip ban protection", "Settings", "Check for Updates", "Help", "Exit")
  } else {
    $mainmenu = menu @("Start Bot", "Start Emulator", "Quickstart","Setup ip ban protection", "Settings", "Check for Updates", "Help", "Exit")
  }
  if($mainmenu -eq "Start Bot"){
    start-bot
  }
  if($mainmenu -eq "Settings"){
    show-settings-menu
  }
  if($mainmenu -eq "Release USB Device"){
    $global:adbpath = $(Get-Item -Path ".\").FullName+"\data\adb\adb.exe"
    cls
    Write-host ""
    Write-host "Select your device type:"
    Write-host ""
    list-adb-devices
    $global:adbname = (menu $global:devicelist).Trim()
    cls
    Write-host ""
    Write-host "Prepare device..."
    Write-host ""
    Write-host "Reset resolution"
    Write-host ""
    $usbargs = @("-s $global:adbname","shell wm size reset")
    run-prog $global:adbpath $usbargs
    Write-host "Reset density"
    Write-host ""
    $usbargs = @("-s $global:adbname","shell wm density reset")
    run-prog $global:adbpath $usbargs
    Write-host "You can unplug your device"
    Write-host ""
    start-sleep -s 3
    show-main-menu
  }
  if($mainmenu -eq "Exit"){
    break
  }
  if($mainmenu -eq "Setup ip ban protection"){
    configure-drony
  }
  if($mainmenu -eq "Quickstart"){
    cls
    Write-host ""
    Write-host $mainmenu
    Write-host ""
    $qstartselect = menu @("Start","Configure","go back")
    if($qstartselect -eq "Start"){
      quickstart
    }
    if($qstartselect -eq "Configure"){
      qs_opt $qstartselect
    }
    if($qstartselect -eq "go back"){
      show-main-menu
    }
    if([string]::IsNullOrEmpty($qstartselect)){
      show-main-menu
    }
  }
  if($mainmenu -eq "Check for Updates"){
    VWOCMBB-updater @("$global:botversion",((Get-Item -Path ".\").FullName))
  }
  if($mainmenu -eq "Start Emulator"){
    start-emulator
    show-main-menu
  }

  if([string]::IsNullOrEmpty($mainmenu)){
    show-main-menu
  }
}

#Quickstart Options
function qs_opt($selected){
  $xml = new-object System.Xml.XmlDocument
  $path = '.\data\settings.xml'
  $xml = [xml](Get-Content $path)
  cls
  Write-host ""
  Write-host $selected
  Write-host ""
  $qstartselect = menu @("Quickstart Mode","Time between emulators","Emulator","Delayed loading","go back")
  if($qstartselect -eq "Quickstart Mode"){
    cls
    Write-host ""
    Write-host $qstartselect
    Write-host ""
    $node = $xml.OPT.QST | Where-Object {$_.Name -eq 'qstmode'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = menu @("auto","manual")
    if($node -ne $null){
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    } else {
      $newrun = $xml.CreateElement("QST")
      $xml.OPT.AppendChild($newrun) | out-null
      $newrun.SetAttribute("Name","qstmode");
      $newrun.SetAttribute("Value","$imput");
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    }
    if($imput -eq "manual"){
      if([System.IO.File]::Exists("C:\vwocmbb_ps\data\quickstart.xml")){
        qs_opt "Configure"
      } else {
        cls
        Write-host ""
        Write-host "Quickstart file located at:"
        Write-host "C:\vwocmbb_ps\data\quickstart.xml"
        Write-host ""
        Copy-Item -Path "C:\vwocmbb_ps\data\bin\quickstart_empty.xml" -Destination "C:\vwocmbb_ps\data\quickstart.xml" -Force
        start-sleep -s 7
        qs_opt "Configure"
      }
    } else {
      qs_opt "Configure"
    }
  }
  if($qstartselect -eq "Time between emulators"){
    cls
    Write-host ""
    Write-host $qstartselect
    Write-host ""
    $node = $xml.OPT.QST | Where-Object {$_.Name -eq 'qsttime'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = Read-Host -Prompt "Type the time in secends between each Emulator start."
    if($node -ne $null){
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    } else {
      $newrun = $xml.CreateElement("QST")
      $xml.OPT.AppendChild($newrun) | out-null
      $newrun.SetAttribute("Name","qsttime");
      $newrun.SetAttribute("Value","$imput");
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    }
    qs_opt "Configure"
  }
  if($qstartselect -eq "Delayed loading"){
    cls
    Write-host ""
    Write-host $qstartselect
    Write-host ""
    $node = $xml.OPT.QST | Where-Object {$_.Name -eq 'delayed'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = Read-Host -Prompt "Type the time in secends for delayed start"
    if($node -ne $null){
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    } else {
      $newrun = $xml.CreateElement("QST")
      $xml.OPT.AppendChild($newrun) | out-null
      $newrun.SetAttribute("Name","delayed");
      $newrun.SetAttribute("Value","$imput");
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    }
    qs_opt "Configure"
  }
  if($qstartselect -eq "Emulator"){
    cls
    Write-host ""
    Write-host $qstartselect
    Write-host ""
    $node = $xml.OPT.QST | Where-Object {$_.Name -eq 'qstemulator'}
    Write-host "Current value is: "$node.Value
    Write-host ""
    $imput = menu @("Nox","MEmu")
    if($node -ne $null){
      $node.Value = "$imput"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    } else {
      $newrun = $xml.CreateElement("QST")
      $xml.OPT.AppendChild($newrun) | out-null
      $newrun.SetAttribute("Name","qstemulator");
      $newrun.SetAttribute("Value","$imput");
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    }
    qs_opt "Configure"
  }
  if($qstartselect -eq "go back"){
    show-main-menu
  }
  if([string]::IsNullOrEmpty($qstartselect)){
    show-main-menu
  }
}

function quickbot([array]$quickbotargs){
  $emu_mode = $quickbotargs[0]
  $device_addr = $quickbotargs[1]
  $select_bot = $quickbotargs[2]
  $global:active_emulator = $quickbotargs[3]
  $global:deb_bot_name = $select_bot
  if($emu_mode -eq "Nox"){
    $global:adbpath = $global:Nox+"\adb.exe"
    $global:emulatorpath = $global:Nox
    $global:emumode = "Nox"
  }
  if($emu_mode -eq "MEmu"){
    $global:adbpath = $global:MEmu+"\adb.exe"
    $global:emulatorpath = $global:MEmu
    $global:emumode = "MEmu"
  }
  $global:adbname = $device_addr
  $args_arr = @("jobs",$global:emumode,$device_addr,$select_bot)
  #Start-Job -ScriptBlock {Start-Process "C:\vwocmbb_ps\start.lnk" -ArgumentList $args} -ArgumentList $args_arr
  read-botxml $select_bot
}

function jobbot([array]$quickbotargs){
  $emu_mode = $quickbotargs[0]
  $device_addr = $quickbotargs[1]
  $select_bot = $quickbotargs[2]
  if($emu_mode -eq "Nox"){
    $global:adbpath = $global:Nox+"\adb.exe"
    $global:emulatorpath = $global:Nox
    $global:emumode = "Nox"
  }
  if($emu_mode -eq "MEmu"){
    $global:adbpath = $global:MEmu+"\adb.exe"
    $global:emulatorpath = $global:MEmu
    $global:emumode = "MEmu"
  }
  $global:adbname = $device_addr
    $i = 0
    while($i -eq 0){
    doOCR 2 "" "" ""
    start-sleep -m 150
    }
}

function quickstart(){
  cls
  Write-host ""
  Write-host "Quickstart"
  Write-host ""
  if($global:qst_mode -eq "auto"){
    if($global:qst_emul -eq "Nox"){
      $global:adbpath = $global:Nox+"\adb.exe"
      $global:emulatorpath = $global:Nox
      $global:emumode = "Nox"
    }
    if($global:qst_emul -eq "MEmu"){
      $global:adbpath = $global:MEmu+"\adb.exe"
      $global:emulatorpath = $global:MEmu
      $global:emumode = "MEmu"
    }
    if([string]::IsNullOrEmpty($global:qst_mode)){
      cls
      Write-host ""
      Write-host "Quickstart not configured!"
      Write-host "redirect to configuration"
      Write-host ""
      start-sleep -s 4
      qs_opt "Configure"
    }
    [array]$botlist = (Get-ChildItem ((Get-Item -Path ".\").FullName+"\bots\") -Name)
    $i = 1
    if($global:emumode -eq "Nox"){
      [array]$emulator_name = (Get-ChildItem ($global:emulatorpath+"\BignoxVMS") -Name -attributes D)
      while($i -le $botlist.count){
        .($global:emulatorpath+"\Nox.exe") -clone:"Nox_$i"
        Start-Sleep-Prog $global:qst_time "Start Emulator Nox_$i"
        $i++
      }
    }
    if($global:emumode -eq "MEmu"){
      [array]$emulator_name = (Get-ChildItem ($global:emulatorpath+"\MemuHyperv VMs") -Name -attributes D)
      while(($i-1) -le $botlist.count){
        .($global:emulatorpath+"\MEmuConsole.exe") "MEmu_$i"
        Start-Sleep-Prog $global:qst_time "Start Emulator MEmu_$i"
        $i++
      }
    }
    Start-Sleep-Prog $global:esd "Waiting for emulators"
    $devi_num = 26
    foreach($bot in $botlist){
      $args_arr = @("quickbot",$global:emumode,"127.0.0.1:620$devi_num",$bot)
      Start-Process "C:\vwocmbb_ps\start.lnk" -ArgumentList $args_arr
      $devi_num++
    }
  }
  if($global:qst_mode -eq "manual"){
    $xml = new-object System.Xml.XmlDocument
    $path = '.\data\quickstart.xml'
    $xml = [xml](Get-Content $path)
    if($global:qst_emul -eq "Nox"){
      $global:adbpath = $global:Nox+"\adb.exe"
      $global:emulatorpath = $global:Nox
      $global:emumode = "Nox"
    }
    if($global:qst_emul -eq "MEmu"){
      $global:adbpath = $global:MEmu+"\adb.exe"
      $global:emulatorpath = $global:MEmu
      $global:emumode = "MEmu"
    }
    if([string]::IsNullOrEmpty($global:qst_mode)){
      cls
      Write-host ""
      Write-host "Quickstart not configured!"
      Write-host "redirect to configuration"
      Write-host ""
      start-sleep -s 4
      qs_opt "Configure"
    }
    if($global:emumode -eq "Nox"){
      foreach($emu in $xml.Data.QST){
        .($global:emulatorpath+"\Nox.exe") -clone:$emu.Name
        Start-Sleep-Prog $global:qst_time "Start Emulator "+$emu.Name
      }
    }
    if($global:emumode -eq "MEmu"){
      foreach($emu in $xml.Data.QST){
        .($global:emulatorpath+"\MEmuConsole.exe") $emu.Name
        Start-Sleep-Prog $global:qst_time "Start Emulator "+$emu.Name
      }
    }
    Start-Sleep-Prog $global:esd "Waiting for emulators"
    foreach($emu in $xml.Data.QST){
      $bot = $emu.Bot+".xml"
      $args_arr = @("quickbot",$global:emumode,$emu.Address,$bot,$emu.Name)
      Start-Process "C:\vwocmbb_ps\start.lnk" -ArgumentList $args_arr
    }
  }
  if([string]::IsNullOrEmpty($global:qst_mode)){
    cls
    Write-host ""
    Write-host "Quickstart not configured!"
    Write-host "redirect to configuration"
    Write-host ""
    qs_opt "Configure"
  }
}

<#
  Start bot
#>
function start-bot(){
  cls
  Write-host ""
  Write-host "Select your device type:"
  Write-host ""
  $emulatorselect = menu (prepare-emulator-list "bot")
  if($emulatorselect -eq "Nox"){
    $global:adbpath = $global:Nox+"\adb.exe"
    $global:emulatorpath = $global:Nox
    $global:emumode = "Nox"
  }
  if($emulatorselect -eq "MEmu"){
    $global:adbpath = $global:MEmu+"\adb.exe"
    $global:emulatorpath = $global:MEmu
    $global:emumode = "MEmu"
  }
  if($emulatorselect -eq "USB"){
    $global:adbpath = $(Get-Item -Path ".\").FullName+"\data\adb\adb.exe"
    $global:emumode = "USB"
  }
  if([System.IO.File]::Exists($global:adbpath)){
    if($global:emumode -eq "USB"){
      list-adb-devices
    } else {
      list-emulators $global:emumode
      cls
      Start-Sleep-Prog $global:esd "Start Emulator"
      list-adb-devices
    }
    cls
    Write-host ""
    Write-host "Select your device:"
    Write-host ""
    $global:adbname = (menu $global:devicelist).Trim()
    if($global:emumode -eq "USB"){
      cls
      Write-host ""
      Write-host "Prepare device..."
      Write-host ""
      Write-host "Set resolution to 1080x1920"
      Write-host ""
      $usbargs = @("-s $global:adbname","shell wm size 1080x1920")
      run-prog $global:adbpath $usbargs
      Write-host "Set density to 240"
      Write-host ""
      $usbargs = @("-s $global:adbname","shell wm density 240")
      run-prog $global:adbpath $usbargs
      start-sleep -s 3
    }
    cls
    Write-host ""
    Write-host "Select your bot:"
    Write-host ""
    $select_bot =  menu (Get-ChildItem ((Get-Item -Path ".\").FullName+"\bots\") -Name)
    $args_arr = @("jobs",$global:emumode,$global:adbname,$select_bot)
    #Start-Job -ScriptBlock {Start-Process "C:\vwocmbb_ps\start.lnk" -ArgumentList $args} -ArgumentList $args_arr
    $global:deb_bot_name = $select_bot
    read-botxml $select_bot
  } else {
    Write-host ""
    Write-host "adb.exe was not found!"
    Write-host ""
    Start-Sleep -Seconds 4
    show-main-menu
  }
}

<#
Sleep with visual progress
#>
function Start-Sleep-Prog($seconds,$Message) {
    $doneDT = (Get-Date).AddSeconds($seconds)
    while($doneDT -gt (Get-Date)) {
        $secondsLeft = $doneDT.Subtract((Get-Date)).TotalSeconds
        $percent = ($seconds - $secondsLeft) / $seconds * 100
        Write-Progress -Activity "$Message" -Status "Loading..." -SecondsRemaining $secondsLeft -PercentComplete $percent
        [System.Threading.Thread]::Sleep(500)
    }
    Write-Progress -Activity "Sleeping" -Status "Sleeping..." -SecondsRemaining 0 -Completed
}

<#
  Start emulator
#>
function start-emulator(){
  cls
  Write-host ""
  Write-host "Select your device type:"
  Write-host ""
  $emulatorselect = menu (prepare-emulator-list)
  if($emulatorselect -eq "Nox"){
    $global:adbpath = $global:Nox+"\adb.exe"
    $global:emulatorpath = $global:Nox
    $global:emumode = "Nox"
  }
  if($emulatorselect -eq "MEmu"){
    $global:adbpath = $global:MEmu+"\adb.exe"
    $global:emulatorpath = $global:MEmu
    $global:emumode = "MEmu"
  }
  if([System.IO.File]::Exists($global:adbpath)){
    list-emulators $global:emumode
  } else {
    Write-host ""
    Write-host "adb.exe was not found!"
    Write-host ""
    Start-Sleep -Seconds 4
    show-main-menu
  }
}

<#
List emulators
#>
function list-emulators($emumode){
  $global:emu_mode = $emumode
  cls
  Write-host ""
  Write-host "Select your emulator:"
  Write-host ""
  if($emumode -eq "Nox"){
    $emulator_name = menu (Get-ChildItem ($global:emulatorpath+"\BignoxVMS") -Name -attributes D)
    $global:active_emulator = $emulator_name
    .($global:emulatorpath+"\Nox.exe") -clone:$emulator_name
  }
  if($emumode -eq "MEmu"){
    $emulator_name = menu (Get-ChildItem ($global:emulatorpath+"\MemuHyperv VMs") -Name -attributes D)
    $global:active_emulator = $emulator_name
    .($global:emulatorpath+"\MEmuConsole.exe") $emulator_name
  }
}

<#
  Load settings from xml
#>
function loadxmlsettings($qstop,[array]$quickbotargs){
  Copy-Item -Path "C:\vwocmbb_ps\data\bin\active_accounts_empty.xml" -Destination "C:\vwocmbb_ps\data\active_accounts.xml" -Force
  if([System.IO.File]::Exists("C:\vwocmbb_ps\extension\VWOCMBB-customcode\VWOCMBB-customcode.psm1")){
    cls
  } else {
    Copy-Item -Path "C:\vwocmbb_ps\data\bin\VWOCMBB-customcode" -Destination "C:\vwocmbb_ps\extension\VWOCMBB-customcode" -Recurse
  }
  if([System.IO.File]::Exists("C:\vwocmbb_ps\data\timings\time_db.xml")){
    cls
  } else {
    Copy-Item -Path "C:\vwocmbb_ps\data\bin\time_db_empty.xml" -Destination "C:\vwocmbb_ps\data\timings\time_db.xml" -Force
  }
  if([System.IO.File]::Exists("C:\vwocmbb_ps\data\AI\ai_db.xml")){
    cls
  } else {
    Copy-Item -Path "C:\vwocmbb_ps\data\bin\ai_db_empty.xml" -Destination "C:\vwocmbb_ps\data\AI\ai_db.xml" -Force
  }
  $xml = new-object System.Xml.XmlDocument
  $path = '.\data\settings.xml'
  $xml = [xml](Get-Content $path)
  $global:vld = ($xml.OPT.Time | Where-Object {$_.Name -eq 'vld'}).Value
  $global:smcd = ($xml.OPT.Time | Where-Object {$_.Name -eq 'smcd'}).Value
  $global:tbl = ($xml.OPT.Time | Where-Object {$_.Name -eq 'tbl'}).Value
  $global:ct = ($xml.OPT.Time | Where-Object {$_.Name -eq 'ct'}).Value
  $global:esd = ($xml.OPT.Time | Where-Object {$_.Name -eq 'esd'}).Value
  $global:Nox = ($xml.OPT.Path | Where-Object {$_.Name -eq 'Nox'}).Value
  $global:MEmu = ($xml.OPT.Path | Where-Object {$_.Name -eq 'MEmu'}).Value
  $global:nsp = ($xml.OPT.Path | Where-Object {$_.Name -eq 'nsp'}).Value
  $global:msp = ($xml.OPT.Path | Where-Object {$_.Name -eq 'msp'}).Value
  $autoupdate = ($xml.OPT.Update | Where-Object {$_.Name -eq 'update'}).Value
  $global:usb_mode = ($xml.OPT.USB | Where-Object {$_.Name -eq 'usb-mode'}).Value
  $global:botversion = $xml.OPT.Version.Value
  $tmpminms = ($xml.OPT.MSOPT | Where-Object {$_.Name -eq 'minms'}).Value
  $tmpmaxms = ($xml.OPT.MSOPT | Where-Object {$_.Name -eq 'maxms'}).Value
  $global:qst_mode = ($xml.OPT.QST | Where-Object {$_.Name -eq 'qstmode'}).Value
  $global:qst_time = ($xml.OPT.QST | Where-Object {$_.Name -eq 'qsttime'}).Value
  $global:qst_emul = ($xml.OPT.QST | Where-Object {$_.Name -eq 'qstemulator'}).Value
  $global:delayed = ($xml.OPT.QST | Where-Object {$_.Name -eq 'delayed'}).Value
  $global:tbreak = ($xml.OPT.OTW | Where-Object {$_.Name -eq 'tbreak'}).Value

  if($tmpminms -ne $null){
    $global:minms = $tmpminms
  }
  if($tmpmaxms -ne $null){
    $global:maxms = $tmpmaxms
  }
  if($qstop -eq "quick"){
    Start-Sleep-Prog $global:delayed "Delayed boot..."
    quickstart
  }
  if($qstop -eq "quickbot"){
    quickbot $quickbotargs
  }
  if($qstop -eq "jobs"){
    jobbot $quickbotargs
  }
  $host.ui.RawUI.WindowTitle = "VWOCMB Bot Version: $global:botversion"
  VWOCMBB-position @("20","30","850","450")
  if($autoupdate -eq "Yes"){
    VWOCMBB-updater @("$global:botversion",((Get-Item -Path ".\").FullName))
  }
  if($global:usb_mode -eq "On"){
    show-main-menu
  } else {
  if([string]::IsNullOrEmpty(($global:Nox + $global:MEmu))){
    cls
    Write-host ""
    Write-host "No emulator found! Please update your settings"
    Write-host ""
    Start-Sleep -Seconds 4
    show-settings-menu
  } else {
    $error_path = 2
    if([string]::IsNullOrEmpty($global:Nox)){
      $error_path = ($error_path-1)
    } else {
      if([System.IO.File]::Exists($global:Nox+"\adb.exe")){
        $error_path = ($error_path-1)
      }
    }
    if([string]::IsNullOrEmpty($global:MEmu)){
      $error_path = ($error_path-1)
    } else {
      if([System.IO.File]::Exists($global:MEmu+"\adb.exe")){
        $error_path = ($error_path-1)
      }
    }
    if($error_path -eq 0){
      if([string]::IsNullOrEmpty(($global:nsp + $global:msp))){
        cls
        Write-host ""
        Write-host "No Share Path found! Please update your settings"
        Write-host ""
        Start-Sleep -Seconds 4
        show-settings-menu
      } else {
          $error_path = 0
          if([string]::IsNullOrEmpty($global:nsp)){
            $error_path = ($error_path+1)
          }
          if([string]::IsNullOrEmpty($global:msp)){
            $error_path = ($error_path+1)
          }
          if($error_path -eq 2){
            cls
            Write-host ""
            Write-host "No Share Path found! Please update your settings"
            Write-host ""
            Start-Sleep -Seconds 4
            show-settings-menu
          } else {
            show-main-menu
          }
        }
    } else {
      cls
      Write-host ""
      Write-host "One of your emulatorpath is wrong! Please update your settings"
      Write-host ""
      Start-Sleep -Seconds 4
      show-settings-menu
    }
  }
}
}

function Randomize-List{
   Param(
     [array]$InputList
   )

   return $InputList | Get-Random -Count $InputList.Count;
}

function debug_log_start{
 return (Get-Date)
}

function debug_log_stop($starttime,$name,$comment){
  $tody_logdate = (Get-Date -Format d.M.yyyy)
  try {
    New-Item -ItemType directory -Path C:\vwocmbb_ps\data\logs\$tody_logdate\ -errorAction SilentlyContinue
  } catch {

  }
  $Elapsed = ((Get-Date) - $starttime).ToString()
  $filename = $global:logname
  $datname = ($global:adbname -replace ":",".").Trim()
  $bot_name = $global:deb_bot_name
  $recordet_time_at = (Get-Date).tostring()
  $path = "\vwocmbb_ps\data\logs\$tody_logdate\$filename.txt"

  if($name -eq "Botsession Duration"){
    $path = "\vwocmbb_ps\data\logs\$tody_logdate\$bot_name.session_duration.$datname.txt"
  }
  if($name -eq "Connection Lost, Renew IP"){
    $path = "\vwocmbb_ps\data\logs\$tody_logdate\$bot_name.session_duration.$datname.txt"
  }
  if($name -eq "Cannot load Account"){
    $path = "\vwocmbb_ps\data\logs\$tody_logdate\$bot_name.session_duration.$datname.txt"
  }
  $endline = "-----------------------------------------------------------------------------"

  If (Test-Path $path){
    if($name -eq "Account duration"){
      @($endline,$endline,"At      : $recordet_time_at",$endline,$endline,"Name    : $name", "Comment : $comment","Duration: $Elapsed",$endline) +  (Get-Content $path) | Set-Content $path
    } else {
      if($name -eq "Botsession Duration"){
        @($endline,$endline,"At      : $recordet_time_at",$endline,$endline,"Name    : $name", "Comment : $comment","Duration: $Elapsed",$endline) +  (Get-Content $path) | Set-Content $path
      } else {
        @("Name    : $name", "Comment : $comment","At      : $recordet_time_at","Duration: $Elapsed",$endline) +  (Get-Content $path) | Set-Content $path
      }
    }
  }Else{
    if($name -eq "Account duration"){
      @($endline,$endline,"At      : $recordet_time_at",$endline,$endline,"Name    : $name", "Comment : $comment","Duration: $Elapsed",$endline) | Set-Content $path
    } else {
      if($name -eq "Botsession Duration"){
        @($endline,$endline,"At      : $recordet_time_at",$endline,$endline,"Name    : $name", "Comment : $comment","Duration: $Elapsed",$endline) | Set-Content $path
      } else {
        @("Name    : $name", "Comment : $comment","At      : $recordet_time_at","Duration: $Elapsed",$endline) | Set-Content $path
      }
    }
  }
}

function ocr_log_stop($starttime,$name,$comment){
  $tody_logdate = (Get-Date -Format d.M.yyyy)
  try {
    New-Item -ItemType directory -Path C:\vwocmbb_ps\data\logs\$tody_logdate\ -errorAction SilentlyContinue
  } catch {

  }
  $Elapsed = ((Get-Date) - $starttime).ToString()
  $filename = $global:logname
  $datname = ($global:adbname -replace ":",".").Trim()
  $recordet_time_at = (Get-Date).tostring()
  $path = "\vwocmbb_ps\data\logs\$tody_logdate\ocr_log.$datname.txt"
  $endline = "-----------------------------------------------------------------------------"
  If (Test-Path $path){
    @("Name    : $name", "Comment : $comment","At      : $recordet_time_at","Duration: $Elapsed",$endline) + (Get-Content $path) | Set-Content $path
  } else {
    @("Name    : $name", "Comment : $comment","At      : $recordet_time_at","Duration: $Elapsed",$endline) | Set-Content $path
  }
}

<#
read bot xml file
#>
function read-botxml($botfile){
  if($global:emumode -eq "Nox"){
    $nox_vers = (get-item "$global:Nox\Nox.exe").VersionInfo.FileVersion
    if($nox_vers -ne "V.6.2.5.2"){
      cls
      Write-host ""
      Write-host "Please change Nox to version V.6.2.5.2"
      Write-host "Your version is: $nox_vers"
      Write-host ""
      Write-host "Download start in 10 seconds!"
      Write-host ""
      start-sleep -s 10
      start 'https://easy-develope.ch/ps_bot_update/nox/nox_setup_v6.2.5.2_full_intl.zip'
      start-sleep -s 1
      break
    }
  }
  $st_bot_start = debug_log_start
  set_loop_start
  cls
  reconnect_device
  cls
  $adbArgList = @(
    "-s $global:adbname",
    "shell monkey -p org.sandroproxy.drony -v 1"
  )
  run-prog $global:adbpath $adbArgList
  cls
  Start-Sleep-Prog 10 "Boot Drony"
  $global:active_bot = $botfile
  $xml = new-object System.Xml.XmlDocument
  $path = ".\bots\$botfile"
  cls
  Write-host ""
  if((ValidateXmlFile $path) -eq $false){
    start-sleep -s 60
    Write-host ""
    Write-host "Close in 60s"
    break
  }
  try{
    $xml_content = Get-Content $path
    $xml_content | Set-Content -Encoding utf8 $path
  } catch {
    cls
    Write-host ""
    write-host "Cannot convert botfile to utf8 $path"
    Write-host "Error-Code:"
    $xml_content = Get-Content $path
    $xml_content | Set-Content -Encoding utf8 $path
    start-sleep -s 10
    break
  }
  try{
    $xml = [xml](Get-Content $path)
  } catch {
    cls
    Write-host ""
    Write-host "Error Loading Botfile $path"
    Write-host "Error-Code:"
    $xml = [xml](Get-Content $path)
    start-sleep -s 10
    break
  }
  if ($xml.Bot.OPT.LoopTimeout -ne $null) {
    $global:tbl = $xml.Bot.OPT.LoopTimeout.Value
  }
  if ($xml.Bot.OPT.ClickTimeout -ne $null) {
    $global:ct = $xml.Bot.OPT.ClickTimeout.Value
  }
  if (($xml.Bot.OPT.Posx -ne $null) -and ($xml.Bot.OPT.Posy -ne $null) -and ($xml.Bot.OPT.Height -ne $null) -and ($xml.Bot.OPT.Width -ne $null)) {
    VWOCMBB-position @($xml.Bot.OPT.Posx.Value,$xml.Bot.OPT.Posy.Value,$xml.Bot.OPT.Height.Value,$xml.Bot.OPT.Width.Value)
  }
  if ($xml.Bot.OPT.RNDMode -ne $null) {
    if($xml.Bot.OPT.RNDMode.Value -eq "off"){
      $rndmode_state = 0
      $acc_name_array = $xml.Bot.Account.Name
    }
    if($xml.Bot.OPT.RNDMode.Value -eq "on"){
      $rndmode_state = 1
      $acc_name_array = (Randomize-List -InputList $xml.Bot.Account.Name)
    }
  } else {
    $rndmode_state = 1
    $acc_name_array = (Randomize-List -InputList $xml.Bot.Account.Name)
  }
  start-sleep-prog (Get-Random -Minimum 5 -Maximum 40) "Prepare Bot..."
  foreach ($account in $acc_name_array) {
    $st_acc_start = debug_log_start
    if((is-acc-running $account) -eq 0){
      if((acc $account) -eq 0){
        $acc_cont = $xml.Bot.Account | Where-Object {$_.Name -eq $account}

            if($rndmode_state -eq 1){
              $acc_func_array = (Randomize-List -InputList $acc_cont.Function.Name)
            } else {
              $acc_func_array = $acc_cont.Function.Name
            }

        foreach ($function in $acc_func_array){
          $st_function_start = debug_log_start
          $func_cont = $acc_cont.Function | Where-Object {$_.Name -eq $function}
          $func_params = $func_cont.Param.Value
          if($func_params.Length -gt 0){
          if (Get-Command $function -errorAction SilentlyContinue){
            reconnect_device
            $error = & $function $func_params -errorAction SilentlyContinue
          }
          } else {
            if (Get-Command $function -errorAction SilentlyContinue){
            reconnect_device
            $error = & $function -errorAction SilentlyContinue
            }
          }
          debug_log_stop $st_function_start "Function duration" $function
        }
      } else {
        $st_cla_start = debug_log_start
        cls
        Write-host ""
        Write-host "Cannot load Account: $account"
        Write-host ""
        Start-Sleep -Seconds 2
        debug_log_stop $st_cla_start "Cannot load Account" "Multibox cannot open acc: $account"
      }
    } else {
      $st_rob_start = debug_log_start
      cls
      Write-host ""
      Write-host "Account: $account is running in other bot. Skip"
      Write-host ""
      Start-Sleep -Seconds 2
      debug_log_stop $st_rob_start "Cannot load Account" "Acc: $account is active on other bot"
    }
    debug_log_stop $st_acc_start "Account duration" $account
  }
  debug_log_stop $st_bot_start "Botsession Duration" "Botfile: $botfile"
  restart-loop
}

function set_loop_start{
  if($global:loop_start_time -eq ""){
      $global:loop_start_time = (Get-Date)
  }
}

function aut_reboot_emu{
  $loopstart = $global:loop_start_time
  $now_time = (get-date)
  $diff = ($now_time - $loopstart).hours
  if($diff -ge 1){
    #todo reboot
    if($global:emumode -eq "Nox"){
      .($global:emulatorpath+"\Nox.exe") -clone:$global:active_emulator -quit
      Start-Sleep-Prog 10 "Shutdown Emulator"
      .($global:emulatorpath+"\Nox.exe") -clone:$global:active_emulator
      Start-Sleep-Prog $global:esd "Start Emulator"
      reconnect_device
      cls
      $adbArgList = @(
        "-s $global:adbname",
        "shell monkey -p org.sandroproxy.drony -v 1"
      )
      run-prog $global:adbpath $adbArgList
      cls
      Start-Sleep-Prog 10 "Boot Drony"
    }
    if($global:emumode -eq "MEmu"){
      [string]$memuname = $global:active_emulator
      .($global:emulatorpath+"\MEmuConsole.exe") ShutdownVm $global:active_emulator
      Start-Sleep-Prog 10 "Shutdown Emulator"
      .($global:emulatorpath+"\MEmuConsole.exe $memuname")
      Start-Sleep-Prog $global:esd "Start Emulator"
      reconnect_device
      cls
      $adbArgList = @(
        "-s $global:adbname",
        "shell monkey -p org.sandroproxy.drony -v 1"
      )
      run-prog $global:adbpath $adbArgList
      cls
      Start-Sleep-Prog 10 "Boot Drony"
    }
    $global:loop_start_time = (Get-Date)
  }
}

<#
  restart loop
#>
function restart-loop{
  $adbArgList = @(
    "-s $global:adbname",
    "shell am force-stop ch.easy_develope.vwocmb.vikingswarofclansmultibox"
  )
  run-prog $global:adbpath $adbArgList
  $adbArgList = @(
    "-s $global:adbname",
    "shell am force-stop com.plarium.vikings"
  )
  run-prog $global:adbpath $adbArgList
  Copy-Item -Path "C:\vwocmbb_ps\data\bin\active_accounts_empty.xml" -Destination "C:\vwocmbb_ps\data\active_accounts.xml" -Force
  cls
  if($global:running_acc -ne ""){
  remove-running $global:running_acc
  }
  $adbArgList = @(
    "-s $global:adbname",
    "shell input keyevent 3"
  )
  run-prog $global:adbpath $adbArgList
  Start-Sleep-Prog $global:tbl "Loop has finish! Restart is"
  read-botxml $global:active_bot
}

<#
Call multibox account
#>
function acc($params){
  aut_reboot_emu
  $global:logname = ($params -replace " ","_") + "_" + ($global:active_bot -replace ".xml","") + "_" + ($global:adbname -replace ":",".").Trim()
  $host.ui.RawUI.WindowTitle = "$global:logname | VWOCMB Bot Version: $global:botversion"
  cls
  reconnect_device
  bot_notify "Open Multibox Account: $params"
  if($global:running_acc -ne ""){
  remove-running $global:running_acc
  }
  $global:running_acc = $params
  add-running $params
  $adbArgList = @(
    "-s $global:adbname",
    "shell input keyevent 3"
  )
  run-prog $global:adbpath $adbArgList
  cls
  bot_notify "Open Multibox API | Acc: $params"
  $accname = $params -replace " ", "_"
  $adbArgList = @(
    "-s $global:adbname",
    "shell am force-stop ch.easy_develope.vwocmb.vikingswarofclansmultibox"
  )
  run-prog $global:adbpath $adbArgList
  $adbArgList = @(
    "-s $global:adbname",
    "shell am force-stop com.plarium.vikings"
  )
  run-prog $global:adbpath $adbArgList
  Start-Sleep -Seconds 1
  $adbArgList = @(
    "-s $global:adbname",
    "shell am start",
    "-n ch.easy_develope.vwocmb.vikingswarofclansmultibox/ch.easy_develope.vwocmb.vikingswarofclansmultibox.MainActivity",
    '--es "accname" ' + $accname
  )
  run-prog $global:adbpath $adbArgList
  cls
  bot_notify "Open Multibox API | Acc: $params"
  Start-Sleep -Seconds 15
  $returnval = 0
  if((doOCR 1 "pixel-check" "mb_wont_load") -eq 1){
    $returnval = 1
  } else {
    $adbArgList = @(
      "-s $global:adbname",
      "shell am force-stop ch.easy_develope.vwocmb.vikingswarofclansmultibox"
    )
    run-prog $global:adbpath $adbArgList
  close-shop-window
  }
  return $returnval
}

<#
Close shop window
#>
function close-shop-window{
  $global:whereami = "close-shop-window"
  cls
  Start-Sleep-Prog $global:vld "Close shop popup"
  bot_notify "Check if connection lost"
  if((doOCR 1 "pixel-check" "connection_lost") -eq 1){
    $st_conlost_start = debug_log_start
    bot_notify "Connection lost!"
    Start-Sleep -s 1
    $adbArgList = @(
      "-s $global:adbname",
      "shell monkey -p org.sandroproxy.drony -v 1"
    )
    run-prog $global:adbpath $adbArgList
    cls
    Start-Sleep-Prog 60 "Renew IP address!"
    $adbArgList = @(
      "-s $global:adbname",
      "shell monkey -p com.plarium.vikings -v 1"
    )
    run-prog $global:adbpath $adbArgList
    cls
    Start-Sleep -m 2500
    doOCR 1 "pixel" "connection_lost" "close-shop-window"
    debug_log_stop $st_conlost_start "Connection Lost, Renew IP" $global:running_acc
    close-shop-window
  } else {
    doOCR 1 "pixel" "close_top_right" "close-shop-window"
  }
}

<#
OCR Close window
#>
function ai_close{
  bot_notify "ai_close"
  doOCR 1 "batch" @("close","close_4")
}

#bonus_collector
function bonus_collector{
  $global:whereami = "bonus_collector"
  bot_notify "bonus_collector"
  if((doOCR 1 "pixel-check" "bonus_obj") -eq 1){
    doOCR 0 "pixel" "bonus_obj"
    start-sleep -s 3
    click-screen 540 1333
    apply_vip_point
  }
}

function apply_vip_point{
  click-screen 623 139
  start-sleep -s 3
  click-screen 319 839
  if((doOCR 1 "check" "btn_use") -eq 1){
    $btn_use_visable = 1
    while($btn_use_visable -eq 1){
      doOCR 1 "single-long" "btn_use_vip"
      start-sleep -m 600
      click-screen 755 1178
      start-sleep -m 600
      click-screen 360 1400
      start-sleep -s 5
      click-screen 673 1240
      start-sleep -m 2000
      $btn_use_visable = doOCR 1 "check" "btn_use"
    }
  }
  doOCR 1 "pixel" "close_top_right"
}

#help_mem
function help_mem{
  $global:whereami = "help_mem"
  bot_notify "help_mem"
  if((doOCR 1 "pixel-check" "help_mem_hand") -eq 1){
    doOCR 0 "pixel" "help_mem_hand"
    start-sleep -s 2
    click-screen 881 1815
    start-sleep -m 500
    click-screen 1044 134
  }
}

#Open Loki
function loki{
  $global:whereami = "Open loki chest"
  bot_notify "open loki chest"
  Start-Sleep -s 3
  click-screen	985	1575
  Start-Sleep -s 3
  click-screen	520	1260
  Start-Sleep -s 1
}

#daygoals
function daygoals{
  $global:whereami = "daygoals"
  if(calculate-time @("d","1","daygoals","check") -eq 1){
    bot_notify "Daily Present | by K102"
    #Neuigkeiten weg klicken
    if((doOCR 1 "pixel-check" "news_obj_0") -eq 1){
      doOCR 0 "pixel" "news_obj_0"
      Start-Sleep -s 2
      doOCR 1 "pixel" "news_mark_read_btn"
    } else {
      if((doOCR 1 "pixel-check" "news_obj_1") -eq 1){
        doOCR 0 "pixel" "news_obj_1"
        Start-Sleep -s 2
        doOCR 1 "pixel" "news_mark_read_btn"
      }
    }
    doOCR 1 "pixel" "close_top_right"
    Start-Sleep -s 2
    if((doOCR 1 "pixel-check" "goals_obj") -eq 1){
      doOCR 0 "pixel" "goals_obj"
      Start-Sleep -s 3
      doOCR 1 "pixel" "ret_goals_btn"
    }
  calculate-time @("d","1","daygoals","update")
  }
}

#trainwarrior
function trainwarrior([array]$params){
  $global:whereami = "trainwarrior"
  $wartype = $params[0]
  $train_amount = $params[1]
  $repeate_time = $params[2]
  if(calculate-time @("h","$repeate_time","trainwarrior","check") -eq 1){
    bot_notify "Train warrior by K102,K127"
    click-screen 620 1830
    # Nahkämper  530 700
    # Kavallarie  530 900
    # Fernkämpfer 530 1130
    # Mörder      530 1350
    # Belagerung  530 1555
    # Spios       530 1800
    if($wartype -eq 1){
      $ai_val = read_ai_db "trainwarrior" "soldiers"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "soldiers" "trainwarrior"
      }
    }
    if($wartype -eq 2){
      $ai_val = read_ai_db "trainwarrior" "cavalry"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "cavalry" "trainwarrior"
      }
    }
    if($wartype -eq 3){
      $ai_val = read_ai_db "trainwarrior" "ranged"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "ranged" "trainwarrior"
      }
    }
    if($wartype -eq 4){
      $ai_val = read_ai_db "trainwarrior" "killer"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "killer" "trainwarrior"
      }
    }
    if($wartype -eq 5){
      $ai_val = read_ai_db "trainwarrior" "siege"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "siege" "trainwarrior"
      }
    }
    if($wartype -eq 6){
      $ai_val = read_ai_db "trainwarrior" "scout"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "scout" "trainwarrior"
      }
    }
    if($train_amount -eq 50){
      click-screen	400	850
    }
    if($train_amount -eq 100){
      click-screen	605	850
    }
    Start-Sleep -s 1
    click-screen	330	1100
    $ai_val = read_ai_db "trainwarrior" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "trainwarrior"
      }
  calculate-time @("h","$repeate_time","trainwarrior","update")
  }
}

#buildskill
function buildskill{
  $global:whereami = "buildskill"
  if(calculate-time @("d","99999","buildskill","check") -eq 1){
    bot_notify "Building skill by K102"
    click-screen 980	1820
    click-screen 400 950
    Start-Sleep -s 2
    click-screen 100	1570
    for ($i=1;$i -le 10;$i++){
      click-screen 360	670
    }
    $ai_val = read_ai_db "buildskill" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "buildskill"
      }
    calculate-time @("d","99999","buildskill","update")
  }
}

#traintroop
function traintroop{
  $global:whereami = "traintroop"
  if(calculate-time @("d","1","traintroop","check") -eq 1){
    bot_notify "Train 1 Warrior"
    click-screen 620	1830
    doOCR 1 "single" "soldiers" "traintroop"
    start-sleep -s 2
    click-screen 770	1090
    doOCR 1 "pixel" "close_top_right" "traintroop"
    calculate-time @("d","1","traintroop","update")
  }
}

#putshield
function putshield{
  $global:whereami = "putshield"
  if(calculate-time @("d","1","putshield","check") -eq 1){
    bot_notify "Put shield"
    click-screen 	260	1806
    Start-Sleep -m 1500
    $clickarray = @("966,446","911,1156","731,1260","377,820","731,1260","921,814","711,1266","390,1145","711,1266")
    foreach ($click in $clickarray){
      $click = $click.Split(",")
      $clickx = $click[0]
      $clicky = $click[1]
      Start-Sleep -m 350
      click-screen $clickx $clicky
    }
    Start-Sleep -s 1
    $ai_val = read_ai_db "putshield" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "putshield"
      }
  calculate-time @("d","1","putshield","update")
  }
}

#castlechest
function castlechest([array]$params){
  $global:whereami = "castlechest"
  if(calculate-time @("d","1","castlechest","check") -eq 1){
    $loop_amount = [int]$params[0]
    bot_notify "Grab castle chest"
    click-screen 243 1824
    Start-Sleep -s 1
    for ($i=1;$i -le $loop_amount;$i++){
      click-screen 744 299
      click-screen 934 822
    }
    Start-Sleep -s 1
    $ai_val = read_ai_db "castlechest" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "castlechest"
      }
  calculate-time @("d","1","castlechest","update")
  }
}


#missions
function missions([array]$params){
  $global:whereami = "missions"
  if(calculate-time @("d","1","missions","check") -eq 1){
    $loop_amount = [int]$params[0]
    bot_notify "Finish Missions"
    click-screen 101	324
    Start-Sleep -s 1
    for ($i=1;$i -le $loop_amount;$i++){
      click-screen 815	757
    }
    Start-Sleep -s 1
    $ai_val = read_ai_db "missions" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "missions"
      }
    calculate-time @("d","1","missions","update")
  }
}

#skins
function skins{
  $global:whereami = "skins"
  if(calculate-time @("d","1","skins","check") -eq 1){
    bot_notify "Apply Skin"
    click-screen 280  1820
    Start-Sleep -s 1
    click-screen 752 467
    Start-Sleep -s 1
    $clickarray = @("889,1687","684,1266","377,820","684,1266","885,831","689,1268","390,1680","689,1268")
    foreach ($click in $clickarray){
      $click = $click.Split(",")
      $clickx = $click[0]
      $clicky = $click[1]
      Start-Sleep -m 350
      click-screen $clickx $clicky
    }
    Start-Sleep -s 1
    $ai_val = read_ai_db "skins" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "skins"
      }
    calculate-time @("d","1","skins","update")
  }
}

#invaider_lvl_1_knowlege
function invader_lvl_1_knowlege{
  $global:whereami = "invader_lvl_1_knowlege"
  if(calculate-time @("d","99999","invader_lvl_1_knowlege","check") -eq 1){
    bot_notify "Invader knowlege"
    click-screen  992 1828
    Start-Sleep -s 1
    $clickarray = @("900,650","600,1380","500,400","320,960","760,930")
    foreach ($click in $clickarray){
      $click = $click.Split(",")
      $clickx = $click[0]
      $clicky = $click[1]
      Start-Sleep -m 350
      click-screen $clickx $clicky
    }
    $ai_val = read_ai_db "invader_lvl_1_knowlege" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "invader_lvl_1_knowlege"
      }
  calculate-time @("d","99999","invader_lvl_1_knowlege","update")
  }
}

#getkvkcvcrelo
function getkvkcvcrelo([array]$params){
  $global:whereami = "getkvkcvcrelo"
  if((get-date).DayOfWeek -eq "Tuesday" -or (get-date).DayOfWeek -eq "Wednesday" -or (get-date).DayOfWeek -eq "Friday" -or (get-date).DayOfWeek -eq "Saturday" -or (get-date).DayOfWeek -eq "Sunday"){
  if(calculate-time @("d","0","getkvkcvcrelo","check") -eq 1){
    $shmode=$params[0]
    if($shmode -eq 0){
      $shtext="without Stronghold"
      [int]$shposx=89
      [int]$shposy=500
    }

    if($shmode -eq 1){
      $shtext=with Stronghold
      [int]$shposx=98
      [int]$shposy=641
    }
    bot_notify " Get Relocation $shtext | by K127"
    Start-Sleep -s 1
    map
    click-screen $shposx $shposy
    Start-Sleep -s 2
    click-screen 891 1331
    click-screen 908 1673
    Start-Sleep -s 2
    $ai_val = read_ai_db "getkvkcvcrelo" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "getkvkcvcrelo"
      }
    Start-Sleep -s 1
    city
    if((get-date).DayOfWeek -eq "Tuesday"){
      calculate-time @("d","3","getkvkcvcrelo","update")
    }
    if((get-date).DayOfWeek -eq "Wednesday"){
      calculate-time @("d","2","getkvkcvcrelo","update")
    }
    if((get-date).DayOfWeek -eq "Friday"){
      calculate-time @("d","4","getkvkcvcrelo","update")
    }
    if((get-date).DayOfWeek -eq "Saturday"){
      calculate-time @("d","3","getkvkcvcrelo","update")
    }
    if((get-date).DayOfWeek -eq "Sunday"){
      calculate-time @("d","2","getkvkcvcrelo","update")
    }
  }
}
}


#city
function city{
  click-screen 99 1820
  start-sleep-prog $global:smcd "open city"
}

#map
function map{
  click-screen 99 1820
  start-sleep-prog $global:smcd "open map"
}

#helpclanmem
function helpclanmem{
  $global:whereami = "helpclanmem"
  bot_notify "help clan member"
  click-screen 800 1830
  start-sleep -m 700
  click-screen 728 1837
  start-sleep -m 700
  click-screen 881 1815
  start-sleep -m 700
  $ai_val = read_ai_db "helpclanmem" "close"
    if($ai_val -ne 0){
      $posx = $ai_val[0]
      $posy = $ai_val[1]
      click-screen $posx $posy
    } else {
      doOCR 1 "single" "close" "helpclanmem"
    }
}

#helpclanmem
function helpclanmemsmall{
  $global:whereami = "helpclanmemsmall"
  bot_notify "help clan member small"
  click-screen 800 1830
  start-sleep -m 700
  click-screen 513 1670
  start-sleep -m 700
  click-screen 881 1815
  start-sleep -m 700
  $ai_val = read_ai_db "helpclanmemsmall" "close"
    if($ai_val -ne 0){
      $posx = $ai_val[0]
      $posy = $ai_val[1]
      click-screen $posx $posy
    } else {
      doOCR 1 "single" "close" "helpclanmemsmall"
    }
}

#K127-inv-gho
#hitlvl1
function hitlvl1{
  $global:whereami = "HitInavder Lvl: 1"
  bot_notify "HitInavder Lvl: 1"
  Start-Sleep -s 2
  click-screen 265 764
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl2
function hitlvl2{
  $global:whereami = "HitInavder Lvl: 2"
  bot_notify "HitInavder Lvl: 2"
  Start-Sleep -s 2
  click-screen 259 557
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl3
function hitlvl3{
  $global:whereami = "HitInavder Lvl: 3"
  bot_notify "HitInavder Lvl: 3"
  Start-Sleep -s 2
  click-screen 256 995
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl4
function hitlvl4{
  $global:whereami = "HitInavder Lvl: 4"
  bot_notify "HitInavder Lvl: 4"
  Start-Sleep -s 2
  click-screen 262 1100
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl5
function hitlvl5{
  $global:whereami = "HitInavder Lvl: 5"
  bot_notify "HitInavder Lvl: 5"
  Start-Sleep -s 2
  click-screen 262 1208
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl6
function hitlvl6{
  $global:whereami = "HitInavder Lvl: 6"
  bot_notify "HitInavder Lvl: 6"
  Start-Sleep -s 2
  click-screen 262 1325
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl6
function hitlvl7{
  $global:whereami = "HitInavder Lvl: 7"
  bot_notify "HitInavder Lvl: 7"
  Start-Sleep -s 2
  click-screen 262 1445
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl1ghost
function hitlvl1ghost{
  $global:whereami = "HitGhost Lvl: 1"
  bot_notify "HitGhost Lvl: 1"
  Start-Sleep -s 2
  click-screen 262 820
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl2ghost
function hitlvl2ghost{
  $global:whereami = "HitGhost Lvl: 2"
  bot_notify "HitGhost Lvl: 2"
  Start-Sleep -s 2
  click-screen 262 939
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl3ghost
function hitlvl3ghost{
  $global:whereami = "HitGhost Lvl: 3"
  bot_notify "HitGhost Lvl: 3"
  Start-Sleep -s 2
  click-screen 262 1043
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl4ghost
function hitlvl4ghost{
  $global:whereami = "HitGhost Lvl: 4"
  bot_notify "HitGhost Lvl: 4"
  Start-Sleep -s 2
  click-screen 262 1164
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl5ghost
function hitlvl5ghost{
  $global:whereami = "HitGhost Lvl: 5"
  bot_notify "HitGhost Lvl: 5"
  Start-Sleep -s 2
  click-screen 262 1265
  Start-Sleep -s 2
  click-screen 876 825
}

#hitlvl6ghost
function hitlvl6ghost{
  $global:whereami = "HitGhost Lvl: 6"
  bot_notify "HitGhost Lvl: 6"
  Start-Sleep -s 2
  click-screen 262 1392
  Start-Sleep -s 2
  click-screen 876 825
}

#hitsingle
function hitsingle{
  bot_notify "Single Attack"
  Start-Sleep -s 2
  click-screen 391 1454
}

#hitenhanced
function hitenhanced{
  bot_notify "Enhanced Attack"
  Start-Sleep -s 2
  click-screen 697 1451
}

function opennavloc{
  bot_notify "Open Navigator Location Type"
  Start-Sleep -s 2
  click-screen 981 1827
  Start-Sleep -s 1
  click-screen 166 1251
  Start-Sleep -s 2
  click-screen 472 505
}

#hitinvader
function hitinvader([array]$params){
  $global:whereami = "HitInavder"
  $invinter=$params[0]
  $invlvl=$params[1]
  $invmode=$params[2]

  if(calculate-time @("h","$invinter","hitinvader","check") -eq 1){
    if($invmode -eq 1){
      $invtext="single"
    }
    if($invmode -eq 2){
      $invtext="enhanced"
    }
    bot_notify "HitInavder Lvl: $invlvl $invtext"
    Start-Sleep -s 4
    opennavloc
    Start-Sleep -s 2
    click-screen 268 1328
    Start-Sleep -s 2
    click-screen 1005 511
    Start-Sleep -s 2
    if($invlvl -le 7){
      Invoke-Expression "hitlvl$invlvl"
      if($invmode -eq 1){
        hitsingle
      }
      if($invmode -eq 2){
        hitenhanced
      }
      Start-Sleep -s 2
      click-screen 718 1325
      Start-Sleep -s 2
      click-screen 891 317
      Start-Sleep -s 1
      $ai_val = read_ai_db "hitinvader" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "hitinvader"
      }
      Start-Sleep -s 1
    }
  calculate-time @("h","$invinter","hitinvader","update")
  }
}

#htighost
function hitghost([array]$params){
  $global:whereami = "HitGhost"
  $invinter=$params[0]
  $invlvl=$params[1]
  $invmode=$params[2]
  if(calculate-time @("h","$invinter","hitghost","check") -eq 1){

      if($invmode -eq 1){
        $invtext="single"
      }
      if($invmode -eq 2){
        $invtext="enhanced"
      }
      bot_notify "HitGhost Lvl: $invlvl $invtext"
      Start-Sleep -s 4
      opennavloc
      Start-Sleep -s 2
      click-screen 267 1570
      Start-Sleep -s 2
      click-screen 1005 511
      Start-Sleep -s 2
      if($invlvl -le 6){
        $invlvl=$invlvl+"ghost"
        Invoke-Expression "hitlvl${invlvl}"
        if($invmode -eq 1){
          hitsingle
        }
        if($invmode -eq 2){
          hitenhanced
        }
        Start-Sleep -s 2
        click-screen 718 1325
        Start-Sleep -s 2
        click-screen 891 317
        Start-Sleep -s 1
        $ai_val = read_ai_db "hitghost" "close"
        if($ai_val -ne 0){
          $posx = $ai_val[0]
          $posy = $ai_val[1]
          click-screen $posx $posy
        } else {
          doOCR 1 "single" "close" "hitghost"
        }
        Start-Sleep -s 1
      }
  calculate-time @("h","$invinter","hitghost","update")
  }
}

#rsscontact1
function rsscontact1([array]$params){
  $global:whereami = "rsscontact1"
  bot_notify "send ressources to contact 1"
  click-screen  444 1815
  Start-Sleep -m 650
  click-screen  944 307
  Start-Sleep -m 650
  click-screen  910 575
  Start-Sleep -s 1
  click-screen  344 890
  Start-Sleep -s 1
  click-screen  628 857
  Start-Sleep -s 1
  click-screen  377 1210
  Start-Sleep-Prog $global:smcd "Wait switching to map"
  click-screen  540 900
  Start-Sleep -s 1
  click-screen  743 1393
  Start-Sleep -m 650
  click-screen  880 744
  Start-Sleep -m 650
  click-screen  743 1450
  Start-Sleep -m 650
  click-screen  743 1388
  Start-Sleep -s 1
  [int]$i=0
  foreach ($param in $params){
    if($param -eq "food"){
      sendfood $params[$i+1]
    }
    if($param -eq "wood"){
      sendwood $params[$i+1]
    }
    if($param -eq "iron"){
      sendiron $params[$i+1]
    }
    if($param -eq "stone"){
      sendstone $params[$i+1]
    }
    if($param -eq "silver"){
      sendsilver $params[$i+1]
    }
    $i++
  }
  Start-Sleep -s 1
  click-screen 1063 90
  click-screen 90 1830
}

#sendrssovermarket
function sendrssovermarket([array]$params){
  $global:whereami = "sendrssovermarket to:"+$params[0]
bot_notify "Send Rss To xxx by K127"
click-screen  1006 1185
click-screen  1006 1185
Start-Sleep -s 4
click-screen  800 300
Start-Sleep -s 4
click-screen  350 450
Start-Sleep -s 1
click-screen  350 450
Start-Sleep -s 1
click-screen  350 450
Start-Sleep -s 4
write-acc-name $params[0]
Start-Sleep -s 4
click-screen  920 700
Start-Sleep -s 4
[int]$i=0
foreach ($param in $params){
  if($param -eq "food"){
    sendfood $params[$i+1]
  }
  if($param -eq "wood"){
    sendwood $params[$i+1]
  }
  if($param -eq "iron"){
    sendiron $params[$i+1]
  }
  if($param -eq "stone"){
    sendstone $params[$i+1]
  }
  if($param -eq "silver"){
    sendsilver $params[$i+1]
  }
  $i++
}
Start-Sleep -s 1
click-screen  1063 90
}

#sendfood
function sendfood([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen  618 355
    click-screen  901 1738
    click-screen  590 1220
    bot_notify "$i of $amount"
  }
}

#sendwood
function sendwood([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen  618 585
    click-screen  901 1738
    click-screen  590 1220
    bot_notify "$i of $amount"
  }
}

#sendiron
function sendiron([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen  618 815
    click-screen  901 1738
    click-screen  590 1220
    bot_notify "$i of $amount"
  }
}

#sendstone
function sendstone([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen  618 1045
    click-screen  901 1738
    click-screen  590 1220
    bot_notify "$i of $amount"
  }
}

#sendsilver
function sendsilver([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen  618 1275
    click-screen  901 1738
    click-screen  590 1220
    bot_notify "$i of $amount"
  }
}

#rss_to_sh_ext
# timeout,loops,max_marches
function rss_to_sh_ext([array]$params){
  [int]$timeout = $params[0]
  [int]$max_marches = $params[1]
  [int]$marches = 0
  $global:whereami = "rss_to_sh"
  bot_notify "Send RSS to SH"
  click-screen 818 1818
  Start-Sleep -m 350
  click-screen 465 900
  Start-Sleep-Prog 13 "Wait for SH"
  click-screen 470 45
  Start-Sleep -m 350
  click-screen 860 470
  scrollup
  scrollup
  $loop_count = 0
    [int]$lol=0
    foreach ($param in $params){
      if($param -eq "food"){
        for ($i=1;$i -le $params[$lol+1];$i++){
          if($marches -ge $max_marches){
            start-sleep-prog $timeout "out of marches!"
            reconnect_device
            $marches = 0
          }
          sendfoodSH 1
          $marches++
        }
      }
      if($param -eq "wood"){
        for ($i=1;$i -le $params[$lol+1];$i++){
          if($marches -ge $max_marches){
            start-sleep-prog $timeout "out of marches!"
            reconnect_device
            $marches = 0
          }
          sendwoodSH 1
          $marches++
        }
      }
      if($param -eq "iron"){
        for ($i=1;$i -le $params[$lol+1];$i++){
          if($marches -ge $max_marches){
            start-sleep-prog $timeout "out of marches!"
            reconnect_device
            $marches = 0
          }
          sendironSH 1
          $marches++
        }
      }
      if($param -eq "stone"){
        for ($i=1;$i -le $params[$lol+1];$i++){
          if($marches -ge $max_marches){
            start-sleep-prog $timeout "out of marches!"
            reconnect_device
            $marches = 0
          }
          sendstoneSH 1
          $marches++
        }
      }
      if($param -eq "silver"){
        for ($i=1;$i -le $params[$lol+1];$i++){
          if($marches -ge $max_marches){
            start-sleep-prog $timeout "out of marches!"
            reconnect_device
            $marches = 0
          }
          sendsilverSH 1
          $marches++
        }
      }
      $lol++
    }
  click-screen 1063 90
  click-screen 90 1830
}

#rss_to_sh
function rss_to_sh([array]$params){
  $global:whereami = "rss_to_sh"
  bot_notify "Send RSS to SH"
  click-screen 818 1818
  Start-Sleep -m 350
  click-screen 465 990
  Start-Sleep-Prog 13 "Wait for SH"
  click-screen 470 45
  Start-Sleep -m 350
  click-screen 860 470
  scrollup
  scrollup
  [int]$i=0
  foreach ($param in $params){
    if($param -eq "food"){
      sendfoodSH $params[$i+1]
    }
    if($param -eq "wood"){
      sendwoodSH $params[$i+1]
    }
    if($param -eq "iron"){
      sendironSH $params[$i+1]
    }
    if($param -eq "stone"){
      sendstoneSH $params[$i+1]
    }
    if($param -eq "silver"){
      sendsilverSH $params[$i+1]
    }
    $i++
  }
  click-screen 1063 90
  click-screen 90 1830
}

function sendfoodSH([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen 618 447
    click-screen 901 1738
    click-screen 590 1220
    bot_notify "$i of $amount"
  }
}

function sendwoodSH([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen 618 671
    click-screen 901 1738
    click-screen 590 1220
    bot_notify "$i of $amount"
  }
}

function sendironSH([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen 618 900
    click-screen 901 1738
    click-screen 590 1220
    bot_notify "$i of $amount"
  }
}

function sendstoneSH([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen 618 1130
    click-screen 901 1738
    click-screen 590 1220
    bot_notify "$i of $amount"
  }
}

function sendsilverSH([int]$amount){
  for ($i=1;$i -le $amount;$i++){
    click-screen 618 1350
    click-screen 901 1738
    click-screen 590 1220
    bot_notify "$i of $amount"
  }
}

#opentaskwindow
function opentaskwindow([array]$params){
  $global:whereami = "opentaskwindow"
  bot_notify "Open Tasks"
  $i=0
  $skipval
  foreach($param in $params){
    if($param -eq "f"){
      bot_notify "Force tasks"
      $skipval = 0
    }
    if($param -eq "t"){
      $skipval = 1
    }
    if($param -eq "personal"){
      if(($skipval -eq 1) -and (calculate-time @("h",$global:tbreak,"opentaskwindowpersonal","check") -eq 1)){
        bot_notify "Open Personal Tasks"
        click-screen 90	490
        start-sleep -m 800
        click-screen 180 300
        if($params[$i+1] -ne "full"){
          task-loop $params[$i+1]
        } else {
        start-sleep -m 800
          click-screen 890 1861
          $ai_val = read_ai_db "opentaskwindow" "close"
          if($ai_val -ne 0){
            $posx = $ai_val[0]
            $posy = $ai_val[1]
            click-screen $posx $posy
          } else {
            doOCR 1 "single" "close" "opentaskwindow"
          }
        }
        calculate-time @("h",$global:tbreak,"opentaskwindowpersonal","update")
      }
      if($skipval -eq 0){
        bot_notify "Open Personal Tasks"
        click-screen 90	490
        start-sleep -m 800
        click-screen 180 300
        if($params[$i+1] -ne "full"){
          task-loop $params[$i+1]
        } else {
        start-sleep -m 800
          click-screen 890 1861
          $ai_val = read_ai_db "opentaskwindow" "close"
          if($ai_val -ne 0){
            $posx = $ai_val[0]
            $posy = $ai_val[1]
            click-screen $posx $posy
          } else {
            doOCR 1 "single" "close" "opentaskwindow"
          }
        }
      }
    }
    if($param -eq "clan"){
      if(($skipval -eq 1) -and (calculate-time @("h",$global:tbreak,"opentaskwindowclan","check") -eq 1)){
        bot_notify "Open Caln Tasks"
        click-screen 90	490
        start-sleep -m 800
        click-screen 530 300
        if($params[$i+1] -ne "full"){
          task-loop $params[$i+1]
        } else {
        start-sleep -m 800
          click-screen 890 1861
          $ai_val = read_ai_db "opentaskwindow" "close"
          if($ai_val -ne 0){
            $posx = $ai_val[0]
            $posy = $ai_val[1]
            click-screen $posx $posy
          } else {
            doOCR 1 "single" "close" "opentaskwindow"
          }
        }
        calculate-time @("h",$global:tbreak,"opentaskwindowclan","update")
      }
      if($skipval -eq 0){
        bot_notify "Open Caln Tasks"
        click-screen 90	490
        start-sleep -m 800
        click-screen 530 300
        if($params[$i+1] -ne "full"){
          task-loop $params[$i+1]
        } else {
        start-sleep -m 800
          click-screen 890 1861
          $ai_val = read_ai_db "opentaskwindow" "close"
          if($ai_val -ne 0){
            $posx = $ai_val[0]
            $posy = $ai_val[1]
            click-screen $posx $posy
          } else {
            doOCR 1 "single" "close" "opentaskwindow"
          }
        }
      }
    }
    if($param -eq "vip"){
      if(($skipval -eq 1) -and (calculate-time @("h",$global:tbreak,"opentaskwindowvip","check") -eq 1)){
        bot_notify "Open VIP Tasks"
        click-screen 90	490
        start-sleep -m 800
        click-screen 890 300
        if($params[$i+1] -ne "full"){
          task-loop $params[$i+1]
        } else {
        start-sleep -m 800
          click-screen 890 1861
          $ai_val = read_ai_db "opentaskwindow" "close"
          if($ai_val -ne 0){
            $posx = $ai_val[0]
            $posy = $ai_val[1]
            click-screen $posx $posy
          } else {
            doOCR 1 "single" "close" "opentaskwindow"
          }
        }
        calculate-time @("h",$global:tbreak,"opentaskwindowvip","update")
      }
      if($skipval -eq 0){
        bot_notify "Open VIP Tasks"
        click-screen 90	490
        start-sleep -m 800
        click-screen 890 300
        if($params[$i+1] -ne "full"){
          task-loop $params[$i+1]
        } else {
        start-sleep -m 800
          click-screen 890 1861
          $ai_val = read_ai_db "opentaskwindow" "close"
          if($ai_val -ne 0){
            $posx = $ai_val[0]
            $posy = $ai_val[1]
            click-screen $posx $posy
          } else {
            doOCR 1 "single" "close" "opentaskwindow"
          }
        }
      }
    }
    $i++
  }
}

#taskloop
function task-loop([int]$params){
  bot_notify "Task-Loop"
  for ($i=1;$i -le $params;$i++){
    click-screen 900 630
    start-sleep -m 450
    click-screen 900 630
    bot_notify "$i of $params"
  }
  $ai_val = read_ai_db "task-loop" "close"
  if($ai_val -ne 0){
    $posx = $ai_val[0]
    $posy = $ai_val[1]
    click-screen $posx $posy
  } else {
    doOCR 1 "single" "close" "task-loop"
  }
}

#timecalculator
function calculate-time($params){
  $timenow = Get-Date
  $calcmode = $params[0]
  [int]$calctime = $params[1]
  $functionname = $params[2]
  $launchmode = $params[3]
  $nextlaunch = ""
  $tmplogname = $global:logname
  $dbname = $tmplogname+$functionname

  if($launchmode -eq "update"){
    if($calcmode -eq "d"){
      $nextlaunch = $timenow.AddDays($calctime)
    }
    if($calcmode -eq "h"){
      $nextlaunch = $timenow.AddHours($calctime)
    }

    $xml = new-object System.Xml.XmlDocument
    $path = ".\data\timings\time_db.xml"
    $xml = [xml](Get-Content $path)
    $node = $xml.Timing.Fname | where {$_.Name -eq $dbname}
    if($node -ne $null){
      $node.Nextexecute = "$nextlaunch"
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    } else {
      $newrun = $xml.CreateElement("Fname")
      $xml.Timing.AppendChild($newrun) | out-null
      $newrun.SetAttribute("Name","$dbname");
      $newrun.SetAttribute("Nextexecute","$nextlaunch");
      $xml.Save((Get-Item -Path ".\").FullName + $path)
    }
  }
  if($launchmode -eq "check"){
    $xml = new-object System.Xml.XmlDocument
    $path = ".\data\timings\time_db.xml"
    $xml = [xml](Get-Content $path)
    $node = $xml.Timing.Fname | where {$_.Name -eq $dbname}
    if($node.Nextexecute -lt $timenow){
      return 1
    } else {
      return 0
    }
  }
}

function auto_vip{
  bot_notify "Auto Vip"
  if(calculate-time @("d","29","auto_vip","check") -eq 1){
    if((doOCR 1 "check" "vip_off") -eq 1){
      $ai_val = read_ai_db "auto_vip" "vip_off"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 0 "single" "vip_off" "auto_vip"
      }
      click-screen 873 1079
      start-sleep -m 1500
      scrollup
      start-sleep -m 600
      click-screen 903 1832
      start-sleep -m 600
      click-screen 711 1261
      start-sleep -m 600
      $ai_val = read_ai_db "auto_vip" "close"
      if($ai_val -ne 0){
        $posx = $ai_val[0]
        $posy = $ai_val[1]
        click-screen $posx $posy
      } else {
        doOCR 1 "single" "close" "auto_vip"
      }
      if((doOCR 1 "check" "vip_off") -ne 1){
        calculate-time @("d","29","auto_vip","update")
      }
    }
  }
}

#write
function write-acc-name([string]$params){
  [array]$chararray = $params.ToCharArray()
  foreach ($char in $chararray){
    if($char -eq "a"){
      click-screen 120	1718
    }
    if($char -eq "b"){
      click-screen 642	1818
    }
    if($char -eq "c"){
      click-screen 418	1818
    }
    if($char -eq "d"){
      click-screen 303	1720
    }
    if($char -eq "e"){
      click-screen 247	1628
    }
    if($char -eq "f"){
      click-screen 429	1735
    }
    if($char -eq "g"){
      click-screen 577	1726
    }
    if($char -eq "h"){
      click-screen 625	1726
    }
    if($char -eq "i"){
      click-screen 828	1645
    }
    if($char -eq "j"){
      click-screen 742	1735
    }
    if($char -eq "k"){
      click-screen 870	1735
    }
    if($char -eq "l"){
      click-screen 974	1735
    }
    if($char -eq "m"){
      click-screen 851	1812
    }
    if($char -eq "n"){
      click-screen 774	1812
    }
    if($char -eq "o"){
      click-screen 915	1649
    }
    if($char -eq "p"){
      click-screen 1014	1649
    }
    if($char -eq "q"){
      click-screen 65	1639
    }
    if($char -eq "r"){
      click-screen 397	1659
    }
    if($char -eq "s"){
      click-screen 218	1735
    }
    if($char -eq "t"){
      click-screen 479	1647
    }
    if($char -eq "u"){
      click-screen 704	1647
    }
    if($char -eq "v"){
      click-screen 502	1818
    }
    if($char -eq "w"){
      click-screen 157	1659
    }
    if($char -eq "x"){
      click-screen 310	1806
    }
    if($char -eq "y"){
      click-screen 585	1634
    }
    if($char -eq "z"){
      click-screen 207	1793
    }
    if($char -eq "0"){
      click-screen 1042	1651
    }
    if($char -eq "1"){
      click-screen 47	1642
    }
    if($char -eq "2"){
      click-screen 172	1634
    }
    if($char -eq "3"){
      click-screen 258	1653
    }
    if($char -eq "4"){
      click-screen 368	1645
    }
    if($char -eq "5"){
      click-screen 490	1649
    }
    if($char -eq "6"){
      click-screen 597	1657
    }
    if($char -eq "7"){
      click-screen 709	1657
    }
    if($char -eq "8"){
      click-screen 799	1659
    }
    if($char -eq "9"){
      click-screen 925	1655
    }
    if($char -eq "-"){
      click-screen 280 1915
    }

  }
}

#regonnect
function reconnect_device{
  $connect_arg = @("connect $global:adbname")
  #$devicestate = (run-prog $global:adbpath $connect_arg)
  try{
    $devicestate = (& $global:adbpath connect $global:adbname) | Out-String
  } catch {
    $devicestate = "unable to"
  }
  cls
  bot_notify "Check device status"
  bot_notify "Status is: $devicestate"
  if (($devicestate -like '*unable to*') -or ($devicestate -like '*daemon not running*')) {
    if($global:emumode -eq "Nox"){
      .($global:emulatorpath+"\Nox.exe") -clone:$global:active_emulator -quit
      Start-Sleep-Prog 10 "Shutdown Emulator"
      .($global:emulatorpath+"\Nox.exe") -clone:$global:active_emulator
      Start-Sleep-Prog $global:esd "Start Emulator"
      read-botxml $global:active_bot
    }
    if($global:emumode -eq "MEmu"){
      [string]$memuname = $global:active_emulator
      .($global:emulatorpath+"\MEmuConsole.exe") ShutdownVm $global:active_emulator
      Start-Sleep-Prog 10 "Shutdown Emulator"
      .($global:emulatorpath+"\MEmuConsole.exe $memuname")
      Start-Sleep-Prog $global:esd "Start Emulator"
      read-botxml $global:active_bot
    }
  }
  cls
}

function scrollup{
  bot_notify "scroll up"
  $scroll_arg = @("-s $global:adbname","shell input swipe 500 1000 500 300")
  Start-Sleep -s 1
  run-prog $global:adbpath $scroll_arg
}

function scrolldown{
  bot_notify "scroll down"
  $scroll_arg = @("-s $global:adbname","shell input swipe 500 300 500 1000")
  Start-Sleep -s 1
  run-prog $global:adbpath $scroll_arg
}

function scrollright{
  bot_notify "scroll right"
  $scroll_arg = @("-s $global:adbname","shell input swipe 300 500 1000 500")
  Start-Sleep -s 1
  run-prog $global:adbpath $scroll_arg
}

function scrollleft{
  bot_notify "scroll left"
  $scroll_arg = @("-s $global:adbname","shell input swipe 1000 500 300 500")
  Start-Sleep -s 1
  run-prog $global:adbpath $scroll_arg
}

#Show bot notifications
function bot_notify($content){
  cls
  Write-host ""
  Write-host $global:whereami
  Write-host ""
  Write-host $global:logname
  Write-host ""
  Write-host $content
  Write-host ""
}

<#
OCR reconnect
$cap 0,1 - cap screen
$mode single,batch,check
$obj objectname to recognize
#>
function doOCR($cap,$mode,$obj,$func_name){
  $st_prepare_start = debug_log_start
  [int]$global:failclicks = 0
  $imagename = $global:logname
  if($global:emumode -eq "Nox"){
    #$cap_arg_2 = "shell screencap -p /sdcard/$imagename-screen.dump"
    $cap_arg_2 = "shell screencap -p /mnt/shared/Image/$imagename-screen.dump"
    $resize_path = '"' + $global:nsp + '\ImageShare\' + $imagename + '-screen.dump"'

    #$resize_path = '"' + (Get-Item -Path ".\").FullName +'\data\AI\Images\src\' + $imagename + '-screen.dump"'
    $extpath = ('"/sdcard/' + $imagename + '-screen.dump"').Trim()
    $intpath = ('"' + (Get-Item -Path ".\").FullName + '\data\AI\Images\src\' + $imagename + '-screen.dump"').Trim()
    $pull_arg = @(
      "-s $global:adbname",
      'pull -p -a',
      $extpath,
      $intpath
    )
  }
  if($global:emumode -eq "MEmu"){
    #$cap_arg_2 = "shell screencap -p /sdcard/$imagename-screen.dump"
    $cap_arg_2 = "shell screencap -p /sdcard/Pictures/$imagename-screen.dump"
    $resize_path = '"' + $global:msp + '\Pictures\MEmu Photo\' + $imagename + '-screen.dump"'

    #$resize_path = '"' + (Get-Item -Path ".\").FullName +'\data\AI\Images\src\' + $imagename + '-screen.dump"'
    $extpath = ('"/sdcard/' + $imagename + '-screen.dump"').Trim()
    $intpath = ('"' + (Get-Item -Path ".\").FullName + '\data\AI\Images\src\' + $imagename + '-screen.dump"').Trim()
    $pull_arg = @(
      "-s $global:adbname",
      'pull -p -a',
      $extpath,
      $intpath
    )
  }
  if($global:emumode -eq "USB"){
    $cap_arg_2 = "shell screencap -p /sdcard/$imagename-screen.dump"
    $resize_path = '"' + (Get-Item -Path ".\").FullName +'\data\AI\Images\src\' + $imagename + '-screen.dump"'
    $extpath = ('"/sdcard/' + $imagename + '-screen.dump"').Trim()
    $intpath = ('"' + (Get-Item -Path ".\").FullName + '\data\AI\Images\src\' + $imagename + '-screen.dump"').Trim()
    $pull_arg = @(
      "-s $global:adbname",
      'pull -p -a',
      $extpath,
      $intpath
    )
    $rm_arg = @("-s $global:adbname","shell rm /sdcard/$imagename-screen.dump")
    $usb_resize_arg = @(
      '"' + (Get-Item -Path ".\").FullName + '\data\AI\Images\src\' + $imagename + '-screen.dump"',
      '-gravity center -crop "1080x1920+0+0"',
      '+repage "' + (Get-Item -Path ".\").FullName + '\data\AI\Images\src\' + $imagename + '-screen.dump"'
    )
  }
  ocr_log_stop $st_prepare_start "Prepare duration" "$cap,$mode,$obj,$func_name"
  $st_cap_start = debug_log_start

  if($cap -eq 1){
    #cap
    $adbArgList = @("-s $global:adbname",$cap_arg_2)
    run-prog $global:adbpath $adbArgList
    #run-prog $global:adbpath $pull_arg
    #aditions for USB
    if($global:emumode -eq "USB"){
      run-prog $global:adbpath $pull_arg
      run-prog $global:ai_path $usb_resize_arg
      run-prog $global:adbpath $rm_arg
    }
    #resize
    if($mode -eq "pixel" -or $mode -eq "pixel-check"){
      bot_notify "PixelMode"
    } else {
      $adbArgList = @($resize_path.Trim(),"-resize 10%",$resize_path.Trim())
      run-prog $global:ai_path $adbArgList
    }
  }
  ocr_log_stop $st_cap_start "Screencp duration" "$cap,$mode,$obj,$func_name"
  $st_action_start = debug_log_start
  if($mode -eq "single"){
    for ($i=1;$i -le 2;$i++){
      $posarray = run-prog-ocr ($resize_path.Trim()) $obj
      if($posarray[1] -eq "error"){
        bot_notify "Not found: $obj"
      } else {
        bot_notify "Found: $obj"
		    [int]$obj_width = ((C:\vwocmbb_ps\data\AI\ICompare\identify -format %w "C:\vwocmbb_ps\data\AI\Images\compare\$obj.png")/2)*10
		    [int]$obj_height = ((C:\vwocmbb_ps\data\AI\ICompare\identify -format %h "C:\vwocmbb_ps\data\AI\Images\compare\$obj.png")/2)*10
		    $posx = ([int]($posarray[1])*10)+$obj_width
		    $posy = ([int]($posarray[2])*10)+$obj_height
        click-screen $posx $posy
        if($func_name -ne $null){
          add_ai_db $func_name $obj $posx $posy
        }
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-1.png")
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-0.png")
        break
      }
    }
    ocr_log_stop $st_action_start "Action duration" "$cap,$mode,$obj,$func_name"
  }
  if($mode -eq "single-long"){
    for ($i=1;$i -le 2;$i++){
      $posarray = run-prog-ocr ($resize_path.Trim()) $obj
      if($posarray[1] -eq "error"){
        bot_notify "Not found: $obj"
      } else {
        bot_notify "Found: $obj"
        [int]$obj_width = ((C:\vwocmbb_ps\data\AI\ICompare\identify -format %w "C:\vwocmbb_ps\data\AI\Images\compare\$obj.png")/2)*10
        [int]$obj_height = ((C:\vwocmbb_ps\data\AI\ICompare\identify -format %h "C:\vwocmbb_ps\data\AI\Images\compare\$obj.png")/2)*10
        $posx = ([int]($posarray[1])*10)+$obj_width
        $posy = ([int]($posarray[2])*10)+$obj_height
        if($obj -eq "btn_use_vip"){
          $posx = $posx+150
        }
        click-screen $posx $posy "long"
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-1.png")
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-0.png")
        break
      }
    }
    ocr_log_stop $st_action_start "Action duration" "$cap,$mode,$obj,$func_name"
  }
  if($mode -eq "batch"){
    $fc = 0
    $r_path = $resize_path.Trim()
    foreach($single_obj in $obj){
      $posarray = run-prog-ocr ($r_path) $single_obj
      if($posarray[1] -eq "error"){
        bot_notify "Not found: $single_obj"
        $fc++
      } else {
        bot_notify "Found: $single_obj"
		    [int]$obj_width = ((C:\vwocmbb_ps\data\AI\ICompare\identify -format %w "C:\vwocmbb_ps\data\AI\Images\compare\$single_obj.png")/2)*10
		    [int]$obj_height = ((C:\vwocmbb_ps\data\AI\ICompare\identify -format %h "C:\vwocmbb_ps\data\AI\Images\compare\$single_obj.png")/2)*10
        $posx = ([int]($posarray[1])*10)+$obj_width
		    $posy = ([int]($posarray[2])*10)+$obj_height
        click-screen $posx $posy
        if($single_obj -like '*help*' ){
          start-sleep -m 650
          click-screen $posx $posy
        }
        if($func_name -ne $null){
          add_ai_db ($func_name+"$fc") $single_obj $posx $posy
        }
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-1.png")
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-0.png")
        $fc = 0
        break
      }
    }
    ocr_log_stop $st_action_start "Action duration" "$cap,$mode,$obj,$func_name"
    return $fc
  }
  if($mode -eq "check"){
    $the_return = 0
    for ($i=1;$i -le 2;$i++){
      $posarray = run-prog-ocr ($resize_path.Trim()) $obj
      if($posarray[1] -eq "error"){
        bot_notify "Not found: $obj"
      } else {
        Write-host "Found: $obj"
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-1.png")
        Remove-Item ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-output-0.png")
        $the_return = 1
        break
      }
    }
    ocr_log_stop $st_action_start "Action duration" "$cap,$mode,$obj,$func_name"
    return $the_return
  }
  if($mode -eq "pixel"){
    $fc = 0
    $xml = new-object System.Xml.XmlDocument
    $path = "C:\vwocmbb_ps\data\color_table\$obj.xml"
    $xml = [xml](Get-Content $path)
    $yml_array = $xml.Pixel.Color
    foreach($colornode in $yml_array){
      $ret_color = run-prog-pixel ($resize_path.Trim()) $colornode.px $colornode.py
      if($ret_color -eq ($colornode.srgb+",1")){
        cls
        bot_notify "PixelMode"
        Write-host "Equal:"
        Write-host $ret_color
        Write-host ($colornode.srgb)',1'
        click-screen $colornode.px $colornode.py
        $fc = 0
        break
      } else {
        cls
        bot_notify "PixelMode"
        Write-host "Not Equal:"
        Write-host $ret_color
        Write-host ($colornode.srgb)',1'
        $fc++
      }
    }
    ocr_log_stop $st_action_start "Action duration" "$cap,$mode,$obj,$func_name"
    return $fc
  }
  if($mode -eq "pixel-check"){
    $the_return = 0
    $xml = new-object System.Xml.XmlDocument
    $path = "C:\vwocmbb_ps\data\color_table\$obj.xml"
    $xml = [xml](Get-Content $path)
    [int]$xml_count = ($xml.Pixel.Color).count
    $io_counter = 0
    $yml_array = $xml.Pixel.Color
    foreach($colornode in $yml_array){
      $ret_color = run-prog-pixel ($resize_path.Trim()) $colornode.px $colornode.py
      if($ret_color -eq ($colornode.srgb+",1")){
        cls
        bot_notify "PixelMode"
        Write-host "Equal:"
        Write-host $ret_color
        Write-host ($colornode.srgb)',1'
        $io_counter++
      } else {
        cls
        bot_notify "PixelMode"
        Write-host "Not Equal:"
        Write-host $ret_color
        Write-host ($colornode.srgb)',1'
      }
    }
    ocr_log_stop $st_action_start "Action duration" "$cap,$mode,$obj,$func_name"
    if($io_counter -ge ($xml_count-1)){
      $the_return = 1
    } else {
      $the_return = 0
    }
    return $the_return
  }
}

#Add to ai_db
function add_ai_db([string]$func_name,[string]$obj,[int]$posx,[int]$posy){
  $ai_name = $func_name+$obj

  $xml = new-object System.Xml.XmlDocument
  $path = ".\data\AI\ai_db.xml"
  $xml = [xml](Get-Content $path)
  $newAI = $xml.CreateElement("Data")
  $xml.AI.AppendChild($newAI) | out-null
  $newAI.SetAttribute("Name","$ai_name");
  $newAI.SetAttribute("PosX","$posx");
  $newAI.SetAttribute("PosY","$posy");
  $xml.Save((Get-Item -Path ".\").FullName + $path)
}

#read ai_db
function read_ai_db([string]$func_name,[string]$obj){
  cls
  bot_notify "Read AI Database"
  $ai_name = $func_name+$obj
  $xml = new-object System.Xml.XmlDocument
  $path = ".\data\AI\ai_db.xml"
  $xml = [xml](Get-Content $path)

    $random_ai_limit = Get-Random -Minimum 5 -Maximum 100

    bot_notify "AI limit is: $random_ai_limit"

    $ai_obj_arr = $xml.AI.Data | Where-Object {$_.Name -eq $ai_name}
    if(($ai_obj_arr.PosX | group | sort count -desc | select -ExpandProperty Count -First 1) -ge $random_ai_limit){
      $clk_x = $ai_obj_arr.PosX | group | sort count -desc | select -ExpandProperty Name -First 1
      $ai_obj_arr = $xml.AI.Data | Where-Object {$_.Name -eq $ai_name -and $_.PosX -eq $clk_x}
      if(($ai_obj_arr.PosY | group | sort count -desc | select -ExpandProperty Count -First 1) -ge $random_ai_limit){
        $clk_y = $ai_obj_arr.PosY | group | sort count -desc | select -ExpandProperty Name -First 1
        bot_notify "AI data found: $clk_x,$clk_y"
        return @($clk_x,$clk_y)
      } else {
        bot_notify "No AI data"
        return 0
      }
    } else {
      bot_notify "No AI data"
    return 0
    }
    bot_notify "No AI data"
  return 0
}

<#
adb click event
#>
function click-screen([int]$pos_x,[int]$pos_y,$press_type){
  bot_notify "click-screen"
  $random_a = Get-Random -Minimum 0 -Maximum 2
  $random_b = Get-Random -Minimum 0 -Maximum 2
  $random_ms = Get-Random -Minimum $global:minms -Maximum $global:maxms
  $posx = $pos_x+$random_a
  $posy = $pos_y+$random_b
  Write-host "Random val x: $random_a"
  Write-host "Random val y: $random_b"
  Write-host "Timeout is: $random_ms"
  Write-host ""
  Write-host "pos_x: $posx"
  Write-host "pos_y: $posy"
  if($press_type -eq "long"){
    $click_arg = @("-s $global:adbname","shell input touchscreen swipe $posx $posy $posx $posy 3000")
  } else {
    $click_arg = @("-s $global:adbname","shell input tap $posx $posy")
  }
  run-prog-clk $global:adbpath $click_arg
  if($press_type -eq "long"){
    start-sleep -m 3500
  }
  if($global:ct -eq "ms"){
    Start-Sleep -m $random_ms
  } else {
    Start-Sleep -s $global:ct
  }
}
function run-prog-clk($prog_path, $args_arr){
Start-Process -FilePath $prog_path -ArgumentList $args_arr -NoNewWindow -ErrorAction SilentlyContinue
}
<#
run ext program
#>
function run-prog($prog_path, $args_arr){
Start-Process -FilePath $prog_path -ArgumentList $args_arr -NoNewWindow -Wait -ErrorAction SilentlyContinue
}
function run-prog-ocr($imput_img,$img_obj){
  $imagename = $global:logname
  $ocr_args = @(
    "-metric pae -subimage-search",
    $imput_img,
    ('"' + (Get-Item -Path ".\").FullName + '\data\AI\Images\compare\' + $img_obj + '.png"').Trim(),
    ('"' + (Get-Item -Path ".\").FullName + '\data\AI\Images\src\' + $imagename + '-output.png"').Trim()
  )
  $ocr_path = (Get-Item -Path ".\").FullName + "\data\AI\ICompare\compare.exe"
  $sub_search_result = Start-Process -FilePath $ocr_path -ArgumentList $ocr_args -NoNewWindow -PassThru -Wait -RedirectStandardError ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-ocr.txt")
  $content = (Get-Content ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-ocr.txt") -raw) -match "^.*@ (.+),(.+)$"
  if($matches.Length -gt 0){
    return $matches
  } else {
    #$content = (Get-Content ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$global:logname-ocr.txt") -raw) -match "^.*@ (.+)/(.+)/(.+)/(.+)$"
    return @("","error")
  }
}

function run-prog-pixel($imput_img,$pixel_x,$pixel_y){
  $imagename = $global:logname
  $condits = "1x1+$pixel_x+$pixel_y"
  $pixel_args = @(
    $imput_img,
    '-crop "'+$condits+'" -gravity center -depth 8 txt:-'
  )
  $ocr_path = (Get-Item -Path ".\").FullName + "\data\AI\ICompare\convert.exe"
  Start-Process -FilePath $ocr_path -ArgumentList $pixel_args -NoNewWindow -Wait -RedirectStandardOutput ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-pixel.txt")
  #$content = (Get-Content ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-pixel.txt") -raw)
  $matcharray = [regex]::Matches((Get-Content ((Get-Item -Path ".\").FullName + "\data\AI\Images\src\$imagename-pixel.txt") -raw), '\(([^/)]+)\)') |ForEach-Object { $_.Groups[1].Value }
  $srgb_color = $matcharray[1]
  return $srgb_color
}

<#
check if account is running
#>
function is-acc-running($params){
  $xml = new-object System.Xml.XmlDocument
  $path = ".\data\active_accounts.xml"
  $xml = [xml](Get-Content $path)
  $node = $xml.Active.Acc | where {$_.Name -eq $params}
  if($node.Name.Length -gt 0){
    return 1
  } else {
    return 0
  }
}

function configure-drony{
  cls
  Write-host ""
  Write-host "Select your device type:"
  Write-host ""
  $emulatorselect = menu (prepare-emulator-list "bot")
  if($emulatorselect -eq "Nox"){
    $global:adbpath = $global:Nox+"\adb.exe"
    $global:emulatorpath = $global:Nox
    $global:emumode = "Nox"
  }
  if($emulatorselect -eq "MEmu"){
    $global:adbpath = $global:MEmu+"\adb.exe"
    $global:emulatorpath = $global:MEmu
    $global:emumode = "MEmu"
  }
  if($emulatorselect -eq "USB"){
    $global:adbpath = $(Get-Item -Path ".\").FullName+"\data\adb\adb.exe"
    $global:emumode = "USB"
  }
  if([System.IO.File]::Exists($global:adbpath)){
    if($global:emumode -eq "USB"){
      list-adb-devices
    } else {
      list-emulators $global:emumode
      cls
      Start-Sleep-Prog $global:esd "Start Emulator"
      list-adb-devices
    }
    cls
    Write-host ""
    Write-host "Select your device:"
    Write-host ""
    $global:adbname = (menu $global:devicelist).Trim()
    if($global:emumode -eq "USB"){
      cls
      Write-host ""
      Write-host "Prepare device..."
      Write-host ""
      Write-host "Set resolution to 1080x1920"
      Write-host ""
      $usbargs = @("-s $global:adbname","shell wm size 1080x1920")
      run-prog $global:adbpath $usbargs
      Write-host "Set density to 240"
      Write-host ""
      $usbargs = @("-s $global:adbname","shell wm density 240")
      run-prog $global:adbpath $usbargs
      start-sleep -s 3
    }
    cls
    bot_notify "Prepare Drony Update"
    start-sleep -s 2
    bot_notify "Uninstall Drony"
    $adbargs = @("-s $global:adbname","uninstall org.sandroproxy.drony")
    run-prog-clk $global:adbpath $adbargs
    bot_notify "Install Drony_Ad_Free"
    start-sleep -s 4
    $adbargs = @("-s $global:adbname","install -r C:\vwocmbb_ps\data\bin\eum_confs\Drony.v.1.3.131.b.131.crk.ADS.Removed.apk")
    run-prog $global:adbpath $adbargs
    start-sleep -s 2
    bot_notify "Configure Drony"
    $adbargs = @("-s $global:adbname","restore C:\vwocmbb_ps\data\bin\eum_confs\drony.ab")
    run-prog-clk $global:adbpath $adbargs
    start-sleep -s 2
    click-screen 800 1880
    start-sleep -s 5
    $adbArgList = @(
      "-s $global:adbname",
      "shell monkey -p org.sandroproxy.drony -v 1"
    )
    run-prog $global:adbpath $adbArgList
    cls
    start-sleep -s 6
    click-screen 540 1880
    start-sleep -s 2
    click-screen 540 1880
    start-sleep -s 2
    click-screen 877 1119
    start-sleep -s 2
    $adbArgList = @(
      "-s $global:adbname",
      "shell input keyevent 3"
    )
    run-prog $global:adbpath $adbArgList
    bot_notify "Configure Drony has finish."
    start-sleep 3
    show-main-menu
  } else {
    Write-host ""
    Write-host "adb.exe was not found!"
    Write-host ""
    Start-Sleep -Seconds 4
    show-main-menu
  }
}

<#
Update running accs
#>
function add-running($params){
  $xml = new-object System.Xml.XmlDocument
  $path = ".\data\active_accounts.xml"
  $xml = [xml](Get-Content $path)

  $newrun = $xml.CreateElement("Acc")
  $xml.Active.AppendChild($newrun) | out-null
  $newrun.SetAttribute("Name","$params");
  $xml.Save((Get-Item -Path ".\").FullName + $path)
}
function remove-running($params){
  $xml = new-object System.Xml.XmlDocument
  $path = ".\data\active_accounts.xml"
  $xml = [xml](Get-Content $path)

  $node = $xml.Active.Acc | where {$_.Name -eq $params}
  foreach ($xmlrow in $node){
    $xmlrow.ParentNode.RemoveChild($xmlrow) | out-null
  }
  $xml.Save((Get-Item -Path ".\").FullName + $path)
}

function check-osvers{
  [int]$currpsvers = (Get-Variable PSVersionTable -ValueOnly).PSVersion.Major
  if($currpsvers -lt 4){
    [version]$OSVersion = Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty Version
    If ($OSVersion -gt "10.0") {
      loadxmlsettings
    } ElseIf ($OSVersion -gt "6.3") {
      loadxmlsettings
    } ElseIf ($OSVersion -gt "6.2") {
      loadxmlsettings
    } ElseIf ($OSVersion -gt "6.1") {
      if ((gwmi win32_operatingsystem | select osarchitecture).osarchitecture -eq "64-bit"){
        #64 bit logic here
        write-host "Please update your servicepack!"
        & 'C:\vwocmbb_ps\data\bin\Win7AndW2K8R2-KB3191566-x64\Win7AndW2K8R2-KB3191566-x64.msu'
      } else {
        #32 bit logic here
        write-host "Please update your servicepack!"
        & 'C:\vwocmbb_ps\data\bin\Win7-KB3191566-x86\Win7-KB3191566-x86.msu'
      }
    } ElseIf ($OSVersion -gt "6.0") {
      write-host 'Bot is incompatible with your os version!'
    } Else {
      write-host 'Bot is incompatible with your os version!'
      catch
    }
  } else {
    loadxmlsettings
  }
}
if($args[0] -eq "jobs"){
  $botarr = @($args[1],$args[2],$args[3])
  loadxmlsettings "jobs" $botarr
} else {
  if($args[0] -eq "quick"){
    loadxmlsettings "quick"
  } else {
    if($args[0] -eq "quickbot"){
      $botarr = @($args[1],$args[2],$args[3],$args[4])
      loadxmlsettings "quickbot" $botarr
    } else {
      check-osvers
    }
  }
}

function VWOCMBB-updater([array]$params){
  try {
    cls
  Write-host "Check for updates!"
    $json_url = "https://app.easy-develope.ch/_/items/bot_updater?access_token=g6fg5fs4gh456g4fjg4jhgn5gh4j5u4t8rg54sd21v54gbfh47r876ets4gfd1v3cx54gbf8hrt6s5df6897gfds3v313xc54h8f67rsddfg"
    $jsoncon = Invoke-WebRequest $json_url | convertfrom-json
    $global:newversion = $jsoncon.data.version
    $global:updat_url = $jsoncon.data.bot_url
    $global:changelog_single = $jsoncon.data.changelog_single
    $global:custom_script = $jsoncon.data.custom_commands
    if($global:newversion -eq $params[0]){
      cls
      Write-host "No Update available"
      Start-Sleep -s 3
      cls
      show-main-menu
    } else {
      cls
      Write-host "Update available. Update now?"
      write-host ""
      write-host $global:newversion
      write-host "Changelog:"
      write-host ""
      write-host $global:changelog_single
  	  write-host ""
      $updateq = menu @("Yes","No")
      if($updateq -eq "Yes"){
        cls
        run_custom_script
        Write-host "Delete old backups..."
        dir 'C:\vwocmbb_ps\backup\*.zip' | foreach {del $_}
        cls
        Write-host "Backup current bot!"
        write-host $params[1]
        $zippath = ($params[1]+'\backup\backup_'+$params[0]+'.zip')
        $bk_path = $params[1]
        & $PSScriptRoot\7za.exe a $zippath $bk_path '-xr!*.zip'
        start-sleep -s 4
        cls
        Write-host "Dowloading update..."
        $url = $global:updat_url
        $name = $global:newversion
        $output = "$PSScriptRoot\update-$name.zip"
        Invoke-WebRequest -Uri $url -OutFile $output
        cls
        Write-host "Extract update..."
        Expand-Archive -Path "$PSScriptRoot\update-$name.zip" -DestinationPath $params[1] -Force
        $xml = new-object System.Xml.XmlDocument
        $path = $params[1]+'\data\settings.xml'
        $xml = [xml](Get-Content $path)
        $vers = $global:newversion
        $xml.OPT.Version.Value = "$vers"
        $xml.Save($path)
        cls
        dir 'C:\vwocmbb_ps\modules\VWOCMBB-updater\*.zip' | foreach {del $_}
        Write-host "Update was succesfully!"
        Write-host "Please restart the bot"
        Write-host "Terminate updater in 4 seconds Please wait!"
        start-sleep -s 4
        Break
      } else {
        show-main-menu
      }
    }
  } catch {
    cls
    write-host "Plarium fucking back... something went wrong!"
    Write-Host $_.Exception.Message
    start-sleep -s 5
  }
}

function run_custom_script{
  $scriptBlock = [Scriptblock]::Create($global:custom_script)
  & $scriptBlock
}

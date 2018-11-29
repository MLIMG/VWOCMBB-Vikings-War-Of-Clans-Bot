function VWOCMBB-updater([array]$params){
  try {
    cls
  Write-host "Check for updates!"
    $json_url = "https://api.easy-develope.ch/mbb/get_bot_version"
    $jsoncon = Invoke-WebRequest $json_url | convertfrom-json
    $global:newversion = $jsoncon.version
    if($jsoncon.version -eq $params[0]){
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
      $url = "https://easy-develope.ch/ps_bot_update/meta.xml"
      $output = "$PSScriptRoot\meta.xml"
      Invoke-WebRequest -Uri $url -OutFile $output
      $xml = new-object System.Xml.XmlDocument
      $path = "$PSScriptRoot\meta.xml"
      $xml = [xml](Get-Content $path)
      foreach ($cline in ($xml.Meta.Changelog.Info)){
        Write-host ("- " + $cline.Value)
      }
  	  write-host ""
      $updateq = menu @("Yes","No")
      if($updateq -eq "Yes"){
        cls
        Write-host "Backup current bot!"
        write-host $params[1]
        $zippath = ($params[1]+'\backup\backup_'+$params[0]+'.zip')
        $bk_path = $params[1]
        & $PSScriptRoot\7za.exe a $zippath $bk_path '-xr!*.zip'
        start-sleep -s 4
        cls
        Write-host "Dowloading update..."
        $url = $xml.Meta.Path.Value
        $name = $xml.Meta.Version.Value
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

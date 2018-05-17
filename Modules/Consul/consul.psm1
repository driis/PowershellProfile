Function Open-ConsulSession {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$SessionName
    )

    begin
    {
      $consulUrl = $OctopusParameters["consul.url"]
      $token = $OctopusParameters["counsul.token"]
      $hostName = $OctopusParameters["Octopus.Machine.Name"]

      $json =
      '
          {
              "Name": "Host: ' + $hostName + ' | Sesstion: ' + $SessionName + '",
              "TTL": "60s",
              "LockDelay": "0s"
          }
      '
    }

    process
    {
      try
      {
      $Uri = $consulUrl + '/v1/session/create?token=' + $token
      write-host $Uri
      $session = Invoke-RestMethod -Method Put -Body $json -Uri $Uri
      return $session
      }
      catch
      {
      }
    }
  }

  Function Close-ConsulSession {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$SessionId
    )

    begin
    {
      $consulUrl = $OctopusParameters["consul.url"]
      $token = $OctopusParameters["counsul.token"]

    }

    process
    {
      try
      {
      $Uri = $consulUrl + '/v1/session/destroy/' + $SessionId + '?token=' + $token
      $session = Invoke-RestMethod -Method Put -Uri $Uri
      return $session
      }
      catch
      {
      }
    }
  }

  Function Lock-ConsulMutex {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$sessionId
    )

    begin
    {
      $consulUrl = $OctopusParameters["consul.url"]
      $token = $OctopusParameters["counsul.token"]
      $key = $OctopusParameters["consul.mutex.key"]
      $hostName = $OctopusParameters["Octopus.Machine.Hostname"]
    }

    process
    {
      try
      {
      $url = $consulUrl + '/v1/kv/' + $key + '?acquire=' + $sessionId +'&token=' + $token
      $mutex =  Invoke-RestMethod -Method Put -Body $hostName -Uri $url
      return $mutex
      }
      catch
      {
      }
    }
  }

  Function Unlock-ConsulMutex {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$sessionId
    )

    begin
    {
      $consulUrl = $OctopusParameters["consul.url"]
      $token = $OctopusParameters["counsul.token"]
      $key = $OctopusParameters["consul.mutex.key"]
    }

    process
    {
      try
      {
          $url = $consulUrl + '/v1/kv/' + $key + '?release=' + $sessionId +'&token=' + $token
          $mutex =  Invoke-RestMethod -Method Put -Uri $url
          return $mutex
      }
      catch
      {
      }
    }
  }

  Function Register-ConsulMutex {
    [CmdletBinding()]
    param
    (
      [string]$sessionId
    )

      try
      {
      Write-Output "Waiting for mutex"
      $count = 0
      do
      {
          $leader = Lock-ConsulMutex -sessionId $sessionId
          if(!($leader))
          {
              Start-Sleep -Seconds 1
          }
          $count = $count + 1
      }
      while (($leader -eq $false) -and ($count -le "300"))
      Write-Output "Now i'm the leader"
      }
      catch
      {
      }
  }

  Function Unregister-ConsulMutex {
    [CmdletBinding()]
    param
    (
      [string]$sessionId
    )
      try
      {
          Write-Output "Releasing the mutex"
          Start-Sleep -Seconds 1
          $output = Unlock-ConsulMutex -sessionId $sessionId
          Start-Sleep -Seconds 1
          $output = Close-ConsulSession -SessionId $sessionId
      }
      catch
      {
      }
  }

  Function Register-ConsulService {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$serviceName,
      [Parameter(Mandatory=$True)]
      [string]$fqdn,
      [Parameter(Mandatory=$false)]
      [string]$tags,
      [Parameter(Mandatory=$True)]
      [string]$port
    )

    begin
    {
      if(!$tags)
      {
          $tags = "[`"urlprefix-$fqdn`"]"
      }
    }

    process
    {
      try
      {
          $json = @('
              {
                "ID": "' + $serviceName +'",
                "Name": "'+ $serviceName +'",
                "Tags": '+ $tags +'
                ,
                "Port": '+ $port +',
                "EnableTagOverride": false,
                "Check": {
                  "id": "'+ $serviceName +'",
                  "name": "HTTP check: http://'+ $fqdn +'/_monitor/shallow",
                  "http": "http://localhost:'+ $port +'/_monitor/shallow",
                  "header": {"Host":["'+ $fqdn +'"]},
                  "interval": "10s",
                  "timeout": "1s"
                }
              }
          ')
          Write-Output "Registrering service in Consul"
          $Uri = 'http://localhost:8500/v1/agent/service/register'
          $result = Invoke-RestMethod -Method Put -Body $json -Uri $Uri
          return $result
      }
      catch
      {
          Write-Output $_
          Write-Output $json
          return $false
      }

    }
  }

   Function Register-GDPR-Endpoint([string] $url) {

    $gdprUrl = $url + "/_gdpr/ready"

     try
     {
        Write-Host "Calling GDPR endpoint on $gdprUrl"

        $response = Invoke-WebRequest -Uri $gdprUrl -UseBasicParsing -DisableKeepAlive

        $statuscode = $response.StatusCode;

        if ($response.content.Length -gt 25) {
            $content = $response.content.SubString(0,25);
        } else {
            $content = $response.content
        }

        Write-Host "GDPR Ready check - StatusCode:$statuscode - Content:$content"

        if ($response.StatusCode -eq 200 -And ($response.Content -eq 'gdpr_ready' -or $response.Content.Contains('"gdpr_ready"')) ) {

           Write-Host "Adding GDPR tag in consul."

           return $true
        }

        Write-Host "Do not add GDPR tag in consul"

        return $false;
     }
     catch [System.Net.WebException]
     {
        $message = $_.Exception.Message
        $statuscode = $_.Exception.Response.StatusCode

        Write-Host "GDPR Ready check failed : $message"

        Write-Host "Do not add GDPR tag in consul"

        if ($statuscode -eq "500") {
            Write-Host "GDPR Endpoint is responding with 500"
            #Exit 2
        }

        return $false;
     }
     catch
     {
        $message = $_.Exception.Message

        Write-Host "GDPR Ready check failed : $message"

        Write-Host "Do not add GDPR tag in consul"

        return $false;
     }
  }

  Function Register-ConsulService-External {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$consulUrl,
      [Parameter(Mandatory=$True)]
      [string]$dc,
      [Parameter(Mandatory=$True)]
      [string]$serviceName,
      [Parameter(Mandatory=$True)]
      [string]$fqdn,
      [Parameter(Mandatory=$false)]
      [string]$tags,
      [Parameter(Mandatory=$True)]
      [string]$port,
      [string]$iisport
    )

    begin
    {
      $node = "$serviceName_$dc"
    }

    process
    {
      try
      {
          $gdprUrl = "http://$fqdn"
          Write-Output "Checking GDPR endpoint at $gdprUrl"
          $Register_GDPR_Endpoint = Register-GDPR-Endpoint -url $gdprUrl
          if($Register_GDPR_Endpoint)
          {
              [string[]]$tagsArray = $tags |ConvertFrom-Json

              $tagsArray += "gdpr"
              $tags = $tagsArray | ConvertTo-Json
          }

          $json = @('
              {
                "Datacenter": "' + $dc +'",
                "Node": "' + $node +'",
                "Address": "' + $serviceName +'",
                "Service": {
                  "ID": "' + $serviceName +'",
                  "Service": "' + $serviceName +'",
                  "Address": "' + $fqdn +'",
                  "Port": ' + $port +',
                  "Tags": '+ $tags +'
                }
              }
          ')

          Write-Output "Registrering service in external Consul: $consulUrl"
          $Uri = 'http://' + $consulUrl +'/v1/catalog/register'
          $result = Invoke-RestMethod -Method Put -Body $json -Uri $Uri
          return $result
      }
      catch
      {
          Write-Output $_
          Write-Output $json
          return $false
      }

    }
  }

  Function Unregister-ConsulService {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$serviceName
    )

    begin
    {
    }

    process
    {
      try
      {
          Write-Output "Deregistrering service in Consul"
          $Uri = "http://localhost:8500/v1/agent/service/deregister/$serviceName"
          $result = Invoke-RestMethod -Method Put -Uri $Uri
          return $result
      }
      catch
      {
          Write-Output $_
          return $false
      }

    }
  }

  Function Write-DeploymentDataToConsul {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$key,
      [Parameter(Mandatory=$True)]
      [string]$value
    )

    begin
    {
      $consulUrl = $OctopusParameters["consul.url"]
      $token = $OctopusParameters["counsul.token"]
      $consul_progress_path = $OctopusParameters["consul.progress.path"]
    }

    process
    {
      try
      {
          Write-Output "Writing key to Consul"
          $Uri = $consulUrl + '/v1/kv/' + $consul_progress_path + "/" + $key +'?token=' + $token
          $result = Invoke-RestMethod -Method Put -Body $value -Uri $Uri
          return $result
      }
      catch
      {
          Write-Output $_
          return $false
      }

    }
  }

  Function Read-DeploymentDataFromConsul {
    [CmdletBinding()]
    param
    (
      [Parameter(Mandatory=$True)]
      [string]$key
    )


    begin
    {
      $consulUrl = $OctopusParameters["consul.url"]
      $token = $OctopusParameters["counsul.token"]
      $consul_progress_path = $OctopusParameters["consul.progress.path"]
    }

    process
    {
      try
      {
          Write-Output "Reading key from Consul"
          $Uri = $consulUrl + '/v1/kv/' + $consul_progress_path + "/" + $key +'?token=' + $token
          $result = Invoke-RestMethod -Method Get -Uri $Uri
          $value = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($result.Value))

          return $value
      }
      catch
      {
          Write-Output $_
          return $false
      }
    }
  }

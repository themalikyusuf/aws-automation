$iisSiteName = ""
$resize = (Get-PartitionSupportedSize -DriveLetter c).sizeMax - 40000000000
$erlangUri = "http://erlang.org/download/otp_win64_17.0.exe"
$erlangPath = "D:\otp_win64_17.0.exe"
$rabbitmqUri = "https://www.rabbitmq.com/releases/rabbitmq-server/v3.3.1/rabbitmq-server-3.3.1.exe"
$rabbitmqPath = "D:\rabbitmq-server-3.3.1.exe"
$fullName = ""
$user = ""
$password = ""
$features = "Web-Default-Doc", "Web-Dir-Browsing", "Web-Http-Errors", "Web-Static-Content", "Web-Http-Redirect", "Web-Http-Logging", "Web-Custom-Logging", "Web-Log-Libraries", "Web-Request-Monitor", "Web-Stat-Compression", "Web-Filtering", "Web-Basic-Auth", "Web-IP-Security", "Web-Net-Ext45", "Web-Asp-Net45", "Web-ISAPI-Ext", "Web-ISAPI-Filter", "Web-Mgmt-Console", "NET-Framework-Core", "NET-Framework-45-Core", "NET-Framework-45-ASPNET", "NET-WCF-TCP-PortSharing45"
$groups = "Performance Log Users", "Performance Monitor Users"
$iisAppPoolName = ""
$packages = "UrlRewrite", "javaruntime --version 8.0.121", "notepadplusplus", "sql-server-management-studio", "vcredist2013"
$zabbixUri = "https://www.zabbix.com/downloads/3.2.0/zabbix_agents_3.2.0.win.zip"
$zabbixPath = "D:\zabbix_agents_3.2.0.win"

$urlRewriteString = @"
<system.webServer>
  <rewrite>
      <rules>
        <rule name="HTTP to HTTPS redirect" stopProcessing="true">
                <match url="(.*)" />
                      <conditions>
                        <add input="{HTTPS}" pattern="off" ignoreCase="true" />
                      </conditions>
               <action type="Redirect" redirectType="Found" url="https://{HTTP_HOST}/{R:1}" />
              </rule>
      </rules>
    </rewrite>
"@

# Resize C Drive and Create D Drive
Resize-Partition -DiskNumber 0 -PartitionNumber 2 -Size ($resize)
New-Partition -DiskNumber 0 -UseMaximumSize -DriveLetter D ; Format-Volume -DriveLetter D -Confirm:$false

Start-Sleep -s 20

# Download and Install Erlang
Invoke-WebRequest -Uri $erlangUri -OutFile $erlangPath
Invoke-Command -ScriptBlock {D:\otp_win64_17.0.exe /S}

# Download and Install RabbitMQ
Invoke-WebRequest -Uri $rabbitmqUri -OutFile $rabbitmqPath
Start-Sleep -s 60
Invoke-Command -ScriptBlock {D:\rabbitmq-server-3.3.1.exe /S}

# Install IIS Roles and Features
foreach ($i in $features)
{
	Install-WindowsFeature -Name $i
}

# Create User Account
net user $user $password /add /passwordreq:yes /passwordchg:no /fullname:$fullName /expires:never
WMIC USERACCOUNT WHERE "Name='$user'" SET PasswordExpires=FALSE

foreach ($j in $groups)
{
	net localgroup $j $user /add
}

Import-Module WebAdministration

Remove-WebAppPool -Name "DefaultAppPool"
Remove-WebSite -Name "Default Web Site" 
Start-Sleep -s 10

# Create Application Pool
cd IIS:\AppPools\
if (!(Test-Path $iisAppPoolName -pathType container))
{
  $appPool = New-Item $iisAppPoolName
  $appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value "v4.0"
  $appPool | Set-ItemProperty -Name processModel -Value @{userName = $user; password = $password; identitytype = 3}
	$appPool | Set-ItemProperty -Name "enable32BitAppOnWin64" -Value "True"
}

# Create Website
New-Website -Name $iisSiteName -ApplicationPool $iisAppPoolName -PhysicalPath "D:\WEB"

# Install Chocolatey to Install UrlRewrite, SSMS, Java, Notepad ++
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
foreach ($k in $packages)
{
  cinst $k -y
}

(Get-Content D:\WEB\Web.config).replace('<system.webServer>', $urlRewriteString) | Set-Content D:\WEB\Web.config

# Download Zabbix Agent
Invoke-WebRequest -Uri $zabbixUri -OutFile $zabbixPath

# Unzip the download
$zabbixAgentUnzipPath = "D:\zabbix"

Unzip $zabbixPath $zabbixAgentUnzipPath

Remove-Item $zabbixPath -recurse

Start-Sleep -s 10
# Install zabbix agent using config file
& "D:\zabbix\bin\win64\zabbix_agentd.exe" --config "D:\zabbix\conf\zabbix_agentd.win.conf" --install

# Set Zabbix server IP on both "Server" and "ServerActive" for active and or passive checks
(Get-Content D:\zabbix\conf\zabbix_agentd.win.conf).replace('127.0.0.1', '10.10.10.207') | Set-Content D:\zabbix\conf\zabbix_agentd.win.conf

# set zabbix listen port
(Get-Content D:\zabbix\conf\zabbix_agentd.win.conf).replace('# ListenPort=10050', 'ListenPort=10051') | Set-Content D:\zabbix\conf\zabbix_agentd.win.conf

# set host metadata for auto registration
(Get-Content D:\zabbix\conf\zabbix_agentd.win.conf).replace('# HostMetadataItem=', 'HostMetadataItem=system.uname') | Set-Content D:\zabbix\conf\zabbix_agentd.win.conf

# set log file size
(Get-Content D:\zabbix\conf\zabbix_agentd.win.conf).replace('# LogFileSize=1', 'LogFileSize=0') | Set-Content D:\zabbix\conf\zabbix_agentd.win.conf

# Start Agent
& "D:\zabbix\bin\win64\zabbix_agentd.exe" --start

# Disable IE Enhanced Security
function Disable-IEESC
{
  $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
  Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
  $UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
  Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0
  Write-Host "IE Enhanced Security Configuration (ESC) has been disabled." -ForegroundColor Green
}
Disable-IEESC


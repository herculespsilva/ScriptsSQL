#connect to the portal through the browser before
Connect-AzAccount -UseDeviceAuthentication

#Get subscriptions that the current account can access.
Get-AzSubscription

#Sets the tenant, subscription, and environment for cmdlets to use in the current session
Set-AzContext -Subscription "Pay-As-You-Go" 

#identify the SQL Server
Get-AzSqlServer | Select-Object -Property ServerName, ResourceGroupName, PublicNetworkAccess

#identify the Resource Group
Get-AzResourceGroup | Select-Object -Property ResourceGroupName, ProvisioningState

#identify the SQL Server
Get-AzSqlServer | Select-Object -Property ServerName, ResourceGroupName, PublicNetworkAccess

#identify the Log Analytics Workspace
Get-AzResource -ResourceType "Microsoft.OperationalInsights/workspaces" | Where-Object { $_.Name -eq "sqlworkspace001kd" } | Select-Object -Property ResourceId 


/subscriptions/58f6b225-ddeb-4bb8-9eed-08d47345ede9/resourceGroups/HandsOn2/providers/Microsoft.OperationalInsights/workspaces/sqlworkspace001kd


##############################################################################################################################################################################
# Parameters for creating Diagnostic Settings
##############################################################################################################################################################################

$ResourceGroupName = "HandsOn2"
$workspaceId = "/subscriptions/58f6b225-ddeb-4bb8-9eed-08d47345ede9/resourceGroups/HandsOn2/providers/Microsoft.OperationalInsights/workspaces/sqlworkspace001kd"
$DiagSetName = "DiagnosticSettings_"
$ServerName = "sqlserveradssdpk002"

#File Paths
$TemplateFilePath = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\03_azureDiagnosticSettingsDeploy.json"
$ParametersFilePath = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\03_azureDiagnosticSettingsDeploy.parameters.json"

#Get Resources (https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric-near-real-time)
$Server = Get-AzResource -ResourceType "Microsoft.Sql/servers" | Where-Object { $_.Name -eq $ServerName } | Select-Object -Property Name

$Resources = Get-AzResource -ResourceType "Microsoft.Sql/servers/databases" | Where-Object { $_.Name -ne $Server.Name + "/master" } | Select-Object -Property ResourceId, Name

#Deploy All Alert in each feature
foreach ($rs in $Resources){
    
    Write-Host "Creating Diagnostic Settings for" $rs.Name -ForegroundColor Yellow
    
    $ResourceName = $rs.Name

    #format the resource name, due to the SQL Server "/" special character Exemple "ssdp00891/AdventureWorksLT"
    $PositionStart = $ResourceName.IndexOf('/')
    $LengthName = $ResourceName.Length
    $NameFormat = $ResourceName.Substring($PositionStart + 1, $LengthName - $PositionStart - 1)

    $ResourceID = $rs.ResourceId
    $FinalName = $DiagSetName + $NameFormat

    #Get JSON
    $ParamFile = Get-Content $ParametersFilePath -Raw | ConvertFrom-Json
    
    #Update Values
    $ParamFile.parameters.settingName.value = $FinalName
    $ParamFile.parameters.serverName.value = $Server.Name
    $ParamFile.parameters.dbName.value = $NameFormat
    $ParamFile.parameters.workspaceId.value = $workspaceId

    #Update JSON
    $UpdatedJSON = $ParamFile | ConvertTo-Json
    $UpdatedJSON > $ParametersFilePath
    
    #Deploy Template
    $DeploymentName = "DeployResource_" + $FinalName
    New-AzResourceGroupDeployment `
        -Name $DeploymentName `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFilePath `
        -TemplateParameterFile $ParametersFilePath

     Write-Host "---> Diagnostic Settings created [$FinalName] successfully" -ForegroundColor Green
} 

#Reference Link
#https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-manager-diagnostic-settings?tabs=json
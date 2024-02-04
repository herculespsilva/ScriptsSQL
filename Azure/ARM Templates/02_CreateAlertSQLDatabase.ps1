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

#identify the actionGroupId
Get-AzResource -ResourceType "Microsoft.Insights/ActionGroups" | Where-Object { $_.Name -eq "HandsOn" } | Select-Object -Property ResourceId


##############################################################################################################################################################################
# Parameters for creating alerts
##############################################################################################################################################################################

$ResourceGroupName = "HandsOn2"
$ActionGroupId = "/subscriptions/a4ea9518-b727-44b9-b04f-9294a9ed7791/resourceGroups/sqlsaturday/providers/microsoft.insights/actiongroups/sqlsaturdayactgroup"

$AlertName  = "_DB_CPU_ERR"      # maintain a standard in the name
$MetricName = "cpu_percent"      # Azure Metrics
$Threshold = "95"
$TimeAggregation = "Maximum"     # Average | Minimum | Maximum | Total
$AlertDescription = "The percentage of allocated compute units that are currently in use by the resource"
$Operator = "GreaterThanOrEqual" # Equals | NotEquals | GreaterThan | GreaterThanOrEqual | LessThan | LessThanOrEqual
$AlertSeverity = 1               # 0 - Critical | 1 - Error | 2 - Warning | 3 - Information | 4 - Verbose

#File Paths
$TemplateFilePath = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\02_azureAlertDeploy.json"
$ParametersFilePath = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\02_azureAlertDeploy.parameters.json"

#Get Resources (https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric-near-real-time)
$Server = Get-AzResource -ResourceType "Microsoft.Sql/servers" | Select-Object -Property Name

$Resources = Get-AzResource -ResourceType "Microsoft.Sql/servers/databases" -ResourceGroupName $ResourceGroupName | Where-Object { $_.Name -ne $Server.Name + "/master" } | Select-Object -Property ResourceId, Name

#Deploy All Alert in each feature
foreach ($rs in $Resources) {
    
    Write-Host "Creating Metric Alerts for" $rs.Name -ForegroundColor Yellow
    
    #$numberTo = get-random -maximum 1000
    $ResourceName = $rs.Name

    #format the resource name, due to the SQL Server "/" special character Exemple "ssdp00891/AdventureWorksLT"
    $PositionStart = $ResourceName.IndexOf('/')
    $LengthName = $ResourceName.Length
    $NameFormat = $ResourceName.Substring($PositionStart + 1, $LengthName - $PositionStart - 1)

    $ResourceID = $rs.ResourceId
    $FinalName = $NameFormat + $alertName 

    #Get JSON
    $ParamFile = Get-Content $ParametersFilePath -Raw | ConvertFrom-Json
    
    #Update Values
    $ParamFile.parameters.alertName.value = $FinalName
    $ParamFile.parameters.metricName.value = $MetricName
    $ParamFile.parameters.resourceId.value = $ResourceID
    $ParamFile.parameters.threshold.value = $Threshold
    $ParamFile.parameters.actionGroupId.value = $ActionGroupId
    $ParamFile.parameters.timeAggregation.value = $TimeAggregation
    $ParamFile.parameters.alertDescription.value = $AlertDescription
    $ParamFile.parameters.operator.value = $Operator
    $ParamFile.parameters.alertSeverity.value = $AlertSeverity

    #Update JSON
    $UpdatedJSON = $ParamFile | ConvertTo-Json
    $UpdatedJSON > $ParametersFilePath
    
    #Deploy Template
    $DeploymentName = "DeployResource_" + $FinalName
    New-AzResourceGroupDeployment `
        -Name $DeploymentName `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFilePath `
        -TemplateParameterFile $ParametersFilePath `
        -ErrorVariable errorDeploy

    if($errorDeploy.Count -eq 0) {
        Write-Host "---> Alert [$FinalName] created successfully" -ForegroundColor Green
        Write-Host ""
    }
    else {
        Write-Host "---> There was an error creating the alert [$FinalName]" -ForegroundColor Red
        Write-Host "" 
    }
} 

#Reference Link
#https://learn.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-metric-create-templates
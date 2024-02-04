#need to import the modules before
Install-Module -Name Az -Repository PSGallery -Force

#Update module
Update-Module -Name Az

#connect to the portal through the browser before
Connect-AzAccount -UseDeviceAuthentication

#Get subscriptions that the current account can access.
Get-AzSubscription

#Sets the tenant, subscription, and environment for cmdlets to use in the current session
Set-AzContext -Subscription "Pay-As-You-Go" 

#Create new Resource Group
New-AzResourceGroup `
    -Name HandsOn2 `
    -Location "East US 2" `
    -Tag @{"hands-on"="DEPLOY"}

#identify the Resource Group
Get-AzResourceGroup | Select-Object -Property ResourceGroupName, ProvisioningState

#identify the SQL Server
Get-AzSqlServer | Select-Object -Property ServerName, ResourceGroupName, PublicNetworkAccess

############################################################################################################################################
# deploy One Database
############################################################################################################################################

$templateFile = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\01_azureSQLDatabaseDeploy.json"
$parameterFile = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\01_azureSQLDatabaseDeploy.parameters.json"
New-AzResourceGroupDeployment `
  -Name createsqldatabasesqldeploy `
  -ResourceGroupName HandsOn2 `
  -TemplateFile $templateFile `
  -TemplateParameterFile $parameterFile

############################################################################################################################################
# deploy multiple databases
############################################################################################################################################

#Parameters
$ResourceGroupName = "HandsOn2"
$sqlServerName = "sqlserveradssdpk002"
$sqldatabaseName = "sqldbpsdeployhandson"

#File Paths
$TemplateFilePath = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\01_azureSQLDatabaseDeploy.json"
$ParametersFilePath = "C:\Users\Hercules Pereira\Desktop\DataSide\Palestras\003 - Administrando Azure SQL DB em escala através de ARM templates\Scripts\01_azureSQLDatabaseDeploy.parameters.json"

for($i = 1; $i -le 5; $i++) {

    $FinalNameSQLDatabase = $sqldatabaseName + $i

    Write-Host "Creating SQL Database called [$FinalNameSQLDatabase]" -ForegroundColor Yellow

    #Get JSON
    $ParamFile = Get-Content $ParametersFilePath -Raw | ConvertFrom-Json
    
    #Update Values
    $ParamFile.parameters.sqlServerName.value = $sqlServerName
    $ParamFile.parameters.sqldatabaseName.value = $FinalNameSQLDatabase

    #Update JSON
    $UpdatedJSON = $ParamFile | ConvertTo-Json
    $UpdatedJSON > $ParametersFilePath

    #Deploy Template
    $DeploymentName = "DeployResource_" + $FinalNameSQLDatabase
    New-AzResourceGroupDeployment `
        -Name $DeploymentName `
        -ResourceGroupName $ResourceGroupName `
        -TemplateFile $TemplateFilePath `
        -TemplateParameterFile $ParametersFilePath `
        -ErrorVariable errorDeploy


    if($errorDeploy.Count -eq 0) {
        Write-Host "---> SQL Database [$FinalNameSQLDatabase] created successfully" -ForegroundColor Green
        Write-Host ""
    }
    else {
        Write-Host "---> There was an error creating the alert [$FinalNameSQLDatabase]" -ForegroundColor Red
        Write-Host "" 
    }
}
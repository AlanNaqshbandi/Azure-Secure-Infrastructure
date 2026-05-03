# ============================================================
# STEP 5 — Private Endpoints & PaaS Security
# Azure Secure Infrastructure Project
# Author: Alan Naqshbandi | Azure Security Engineer
# ============================================================

# Variables
$resourceGroup  = "AzureSecure-RG"
$location       = "canadacentral"
$storageName    = "alansecurestorage"
$vnetName       = "AzureSecure-VNet"

# Step 1 — Create Storage Account
$storage = New-AzStorageAccount `
    -Name $storageName `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -SkuName "Standard_LRS" `
    -Kind "StorageV2"

Write-Host "Storage created: $($storage.StorageAccountName)" -ForegroundColor Cyan

# Step 2 — Disable public access
Set-AzStorageAccount `
    -Name $storageName `
    -ResourceGroupName $resourceGroup `
    -PublicNetworkAccess Disabled

Write-Host "Public access disabled" -ForegroundColor Yellow

# Step 3 — Get VNet and Subnet
$vnet   = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup
$subnet = $vnet.Subnets | Where-Object { $_.Name -eq "App-Subnet" }

# Step 4 — Create Private Link Connection
$privateEndpointConnection = New-AzPrivateLinkServiceConnection `
    -Name "AlanStorage-Connection" `
    -PrivateLinkServiceId $storage.Id `
    -GroupId "blob"

# Step 5 — Create Private Endpoint
New-AzPrivateEndpoint `
    -Name "AlanStorage-PE" `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -Subnet $subnet `
    -PrivateLinkServiceConnection $privateEndpointConnection

Write-Host "Step 5 Complete — Private Endpoint deployed successfully" -ForegroundColor Green


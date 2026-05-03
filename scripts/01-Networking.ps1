# ============================================================
# STEP 1 — Networking (VNet, Subnets, NSG)
# Azure Secure Infrastructure Project
# Author: Alan Naqshbandi | Azure Security Engineer
# ============================================================

# Connect to Azure
Connect-AzAccount

# Variables
$resourceGroup = "AzureSecure-RG"
$location      = "canadacentral"
$vnetName      = "AzureSecure-VNet"
$nsgName       = "AppSubnet-NSG"

# Step 1 — Create Resource Group
New-AzResourceGroup -Name $resourceGroup -Location $location

# Step 2 — Create Virtual Network
New-AzVirtualNetwork `
    -Name $vnetName `
    -ResourceGroupName $resourceGroup `
    -Location $location `
    -AddressPrefix "10.0.0.0/16"

# Step 3 — Add Subnets
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup

Add-AzVirtualNetworkSubnetConfig `
    -Name "Web-Subnet" `
    -VirtualNetwork $vnet `
    -AddressPrefix "10.0.1.0/24"

Add-AzVirtualNetworkSubnetConfig `
    -Name "App-Subnet" `
    -VirtualNetwork $vnet `
    -AddressPrefix "10.0.2.0/24"

$vnet | Set-AzVirtualNetwork

# Step 4 — Create NSG
$nsg = New-AzNetworkSecurityGroup `
    -Name $nsgName `
    -ResourceGroupName $resourceGroup `
    -Location $location

# Step 5 — Add NSG Rules
Add-AzNetworkSecurityRuleConfig `
    -NetworkSecurityGroup $nsg `
    -Name "Allow-RDP" `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix "*" `
    -SourcePortRange "*" `
    -DestinationAddressPrefix "*" `
    -DestinationPortRange 3389 `
    -Access Allow

Add-AzNetworkSecurityRuleConfig `
    -NetworkSecurityGroup $nsg `
    -Name "Deny-All-Inbound" `
    -Protocol "*" `
    -Direction Inbound `
    -Priority 200 `
    -SourceAddressPrefix "*" `
    -SourcePortRange "*" `
    -DestinationAddressPrefix "*" `
    -DestinationPortRange "*" `
    -Access Deny

Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg

# Step 6 — Attach NSG to App-Subnet
$vnet   = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup
$subnet = Get-AzVirtualNetworkSubnetConfig -Name "App-Subnet" -VirtualNetwork $vnet

Set-AzVirtualNetworkSubnetConfig `
    -Name "App-Subnet" `
    -VirtualNetwork $vnet `
    -AddressPrefix "10.0.2.0/24" `
    -NetworkSecurityGroup $nsg

$vnet | Set-AzVirtualNetwork

# Verify
$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroup
$vnet.Subnets | Select-Object Name, AddressPrefix, NetworkSecurityGroup

Write-Host "Step 1 Complete — Networking deployed successfully" -ForegroundColor Green


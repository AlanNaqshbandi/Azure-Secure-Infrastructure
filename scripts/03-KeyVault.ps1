# ============================================================
# STEP 3 — Key Vault & Secrets Management
# Azure Secure Infrastructure Project
# Author: Alan Naqshbandi | Azure Security Engineer
# ============================================================

# Variables
$resourceGroup = "AzureSecure-RG"
$location      = "canadacentral"
$vaultName     = "AlanSecureVault"

# Step 1 — Create Key Vault
$kv = New-AzKeyVault `
    -Name $vaultName `
    -ResourceGroupName $resourceGroup `
    -Location $location

Write-Host "Key Vault created: $($kv.VaultName)" -ForegroundColor Cyan

# Step 2 — Check permission model
$kv = Get-AzKeyVault -VaultName $vaultName -ResourceGroupName $resourceGroup
Write-Host "RBAC Mode: $($kv.EnableRbacAuthorization)" -ForegroundColor Yellow

# Step 3 — Assign access (RBAC mode)
$me = Get-AzADUser -SignedIn

New-AzRoleAssignment `
    -ObjectId $me.Id `
    -RoleDefinitionName "Key Vault Secrets Officer" `
    -Scope $kv.ResourceId

# Step 4 — Store a secret
$secret = ConvertTo-SecureString "MySecurePass123!" -AsPlainText -Force

Set-AzKeyVaultSecret `
    -VaultName $vaultName `
    -Name "DBPassword" `
    -SecretValue $secret

# Step 5 — Retrieve the secret
$retrieved = Get-AzKeyVaultSecret `
    -VaultName $vaultName `
    -Name "DBPassword" `
    -AsPlainText

Write-Host "Secret retrieved successfully" -ForegroundColor Green
Write-Host "Step 3 Complete — Key Vault deployed successfully" -ForegroundColor Green


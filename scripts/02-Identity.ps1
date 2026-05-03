# ============================================================
# STEP 2 — Identity & Access (RBAC)
# Azure Secure Infrastructure Project
# Author: Alan Naqshbandi | Azure Security Engineer
# ============================================================

# Variables
$resourceGroup = "AzureSecure-RG"

# Step 1 — Get my own account
$me = Get-AzADUser -SignedIn
Write-Host "Signed in as: $($me.DisplayName)" -ForegroundColor Cyan

# Step 2 — View available roles
Get-AzRoleDefinition | Where-Object {
    $_.Name -eq "Owner" -or
    $_.Name -eq "Contributor" -or
    $_.Name -eq "Reader"
} | Select-Object Name, Description

# Step 3 — Assign Reader role to myself on the Resource Group
New-AzRoleAssignment `
    -ObjectId $me.Id `
    -RoleDefinitionName "Reader" `
    -ResourceGroupName $resourceGroup

# Step 4 — Verify assignment
Get-AzRoleAssignment -ResourceGroupName $resourceGroup |
    Where-Object { $_.DisplayName -eq $me.DisplayName } |
    Select-Object DisplayName, RoleDefinitionName, Scope

Write-Host "Step 2 Complete — RBAC assigned successfully" -ForegroundColor Green


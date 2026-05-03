# ============================================================
# STEP 4 — Azure Policy & Governance
# Azure Secure Infrastructure Project
# Author: Alan Naqshbandi | Azure Security Engineer
# ============================================================

# Variables
$resourceGroup = "AzureSecure-RG"

# Step 1 — Find the Allowed Locations policy
$policy = Get-AzPolicyDefinition | Where-Object {
    $_.DisplayName -eq "Allowed locations" -and
    $_.PolicyType -eq "BuiltIn"
}

Write-Host "Policy found: $($policy.DisplayName)" -ForegroundColor Cyan

# Step 2 — Get Resource Group scope
$rg = Get-AzResourceGroup -Name $resourceGroup

# Step 3 — Assign policy to Resource Group
New-AzPolicyAssignment `
    -Name "Allow-CanadaCentral-Only" `
    -PolicyDefinition $policy `
    -Scope $rg.ResourceId `
    -PolicyParameterObject @{listOfAllowedLocations = @("canadacentral")}

# Step 4 — Verify assignment
Get-AzPolicyAssignment -Scope $rg.ResourceId |
    Select-Object Name, EnforcementMode

Write-Host "Step 4 Complete — Policy enforced successfully" -ForegroundColor Green


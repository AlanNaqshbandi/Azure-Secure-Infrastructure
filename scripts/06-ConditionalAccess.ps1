# ============================================================
# STEP 6 — Conditional Access & Zero Trust
# Azure Secure Infrastructure Project
# Author: Alan Naqshbandi | Azure Security Engineer
# ============================================================

# Step 1 — Install Microsoft Graph module (one time only)
# Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Step 2 — Connect to Microsoft Graph
Connect-MgGraph -Scopes `
    "Policy.Read.All", `
    "Policy.ReadWrite.ConditionalAccess", `
    "Application.Read.All", `
    "Directory.Read.All"

# Step 3 — Verify connection and scopes
Write-Host "Connected scopes:" -ForegroundColor Cyan
(Get-MgContext).Scopes

# Step 4 — Build policy body
$body = @{
    displayName = "Require-MFA-All-Users"
    state       = "enabledForReportingButNotEnforced"
    conditions  = @{
        users        = @{ includeUsers = @("All") }
        applications = @{ includeApplications = @("All") }
    }
    grantControls = @{
        operator         = "OR"
        builtInControls  = @("mfa")
    }
}

# Step 5 — Create Conditional Access Policy
New-MgIdentityConditionalAccessPolicy -BodyParameter $body

# Step 6 — Verify policy was created
Get-MgIdentityConditionalAccessPolicy |
    Select-Object DisplayName, State

Write-Host "Step 6 Complete — Conditional Access policy created" -ForegroundColor Green
Write-Host "NOTE: Policy is in Report-Only mode — safe for testing" -ForegroundColor Yellow


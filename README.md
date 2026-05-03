# Azure-Secure-Infrastructure

# 🔐 Azure Secure Infrastructure — PowerShell Deployed

> **A complete enterprise-grade Azure security infrastructure built from scratch using PowerShell — no portal clicking.**

---

## 📋 Project Overview

This project demonstrates the end-to-end deployment of a secure Azure environment using **pure PowerShell automation**. Every resource was created, configured, and verified through the command line — simulating how real Azure Security Engineers operate in production environments.

**Deployed to:** Canada Central  
**Subscription:** Azure 2026  
**Tools Used:** PowerShell 7.6, Az Module 15.5, Microsoft.Graph    

---

## 🏗️ What Was Built

```
AzureSecure-RG
├── 🌐 Networking
│   ├── AzureSecure-VNet        (10.0.0.0/16)
│   ├── Web-Subnet              (10.0.1.0/24) — public facing
│   └── App-Subnet              (10.0.2.0/24) — private + NSG protected
│       └── AppSubnet-NSG
│           ├── Rule 1: Allow RDP    (Priority 100)
│           └── Rule 2: Deny All     (Priority 200)
│
├── 🔑 Identity & Access
│   └── RBAC Role Assignment
│       └── Reader role — scoped to AzureSecure-RG only
│
├── 🔒 Key Vault
│   └── AlanSecureVault
│       ├── RBAC Authorization enabled
│       ├── Key Vault Secrets Officer role assigned
│       └── DBPassword secret stored securely
│
├── 📋 Policy & Governance
│   └── Allow-CanadaCentral-Only
│       └── Blocks any resource deployed outside canadacentral
│
├── 🔗 Private Endpoints
│   └── alansecurestorage (StorageV2)
│       ├── Public access: Disabled
│       └── AlanStorage-PE → connected to App-Subnet only
│
└── 🛡️ Zero Trust & Conditional Access
    └── Require-MFA-All-Users policy
        ├── Applies to: All users + All cloud apps
        ├── Requires: Multi-Factor Authentication
        └── State: Report-Only (safe testing mode)
```

---

## 🚀 Deployment Steps

| Step | Area | Script | What it deploys |
|------|------|--------|-----------------|
| 1 | Networking | `01-Networking.ps1` | VNet, 2 Subnets, NSG, Security Rules |
| 2 | Identity | `02-Identity.ps1` | RBAC role assignment, Reader scope |
| 3 | Key Vault | `03-KeyVault.ps1` | Key Vault, RBAC access, Secret storage |
| 4 | Policy | `04-Policy.ps1` | Location governance policy |
| 5 | Private Endpoints | `05-PrivateEndpoints.ps1` | Storage Account, Private Endpoint |
| 6 | Zero Trust | `06-ConditionalAccess.ps1` | MFA Conditional Access policy |

---

## 🔧 How to Run

### Prerequisites
```powershell
# Install Az module
Install-Module -Name Az -Scope CurrentUser -Force

# Install Microsoft Graph module
Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Connect to Azure
Connect-AzAccount
```

### Run Each Step
```powershell
# Run scripts in order
.\scripts\01-Networking.ps1
.\scripts\02-Identity.ps1
.\scripts\03-KeyVault.ps1
.\scripts\04-Policy.ps1
.\scripts\05-PrivateEndpoints.ps1
.\scripts\06-ConditionalAccess.ps1
```

### Clean Up
```powershell
# Delete everything with one command
Remove-AzResourceGroup -Name "AzureSecure-RG" -Force
```

---

## 🛡️ Security Design Principles

| Principle | Implementation |
|-----------|----------------|
| **Network Segmentation** | Public Web-Subnet separated from private App-Subnet |
| **Least Privilege** | Reader role scoped to RG only, not full subscription |
| **Zero Trust** | MFA required for all users on all applications |
| **Secrets Management** | No hardcoded credentials — Key Vault only |
| **Private Connectivity** | Storage accessible only from inside VNet |
| **Governance** | Policy enforces Canada Central location compliance |
| **Defence in Depth** | NSG + Private Endpoint + RBAC + Policy layered together |

---

## 📁 Repository Structure

```
Azure-Secure-Infrastructure/
├── README.md
├── scripts/
│   ├── 01-Networking.ps1
│   ├── 02-Identity.ps1
│   ├── 03-KeyVault.ps1
│   ├── 04-Policy.ps1
│   ├── 05-PrivateEndpoints.ps1
│   └── 06-ConditionalAccess.ps1
└── docs/
    └── AzureSecure-Complete-Reference.docx
```

---

## 💡 Key PowerShell Concepts Used

- **Variables & Objects** — storing Azure resources in `$variables` for reuse
- **Pipeline** — `Get-AzResource | Where-Object | Select-Object`
- **Get → Modify → Set pattern** — fetch, edit locally, push back to Azure
- **Secure Strings** — `ConvertTo-SecureString` for credential handling
- **Error handling** — real troubleshooting of capacity limits, permission models, region conflicts

---

## 🎯 Business Use Case

This infrastructure pattern is used by Azure Security Engineers to:

- **Deploy secure environments consistently** — same result every time, no human error
- **Enforce compliance automatically** — Policy blocks non-compliant resources before they exist
- **Protect sensitive data** — Private Endpoints eliminate public attack surface
- **Control identity access** — RBAC ensures least privilege at every layer
- **Automate incident response** — scripts can rebuild entire environments in minutes


*Built by **Alan Naqshbandi** — Azure Security Engineer | 2026*  
*Deployed on real Azure subscription — all resources verified live*

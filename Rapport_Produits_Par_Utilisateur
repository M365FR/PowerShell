# Construit à partir de https://github.com/12Knocksinna/Office365itpros/blob/master/ReportIndividualApplicationLicenses.PS1
# Article initial trouvé ici https://office365itpros.com/2021/06/08/report-licenses-individual-o365-accounts/
# Sert à obtenir le nombre d'applications ou de fonctionnalités attribuées aux utilisateurs.
# Nécessite une connexion au module Azure AD PowerShell. Il faut exécuter Connect-AzureAD avant d'executer ce script.
# Definissez ici les noms de produits/fonctionnalités que vous souhaitez chercher, vous pouvez en ajouter/retirer si nécessaire. Les identifiants d'applications 
# peuvent être trouvées à https://docs.microsoft.com/en-us/azure/active-directory/enterprise-users/licensing-service-plan-reference
$Plans = @{}
$Plans.Add(“33c4f319-9bdd-48d6-9c4d-410b750a4a5a”, “Informations par MyAnalytics”)
$Plans.Add(“57ff2da0-773e-42df-b2af-ffb7a2317929”, “Teams”)
$Plans.Add(“2789c901-c14e-48ab-a76a-be334d9d793a”, “Forms”)
$Plans.Add(“76846ad7-7776-4c40-a281-a386362dd1b9”, “Power Automate E3”)
$Plans.Add(“07699545-9485-468e-95b6-2fca3738be01”, “Power Automate E5”)


# Définissez ici les identifiants GUID des SKUS qu'il faudra analyser, vous pouvez en ajouter/supprimer d'autres si nécessaire
$Office365E1 = "18181a46-0d4e-45cd-891e-60aabd171b4e"
$Office365E3 = "6fd2c87f-b296-42f0-b197-1e91e994b900"
$Office365E5 = "c7df2760-2c81-4ef7-b578-5b5392b571df"

Write-Host “Recherche des informations de comptes AD”
$Users = Get-AzureADUser -All $True -Filter "Usertype eq 'Member'"
CLS
$Product = Read-Host "Entrez l'information de l'application Microsoft 365 recherchée"
if (!($Plans.ContainsValue($Product))) { # Ne trouve pas
   Write-Host “Impossible de trouver” $Product “dans la liste des applications”; break }
Foreach ($Key in $Plans.Keys) { # Regarde la table pour trouver le produit SKU
   If ($Plans[$Key] -eq $Product) { $PlanId = $Key }
}
$PlanUsers = [System.Collections.Generic.List[Object]]::new() 
ForEach ($User in $Users) {
  $License = $Null
  If ($PlanId -in $User.AssignedPlans.ServicePlanId) {
    $Status = ($User.AssignedPlans | ? {$_.ServicePlanId -eq $PlanId} | Select -ExpandProperty CapabilityStatus )
    If ($Office365E3 -in $User.AssignedLicenses.SkuId) {$LicenseName = "Office 365 E3"}
       ElseIf ($Office365E5 -in $User.AssignedLicenses.SkuId) {$LicenseName = "Office 365 E5"}
       ElseIf ($Office365E1 -in $User.AssignedLicenses.SkuId) {$LicenseName = "Office 365 E1"}
       ElseIf ($Status -eq "Enabled") {$LicenseName = $Product }
       Else {$LicenseName = "Product not enabled"}

    $ReportLine  = [PSCustomObject] @{
          User       = $User.DisplayName 
          UPN        = $User.UserPrincipalName
          Department = $User.Department
          Country    = $User.Country
          SKU        = $PlanId
          Product    = $Product
          License    = $LicenseName
          Status     = $Status } 
    $PlanUsers.Add($ReportLine) }
}
Write-Host "Nombre de comptes scannés:" $PlanUsers.Count
$DisabledCount = $PlanUsers | ?{$_.Status -eq "Deleted"}
$EnabledCount = $PlanUsers | ? {$_.Status -eq "Enabled"}
Write-Host (“{0} est activé pour {1} comptes et n'est pas activé pour {2} comptes” -f $Product, $EnabledCount.Count, $DisabledCount.Count)
$PlanUsers | Sort User | Out-GridView #Ici c'est une sortie Out-GridView, possibilité de remplacer par un fichier CSV avec Export-CSV -Path "C:\cheminChoisi\nomDuFichier.csv" -Delimiter ";"

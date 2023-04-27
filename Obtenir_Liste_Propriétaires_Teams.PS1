# Obtention des identifiants 
$credentials=Get-Credential  
 
# Connexion à Teams  
Connect-MicrosoftTeams -Credential $credentials  
 
# Obtention de toutes les équipes du tenant  
$teamColl=Get-Team  
 
# Regarder pour chaque équipe 
foreach($team in $teamColl)  
{  
    Write-Host -ForegroundColor Magenta "Getting all the owners from Team: " $team.DisplayName  
 
    # Obtention des propriétaires d'équipe  
    $ownerColl= Get-TeamUser -GroupId $team.GroupId -Role Owner  
 
    #Regarder pour chaque propriétaire  
    foreach($owner in $ownerColl)  
    {  
        Write-Host -ForegroundColor Yellow "ID d'utilisateur: " $owner.UserId "   UPN: " $owner.User  "   Nom: " $owner.Name 
    }      
}
#Ici c'est une sortie Out-GridView, possibilité de remplacer par un fichier CSV avec Export-CSV -Path "C:\cheminChoisi\nomDuFichier.csv" -Delimiter ";"
$ownerColl | Sort User | Out-GridView 

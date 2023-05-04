#Connexion au module teams
Connect-MicrosoftTeams 
#Ici il faut spécifier le chemin du CSV. Le fichier ne doit avoir qu'une seule colonne UPN avec les noms d'utilisateurs inscrits
#On ne peut inviter dans une équipe que des personnes déjà dans le tenant, donc pas d'invités externes n'étant pas dans le tenant
#Dans AAD les invités ont un UPN du style prenom.nom_outlook.com#EXT#@nomDuDomaine.onmicrosoft.com mais il faut simplement les ajouter dans le fichier avec prenom.nom@outlook.com
Import-CSV C:\Users\NomUtilisateur\Fichier.csv | foreach {   
$UPN=$_.UPN    
#Ici il vous faudra trouver le GroupID de l'équipe avec Get-Team, sinon dans le TAC, et l'indiquer à la place de <GroupID Team>
Add-TeamUser –GroupId <GroupID Team> -User $UPN   
If($?)   
{   
 Write-Host $UPN A été ajouté avec succès -ForegroundColor Green   
}   
Else   
{   
 Write-Host $UPN - Une erreur est survenue –ForegroundColor Red   
}   
} 

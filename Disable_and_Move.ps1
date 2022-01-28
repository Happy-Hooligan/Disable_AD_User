Set-ExecutionPolicy -ExecutionPolicy Bypass

#Type in username, locate them and save to a variable. Samaccount name works very well in powershell

$UserCredential = Import-Clixml -Path C:\Users\username\path\to\file\cloud.cred
$AccountName = Read-Host "Enter login name of user to disable"
$User = Get-ADUser -Identity $AccountName

#Disables the account and removes all permissions besides "domain users"

Disable-ADAccount -Identity $AccountName 
Get-AdPrincipalGroupMembership -Identity $AccountName | Where-Object -Property Name -Ne -Value 'Domain Users' | Remove-AdGroupMember -Members $AccountName

#Moves the user to a differnet OU from active users

Move-ADObject -Identity $User.ObjectGUID -TargetPath "OU=WhereYoutPutAllDisabledUsers,DC=domain_name,DC=local"

# Connect to Office 365 and set their mailbox to shared

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession -Session $Session -DisableNameChecking

Set-Mailbox $AccountName@emailaddress.com -Type Shared 

#Connect to licensing services and remove any Microsoft cloud licenses

Connect-MsolService -Credential $UserCredential
Set-MsolUserLicense -UserPrincipalName $AccountName@emailaddress.com -RemoveLicenses "License name" 

# Disable_AD_User
Disable, remove permissions, set mailbox to shared and remove Office 365 License. 

This script does all the work for offboarding a user. This assumes that you:
1) Set mailboxes to shared for data retention
2) Disable and not delete users
3) And have a hybrid setup with on-premise user that are replicated to the cloud

This will disable the user, remove all their permission except "domain users," move them to a specified OU, set their mailbox to shared and remove Office 365 licenses. I don't do direct licenses for users anymore, but I left it in the script for older users who would still have direct licensing. I think it's much easier to do by group membership. If you don't know how to do licensing by group membership, I wrote an article on how to do it. https://jefftechs.com/azure-group-license-assignment/

You'll need to update some values for this script. The import path for your credentials (can also swap it out for get-credential), the OU path for the disabled user and the license name for removal. The license name will probably be something like companyname:ENTERPRISEPACK (if it's an office 365 Office Suite license)

You can check the license name, by running these commands:
Connect-MsolService
Get-MsolUser -UserPrincipalName Licensed_User@company.com | select name,licenses

Enjoy!

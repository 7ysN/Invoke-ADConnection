# Test-ADConnection
This script performs a connectivity check against Active Directory LDAP Service.
The script takes all active users from the current domain and tries to log in with the given password.
The script will only display users whose password is correct.

# Usage:
PS C:\tmp> . .\Test-ADConnection.ps1

PS C:\tmp> Enter A Password: Password123 
# Output Example:
Domain\User:Password123


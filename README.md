# Test-ADConnection
This script performs a connectivity check against Active Directory LDAP Service.
The script takes all active users from the current domain and tries to log in with the given password.
The script will only display users whose password is correct.

## Usage:
PS C:\tmp> . .\Test-ADConnection.ps1

PS C:\tmp> Enter A Password: Aa123456! 
## Output Example:
![1](https://user-images.githubusercontent.com/62604022/193708206-7475fc1d-c928-49ee-839b-4f480aac4968.png)

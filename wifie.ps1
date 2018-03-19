function Wifie {

    [CmdLetBinding()]
    param( [string]$network )

    if ( $network ) {

        Write-Host ""
        Write-Host ""
        Write-Host "Wireless Network Details:" -ForegroundColor Cyan
        Write-Host "===================================" -ForegroundColor Gray
        netsh.exe wlan show profiles name=$network key=clear
        Write-Host "===================================" -ForegroundColor Gray
        Write-Host ""

    } else {

        $networks = netsh.exe wlan show profiles key=clear | findstr "All"
        $networkNames = @($networks.Split(":") | findstr -v "All").Trim()

        Write-Host ""
        Write-Host ""
        Write-Host "Wireless Networks and Passwords" -ForegroundColor Cyan
        Write-Host "===================================" -ForegroundColor Gray
        Write-Host ""
        Write-Host "SSID : Password"-ForegroundColor Gray
        
        $result = New-Object -TypeName PSObject
 
        foreach ( $ap in $networkNames ) {
            
            try {
            
                $password = netsh.exe wlan show profiles name=$ap key=clear | findstr "Key" | findstr -v "Index"
                $passwordDetail = @($password.Split(":") | findstr -v "Key").Trim()
                #if ( -Not $password ) {
                #    $password = netsh.exe wlan show profiles name=$ap key=clear | findstr "Auth"
                #    $passwordDetail = "$password"
                #}
                Write-Host "$ap" -NoNewline
                Write-Host " : " -NoNewline
                Write-Host "$passwordDetail" -ForegroundColor Green
            } catch {
                Write-Host "Unable to obtain password for $ap - Likely using 802.1x or Open Network" -ForegroundColor Red
            }
        }
        Write-Host ""
        Write-Host "===================================" -ForegroundColor Gray
        Write-Host ""
    }
    Get-Variable | Remove-Variable -EA 0
}

wifie

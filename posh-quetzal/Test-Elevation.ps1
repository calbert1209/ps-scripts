
function Test-Elevation {

    try {
        $identity = [Security.Principal.WindowsIdentity]::GetCurrent() | Out-Null
        $principal = New-Object Security.Principal.WindowsPrincipal -ArgumentList $identity | Out-Null
        return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    }
    catch {
        return $false
    }
}
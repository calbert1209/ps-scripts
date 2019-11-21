
function Get-ImageSize {
    param (
        [Parameter(Mandatory=$true, Position=1)]
        [string]$Path
    )
    
    $shell = New-Object -ComObject Shell.Application
    $folder = Split-Path $Path -Parent
    $file = Split-Path $Path -Leaf
    $shellFolder = $shell.NameSpace($folder)
    $shellFile = $shellFolder.ParseName($file)

    # HINT: SO: Enumerate file properties in PowerShell https://stackoverflow.com/a/9420165
    $DIMENSION_KEY = 31
    
    # NOTE: GetDetailsOf() returns string in format of _9999 x 9999 
    # where '_' is the left-to-right embedding char of value 8234
    $dimensions = $shellFolder.GetDetailsOf($shellFile, $DIMENSION_KEY) -replace "[^\dx]", "" -split "x"
    
    return @{"Width"=$dimensions[0]; "Height"=$dimensions[1]}
}
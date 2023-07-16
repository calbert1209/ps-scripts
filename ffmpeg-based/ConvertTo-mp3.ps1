function ConvertTo-mp3 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]
        $File
    )
        
    begin {
        
    }
    
    process {
        $source = $File.FullName
        $target = $source -replace "m4a", "mp3"

        Write-Host "$source" -ForegroundColor Yellow
        Write-Host "$target" -ForegroundColor Green
    }
    
    end {
        
    }
}

# NOTE: This script assumes:
#    a pre-created ".\entries\" sub-directory containing .doentry files.
#    a pre-created ".\markdown\" sub-directory to hold generated .md files

$xmlGetter = @{n="xml";e={[xml](Get-Content -Path $_.FullName -Encoding UTF8)}}
$entries = Get-ChildItem ".\entries\" -Filter "*.doentry"
$contents = $entries | Select-Object *, $xmlGetter

[xml]$testEntry = $contents[0].xml

function ConvertFrom-Dict {
    param([System.Xml.XmlElement] $Node)

    $output = @{}
    [System.Xml.XmlNodeList]$keyNodes = $Node.SelectNodes("key")
    foreach ($keyNode in $keyNodes) {
        [System.Xml.XmlElement]$valueNode = $keyNode.NextSibling
        
        if (-not $valueNode.HasChildNodes){
            $output.Add($($keyNode.'#text'), $($valueNode.LocalName))
        }
        elseif($valueNode.ChildNodes.Count -eq 1){
            $output.Add($($keyNode.'#text'), $($valueNode.'#text'))
        }
        elseif ($valueNode.LocalName -eq "array"){
            $arrayItems = @()
            foreach ($item in $valueNode.ChildNodes) {
                $arrayItems += $item.'#text'
            }
            $output.Add($($keyNode.'#text'), $arrayItems)
        }
        else {
            $value = ConvertFrom-Dict $valueNode
            $output.Add($($keyNode.'#text'), $value)
        }
        
    }
    return $output
}

Function New-LocationString{
    param([hashtable] $Location)

    if ($null -eq $Location){
        return [String]::Empty
    }

    $locationHeader = "  Location:`n"

    $country = $Location.Country
    $prefecture = $Location.'Administrative Area'
    $locationLineOne = "    $country $prefecture`n"
    $hasLineOne = $locationLineOne.Length -gt 6

    $locality = $Location.Locality
    $place = $Location.'Place Name'
    $locationLineTwo = "    $locality $place`n"
    $hasLineTwo = $locationLineTwo.Length -gt 6
    
    $long = $Location.Longitude
    $lat = $Location.Latitude
    $locationLineThree = "    ($long, $lat)`n"
    $hasLineThree = $locationLineThree.Length -gt 9
    
    $locationString = [String]::Empty
    if ($hasLineOne -or $hasLineTwo -or $hasLineThree){
        $locationString += $locationHeader
    }
    if ($hasLineOne){
        $locationString += $locationLineOne
    }
    if ($hasLineTwo){
        $locationString += $locationLineTwo
    }
    if ($hasLineThree){
        $locationString += $locationLineThree
    }
    if ($locationString.Length -gt 0){
        $locationString += "`n"
    }
}

Function New-MarkdownText {
    [cmdletbinding()]
    Param(
        [Parameter(ValueFromPipeline)]    
        [xml] $Entry
    )

    [hashtable]$entry = ConvertFrom-Dict $Entry.plist.dict

    $locationString = New-LocationString -Location $entry.Locality
    $creationDate = "  Date: $($entry.Creator.'Generation Date') $($entry.'Time Zone')"
    $uuid = "  UUID: $($entry.UUID)"
    $OFS = ", "
    $tags = "  Tags: $($entry.Tags)"
    $footer = "```````n$locationString$creationDate`n$uuid`n$tags`n``````"
    
    Return @{"UUID"=$($entry.UUID); "Text"="`n`# $($entry.'Entry Text')`n`n$footer`n"}
}

function Show-MarkdownText {

    Param(
        [parameter(ValueFromPipeline)]
        [hashtable]$MdHashtable)

    Write-Host "=== $($MdHashtable.UUID).md ===`n" -ForegroundColor Green
    $MdHashtable.Text
}

function Out-MarkdownFile {

    Param(
        [parameter(ValueFromPipeline)]
        [hashtable]$MdObject
    )

    $MdObject.Text | Out-File -FilePath ".\markdown\$($MdObject.UUID).md" -Encoding utf8
}

# :::: Run the script ::::

$Global:counter = $contents.Count
$contents | ForEach-Object {
    $mdObj = $_.xml | New-MarkdownText

    Write-Host "$($Global:counter) $($_.Name)" -ForegroundColor Green

    $mdObj | Out-MarkdownFile
    $Global:counter -= 1
}
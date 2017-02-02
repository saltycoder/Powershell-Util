param (
    [string] $searchin,  # Full Path to start search in
    [string] $wordlist,  # Word list of terms to search for
    [string] $ext,       # Comma delimited string of file extensions.  (aspx,html,jsp)
    [string] $word       # Single term to search for 
)


function SearchForIt($line)
{
    $tblFormat = @{Expression={$_.Filename};Label="Resource";width=20},
                 @{Expression={$_.LineNumber};Label="Line";width=10},
                 @{Expression={$_.Line -replace '^\s+',''};Label="Text";width=400}

    ""
    ""
    Write-Host $line
    Write-Host '-----------------------------------------------------'
    $a = Get-ChildItem -Path $searchin -Include $fileExtensions -Recurse | Select-String "$line" -SimpleMatch
    if($a.count -gt 0) { $a | Format-Table -Wrap $tblFormat }
    $a = ""
}

# Convert the file extension string to an array and prepend
# each array item with the wild card characters.
[array]$fileExtensions = $ext.split(",")

for ( $i = 0; $i -lt $fileExtensions.Count; $i++ ) {
  $fileExtensions[$i] = "*.$($fileExtensions[$i])"
}

# Perform searches on wordlist and/or single word
if($wordlist -ne '')
{
    foreach($line in Get-Content $wordlist)
    {
        SearchForIt $line
    }
}

if($word -ne '')
{
    SearchForIt $word
}
# Defines a new command in powershell, cd-, and yeah you guessed it. It does the same thing that cd - do in linux.
# Go to previous dir. Put in about profile %USERNAME%\Documents\WindowsPowerShell\
# ( https://technet.microsoft.com/en-us/library/hh847857.aspx )

[System.Collections.Stack]$GLOBAL:dirStack = @()
$GLOBAL:oldDir = ''
$GLOBAL:addToStack = $true
function prompt
{
    Write-Host "PS $(get-location)>"  -NoNewLine -foregroundcolor Magenta
    $GLOBAL:nowPath = (Get-Location).Path
    if(($nowPath -ne $oldDir) -AND $GLOBAL:addToStack){
        $GLOBAL:dirStack.Push($oldDir)
        $GLOBAL:oldDir = $nowPath
    }
    $GLOBAL:AddToStack = $true
    return ' '
}
function BackOneDir{
    $lastDir = $GLOBAL:dirStack.Pop()
    $GLOBAL:addToStack = $false
    cd $lastDir
}
Set-Alias cd- BackOneDir

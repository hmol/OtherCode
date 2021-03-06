# Defines a new command in powershell, cd-, and yeah you guessed it. It does the same thing that cd - do in linux.
# Go to previous dir. Put in about profile %USERNAME%\Documents\WindowsPowerShell\
# ( https://technet.microsoft.com/en-us/library/hh847857.aspx )

#########################################################
# cd -
#########################################################
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
#########################################################
# Environments
#########################################################
function SetDevEnvironment(){
	$Env:ASPNETCORE_ENVIRONMENT = "Development"
	Write-Host "ASPNETCORE_ENVIRONMENT: "$Env:ASPNETCORE_ENVIRONMENT
}

function SetProdEnvironment(){
	$Env:ASPNETCORE_ENVIRONMENT = "Production"
	Write-Host "ASPNETCORE_ENVIRONMENT: "$Env:ASPNETCORE_ENVIRONMENT
	
}

Set-Alias set-env-dev SetDevEnvironment
Set-Alias set-env-prod SetProdEnvironment

#########################################################
# Dotnet run
#########################################################

function DotNetRun(){
	dotnet run
}

Set-Alias dnr DotNetRun

#########################################################
# Delete bin,obj folders
#########################################################

function DeleteBinAndObj(){
	Get-ChildItem .\ -include bin,obj -Recurse | foreach ($_) { remove-item $_.fullname -Force -Recurse; Write-Output($_.fullname); }
}

Set-Alias deletebin DeleteBinAndObj

#########################################################
# Delete *.lock.json files
#########################################################
function DeleteLockFiles(){
	Get-ChildItem -Path . -Include *.lock.json -Recurse | foreach { echo "$_"; $_.Delete() }
}

Set-Alias deletelock DeleteLockFiles

#########################################################
# Recurse search replace string
#########################################################
function SearchReplace(){
	$oldString = Read-Host -Prompt 'Input old text'
	$newString = Read-Host -Prompt 'Input new text'
	
	$files = Get-ChildItem . -rec
	foreach ($file in $files)
	{
		Write-Output $file.PSPath
		(Get-Content $file.PSPath) |
		Foreach-Object { $_ -replace $oldString, $newString } |
		Set-Content $file.PSPath
	}
}

Set-Alias search-replace SearchReplace

#########################################################
# Rename files with search replace in filename
#########################################################
function SearchReplaceFileName(){
	$oldString = Read-Host -Prompt 'Input old text'
	$newString = Read-Host -Prompt 'Input new text'
	
	$files = Get-ChildItem -Path .
	foreach ($file in $files) 
	{
		$newFileName=$file.Name.Replace($oldString, $newString)   
		Rename-Item $file $newFileName
	}
}

Set-Alias search-replace-filename SearchReplaceFileName

#########################################################
# Help
#########################################################

function GetHelp(){
	Write-Host "deletebin : delete all bin and obj folders recursive from where you are standing."
	Write-Host "deletelock : delete all *.lock.json files recursive from where you are standing."
	Write-Host "dnr : dotnet run"
	Write-Host "set-env-dev : set dotnet evn variable to dev"
	Write-Host "set-env-prod : set dotnet evn variable to prod"
	Write-Host "cd- : go back to previous dir"
	Write-Host "search-replace : searchreplace recurse"
	Write-Host "search-replace-filename : searchreplace filename"
}

Set-Alias helpme GetHelp



##
## Oct2012

## TODO
#    Upload Directory (with regex .../*.txt)
#    Download support

$idrvUser = "userNameHere" ## TODO: read from file
$hostname = "machineName" ## TODO: Default Destination (/Inbox/machineName)

################################
$idrvBin = "idevsutil.exe"
$idrvPwdFile = "${Home}/.idrive.pw"

$idrvOpt = "--verbose --type"
$idrvTmp = "--temp=" + [System.IO.Path]::GetTempPath()

$cmdUtilityServer = "evs57.idrive.com" ## TODO: get at runtime
 
$idrvURLbase = "${idrvUser}@${cmdUtilityServer}::home"

## idevsutil.exe should be in PATH
$Env:Path = $Env:Path + ";D:\Repo\CloudStoreTools\idevsutil_win"  

################################

$idrvPswd = ""

if (Test-Path -PathType Leaf $idrvPwdFile) {
   #### Windows is not secure to save password ##
   $idrvPswd = "--password-file=$idrvPwdFile"
}


################################

function getCygPath ([string]$path)
{
	$local:uxp = $path.Trim()
   if ( $local:uxp.Substring(1,1).equals(":") ) {
      $local:uxp = "/" + $local:uxp.Substring(0,1).ToLower() + "/" +  $local:uxp.Substring(3).Replace("\","/")
   } else {   
      $local:uxp = $local:uxp.Replace("\","/")
   }
   return $local:uxp
}

################################

function getFullDirName ([string]$path)
{
   return [System.IO.Path]::GetDirectoryName([System.IO.Path]::GetFullPath($path))
}
################################


function idrv-upload-file ([string]$from, [string]$to) 
{

  $local:tmpfile = [System.IO.Path]::GetTempFileName() 

  $local:fileDir = getCygPath(getFullDirName($from))
  
  [System.IO.Path]::GetFileName($from) | Out-File -encoding ascii $local:tmpfile

  $local:idrvCmd = "$idrvBin $idrvOpt $idrvTmp $idrvPswd --files-from=${local:tmpFile} ${local:fileDir}  ${idrvURLbase}$to"
  
  Write-Host "Debug: exec: ${local:idrvCmd}"

  Invoke-Expression  -command $local:idrvCmd  ##| Out-Null
  
  Remove-Item $tmpfile ###-Force
}

idrv-upload-file "D:\Repo\CloudStoreTools\idevsutil_win\Readme.txt" "/Devel"


Write-Host "Debug: Done: " + $?






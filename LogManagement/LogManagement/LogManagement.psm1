<#
 Author				:			Nicolas Belanger

 FileName			:			LogManagement.psm1

 Description		:			Log Management

 Creation Date		:			2015-08-10

 Modification Date	:			2016-01-25
#>

[string]$dp0 = Split-Path -Path $MyInvocation.MyCommand.Path
[string]$dp0Script = $MyInvocation.MyCommand.Definition
[string]$dp0Module = $MyInvocation.MyCommand.Name.Split('.')[0]
[string]$ScriptRoot = $MyInvocation.PSScriptRoot

#Loading configuration
[System.Xml.XmlDocument]$Configuration = $null
#[System.Collections.Hashtable[]]$Emails = New-Object 'System.Collections.Generic.Dictionary[String,String][]'
[System.Collections.Hashtable[]]$Emails = @()
try {
	$Configuration = Get-Content "$dp0\Settings.xml" -ErrorAction Stop
	$Ems = $Configuration.Settings.Emails.Email
	[System.Collections.ArrayList]$LisEmails = New-Object 'System.Collections.Generic.List[System.Collections.Generic.Dictionary[String,String]]'
	[System.Collections.Hashtable]$Email = New-Object 'System.Collections.Generic.Dictionary[String,String]'
	foreach ($E in $Ems){
		$Email = @{
			"From" = $E.From
			"To" = $E.To
			"Smtp" = $E.Smtp
			"Subject" = $E.Subject
			"SmtpUsername" = $E.SmtpUsername
			"SmtpPassword" = $E.SmtpPassword
			"SmtpSSL" = $E.SmtpSSL
			"SmtpPort" = $E.SmtpPort
		}
		$LisEmails.Add($Email)
	}
	$Emails = $LisEmails.ToArray()
	#$Emails = $Configuration.Settings.Emails.Email
}
catch  {
	Write-Error $_
	Write-Verbose "$($dp0Module).$($MyInvocation.MyCommand) : The configuration file Settings.xml in the module folder is not available. You will have to configure the module manually using the function Set-LogManagement"
}

if ($Configuration -eq $null) {
	$Emails = $null
}

[string]$script:LogManagment_LogPath = $null
[string]$script:LogManagment_BaseLogFileName = $null
[bool]$script:LogManagment_OutputToConsole = $false


Function Set-LogManagement {
	<#
	.SYNOPSIS
	Configure the Logging Management for the project calling the current module
	.DESCRIPTION
	Configure the Logging Management for the project calling the current module
	.EXAMPLE
	Set-LogManagement ........ TO BE COMPLETED
	.EXAMPLE
	Set-LogManagement ........ TO BE COMPLETED SECOND EXAMPLE
	.PARAMETER LogPath
	The path containings the log
	.PARAMETER BaseLogFileName
	The basename for the logs files
	.PARAMETER OutputToConsole
	Is it outputed to the console too ($True or $False)
	.PARAMETER $Ems
	Do we send emails containing the logs?
	#>
[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
	param (
		[Parameter(Mandatory=$True,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="What is the folder path of the log files")]
		[string]$LogPath,

		[Parameter(Mandatory=$True,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="What is the base name for the log files")]
		[string]$BaseLogFileName,

		[Parameter(Mandatory=$True,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="Do we output the messages to the console?")]
		[boolean]$OutputToConsole,

		[Parameter(Mandatory=$False,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="Do we send emails containing the logs if so what are the addresses?")]
		[hashtable[]]$Ems
	)

	begin {
		Write-Verbose "$($dp0Module).$($MyInvocation.MyCommand) : Settings LogManagement Module parameters"
	}

	process {
		$script:LogManagment_LogPath = $LogPath.Clone()
		$script:LogManagment_BaseLogFileName = $BaseLogFileName.Clone()
		$script:LogManagment_OutputToConsole = $OutputToConsole
		if ($Ems -ine $null){
			$script:Emails = $Ems
		}
		Log-Normal "Log System Initiated"
	}
}

Function Log-Normal {
	<#
	.SYNOPSIS
	Log "Normal Data"
	.DESCRIPTION
	Log "Normal Data"
	.EXAMPLE
	Log-Normal ........ TO BE COMPLETED
	.EXAMPLE
	Log-Normal ........ TO BE COMPLETED SECOND EXAMPLE
	.PARAMETER DataToBeLogged
	Data that will be logged
	#>
[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
	param (
		[Parameter(Mandatory=$True,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="What data need to be logged")]
		[string]$DataToBeLogged
	)

	begin {}

	process {
		Log-Data -DataToBeLogged $DataToBeLogged -LogLevel "Normal"
	}
}

Function Log-Verbose {
	<#
	.SYNOPSIS
	Log "Verbose Data"
	.DESCRIPTION
	Log "Verbose Data"
	.EXAMPLE
	Log-Verbose ........ TO BE COMPLETED
	.EXAMPLE
	Log-Verbose ........ TO BE COMPLETED SECOND EXAMPLE
	.PARAMETER DataToBeLogged
	Data that will be logged
	#>
[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
	param (
		[Parameter(Mandatory=$True,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="What data need to be logged")]
		[string]$DataToBeLogged
	)

	begin {}

	process {
		Log-Data -DataToBeLogged $DataToBeLogged -LogLevel "Verbose"
	}
}

Function Log-Debug {
	<#
	.SYNOPSIS
	Log "Debug Data"
	.DESCRIPTION
	Log "Debug Data"
	.EXAMPLE
	Log-Debug ........ TO BE COMPLETED
	.EXAMPLE
	Log-Debug ........ TO BE COMPLETED SECOND EXAMPLE
	.PARAMETER DataToBeLogged
	Data that will be logged
	#>
[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
	param (
		[Parameter(Mandatory=$True,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="What data need to be logged")]
		[string]$DataToBeLogged
	)

	begin {}

	process {
		Log-Data -DataToBeLogged $DataToBeLogged -LogLevel "Debug"
	}
}

Function Log-Error {
	<#
	.SYNOPSIS
	Log "Error Data"
	.DESCRIPTION
	Log "Error Data"
	.EXAMPLE
	Log-Debug ........ TO BE COMPLETED
	.EXAMPLE
	Log-Debug ........ TO BE COMPLETED SECOND EXAMPLE
	.PARAMETER DataToBeLogged
	Data that will be logged
	#>
[CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
	param (
		[Parameter(Mandatory=$True,
		#ValueFromPipelineByPropertyName=$True,
		HelpMessage="What data need to be logged")]
		[string]$DataToBeLogged
	)

	begin {}

	process {
		Log-Data -DataToBeLogged $DataToBeLogged -LogLevel "Error"
	}
}

Function Log-Data {
	param (
		[Parameter(Mandatory=$True,
		HelpMessage="What data need to be logged")]
		[string]$DataToBeLogged,

		[Parameter(Mandatory=$True,
		HelpMessage="What level is the data that need to be logged")]
		[string]$LogLevel
	)

	[string]$LogFile = "$script:LogManagment_LogPath`\$LogLevel`_$script:LogManagment_BaseLogFileName"

	$DataToBeLogged = "$(Get-Date) : $DataToBeLogged"

	$DataToBeLogged | Out-File -Append -FilePath $LogFile

	#If it is set to display output of all level, do so by choosing the right stream
	if($LogManagment_OutputToConsole) {
		switch ($LogLevel){
			"Normal" {
				Write-Host $DataToBeLogged
				break
			}
			"Verbose" {
				Write-Verbose $DataToBeLogged
				break
			}
			"Debug" {
				Write-Debug $DataToBeLogged
				break
			}
			"Error" {
				Write-Error $DataToBeLogged
				break
			}
			default {
				Write-Host $DataToBeLogged
				break
			}
		}
	}
	#Else, only display "Normal" Output
	elseif ($LogLevel -eq "Normal"){
		Write-Host $DataToBeLogged
	}

}

Function Email-Logs {
	
	[string]$NormalLogFile = "$script:LogManagment_LogPath`\Normal`_$script:LogManagment_BaseLogFileName" 
	[string]$VerboseLogFile = "$script:LogManagment_LogPath`\Verbose`_$script:LogManagment_BaseLogFileName" 
	[string]$DebugLogFile = "$script:LogManagment_LogPath`\Debug`_$script:LogManagment_BaseLogFileName" 
	[string]$ErrorLogFile = "$script:LogManagment_LogPath`\Error`_$script:LogManagment_BaseLogFileName" 
	[string]$Body = Get-Content -Raw $NormalLogFile
	[System.Collections.ArrayList]$AttachmentsList = New-Object 'System.Collections.ArrayList'

	$Attachments = @($NormalLogFile,$VerboseLogFile,$DebugLogFile,$ErrorLogFile)


	foreach($att in $Attachments){
		if (Test-Path $att){
			$AttachmentsList.Add($att) | Out-Null
		}
	}
	
	foreach($Email in $Emails){
		[pscredential]$Credential = $null
		[securestring]$SecPassword = $null
		if($Email.SmtpPassword -ne ""){
			$SecPassword =  ConvertTo-SecureString $Email.SmtpPassword -AsPlainText -Force
			$Credential = New-Object System.Management.Automation.PSCredential ($Email.SmtpUsername, $SecPassword)
		}
		if (([System.Convert]::ToBoolean($Email.SmtpSSL))){
			if($Credential -ine $null){
				Send-MailMessage -BodyAsHtml -from $Email.From -SmtpServer $Email.Smtp -Body $body -Subject $Email.Subject -To $Email.To -Encoding Default -Attachments $AttachmentsList -UseSsl -Port $Email.SmtpPort -Credential $Credential
			}
			else{
				Send-MailMessage -BodyAsHtml -from $Email.From -SmtpServer $Email.Smtp -Body $body -Subject $Email.Subject -To $Email.To -Encoding Default -Attachments $AttachmentsList -UseSsl -Port $Email.SmtpPort
			}
		}
		else{
			if($Credential -ine $null){
				Send-MailMessage -BodyAsHtml -from $Email.From -SmtpServer $Email.Smtp -Body $body -Subject $Email.Subject -To $Email.To -Encoding Default -Attachments $AttachmentsList -Port $Email.SmtpPort -Credential $Credential
			}
			else{
				Send-MailMessage -BodyAsHtml -from $Email.From -SmtpServer $Email.Smtp -Body $body -Subject $Email.Subject -To $Email.To -Encoding Default -Attachments $AttachmentsList -Port $Email.SmtpPort
			}
		}
	}

}


# expose functions when someone imports this module
Export-ModuleMember -Function Set-LogManagement
Export-ModuleMember -Function Log-Normal
Export-ModuleMember -Function Log-Verbose
Export-ModuleMember -Function Log-Debug
Export-ModuleMember -Function Log-Error
Export-ModuleMember -Function Email-Logs
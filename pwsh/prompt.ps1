function prompt
{
	$isAdmin = (New-Object Security.Principal.WindowsPrincipal (
				[Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole(
			[Security.Principal.WindowsBuiltinRole]::Administrator)

	# {{{ git info
	function GetGitBranch() {
		$gitBranch = git branch | Out-String
		$gitBranch = $gitBranch | Select-String -Pattern "\* .*\n"
		$gitBranch = $gitBranch.Line
		if ([string]::IsNullOrEmpty($gitBranch)) {
			$gitBranch = ""
		} else {
			$gitBranch = $gitBranch.Trim().SubString(2)
		}
		return "$gitBranch"
	}
	# }}}

	# Decorate the CMD Prompt
	# see: https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences
	$colorNone = "`e[0m"
	$colorBgCyan = "`e[46m"
	$colorFgGreen = "`e[32m"
	$colorFgBlue = "`e[34m"
	$gitBranch = GetGitBranch
	# pwsh has bug with background color when scrolling,
	# see: https://github.com/PowerShell/PowerShell/issues/15130
	# $gitBranch = $( if ([string]::IsNullOrEmpty($gitBranch)) { "" } else { "[  $gitBranch  ]" } )
	# $gitBranch = $( if ([string]::IsNullOrEmpty($gitBranch)) { "`r`n" } else { "${gitBranch}`r`n" } )
	# $res = "${colorBgCyan}${gitBranch}${colorNone}"
	$res = "${res}`r`n${colorFgGreen}${env:username}@$(hostname)${colorNone}"
	$res = "${res} ${colorFgBlue}${pwd}${colorNone}"
	$res = "${res}`r`n$( if ($isAdmin) { '#' } else { '$' } ) "
	return $res
}

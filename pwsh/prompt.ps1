function prompt
{
	$isAdmin = (New-Object Security.Principal.WindowsPrincipal (
				[Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole(
			[Security.Principal.WindowsBuiltinRole]::Administrator)

	# {{{ Calculate execution time of last cmd and convert to milliseconds,
	# seconds or minutes
	function CalElapsedTime()
	{
		$lastCommand = Get-History -Count 1
		if ($lastCommand) {
			$runTime = ($lastCommand.EndExecutionTime -
					$lastCommand.StartExecutionTime).TotalSeconds
		}

		if ($runTime -ge 60) {
			$ts = [timespan]::fromseconds($runTime)
			$min, $sec = ($ts.ToString("mm\:ss")).Split(":")
			$elapsedTime = -join ($min, " min ", $sec, " sec")
		}
		else {
			$elapsedTime = [math]::Round($runTime, 2)
			$elapsedTime = -join (($elapsedTime.ToString()), " sec")
		}
		return $elapsedTime
	}
	# }}}

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
	$gitBranch = GetGitBranch
	Write-Host ( $( if ([string]::IsNullOrEmpty($gitBranch)) { "" } else { "  $gitBranch ☰ " } ) ) -BackgroundColor Cyan -NoNewlin
	Write-Host ""  # otherwise the 'Cyan' color above will append to the following line after execute any command
	Write-Host "$env:username@$(hostname) " -ForegroundColor Green -NoNewline
	Write-Host "$pwd " -ForegroundColor Blue -NoNewline
	$elapsedTime = CalElapsedTime
	Write-Host "[$elapsedTime] " -ForegroundColor Yellow
	Write-Host ($(if ($isAdmin) { '#' } else { '$' })) -NoNewline
	return " "
}

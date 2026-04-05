param(
	[string] $Name,
	[string] $ParentDir,
	[string[]] $InitialStates = @("Disabled", "Enabled"),

	[ValidateSet("Node", "Node2D", "Control")]
	[string] $BaseType = "Node",

	[switch] $Tool = $false
)

function PascalToSnake([string] $Value) {
	if ([Regex]::Match($Value, '^[A-Z]+$').Success) {
		return $Value.ToLower()
	}

	# taken from https://gist.github.com/awakecoding/acc626741704e8885da8892b0ac6ce64
	return [Regex]::Replace($Value, '(?<=.)(?=[A-Z])', '_').ToLower()
}

function MakePath([string] $RawPath) {
	# this ensures path resolution works on Windows and macOS
	return Join-Path (Resolve-Path .) $RawPath
}

function CreateBaseFile([string] $BaseDir) {
	$baseFileName = "$(PascalToSnake -Value $Name).gd"
	$baseFilePath = MakePath -RawPath "$ParentDir\$BaseDir\$baseFileName"

	Write-Host "Writing base file '$baseFileName'..."

	$stateNamesUpper = [string[]]($InitialStates | % {
		return $_.ToUpper()
	})

	$firstStateNameUpper = $stateNamesUpper[0]

	$stateEnumStr = $stateNamesUpper -join ", "

	$templateFile = Resolve-Path ".\templates\state_machine_base.gdtemplate" -Relative

	if ($Tool) {
		$templateFile = Resolve-Path ".\templates\state_machine_base_tool.gdtemplate" -Relative
	}

	$baseLines = [IO.File]::ReadAllLines($templateFile)

	$transformedBaseLines = $baseLines | % {
		$_ `
		-replace ("%%ClassName%%", $Name) `
		-replace ("%%BaseType%%", $BaseType) `
		-replace ("%%StateEnumString%%", $stateEnumStr) `
		-replace ("%%FirstStateNameUpper%%", $firstStateNameUpper)
	}

	[IO.File]::WriteAllLines($baseFilePath, $transformedBaseLines)
}

function CreateStateFactory([string] $BaseDir) {
	$stateFactoryFileName = "$(PascalToSnake -Value $Name)_state_factory.gd"
	$stateFactoryFilePath = MakePath -RawPath "$ParentDir\$BaseDir\$stateFactoryFileName"

	Write-Host "Writing state factory file '$stateFactoryFileName'..."

	$statesDictLines = [string[]]($InitialStates | % {
		return "`t`t$($Name).State.$($_.ToUpper()): $($Name)State$($_),"
	}) -join "`n"

	$factoryTemplate = Resolve-Path ".\templates\state_machine_state_factory.gdtemplate" -Relative

	$factoryLines = [IO.File]::ReadAllLines($factoryTemplate)

	$transformedFactoryLines = $factoryLines | % {
		$_ `
		-replace ("%%ClassName%%", $Name) `
		-replace ("%%StatesLines%%", $statesDictLines)
	}

	[IO.File]::WriteAllLines($stateFactoryFilePath, $transformedFactoryLines)
}

function CreateStateData([string] $BaseDir, [string] $StatesDir) {
	$stateDataFileName = "$(PascalToSnake -Value $Name)_state_data.gd"
	$stateDataFilePath = MakePath -RawPath "$ParentDir\$BaseDir\$StatesDir\$stateDataFileName"

	Write-Host "Writing state data file '$stateDataFileName'..."

	$dataTemplate = Resolve-Path ".\templates\state_machine_data.gdtemplate" -Relative

	$dataLines = [IO.File]::ReadAllLines($dataTemplate)

	$transformedDataLines = $dataLines | % {
		$_ -replace ("%%ClassName%%", $Name)
	}

	[IO.File]::WriteAllLines($stateDataFilePath, $transformedDataLines)
}

function CreateBaseStateFile([string] $BaseDir, [string] $StatesDir) {
	$baseStateFileName = "$(PascalToSnake -Value $Name)_state.gd"
	$baseStateFilePath = MakePath -RawPath "$ParentDir\$BaseDir\$StatesDir\$baseStateFileName"

	Write-Host "Writing base state file '$baseStateFileName'..."

	$fieldName = PascalToSnake -Value $Name

	$baseStateTemplate = Resolve-Path ".\templates\state_machine_state_base.gdtemplate" -Relative

	$stateBaseLines = [IO.File]::ReadAllLines($baseStateTemplate)

	$transformedStateBaseLines = $stateBaseLines | % {
		$_ `
		-replace ("%%ClassName%%", $Name) `
		-replace ("%%FieldName%%", $fieldName)
	}

	[IO.File]::WriteAllLines($baseStateFilePath, $transformedStateBaseLines)
}

function CreateStateFile([string] $BaseDir, [string] $StatesDir, [string] $StateName) {
	$machinePrefix = PascalToSnake -Value $Name
	$stateNameLower = $StateName.ToLower()

	$stateFileName = "$($machinePrefix)_state_$($stateNameLower).gd"
	$stateFilePath = MakePath -RawPath "$ParentDir\$BaseDir\$StatesDir\$stateFileName"

	Write-Host "Writing $stateNameLower state file '$stateFileName'..."

	$fieldName = PascalToSnake -Value $Name

	$stateTemplate = Resolve-Path ".\templates\state_machine_state.gdtemplate" -Relative

	$stateLines = [IO.File]::ReadAllLines($stateTemplate)

	$transformedStateLines = $stateLines | % {
		$_ `
		-replace ("%%ClassName%%", $Name) `
		-replace ("%%StateName%%", $StateName) `
		-replace ("%%StateNameLower%%", $stateNameLower) `
		-replace ("%%FieldName%%", $fieldName)
	}

	[IO.File]::WriteAllLines($stateFilePath, $transformedStateLines)
}

if (-not $Name) {
	Write-Error "Please provide a name for the machine!"
	return
}

Write-Host "Generating new state machine for '$Name'..."

$baseDir = PascalToSnake -Value $Name

mkdir (MakePath -RawPath "$ParentDir\$baseDir") | Out-Null

$statesDir = "states"

mkdir (MakePath -RawPath "$ParentDir\$baseDir\$statesDir") | Out-Null

CreateBaseFile -BaseDir $baseDir
CreateStateFactory -BaseDir $baseDir
CreateStateData -BaseDir $baseDir -StatesDir $statesDir
CreateBaseStateFile -BaseDir $baseDir -StatesDir $statesDir

$InitialStates | % {
	CreateStateFile -BaseDir $baseDir -StatesDir $statesDir -StateName $_
}

def handleDirty($lines):
	$lines[1:-2] as $changedFiles
	| $changedFiles | filter(startswith("A")) as $addedFiles
	| $changedFiles | filter(startswith("M")) as $modifiedFiles
	| $changedFiles | filter(startswith("D")) as $deletedFiles
	| $lines[-2] | match("^Working copy : ([\s]$")

. as $lines

| if $lines[0] == "Working copy changes:"
	then

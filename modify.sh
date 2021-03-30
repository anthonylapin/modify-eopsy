function helpFunc() {
	echo "modify [-r] [-l] [-u] <dir/file names...>"
	echo "modify [r] <sed pattern> <dir/file names...>"
	echo "modify [-h]"
	echo "script modifies file names"
	echo "Script is dedicated to: "
	echo "lowercase (-l) file names"
	echo "uppercase (-u) file names"
	echo "apply sed pattern (-s) <pattern> to modify file names"
	echo "changes may be done either with recursion (-r) or without it"
	echo "-h displays help message"
}

function checkFilesExist() {
	arr=("$@")
	for elem in "${arr[@]}"
	do
		if [ ! -e $elem ]
		then
			echo "File $elem does not exist. Please, provide only valid file/directory names."
			exit 1
		fi
	done	
}

function checkOperationExist() {
	oper=$1
	case "$oper" in
		-u | -l | -ul | -lu) ;;
		nothing) 
			echo "No valid operations set. Use -h parameter to get a list of possible commands for this script."
			exit 1
			;;
		*)
			echo a | sed "$oper" >/dev/null 2>/dev/null ;
			if [ $? != 0 ]
			then
				echo "Invalid sed pattern / invalid operation"
				       	exit 1
				fi
			;;
	esac	
}

function renameFile() {
	#check if new name already exists
    if [ "${1}" != "${2}" ]; then
        [ ! -e "${2}" ] && mv -T "${1}" "${2}"
    fi
}

function toLower() {
	new_name="$(dirname "${1}")/$(basename "${1}" | tr '[A-Z]' '[a-z]')"
	renameFile "$1" "$new_name"
}

function toUpper() {
	new_name="$(dirname "${1}")/$(basename "${1}" | tr '[a-z]' '[A-Z]')"
	renameFile "$1" "$new_name"
}

function applySed() {
	new_name="$(dirname "${1}")/$(basename "${1}" | sed "$2")"
	renameFile "$1" "$new_name"
}

function applyOperationOnFile() {
	case "$2" in
		-u) toUpper "$1" ;;
		-l) toLower "$1" ;;
		-ul | -lu) ;;
		*) applySed "$1" "$2" ;;
	esac
}

function applyOperationOnDirectory() {
	for name in "$1"/*
	do
		applyOperationOnFile "$name" "$2"
	done
}

function applyOperationOnDirectoryRecursively() {
	mapfile -t all < <(find "$1" -depth)

	for name in "${all[@]}"
	do
		applyOperationOnFile "$name" "$2"
    done
}

elementsToModify=()
applyRecursion=0
operationToDo="nothing"

i=1;
j=$#;

while [ $i -le $j ]
do
	case "$1" in
		-u | -l | -ul | -lu) operationToDo=$1 ;;
		-h) helpFunc; exit 1 ;;
		-r) applyRecursion=1 ;;
		-s) i=$((i+1)); shift 1; operationToDo=$1 ;;
		*) elementsToModify+=( $1 ) ;;
	esac

	i=$((i+1));
	shift 1;
done

# check if all elements are either files or directories, if no exit script.
checkFilesExist "${elementsToModify[@]}"

# check if all operations are valid
checkOperationExist "${operationToDo}"

for i in "${elementsToModify[@]}"
do
   if [ -d "$i" ]
   then
   	if [ $applyRecursion -eq 1 ]
   	then
   		applyOperationOnDirectoryRecursively "$i" "$operationToDo"
   	else
   		applyOperationOnDirectory "$i" "$operationToDo"
   	fi
   else
   	applyOperationOnFile "$i" "$operationToDo"
   fi
done

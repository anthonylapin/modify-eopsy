#!/usr/bin/bash

function print_dir()
{
	find $1 -print0 | while IFS= read -r -d '' f; do
		echo "$f"
	done
	echo -e "--------------------------\n"
}

function print_test_dir()
{
	if [ -e "tests" ]
	then
		print_dir "tests"
	fi
	if [ -e "TESTS" ]
	then
		print_dir "TESTS"
	fi
}

function remove_test_dir()
{
	if [ -e "tests" ]
	then
		rm -r tests
	fi
	if [ -e "TESTS" ]
	then
		rm -r TESTS
	fi
}

remove_test_dir

mkdir "tests"
mkdir "tests/tests2"
mkdir "tests/tests2/w"

touch "tests/t.txt"
touch "tests/woafaf"
touch "tests/test with space.txt"
touch "tests/test_wfaf&wf12.sh"
touch "tests/test???.txt"
touch "tests/tests2/test_a.txt"
touch "tests/tests2/test space inside.sh"
touch "tests/tests2/wont change inside.txt"
touch "tests/tests2/test_inwwf0$pe& ch@rs.f"
touch "tests/tests2/w/a1"
touch "tests/tests2/w/13"
touch "tests/tests2/w/13.js"

echo -e "\nCalling ./modify.sh -h \n"
./modify.sh -h
echo -e "--------------------------\n"

echo -e "\nCalling ./modify.sh -u "tests/t.txt" "tests/woafaf""
./modify.sh -u "tests/t.txt" "tests/woafaf"
print_test_dir

echo -e "\nCalling ./modify.sh -l "tests/T.TXT" "tests/WOAFAF" "nonexistentfile""
./modify.sh -l "tests/T.TXT" "tests/woafaf" "nonexistentfile"
print_test_dir

echo -e "\nCalling ./modify.sh -l "tests/T.TXT" "tests/WOAFAF""
./modify.sh -l "tests/T.TXT" "tests/woafaf"
print_test_dir

echo -e "\nCalling ./modify.sh -u "tests""
./modify.sh -u "tests"
print_test_dir

echo -e "\n./modify.sh -l "tests""
./modify.sh -l "tests"
print_test_dir

echo -e "\nCalling ./modify.sh -r -u "tests""
./modify.sh -r -u "tests"
print_test_dir

echo -e "\nCalling ./modify.sh -r -l "TESTS""
./modify.sh -r -l "TESTS"
print_test_dir

echo -e "\nCalling ./modify.sh -s "s/h/m/g" "tests""
./modify.sh -s "s/h/m/g" "tests"
print_test_dir

echo -e "\nCalling ./modify.sh -r -s "s/m/h/g" "tests""
./modify.sh -r -s "s/m/h/g" "tests"
print_test_dir

echo -e "\nCalling ./modify.sh "tests""
./modify.sh "tests"
print_test_dir

echo -e "\nCalling ./modify.sh"
./modify.sh
print_test_dir

echo -e "\nCalling ./modify.sh -r -u "tests/nonexisten""
./modify.sh -r -u "tests/nonexisten"
print_test_dir

echo -e "\nCalling ./modify.sh -l -u "tests""
./modify.sh -l -u "tests"
print_test_dir

echo -e "\nCalling ./modify.sh -u -r "tests""
./modify.sh -u -r "tests"
print_test_dir

echo -e "\nCalling ./modify.sh -r "TESTS""
./modify.sh -r "TESTS"
print_test_dir

echo -e "\nCalling ./modify.sh -l """
./modify.sh -l ""
print_test_dir

echo -e "\nCalling ./modify.sh -s "" "TESTS""
./modify.sh -s "" "TESTS"
print_test_dir
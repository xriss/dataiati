
echo " This script will recreate datasets from our individual activitiy files by joining them together "
echo " and removing all duplicate activities so each id is only used once "

export dirname=$( dirname "$(readlink -f "$0")" )
cd "$dirname"

if ! [ -x "$(command -v parallel)" ]; then
	echo "parallel is not installed, atempting to install"
	sudo apt install -y parallel
fi

rm -rf node_modules
npm install d-portal
rm -rf package*


dodataset() {
declare -a 'a=('"$1"')'
slug=${a[0]}

echo Creating unique data only dataset for $slug

node_modules/d-portal/dflat/dflat --dir $dirname packages-join $slug --dedupe 2>&1

}
export -f dodataset

# deleteing all datasets as we will be rebuilding all of them
rm -rf datasets

ls -1 xml | sort -R | parallel -j -1 --bar dodataset


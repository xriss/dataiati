
echo " This script will rebuild the metadata in json from the xml directory "
echo " Including perfile data that is not checked into git "

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

echo " Rebuilding meta data for $slug "

node_modules/d-portal/dflat/dflat --dir $dirname packages-meta $slug 2>&1

}
export -f dodataset

# deleteing all json as we will be rebuilding everything
rm -rf json

ls -1 xml | sort -R | parallel -j -1 --bar dodataset


echo " Merging meta data for all slugs "

node_modules/d-portal/dflat/dflat --dir $dirname packages-meta 2>&1

dirname=$( dirname "$(readlink -f "$0")" )
cd "$dirname"

# This script will recreate datasets from our individual activitiy files by joining them together



# create or replace our datasets directory

rm -rf datasets
mkdir -p datasets


# join all the files together, skipping the first line which is just an xml header

funct() {
declare -a 'a=('"$1"')'
file=${a[0]}

	tail -n+2 -q xml/$file/*.xml >datasets/$file.xml

}
export -f funct
ls -1 xml | sort -R | parallel -j 32 --bar funct


dirname=$( dirname "$(readlink -f "$0")" )
cd "$dirname"

# if you want to use this script then you should also
# .gitignore node_modules and dataflat
# to help keep thongs clean

# use the d-portal from npm to clear and initalise dataflat

rm -rf node_modules
npm install d-portal
rm -rf package*

node_modules/d-portal/dflat/dflat packages --dir "$dirname/dataflat"


# download and parse all the data

dataflat/downloads.sh
dataflat/packages.sh


# replace our xml directory with the one we just created

rm -rf xml
mv dataflat/xml .
cp dataflat/logs.txt .
grep --colour=never  --after-context=1 --before-context=1 --extended-regexp '(curl:|dflat:)' logs.txt >errors.txt


# some files may have failed to download so we restore these from the git history

restore() {
declare -a 'a=('"$1"')'
file=${a[0]}

if [ ! -d "xml/$file" ] ; then

	git checkout -- xml/$file

fi

}
export -f restore
cat dataflat/downloads.txt | sort -R | parallel -j 1 --bar restore

# commit changes to git

git add logs.txt
git add errors.txt
git add xml
git commit -m"$(command date -I)"
git gc

# now we could push the changes...
git push


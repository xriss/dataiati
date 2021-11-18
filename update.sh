
echo " This script will download the latest datasets and parse them into individual xml files "
echo " Build json metadata for these files and finally push the changes into this git repo "

dirname=$( dirname "$(readlink -f "$0")" )
cd "$dirname"


# make sure we are uptodate with git

git pull

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


# some files may have failed to download so we restore these from the git history

restore() {
declare -a 'a=('"$1"')'
file=${a[0]}

if [ ! -d "xml/$file" ] ; then

	git checkout -- xml/$file
	count=`find xml/$file/ -type f -printf '.' | wc -c`
	echo "restored $count files" | tee -a dataflat/logs/$file.txt

fi

}
export -f restore
cat dataflat/downloads.txt | sort -R | parallel -j 1 --bar restore


# regenerate json metadata from the files in the xml directory so restored xml files have correct meta

./json.sh


# do not keep the individual metas
#rm -rf json/activity-identifiers
#rm -rf json/organisation-identifiers



# merge all the logs into one file

cat dataflat/logs/*.txt >logs.txt
grep --colour=never  --after-context=1 --before-context=1 --extended-regexp '(curl:|dflat:)' logs.txt >errors.txt


# commit changes to git

git add logs.txt
git add errors.txt
git add xml
git add json
git commit -m"$(command date -I)"
git gc

# now we could push the changes...
git push


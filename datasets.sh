dirname=$( dirname "$(readlink -f "$0")" )
cd "$dirname"

# This script will recreate datasets from our individual activitiy files by joining them together


rm -rf node_modules
npm install d-portal
rm -rf package*


# create or replace our datasets directory

rm -rf datasets
mkdir -p datasets


node_modules/d-portal/dflat/dflat packages-join --dir "$dirname" --dedupe


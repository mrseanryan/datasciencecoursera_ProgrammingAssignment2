set -e

# go-r.sh <path to R script>
# cat $1 | r --no-save
Rscript $1  # can stop for reading input from stdin..

declare -A BLANK_DEPTH=(["0"]="" ["1"]="  " ["2"]="    ")
find notes -type d | while read dir; do
    depth=$(echo $dir |tr -cd '/' | wc -c)
    blank=${BLANK_DEPTH[$depth]}
    echo "$blank- $dir"
    find $dir -name '*.md' -type f -maxdepth 1 -mindepth 1| while read md_file; do
        echo "$blank  - [$(basename $md_file)]($md_file)"
    done 
done > README.md

echo Done!
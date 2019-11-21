find notes -name '*.md' -type f | while read md_file; do
    echo "- [$(basename $md_file)]($md_file)"
done > README.md

echo Done!
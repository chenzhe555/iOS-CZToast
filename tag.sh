path=":refs/tags/"$1
git add . && git commit -m 'replace tag' && git push origin && git tag -d $1 && git push origin $path && git tag $1 && git push --tags

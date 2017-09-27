if [ -z "$1" ]
then
	echo "A folder is needed" 1>&2
	exit 1
fi


FILES=$(find $1 -type f | grep -v .git)
for f in $FILES
do
	CREATED=$(stat -c '%W' $f)
	MODIFIED=$(stat -c '%Y' $f)
	CHANGED=$(stat -c '%Z' $f)
	echo $f
	if [ $CREATED -ne 0 ]
	then
		git add $f > /dev/null && \
		git commit -m "$f created at $CREATED" > /dev/null && \
		git filter-branch -f --env-filter "
		export GIT_COMMITTER_DATE='$CREATED +0100'" HEAD^.. > /dev/null
	elif [ $MODIFIED -ne 0 ]
	then
		git add $f > /dev/null && \
		git commit -m "$f modified at $MODIFIED" > /dev/null && \
		git filter-branch -f --env-filter "
		export GIT_COMMITTER_DATE='$MODIFIED +0100'" HEAD^.. > /dev/null
	elif [ $CHANGED -ne 0 ]
	then
		git add $f > /dev/null && \
		git commit -m "$f changed at $CHANGED" > /dev/null && \
		git filter-branch -f --env-filter "
		export GIT_COMMITTER_DATE='$CHANGED +0100'" HEAD^.. > /dev/null
	fi
done

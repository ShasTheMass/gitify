#!/bin/bash

if [ -z "$1" ]
then
	echo "A folder is needed" 1>&2
	exit 1
fi

#check that folder exists
# TODO: test this section
if [ ! -d "$1" ]
then
	echo "The local folder does not exist" 1>&2
	exit 1
fi

#check if github username exists
HTTP_RESP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://api.github.com/users/"$2")
if [ "$HTTP_RESP_CODE" == "404" ]
	then echo "The provided github user name does not exist" 1>&2
	exit 1
elif [ "$HTTP_RESP_CODE" == "200" ]
	then echo "The provided github user name exists" 1>&2
else
	echo "Something went wrong"
	exit 2
fi

#check if the local folder .git initiated
if [ -d "$1/.git" ]
then
	echo "The folder is already on Git" 1>&2
	exit 2
fi

cd "$1"
git init .
REPO=$(basename $1)
#TODO: Check that the folder is not on github yet
git remote add origin https://github.com/$2/${REPO}.git
curl -u "$2" https://api.github.com/user/repos -d "{\"name\":\"$REPO\"}"

FILES=$(find . -not -iwholename '*.git*' -type f)
for f in $FILES
do
	CREATED=$(stat -f %SB $f)
	MODIFIED=$(stat -f %Sm $f)
	CHANGED=$(stat -f %Sc $f)

	echo $f

	if [ "$CREATED" != "0" ]
	then
		VERB='created'
		DATE=$CREATED
	elif [ "$MODIFIED" != "0" ]
	then
		VERB='modified'
		DATE=$MODIFIED
	elif [ "$CHANGED" != "0" ]
	then
		VERB='changed'
		DATE=$CHANGED
	fi

	git add $f > /dev/null && \
		git commit -m "$f $VERB at $DATE" > /dev/null && \
		git filter-branch -f --env-filter "export GIT_COMMITTER_DATE='$DATE +0100' export GIT_AUTHOR_DATE='$DATE +0100'" HEAD^.. > /dev/null
done

#TODO: create a readme file and commit it

git push -u origin master

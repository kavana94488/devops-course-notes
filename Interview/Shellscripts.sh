if file size is more than 100KB , move to backup folder

#!/bin/bash
file=$1
backup="backup"

if [ ! -f $file ]; then
        exit 1
else
        exit 0
fi

actualsize=$(wc -c < "$file" )

if [ ! -d $backup ]; then
        mkdir $backup
fi

if [ $actualsize -ge 1024 ]
then
filesize=$(echo "scale=2; $actualsize / 1024" | bc)
if [ $filesize>100 ]
then
mv $1 $backup
fi
echo "size is $filesize MB"
else
        filesize= $(echo "scale=2; $actaulsize / 1048576" | bc)
        echo "size is $filesize GB"
fi

# !/bin/bash
all_dir=$(ls -d /home/test/share/Practice1/bash_homework/bash_homework/*)

for file in $all_dir;do 
if [ -f $file ];then
    echo $(basename $file) >> filename.txt
elif [ -d $file ];then
    echo $(basename $file) >> dirname.txt
fi
done
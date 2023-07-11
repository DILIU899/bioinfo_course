# 部分代码的个人理解
1. 赋值语句的`=`**前后都不能加空格**，否则没有办法正常运行与输出结果(习惯了在写python的时候空格前后都加空格真的很难受)
2. 使用`variable=$(command)`可以将command的运行结果赋值给variable，使用`$(command)`的一个好处是括号内可以完全按照命令行的嵌套写法写
3. `ls`命令运行结果差别。使用`*`通配符来匹配目录下的所有**文件**，这样**文件**才会有完整的目录路径，如果还需要能匹配**文件夹**，则需要额外添加参数`-d`。
```bash
ls /home/test/share/Practice1/bash_homework/bash_homework/ | head -2
# a1.txt
# a-docker
ls /home/test/share/Practice1/bash_homework/bash_homework/* | head -2
# /home/test/share/Practice1/bash_homework/bash_homework/a1.txt
# /home/test/share/Practice1/bash_homework/bash_homework/a.txt
ls -d /home/test/share/Practice1/bash_homework/bash_homework/* | head -2
# /home/test/share/Practice1/bash_homework/bash_homework/a1.txt
# /home/test/share/Practice1/bash_homework/bash_homework/a-docker
```
4. [ -f file ]和[ -d file ]需要完整的路径目录才能进行正确的判别是文件/文件夹，因此在*3*中不使用通配符`*`时是无法进行任何文件类型的判断的（当然也有解决方案是额外添加一个完整路径进去）
```bash
# 法1：不加通配符，手动添加完整路径
all_dir=$(ls /home/test/share/Practice1/bash_homework/bash_homework/)
for file in $all_dir
do 
file="/home/test/share/Practice1/bash_homework/bash_homework/$file"
if [ -f $file ];then
    echo "File name is: $file"
elif [ -d $file ];then
    echo "Dir name is: $file"
fi
done
# 法2：使用通配符匹配返回的完整路径，则可以直接判断
all_dir=$(ls -d /home/test/share/Practice1/bash_homework/bash_homework/*)
for file in $all_dir
do 
if [ -f $file ];then
    echo "File name is: $file"
elif [ -d $file ];then
    echo "Dir name is: $file"
fi
done
```

---
# 运行结果
* bash script
```bash
# !/bin/bash
all_dir=$(ls -d /home/test/share/Practice1/bash_homework/bash_homework/*)

for file in $all_dir;do 
if [ -f $file ];then
    echo $(basename $file) >> filename.txt
elif [ -d $file ];then
    echo $(basename $file) >> dirname.txt
fi
done
```
* filename.txt
> a1.txt
a.txt
b1.txt
bam_wig.sh
b.filter_random.pl
c1.txt
chrom.size
c.txt
d1.txt
dir.txt
e1.txt
f1.txt
human_geneExp.txt
if.sh
image
insitiue.txt
mouse_geneExp.txt
name.txt
number.sh
out.bw
random.sh
read.sh
test3.sh
test4.sh
test.sh
test.txt
> wigToBigWig
* dirname.txt
> a-docker
app
backup
bin
biosoft
c1-RBPanno
datatable
db
download
e-annotation
exRNA
genome
git
highcharts
home
hub29
ibme
l-lwl
map2
mljs
module
mogproject
node_modules
perl5
postar2
postar_app
postar.docker
RBP_map
rout
script
script_backup
software
tcga
test
tmp
tmp_script
var
> x-rbp

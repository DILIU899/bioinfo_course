1. 统计字数和行数
* 统计行数
```bash
wc -l test_command.gtf
# 8 test_command.gtf 
```
* 统计字数
```bash
wc -c test_command.gtf
# 636 test_command.gtf 
```

2. 筛选特定行
```bash
grep 'chr_' test_command.gtf | grep -w 'YDL248W'
# chr_IV  ensembl gene    1802    2953    .       +       .       gene_id "YDL248W"; gene_version "1";
# chr_IV  ensembl transcript      802     2953    .       +       .       gene_id "YDL248W"; gene_version "1";
# chr_IV  ensembl start_codon     1802    1804    .       +       0       gene_id "YDL248W"; gene_version "1";
```

3. 更改并取出特定列
```bash
sed 's/chr_/chromosome_/g' test_command.gtf | cut -f 1,3,4,5
# chromosome_IV   gene    1802    2953
# chromosome_IV   transcript      802     2953
# chromosome_IV   exon    1802    2953
# chromosome_IV   CDS     1802    950
# chromosome_IV   start_codon     1802    1804
# chromosome_IV   stop_codon      2951    2953
# chromosome_IV   gene    762     3836
# chromosome_IV   transcript      3762    836
```

4. 互换2,3列并按照4,5列数字大小排序，将结果输出到新文件中
```bash
awk '{temp=$2;$2=$3;$3=temp;print}' test_command.gtf | sort -k 4 -n -k 5 -n > result.gif
cat result.gif
# chromosome_IV gene ensembl 762 3836 . + . gene_id "YDL247W-A"; gene_version "1";
# chr_IV transcript ensembl 802 2953 . + . gene_id "YDL248W"; gene_version "1";
# chromosome_IV CDS ensembl 1802 950 . + 0 gene_id "YDL248W"; gene_version "1";
# chr_IV start_codon ensembl 1802 1804 . + 0 gene_id "YDL248W"; gene_version "1";
# chr_IV gene ensembl 1802 2953 . + . gene_id "YDL248W"; gene_version "1";
# chromosome_IV exon ensembl 1802 2953 . + . gene_id "YDL248W"; gene_version "1";
# chromosome_IV stop_codon ensembl 2951 2953 . + 0 gene_id "YDL248W"; gene_version "1";
# chr_IV transcript ensembl 3762 836 . + . gene_id "YDL247W-A"; gene_version "1";
```

5. 改变文件权限
```bash
ll
# drwxrwxrwx 1 test test 4096 Jul 10 10:21 ./
# drwxr-xr-x 1 test test 4096 Jul 10 09:31 ../
# -rw-r--r-- 1 test test  636 Jul 10 10:23 result.gif
# -rwxrwxrwx 1 root root  636 Jul 10 09:43 test_command.gtf*
```
该image不知道root账户密码，也没有装sudo，因此需要用docker改一下该文件的所属用户
```PowerShell
docker exec -u root ld_bioinfo chown test:test /home/test/share/test_command.gtf
```
修改后
```bash
ll
# drwxrwxrwx 1 test test 4096 Jul 10 10:21 ./
# drwxr-xr-x 1 test test 4096 Jul 10 09:31 ../
# -rw-r--r-- 1 test test  636 Jul 10 10:23 result.gif
# -rwxrwxrwx 1 test test  636 Jul 10 09:43 test_command.gtf*
```
之后可以正常改动文件权限
```bash
chmod o-wx test_command.gtf
ll
# drwxrwxrwx 1 test test 4096 Jul 10 10:21 ./
# drwxr-xr-x 1 test test 4096 Jul 10 09:31 ../
# -rw-r--r-- 1 test test  636 Jul 10 10:23 result.gif
# -rwxrwxr-- 1 test test  636 Jul 10 09:43 test_command.gtf*
```


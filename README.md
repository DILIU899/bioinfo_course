# 课程笔记
## Lec1
1. **model**和**algorithm**的区别
    * **model**是将具体问题转化为数学语言，后续可以使用解析/数值方法解决
    * **algorithm**是解决问题的具体计算机语言实现，同一个问题可以由不同的算法进行实现

## Lec2
* bash对空格要求很严格
* 管道符`|`可以将连接的命令实现将前一个命令的结果作为后一个命令的输入
* 元组定义方法：`("a" "b" "c")`，小括号封装，空格分开各个元素
* 判断方式`[ condition ]`，前后都要有空格，`[[ condition ]]`提示在判断过程中使用正则表达式
* `$((variable cal))`，对variable进行计算时要封装在双括号中
* `${variable}`对variable做一些操作并返回，用{}封装
* `$(command)`输出command的运行结果
* `sed 's/str1/str2/g'` g表示所有的都替换，str支持正则表达式匹配
* `""`和`''`的区别在于对于符号的转义方式不同，例如`"$q"`正常识别变量，`'$q'`无法正确识别变量会输出$q

## Lec4
* 基因Microarray(基因组和转录组现在用的不太多;甲基化之类的目前还有在用的)
    * 好处：
        * 分析比较流程化，可以直接一个函数分析到底
        * 实验比较简单
    * 坏处：
        * 无法发现新的gene，芯片上的gene是固定的
        * 基于荧光方法，荧光浓度的线性范围比较窄，对很高浓度和低浓度都测不太准
* 基因测序技术(平行测序)
    * 一代测序做质粒测序等简单的测序也可以，单样本下速度也很快并且准确度也很高
    * 二代测序要测多少个cycle代表了测序能测多长
    * 原版的方法需要pcr扩增，会导致额外的bias，限制是太短了，在基因组上的map工作是比较困难的
    * **Nanopore**省去了pcr扩增，使用了**电压记录**（不同的碱基经过纳米孔的时候产生的电压是不同的），此外理论上可以直接测序RNA，而不需要将RNA反转录成cDNA再进行测序，该想法也可以扩展到**蛋白质**。
        * 可以更快更长
        * 电信号处理不需要像光学一样条件非常苛刻，可以把测序机器做的很小巧方便。
        * 直接测序可以进一步探测到比如**碱基修饰**等信息，不会被反转录过程抹去
        * 可以进一步探测分子结构，比如环状的DNA，有茎环结构的RNA等
    * single molecule办法不需要pcr扩增，也可以更快更长
* 蛋白组学技术
    * microarray，使用抗体，效果不是特别好
    * 质谱，也是打成小段，在library在进行比对，目前精度还做不到单细胞，并且也没有办法区分序列上比较相近的蛋白。此外对低丰度的蛋白很难进行检测。
    * 二维电泳。一般结合质谱一起使用，先在实验组和对照组做2D gel，比较差别，再挖出来送去做质谱
* 代谢组
    * NMR进行检测
* 分析流程
    * 预处理
        * transformation，adjust dynamic range，基因表达谱跨度特别大，表达基数不同的时候对variance的敏感程度不一样
        * normalization，需要考虑处理背后的假设
    * 差异表达分析(变化是不是显著)
        * p value一般取-lg, 一般关注p vale大且表达的deviation比较大的gene
        * 聚类分析最简单的是根据表达量的高低做聚类，也可以根据表达的pattern等信息来做聚类
    * function annotation 富集分析(GSEA)
        * 将gene list作为一个整体进行研究
        * 把所有的gene在整个测序中差异表达做排序，得到rank，从小到大遍历，遇到gene list中的gene就加分，遇到非gene list的gene就减分，因为gene list中的gene是比较少的，所以加分的权重比较大，另外主要关心的是两端的gene，两端的gene的得分权重更大，可以得到一个总分数的曲线(也可以看到peak的位置，看peak是否更加倾向于某一个phenotype)以及总分数，这样无论定义的是什么gene list都有一个打分方式，可以用打分做后续的分析，也可以知道是否有富集之类的问题
            * 容忍一定程度的噪音，两端的gene的变化很大，更不可能是假阳性/阴性，也因此权重比较大，而中间的gene可能有一些变化但是变化不大可能是假的或者是噪音导致的变化，因此权重也更小
            * gene list的定义可能有点错的，但是错的这些大概率的差异表达rank是random的，或者比较小的权重比较低，对整体的影响不大
        * 选一个gene set做，gene set比如GO数据
    * 控制FDR的方法
        * BH方法（矫正p value）
        * permutation方法，得到对于随机误差的估计，利用随机shuffle，得到假的control和实验组，从而得到如果是随机情况下的随机误差的分布。再拿真实数值来看，用随机误差的分布算出是随机误差的概率，如果概率很小就可以接受。shuffle目的就是模拟真实的随机误差

## Lec5
* 基因组(一般序列和注释都是从一个数据库来)
    * 组装(得到序列)
        * N50越高，基因组组装效果越好
        * reads越长组装效果越好
        * 先根据overlap，map出contig，再搭出scaffold
    * 注释
        * 软件如SNAP，从头注释，不需要先验知识但是结果不一定是对的
        * 或者比对到基因组上去
        * 不同数据库的注释方法是不一样的，因此不同的数据库结果是不同的
        * 数据库是NCBI(ref-seq注释办法，只包括有实验证据的)，Ensembl(包括一部分的从头注释的结果以及有实验数据的)，Genome Browser(也是有实验和从头注释的部分，但是也重新搞过了)
        * **GRCh38是最常用的人类基因组的ref seq**
    * FASTA格式，最常用的`序列`存储格式
        * 开头为`>`后面是蛋白信息，一行，下一行是序列的具体信息（两行为一个单元）
        * soft mask/hard mask,把重复序列屏蔽掉，soft重复的小写不重复的大写，hard把重复的变成N
        * `Biostrings`，R语言处理fasta，可以实现提取子序列，翻译，生成complement序列等方式
    * GFF/GTF格式，常用的`基因注释`格式
        * 谈基因组位置的时候要注意是0计数还是1计数，这两个格式都是1开始计数的
        * attribute是主要的注释的信息，不同的数据库上面下载的很有可能是不一样的
        * `GenomicFeatures`，R语言处理GTF文件，读取时需要输入taxonomyId，物种序列号，自带一些函数如promoter CDS exon等直接提取一些信息
        * 一个基因会对应多种转录本（TXNAME）
        * IGV软件，进行基因组可视化

* 转录组
    * 测序的办法
        * Ribo-minus，去掉rRNA不加入后续分析
        * poly A尾的拿出来检测
        * 单端和双端测序，双端测序对发现新的转录本的结构更有优势
        * 链特异性和非链特异性，前者合成另一条链的时候用U，然后把带U的降解，只用一个方向的进行测序，后者用T，因此测出来两个方向都有可能，分析表达量的差异时没有大区别，研究可变剪接要用链特异性的
        * 生物学重复指多一些实验动物/细胞，分别测，多样本
        * batch effect，样本很多时需要分批建库和测序，需要去除batch effect，实验设计时采取RCBD
        * 测序深度是测序的碱基数量/基因组大小
        * map到基因组上，计算每个gene的count，map到基因组上时需要考虑是否是链特异性的测序
    * sam/bam文件
        * sam可读，比较大，bam比较小是个二进制文件
        * 需要sort排序生成index后才能进一步进行操作
        * htseq-count进行map后的计数，需要注意是不是链特异性的测序
    * raw count的normalize
        * RPM/CPM 某个gene的reads/建库的所有reads
        * RPKM 比RPM多除以一个gene length
        * TPM
        * rlog
    * RSeQC
        * 质量控制

* 差异表达分析，R包DESeq2
    * result(DESeq(data)) 直接出结果
    * `InteractiveComplexHeatmap`交互式heatmap

* 富集分析
    * gene ontology(GO)，注释基因的功能
    * evidence code GO和gene的关系是根据什么建立起来的
    * GO Ribbon 显示基因的注释水平的区别
    * 注释包org.Hs.eg.db，根据需求可以选择不同的注释包
    * 思路：从N个样本中抽n个基因，其中N中有m个某GO term，n中有i个某GO term，则富集程度服从超几何分布
    * `GOplot`作图
    * `gsea`方法不需要卡阈值，根据排序估计是个非参数方法做的统计分析，必须要先DESeq2处理一下normalize之后再做，可以用R语言或者提供的软件来做

* TF发现
    * 数据：TNBC的三阴性乳腺癌，有更强的侵袭和转移的能力，异质性比较强，通过accession code下载数据，一般从raw counts进行分析，如果做很下游的可以用norm
    * 单细胞聚类，三个肿瘤类型的区别，关注某些和侵袭转移的gene，找到某个cluster的比较牛，再得到这个cluster的marker gene，后续可以用这个marker gene作为
    * 通过可变剪切(AS)视角进行cluster,可以发现哪些正常细胞更接近肿瘤细胞，通过pseudotime分析可以看到那些基因的分化程度高低
    * `ARANCE`分析调控网络，输入为gene list(TF)和seurat类型的experiment的数据，MI互信息的值，调控网络可以用来计算上游基因的活性
    * `Marina`(R package)在不同的cluster中根据TF的调控活性而非简单的TF表达量作为“差异基因”的比较标准，因此需要先用`ARANCE`得到调控网络作为输入

## Lec6
### 实验要求
实验报告：实验名称，实验目的，实验设计（实验步骤），实验结果(如：on target off target score要截频记录，还有潜在offtarget的位置要截频记录)

地点：郑裕彤医学楼 E107

Chrisper 引物设计(软件：Benchling)
* spacer（互补配对）和tracer（二级结构）放在一起是guide RNA，如果只有一条guide RNA就是sgRNA（single guide RNA）
* **考虑因素**：untarget score使得更好地敲除基因，考虑到如果剪切掉3为单位的核酸就没有办法导致移码突变；考虑不能offtarget 脱靶
* **原则**：
    * 不能在UTR上做，效率不高，因此是从CDS设计，从N端开始几百个bp内都是可以的（尽量在前3个exon）
    * 一般按照on target score排序，选前几个，最高的on target基础上找off target分数尽量高的，同时可以看到哪些gene是off target的目标，到时候可能也要检测一下对应的gene有没有被一起敲掉
    * sgRNA一般不选有很多重复序列的，比如AGAGAGAG
* 本次实验：
    * BbsI粘性末端连接法，sgRNA多设计一下粘性末端，直接合成即可
    * 验证是否敲除需要对敲除位点附近700做一个测序，需要再设计一个引物

---
# 学习计划
- [ ] 学习组学分析的模型原理和实现
- [ ] 增强linux，python与R的使用
- [ ] 学习组学分析的基本研究范式

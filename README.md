# MACRO-for-R-C-table-in-SAS
  '不定分类下行×列联表的SAS宏程序'
  '目的'：用于定性变量中，行×列的分类计数（以及相应的百分比）。

# 必填参数目录content
-[indata](#indata)  
-[outdata](#outdata)  
-[var1](#var1)  
-[var2](#var2)  

# 可选参数目录content
-[var1txt](#var1txt)  
-[var2txt](#var2txt)  
-[freqyn](#freqyn)  
-[freqtype](#freqtype)  
-[perfmt](#perfmt)  
-[misstxt](#misstxt)  
-[rowtxt_suffix](#rowtxt_suffix)  
-[delimiter](#delimiter)  

# 宏程序使用语法
'''sas  
%rc_table( in_data_test , out_data_test , var1_test , var2_test );  
%rc_table( indata = in_data_test , outdata = out_data_test , var1 = var1_test , var2 =  var2_test );  
'''  
  宏程序内置了参数注释窗口，调用如下：  
  '''sas  
  %rc_table;  
  %rc_table();  
  %rc_table(help);  
  '''  

# 参数使用语法
## indata
  输入用于分析的数据集名称  
  分析数据集要求：至少有两列'文本分析变量'，目前程序不适用于'文本分析变量+频率权重'的分析数据集。  
  
## outdata
  输出用于呈现分析结果的数据集名称。    
  输出数据集结构如下：  
  
<div align="center">

| cate_标签   | var2_分类1 | var2_分类2 | var2_分类j  |   合计   |
| ----------  | -----------| ----------  | -----------|-----------|
| var1_分类1  | n11        | n12         | n1j        | N1_tol    |
| var1_分类2  | n21        | n22         | n2j        | N2_tol    |
| var1_分类i  | ni1        | ni2         | nij        | Ni_tol    |
| 合计        | n1_tol     | n2_tol      |  nj_tol    | ntol      |

</div>

备注：nij，表示第i行，第j列的分类数。  

## var1
  横标目'文本'分析变量名称。    
  
## var2
  纵标目'文本'分析变量名称。  

## var1txt
  横标目分析变量的分类文本，主要用于分析数据集中'没有但需呈现的分类项'。  
  default  
  '''SAS  
  var1txt = '%'str();  
  '''  
  默认：不调用，即按照分析数据集实际存在的分类进行呈现（排序：按照文本升序排序）。    

  调用：  
  '''sas
  var1txt = '%'str(文本3 文本1 文本2);
  var1txt = '%'str(文本3@文本1@文本2) , delimiter = "@" ;  
  '''  
  结果：  
  
<div align="center">

| cate_横标目标签      |   var2...   |
|  ---------           | -------     |
| 文本3                | nij         |
| 文本1                | ...         |
| 文本2                | ...         |
    
</div>
  
  排序：按照调用中所填文本顺序呈现，可与参数[delimiter](#delimiter)联合使用。  
  
## var2txt
  纵标目分析变量的分类文本，主要用于分析数据集中'没有但需呈现的分类项'。  
  语法同[var1txt](##var1txt)。  

## delimiter
  [var1txt](#var1txt)/[var2txt](#var2txt)的分类分隔符。  
  default  
  '''  
  delimiter = '%'str();  
  '''
  备注：仅作用于var1xtx/var2txtx调用时，中文逗号建议不作为分隔符，非ASCⅡ字符的处理目前存在一些特殊问题。
  

## freqyn
  是否计算频率（即百分比）。 

<div align="center">

| 可选项（数值型）  |   含义      |
|  ---------         | -------     |
| 0                 | 不计算频率  |
| 1                 |  计算频率   |

</div>  
    
  default  
  '''sas  
  freq = 0 ;  
  '''  

## freqtype
  频率计算方法/类型：支持一下三种计算类型。  
<div align="center">
    
| 可选项（文本型）  |   含义      |
| -----             | --------     |
| total             | 按照列联表'总合计例数'计算每个分类的百分比，即 nij / ntol  |
| col               | 按照列联表'列合计例数'计算每一个分类的百分比，即 nij / Ni_tol   |
| row               | 按照列联表'行合计例数'计算每一个分类的百分比，即 nij / nj_tol  |

</div>
  
  default：仅freqyn=1时，生效。  
  '''sas  
  freqtype = %str(total) ;  
  '''  
  备注：不区分大小写。  

## perfmt  
  频率的呈现格式。  
  default  
  '''sas  
  perfmt = percent9.1 ;   
  '''  
  备注：默认为pecent9.1，即X.X%。可调用format自定义格式。  
  

## misstxt
  [var1](#var1)/[var2](#var2)分类变量的'缺失填补文本'。  
  default  
  '''sas  
  misstxt = %str(缺失) ;  
  '''  

## rowtxt_suffix
    横标目分类下，后缀标签文本。  
    default：为空。
  
# END
    










# diabetes_PGS
Estimating Polygenic Score using SBayesRC paradigm

1. Download the multi-ancestry GWAS meta-analysis summary statistics of [Mahajan et al (2022)](https://pubmed.ncbi.nlm.nih.gov/35551307/) paper,
   available in Diagram Consortium [download page](https://diagram-consortium.org/downloads.html).
   Size of the zip file: 422 MG
   
2. Here we use [SBayesRC package](https://github.com/zhilizheng/SBayesRC) to estimate PGS. 
- To work with the package we need to:

  a. Download the package from github,
```bash
 wget  https://github.com/zhilizheng/SBayesRC/releases/download/v0.1.4/SBayesRC_0.1.4.tar.gz
```

  b. Install the SBayesRC package,
```bash
realpath SBayesRC_0.1.4.tar.gz
```

- To download the large LD file from Google drive using the command line we need to use a tool.

```bash

# 1st way/tool: Install gdown
pip install gdown

# The usage of gdown:
gdown [-h] [-V] [-O OUTPUT] [-q] [--fuzzy] [--id] [--proxy PROXY] [--speed SPEED] [--no-cookies] [--no-check-certificate]
      [--continue] [--folder] [--remaining-ok]
      url_or_id

# Copy the id of the ukb_EUR.zip file from the download link of each file and paste it after --id

# 1st LD file: ukb_EUR.zip -> 57.9 GB
~/.local/bin/gdown --id '10BXYrJ2NiaYbvfghajdgXa07bz2q6UxE'
	   

# 2nd way/tool: Download gdrive library
wget https://github.com/prasmussen/gdrive/releases/download/2.1.1/gdrive_2.1.1_linux_386.tar.gz

# Unzip the library
tar -xvf gdrive_2.1.1_linux_386.tar

# Creading a directory 
mkdir ~/.local/bin/gdrive

# Moving the file there
mv gdrive ~/.local/bin/gdrive/

# Turn into executable
chmod a+x  ~/.local/bin/gdrive

# Download the annotation file using gdrive 
# Also need to ckeck the returned url 
# and Insert the token shown in the link
~/.local/bin/gdrive/gdrive download '1n0OtHurbbi-N-sXMUkQl8I0JLBUu8Na6' | pv -br

```

  d. Download the package dependencies [annotation file](https://drive.google.com/drive/folders/1cq364c50vMw1inJBTkeW7ynwyf2W6WIP) 300 MG from Google drive,
  
  e. Download the package dependencies [LD file](https://drive.google.com/drive/folders/1ZTYv_qlbb1EO70VVSSQFaEP9zH7c9KHt) from Google drive and extract the LD file:

```bash
gunzip ukb_EUR.zip
```

3. Preparation of Meta-GWAS results:

- The GWAS summary data is the only essential input for SBayesRC in text format. We need to modify the columns header/order to turn them in the desired COJO format.

```Rscript
library(tidyverse)
library(data.table)

#Coordinates indicate GRCh37
#desired meta-GWAS column names

namesMeta  <- c(#New name  #Original name
		"CHR",     #"chromosome(b37)",
		"POS",     #"position(b37)",
		"SNPid",   #"chrposID",
		"SNP",     #"rsID",
		"A1",      #"effect_allele",
		"A2",      #"other_allele",
		"p",       #"MR-MEGA_p-value_association",
		"MR-MEGA_pHET_ancestry",
		"MR-MEGA_pHET_residual",
		"beta",    #"Fixed-effects_beta",
		"se",      #"Fixed-effects_SE",
		"Pvalue",  #"Fixed-effects_p-value",
		"N")       #"Effective_sample_size"


meta <- fread("~/projects/diabetes_PGS/data/DIAMANTE-TA.sumstat.txt",
	      header = TRUE,
	      col.names = namesMeta,
	      stringsAsFactors = F,
	      sep = ' ',
	      fill = T,
	      nrows = 1000)


# Having effect allele freq in meta-GWAS is essential for sbayesrc
meta %>%
	mutate(across(c("A1", "A2"), toupper),
	       freq = runif(0,1, n = nrow(meta))) %>%
	select(SNP, A1, A2, freq, b, se, p, N) %>%
	write.table("~/projects/diabetes_PGS/data/myMeta.txt",
		    row.names = F,
		    quote = F,
		    sep = ' ')
```

4. Make the meta-GWAS tidy using built-in function in the package

```R
library(SBayesRC)

#SBayesRC::tidy(mafile, LD_PATH, output_FILE)
#LD_PATH: the path to the downloaded and decompressed LD reference.
#output_FILE: the output path.

tidy("~/projects/diabetes_PGS/data/myMeta.txt",
     "~/projects/diabetes_PGS/data/LD/ukb_EUR/",
     "~/projects/diabetes_PGS/output/test_run")
```

- That will save a test_run.log file. Package will use this file as the input for meta-GWAS in COJO format.

5. Run the SBayesRC core function:

```R
# Run SBayesRC with annotation
#SBayesRC::sbayesrc(mafile, LD_PATH, output_FILE, fileAnnot=ANNOT_FILE)
#fileAnnot is the path to annotation file. Other parameters are same above.

sbayesrc("~/projects/diabetes_PGS/data/myMeta.txt",
	 "~/projects/diabetes_PGS/data/LD/ukb_EUR/",
	 "~/projects/diabetes_PGS/output/test_run",
	 fileAnnot = "~/projects/diabetes_PGS/data/annot_baseline2.2.txt")
```

- Now, we need to think how to compensate the lack of the effect allele frequency in multi-ancestry meta-GWAS.

https://www.sciencedirect.com/science/article/pii/S2666979X2200204X

Dariush | 09-Jan-23
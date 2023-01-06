#!/usr/bin/Rscript

#-------------------

# Install R and devtools
# Install by devtools in R
#devtools::install_github("zhilizheng/SBayesRC")

# If you find difficulties to install by devtools
# Alternative: install in R by downloading the tar.gz from releases

#install.packages(c("Rcpp", "data.table", "BH",  "RcppArmadillo", "RcppEigen"))
#install.packages("~/projects/diabetes_PGS/SBayesRC_0.1.4.tar.gz", repos=NULL, type="source")

#-------------------
library(tidyverse)
library(data.table)
#-------------------

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
		"b",    #"Fixed-effects_beta",
		"se",      #"Fixed-effects_SE",
		"Pvalue",  #"Fixed-effects_p-value",
		"N")       #"Effective_sample_size"


meta <- fread("~/projects/diabetes_PGS/data/DIAMANTE-TA.sumstat.txt",
	      header = TRUE,
	      col.names = namesMeta,
	      stringsAsFactors = F,
	      #row.names = F,
	      sep = ' ',
	      #skip = 56,
	      #comment.char='.',
	      #fileEncoding = 'UTF-8',
	      #encoding = "unknown",
	      fill = T,
	      nrows = 1000)

head(meta)
#-------------------

# Having effect allele freq in meta-GWAS is essential for sbayesrc
myMeta <-
	meta %>%
	mutate(across(c("A1", "A2"), toupper)) %>%
	#mutate(freq = runif(0,1, n = nrow(meta))) %>%
	select(SNP, A1, A2, b, se, p, N) #freq,
	

cat("\n\n myMeta looks like this: \n\n")

head(myMeta)

write.table(myMeta,
	    "~/projects/diabetes_PGS/data/myMeta.txt",
	    row.names = F,
	    quote = F,
	    sep = ' ')

#-------------------

library(SBayesRC)
#-------------------

#SBayesRC::tidy(mafile, LD_PATH, output_FILE)
#LD_PATH: the path to the downloaded and decompressed LD reference.
#output_FILE: the output path.

tidy("~/projects/diabetes_PGS/data/myMeta.txt",
     "~/projects/diabetes_PGS/data/LD/ukb_EUR/",
     "~/projects/diabetes_PGS/output/test_run")

#-------------------

# Run SBayesRC with annotation
#SBayesRC::sbayesrc(mafile, LD_PATH, output_FILE, fileAnnot=ANNOT_FILE)
#fileAnnot is the path to annotation file. Other parameters are same above.

sbayesrc("~/projects/diabetes_PGS/data/myMeta.txt",
	 "~/projects/diabetes_PGS/data/LD/ukb_EUR/",
	 "~/projects/diabetes_PGS/output/test_run",
	 fileAnnot = "~/projects/diabetes_PGS/data/annot_baseline2.2.txt")

#-------------------

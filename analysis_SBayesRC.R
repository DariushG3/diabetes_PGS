#!/usr/bin/Rscript

# Install R and devtools
# Install by devtools in R
#devtools::install_github("zhilizheng/SBayesRC")

# If you find difficulties to install by devtools
# Alternative: install in R by downloading the tar.gz from releases

#install.packages(c("Rcpp", "data.table", "BH",  "RcppArmadillo", "RcppEigen"))
#install.packages("~/projects/diabetes_PGS/SBayesRC_0.1.4.tar.gz", repos=NULL, type="source")


#library(SBayesRC)
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
		"P",       #"MR-MEGA_p-value_association",
		"MR-MEGA_pHET_ancestry",
		"MR-MEGA_pHET_residual",
		"BETA",    #"Fixed-effects_beta",
		"SE",      #"Fixed-effects_SE",
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

myMeta <-
	meta %>%
	mutate(across(c("A1", "A2"), toupper)) %>%
	select(SNP, A1, A2, BETA, SE, P, N)
	

cat("\n\n myMeta looks like this: \n\n")

head(myMeta)
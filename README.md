# diabetes_PGS
Estimating Polygenic Score using SBayesRC paradigm

1. Download the multi-ancestry GWAS meta-analysis summary statistics of [Mahajan et al (2022)](https://pubmed.ncbi.nlm.nih.gov/35551307/) paper,
   available in Diagram Consortium [download page](https://diagram-consortium.org/downloads.html).
   Size of the zip file: 422 MG
   
2. Here we use [SBayesRC package](https://github.com/zhilizheng/SBayesRC) to estimate PGS. 
- To work with the package we need to:

  a. Download the package from github,
```bash
git clone https://github.com/zhilizheng/SBayesRC
```
  b. Unzip/Unpack the downloaded R package file,
```bash
tar -zxvf fileNameHere.tgz
```
  c. Install the unzipped SBayesRC package,
```bash

```
  d. Download the package dependencies [annotation file](https://drive.google.com/drive/folders/1cq364c50vMw1inJBTkeW7ynwyf2W6WIP) 300 MG from Google drive,
  
  e. Download the package dependencies [LD file](https://drive.google.com/drive/folders/1ZTYv_qlbb1EO70VVSSQFaEP9zH7c9KHt) from Google drive:

```bash

# Install gdown to be able to download the LD files directly from google drive
pip install gdown

# The usage of gdown:
gdown [-h] [-V] [-O OUTPUT] [-q] [--fuzzy] [--id] [--proxy PROXY] [--speed SPEED] [--no-cookies] [--no-check-certificate]
      [--continue] [--folder] [--remaining-ok]
      url_or_id

# Copy the id of the ukb_EUR.zip file from the download link of each file and paste it after --id

# 1st LD file: ukb_EUR.zip -> 57.9 GB
~/.local/bin/gdown --id '10BXYrJ2NiaYbvfghajdgXa07bz2q6UxE'
	   
# 2nd LD file: ukb_EAS.zip -> 13.5 GB
~/.local/bin/gdown --id '1CyF4hk0h1wnU6FKUg4ZVnkUHLOnQi-_q'

```



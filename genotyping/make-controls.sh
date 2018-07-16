# Make some indexes for bwa and primary graph controls

#!/bin/bash

#wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
#gzip -d hg38.fa.gz
HG38=../haps/hg38.fa 

ref=../haps/hg38.fa
vars=../haps/HGSVC.haps.vcf.gz

chroms=$(grep -v _alt $ref.fai | cut -f 1)

#Make a primary control graph and its indexes
toil-vg construct ./jsc ./controls --fasta ${HG38} --fasta_regions --realTimeLogging  --xg_index --gcsa_index --out_name primary --restart --workDir .

#Make a bwa index
bwa index ${HG38} -p ./controls/hg38.fa


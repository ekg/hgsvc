#!/bin/bash

base=$1
threads=20
ref=./hg38.fa

#chroms=$(cat $ref.fai | cut -f 1)
chroms=$(for i in $(seq 1 22; echo X; echo Y); do echo chr${i}; done)

echo "constructing HG00514"
echo $chroms | tr ' ' '\n' | parallel -j $threads "vg construct -r $ref -v ./HGSVC.HG00514.vcf.gz -R {} -C -m 32 -a -f > $base-add0.{}.vg"

echo "adding HG005733"
echo $chroms | tr ' ' '\n' | parallel -j $threads "bcftools view ./HGSVC.HG005733.vcf.gz -r {} | bgziptabix ./HGSVC.HG005733_{}.vcf.gz; vg add $base-add0.{}.vg -v ./HGSVC.HG005733_{}.vcf.gz > $base-add1.{}.vg ; rm -f ./HGSVC.HG005733_{}.vcf.gz;"

echo "adding NA19240"
echo $chroms | tr ' ' '\n' | parallel -j $threads "bcftools view ./HGSVC.NA19240.vcf.gz -r {} | bgziptabix  ./HGSVC.NA19240_{}.vcf.gz; vg add $base-add1.{}.vg -v ./HGSVC.NA19240_{}.vcf.gz > $base.{}.vg ; rm -f ./HGSVC.NA19240_{}.vcf.gz;"

echo "node id unification"
vg ids -j -m $base.mapping $(for i in $chroms; do echo $base.$i.vg; done)
cp $base.mapping $.base.mapping.backup

echo "xg indexing"
vg index -x $base.xg -g $base.gcsa -k 16 -b work -p -t $threads $(for i in $chroms; do echo $base.$i.vg; done)

echo "pruning"
echo $chroms | tr ' ' '\n' | parallel -j $threads "vg prune -r {} $base.{}.vg > $base.{}.prune.vg"

echo "gcsa indexing"
mkdir work
vg index  -g $base.gcsa -k 16 -b work -p -t $threads $(for i in $chroms; do echo $base.$i.prune.vg; done)
rm -rf work *.prune.vg


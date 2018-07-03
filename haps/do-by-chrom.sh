
#!/bin/bash

base=$1

echo "constructing"
(seq 1 22; echo X; echo Y) | parallel -j 24 'vg construct -r reference.fa -v ~/graphs/hgsvc/haps/HGSVC.haps.vcf.gz -R $i -C -m 128 -a -f > '${base}'chr{}.vg'

echo "node id unification"
vg ids -j -m ${base}mapping $(for i in $(seq 1 22; echo X; echo Y); do echo $base.chr${i}.vg; done)
cp ${base}mapping ${base}mapping.backup

echo "indexing haplotypes"
(echo X; seq 1 22; echo Y) | parallel -j 12 "vg index -G ${base}chr{}.gbwt -v ~/graphs/hgsvc/haps/HGSVC.haps.vcf.gz -F ${base}chr{}.threads ${base}chr{}.vg"

echo "merging GBWT"
vg gbwt -m -f -o ${base}all.gbwt $(for i in $(seq 1 22; echo X; echo Y); do echo ${base}chr${i}.gbwt; done)

echo "building xg index"
vg index -x ${base}all.xg $(for i in $(seq 1 22; echo X; echo Y); do echo ${base}chr${i}.vg; done)

time vg index -p -x HGSVC.haps.xg -G HGSVC.haps.gbwt -v ~/graphs/hgsvc/haps/HGSVC.haps.vcf.gz HGSVC.haps.vg

echo "extracting threads as paths"
time ( vg mod $(for f in $(vg paths -L -x HGSVC.haps.xg ); do echo -n ' -r '$f; done) HGSVC.haps.vg; vg paths -x HGSVC.haps.xg -g HGSVC.haps.gbwt -T -V ) | vg view -v - >HGSVC.haps+threads.vg

echo "re-indexing haps+threads"
time vg index -x HGSVC.haps+threads.xg HGSVC.haps+threads.vg

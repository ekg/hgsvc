#!/bin/bash

echo "constructing"
time vg construct -r ~/graphs/human/hg38.fa -p -a -v ~/graphs/hgsvc/haps/HGSVC.haps.vcf.gz -f -m 128 >HGSVC.haps.vg

echo "indexing"
time vg index -p -x HGSVC.haps.xg -G HGSVC.haps.gbwt -v ~/graphs/hgsvc/haps/HGSVC.haps.vcf.gz HGSVC.haps.vg

echo "extracting threads as paths"
time ( vg mod $(for f in $(vg paths -L -x HGSVC.haps.xg ); do echo -n ' -r '$f; done) HGSVC.haps.vg; vg paths -x HGSVC.haps.xg -g HGSVC.haps.gbwt -T -V ) | vg view -v - >HGSVC.haps+threads.vg

echo "re-indexing haps+threads"
time vg index -x HGSVC.haps+threads.xg HGSVC.haps+threads.vg

# Simulate reads from a sample in the hgsvc graph, map them back, then 
# run vg call to make a vcf. requires that graphs have been made by running
# ./make-vcf.sh and ./do-by-chrom.sh hgsvc_v1 in ../haps/

#!/bin/bash

#best sample to use for now, as it clobbers others in the vcf construction
SAMPLE=HG005733

#wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
#gzip -d hg38.fa.gz
HG38=../haps/hg38.fa 
# Only needs to be done once
rtg format ${HG38} -o ./hg38.sdf

CHROM=chr21

# Make a graph for each haplotype thread of SAMPLE to simulate from
rm -rf js haplo.log; toil-vg construct ./js ./simtest-${SAMPLE} --realTimeLogging --vcf ../haps/HGSVC.haps.vcf.gz --fasta ${HG38} --haplo_sample ${SAMPLE} --xg_index --regions ${CHROM} --out_name hgsvc_baseline --logFile haplo.log

# Simulate some reads for this sample using thread graphs made above
rm -rf js sim.log; toil-vg sim ./js ./simtest-${SAMPLE}/hgsvc_baseline_${SAMPLE}_haplo_thread_0.xg ./simtest-${SAMPLE}/hgsvc_baseline_${SAMPLE}_haplo_thread_1.xg 5000000 ./simtest-${SAMPLE} --realTimeLogging --fastq ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/131219_D00360_005_BH814YADXX/Project_RM8398/Sample_U5a/U5a_AGTCAA_L002_R1_007.fastq.gz --gam  --out_name ${SAMPLE}_sim_5M --fastq_out --sim_chunks 20 --logFile sim.log

# Remap simulated reads to the full graph (takes about 3.5 hours on 32 cores)
echo "Mapping simulated reads back to hgsvc graph"
vg map -d ../haps/hgsvc_v1.threads -f ./simtest-${SAMPLE}/${SAMPLE}_sim_5M.fq.gz -i  > ./simtest-${SAMPLE}/${SAMPLE}_sim_5M_remapped.gam

# Make a vcf using vg call
rm -rf js call.log; toil-vg call ./js ../haps/hgsvc_v1.threads.xg ${SAMPLE} ./simtest-${SAMPLE} --chroms ${CHROM} --gams ./simtest-${SAMPLE}/${SAMPLE}_sim_5M_remapped.gam --realTimeLogging --logFile call.log --whole_genome_config --logFile call.log

# Use vcfeval to compare back to the original vcf (ignoring ploidy mistakes for now)
rm -rf eval.squash; rtg vcfeval -t ./hg38.sdf -b ../haps/HGSVC.haps.vcf.gz -c ./simtest-${SAMPLE}/${SAMPLE}.vcf.gz --region ${CHROM} -o ./eval.squash --sample ${SAMPLE} --squash-ploidy

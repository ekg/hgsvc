### Chromosome 21 Simulation Experiment

## Construction

From `../haps` make the vcfs:

```
for i in `cat haps.urls`; do wget $i; done
./make-vcf.sh
```

Make the graphs.  In both scripts, uncomment `chroms=chr21` and make sure `ref` path is valid

```
./do-by-chroms.sh
./do-by-add.sh
```

From `./genotyping`, make the control graphs (uncomment `chroms=chr21`)

```
./make-controls.sh
```

## Evaluation

From `./genotyping`, run the experiment on each sample for the vcf-constructed graph

```
./sim-test.sh HG005733 ../haps/hgsvc_chr21.threads 
./sim-test.sh HG00514 ../haps/hgsvc_chr21.threads
./sim-test.sh NA19240 ../haps/hgsvc_chr21.threads
```

And the same again on the add-constructed graphs
```
./sim-test.sh HG005733 ../haps/hgsvc_add_chr21  
./sim-test.sh HG00514 ../haps/hgsvc_add_chr21 
./sim-test.sh NA19240 ../haps/hgsvc_add_chr21
```

Print the results:
```
for i in  `ls simtest-hgsvc_*/hgsvc-call_vcfeval_output_summary.txt`; do echo $i; cat $i; done
simtest-hgsvc_add_chr21-HG00514/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  114.000                334            332         51        264     0.8668       0.5585     0.6793
     None                334            332         51        264     0.8668       0.5585     0.6793
simtest-hgsvc_add_chr21-HG005733/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  129.000                188            232        123        162     0.6535       0.5371     0.5896
     None                188            232        123        162     0.6535       0.5371     0.5896
simtest-hgsvc_add_chr21-NA19240/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  167.000                278            332        217        311     0.6047       0.4720     0.5302
     None                280            334        229        309     0.5933       0.4754     0.5278
simtest-hgsvc_chr21.threads-HG00514/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  145.794                354            352         30        244     0.9215       0.5920     0.7209
     None                354            352         32        244     0.9167       0.5920     0.7194
simtest-hgsvc_chr21.threads-HG005733/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  167.000                215            214         25        135     0.8954       0.6143     0.7287
     None                216            215         27        134     0.8884       0.6171     0.7283
simtest-hgsvc_chr21.threads-NA19240/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  130.000                349            347         24        240     0.9353       0.5925     0.7255
     None                349            347         24        240     0.9353       0.5925     0.7255
simtest-hgsvc_HG00514_chr21-HG00514/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  164.000                371            370         40        227     0.9024       0.6204     0.7353
     None                372            371         44        226     0.8940       0.6221     0.7336
simtest-hgsvc_HG00514_chr21-HG005733/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  223.148                 54             66        191        296     0.2568       0.1543     0.1928
     None                 57             69        253        293     0.2143       0.1629     0.1851
simtest-hgsvc_HG00514_chr21-NA19240/hgsvc-call_vcfeval_output_summary.txt
Threshold  True-pos-baseline  True-pos-call  False-pos  False-neg  Precision  Sensitivity  F-measure
----------------------------------------------------------------------------------------------------
  256.056                 74             82        281        515     0.2259       0.1251     0.1610
     None                 81             91        440        508     0.1714       0.1375     0.1526

```

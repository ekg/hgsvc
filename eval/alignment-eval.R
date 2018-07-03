#!/usr/bin/env Rscript

require(ggplot2)
filename <- commandArgs(TRUE)[1]
d <- read.delim(filename)
t.test(d$ident.ref.hg38, d$ident.hgsvc.hg38)

ggplot(d, aes(x=ident.hgsvc.hg38-ident.ref.hg38)) + geom_histogram(binwidth=0.01) + theme_bw() + scale_y_log10()
ggsave(paste(filename, ".hist.png", sep=""), height=4, width=7)

ggplot(d, aes(x=ident.ref.hg38, y=ident.hgsvc.hg38)) + geom_point(alpha=I(1/20)) + theme_bw() + coord_fixed()
ggsave(paste(filename, ".points.png", sep=""))


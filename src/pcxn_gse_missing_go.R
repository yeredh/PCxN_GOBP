gse_annot = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/GSE_annotation.RDS")
# get sample size per GSE series
gse_count = table(gse_annot$GSE)
gse_count = sort(gse_count,decreasing=T)
# keep series with at least 5 samples
gse_ids = names(gse_count[gse_count >= 5])

# read RDS files with results
setwd("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO")
rds_files = sort(list.files(pattern="RDS"))
gse_done = sort(sapply(rds_files,function(x){gsub("(GSE[0-9]*)_go_pathcor.*","\\1",x)}))
names(gse_done) = NULL
gse_miss=setdiff(gse_ids,gse_done)
ind=match(gse_miss,gse_ids)
ind


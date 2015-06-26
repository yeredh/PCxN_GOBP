rm(list=ls())
options(stringsAsFactors = F)
# ==== Results ====
# load results into a single data frame
pathCor = as.data.frame(rbind(readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/CP/res/pathCor_CP_dframe.RDS"),
                              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/pathCor_GOBP_dframe.RDS"),
                              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/merge/res/pathCor_CP_GOBP_dframe.RDS")))

# remove NAs
pathCor = pathCor[!is.na(pathCor$PathCor),]
# adjust p-values for multiple comparison
pathCor$p.Adjust = p.adjust(pathCor$p.value,"fdr")
# save results
saveRDS(pathCor,"/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/merge/res/pathCor_merge_dframe.RDS")

rm(list=ls())

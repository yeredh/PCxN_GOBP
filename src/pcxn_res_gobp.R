# ==== PCxN results ====
# load results
pathCor = readRDS("output/pathCor_GOBP_dframe.RDS")
# fix variable types
pathCor$Pathway.A = as.character(pathCor$Pathway.A)
pathCor$Pathway.B = as.character(pathCor$Pathway.B)
pathCor$PathCor = as.numeric(pathCor$PathCor)
pathCor$p.value = as.numeric(pathCor$p.value)
pathCor$Overlap.Coefficient = as.numeric(pathCor$Overlap.Coefficient)
# remove NAs
pathCor = pathCor[!is.na(pathCor$PathCor),]
# adjust p-values for multiple comparison
pathCor$p.Adjust = p.adjust(pathCor$p.value,"fdr")
# save results
saveRDS(pathCor,"output/pathCor_GOBP_dframe.RDS")

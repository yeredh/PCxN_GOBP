rm(list=ls())

# ==== Results ====
over_coeff = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/over_coef.RDS")
pathway_names = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/pathway_names.RDS")
r_bar = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_bar.RDS")
p_combined = c(readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_combined1.RDS"),
               readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_combined2.RDS"))


# === Results ====
pathCor = data.frame(Pathway.A = pathway_names[,1],Pathway.B = pathway_names[,2],
                     PathCor = r_bar, p.value = p_combined, Overlap.Coefficient=over_coeff)

# remove NAs
pathCor = pathCor[!is.na(pathCor$PathCor),]
# adjust p-values for multiple comparison
pathCor$p.Adjust = p.adjust(pathCor$p.value,"fdr")

saveRDS(pathCor,"/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/pathCor_GO_dframe.RDS")
rm(list=ls())


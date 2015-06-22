rm(list=ls())

# ==== Results ====
over_coeff = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/over_coef.RDS")
pathway_names = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/pathway_names.RDS")
r_bar = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/r_bar.RDS")
p_combined = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/p_combined.RDS")


# === Results ====
pathCor = data.frame(Pathway.A = pathway_names[,1],Pathway.B = pathway_names[,2],
                     PathCor = r_bar, p.value = p_combined, Overlap.Coefficient=over_coeff)


saveRDS(pathCor,"/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/pathCor_GOBP_dframe.RDS")
rm(list=ls())


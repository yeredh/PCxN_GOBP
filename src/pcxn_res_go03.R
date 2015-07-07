rm(list=ls())
# ==== Experiment-level correlation estimates ====
r_mat = cbind(readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat1.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat2.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat3.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat4.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat5.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat6.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat7.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat8.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat9.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_mat10.RDS"))

# sample size per experiment
n_vec = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/n_vec.RDS")

# weighted average for the correlation estimates
n_mult = n_vec/sum(n_vec)
rm(n_vec)
r_bar = r_mat%*%n_mult

saveRDS(r_bar,paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/r_bar.RDS"))
rm(list=ls())
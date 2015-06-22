rm(list=ls())
# ==== Experiment-level p-values ====
p_mat = cbind(readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/p_mat1.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/p_mat2.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/p_mat3.RDS"),
              readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/p_mat4.RDS"))


# combined p-values
library(metap)
p_combined = apply(p_mat,1,function(x){
  if(any(is.na(x)) | sum(x!=1) <2){
    return(1)
  }else{
    logitp(x)$p
  }})



saveRDS(p_combined,paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/p_combined.RDS"))


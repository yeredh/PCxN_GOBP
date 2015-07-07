rm(list=ls())

# ==== Pathway Annotation ====
gs_lst = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/go_gs.RDS")
n_pairs = choose(length(gs_lst),2)


# ==== Experiment-level p-values ====
args = as.numeric(commandArgs(trailingOnly = T))
cat(args,"\n")

if(args == 1){
  ind = 1:ceiling(n_pairs/2)
}
if(args == 2){
  ind = (ceiling(n_pairs/2) + 1):n_pairs
}

p_mat   = cbind(readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat1.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat2.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat3.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat4.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat5.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat6.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat7.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat8.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat9.RDS")[ind,],
                readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_mat10.RDS")[ind,])

# combined p-values
library(metap)
p_combined = apply(p_mat,1,function(x){
  if(any(is.na(x)) | sum(x!=1) <2){
    return(1)
  }else{
    logitp(x)$p
  }})


saveRDS(p_combined,paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/res/p_combined",args,".RDS"))
rm(list=ls())
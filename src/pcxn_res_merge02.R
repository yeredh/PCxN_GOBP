rm(list=ls())
# ==== GSE annotation ====
gse_annot = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/GSE_annotation.RDS")
# get sample size per GSE series
gse_count = table(gse_annot$GSE)
gse_count = sort(gse_count,decreasing=T)
# keep series with at least 10 samples
gse_ids = names(gse_count[gse_count >= 5])

# ==== Pathway Annotation ====
gs_lst01 = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/gobp_gs.RDS")
gs_lst02 = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/cp_gs.RDS")
n_pairs = length(gs_lst01)*length(gs_lst02)

library(parallel)
nc = detectCores()

# split GSE into ten groups
gse_split = split(gse_ids, ceiling(seq_along(gse_ids)/169))

# read command line arguments
# the script is run as job array, the args correponds to the job array index
args <- as.numeric(commandArgs(trailingOnly = T))


# get correlation estimates and p-values
r_mat = matrix(NA,ncol=length(gse_split[[args]]),nrow=n_pairs,dimnames=list(NULL,gse_split[[args]]))
p_mat = r_mat


ic=1
pb = txtProgressBar(min=0,max=length(gse_split[[args]]),style=3,initial=0)
for(gse in gse_split[[args]]){
  # load RDS file
  gse_lst = readRDS(paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/merge/",gse,"_cp_gobp_pathcor.RDS"))
  # get correlation estimates
  tmp = mclapply(gse_lst,function(x){
    if(length(x) == 7){
      return(x[[3]])
    }else{
      return(NA)
    }},mc.cores=nc)
  
  tmp = simplify2array(tmp, higher = TRUE)
  r_mat[,ic] = tmp
  
  # get p-values
  tmp = mclapply(gse_lst,function(x){
    if(length(x) == 7){
      return(x[[6]])
    }else{
      return(NA)
    }},mc.cores=nc)
  
  tmp = simplify2array(tmp, higher = TRUE)
  p_mat[,ic] = tmp
  
  setTxtProgressBar(pb,ic)
  ic=ic+1
}
close(pb)
saveRDS(p_mat,paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/merge/res/p_mat",args,".RDS"))
saveRDS(r_mat,paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/merge/res/r_mat",args,".RDS"))

rm(list=ls())
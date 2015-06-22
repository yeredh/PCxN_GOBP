rm(list=ls())
# ==== GSE annotation ====
gse_annot = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/GSE_annotation.RDS")
# get sample size per GSE series
gse_count = table(gse_annot$GSE)
gse_count = sort(gse_count,decreasing=T)
# keep series with at least 10 samples
gse_ids = names(gse_count[gse_count >= 5])

# ==== Pathway Annotation ====
gs_lst = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/gobp_gs.RDS")
n_pairs = choose(length(gs_lst),2)


GetN = function(ic){
  gse=gse_ids[ic]
  gse_lst = readRDS(paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/",gse,"_gobp_pathcor.RDS"))
  setTxtProgressBar(pb,ic)
  return(gse_lst[[1]]$n)
}

library(parallel)
nc = detectCores()

pb = txtProgressBar(min=0,max=length(gse_ids),style=3,initial=0)
cat("\n")
n_vec = mclapply(1:length(gse_ids),GetN,mc.cores=nc)
n_vec = simplify2array(n_vec, higher = TRUE)
close(pb)

saveRDS(n_vec,"/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/n_vec.RDS")

# get overlap coefficient
gse_lst = readRDS(paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/",gse_ids[1],"_gobp_pathcor.RDS"))
over_coef = mclapply(gse_lst,function(x){
  if(length(x) == 7){
    return(x[[7]])
  }else{
    return(1)
  }},mc.cores=nc)
over_coef = unlist(over_coef)

saveRDS(over_coef,"/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/over_coef.RDS")

# get pathway names
pathway_names = mclapply(gse_lst,function(x){
  if(length(x) == 7){
    return(unlist(x[1:2]))
  }else{
    return(c(NA,NA))
  }},mc.cores=nc)

pathway_names = t(simplify2array(pathway_names, higher = TRUE))

saveRDS(pathway_names,"/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GOBP/res/pathway_names.RDS")

rm(list=ls())
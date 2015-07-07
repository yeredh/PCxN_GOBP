rm(list=ls())
library(parallel)
options(stringsAsFactors = F)
# ==== PCxN Functions ====
source("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/src/pcxn_functions.R")

# ==== GSE annotation ====
gse_annot = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/GSE_annotation.RDS")
# get sample size per GSE series
gse_count = table(gse_annot$GSE)
gse_count = sort(gse_count,decreasing=T)
# keep series with at least 5 samples
gse_ids = names(gse_count[gse_count >= 5])

# ==== Pathway Annotation ====
gs_lst = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/go_gs.RDS")

# ==== Expression Background ====
exprs_rnk = readRDS("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/data/GPL570.Rp.mat.RDS")

# read command line arguments
args <- as.numeric(commandArgs(trailingOnly = T))
# argument to pick GSE series
cat("GSE Series:", gse_ids[args],"\n")

# select GSE series
gse = gse_ids[args]
gsm_targets = gse_annot$GSM[gse_annot$GSE == gse]
gsm_ind = colnames(exprs_rnk) %in% gsm_targets
# subset expression ranks
exprs_rnk = exprs_rnk[,gsm_ind]

ProcessElement <- function(ic){
  i = ceiling((sqrt(8*(ic+1)-7)+1)/2)
  j = ic-choose(floor(1/2+sqrt(2*ic)),2)
  
  # pathway gene sets
  gsA=gs_lst[[i]]
  gsB=gs_lst[[j]]
  
  # split into three disjoint sets:
  # 1. genes shared by pathwatys A and B
  gsAB <- intersect(gsA,gsB)
  # 2. genes unique to pathway A
  gsAu <- setdiff(gsA,gsB)
  # 3. genes unique to pathway B
  gsBu <- setdiff(gsB,gsA)
  # Check for gene overlap
  over_check <- length(gsAB) > 0
  
  if(over_check){
    # overlap case
    uCheck <- length(gsAu) == 0 | length(gsBu) == 0
    if(uCheck){
      cat("\n no unique genes for one of the pathways! >=( \n")
      tmp <- rep(NA,4)
      names(tmp) = c("estimate","n","statistic","p.value")
    }else{
      # get pathway summaries
      summaryAu = GetSummary(dat=exprs_rnk,gs=gsAu,sum_fun=colMedians)
      summaryBu = GetSummary(dat=exprs_rnk,gs=gsBu,sum_fun=colMedians)
      summaryAB = GetSummary(dat=exprs_rnk,gs=gsAB,sum_fun=colMedians)
      # get correlation estimates
      tmp = data.frame(Pathway.A=names(gs_lst)[i],Pathway.B=names(gs_lst)[j])
      tmp = c(tmp,ShrinkPCor(summaryAu,summaryBu,summaryAB,method="spearman"))
      # overlap coefficient
      tmp$Overlap.Coeff= OverlapCoefficient(gs_lst[[i]],gs_lst[[j]])
    }
  }else{
    # no overlap
    # get pathway summaries
    summaryA = GetSummary(dat=exprs_rnk,gs=gsA,sum_fun=colMedians)
    summaryB = GetSummary(dat=exprs_rnk,gs=gsB,sum_fun=colMedians)
    # get correlation estimates
    tmp = data.frame(Pathway.A=names(gs_lst)[i],Pathway.B=names(gs_lst)[j])
    tmp = c(tmp,ShrinkCor(summaryA,summaryB,method="spearman"))
    tmp$Overlap.Coeff = 0 
  }
  setTxtProgressBar(pb,ic)
  return(tmp)
}


(nc = detectCores())

# loop through pathways  
number_of_pathways = choose(length(gs_lst),2)
input = 1:number_of_pathways
pb = txtProgressBar(min=0,max=number_of_pathways,style=3,initial=0)
cat("\n")
res = mclapply(input,ProcessElement,mc.cores=nc)
close(pb)


# save results
saveRDS(res,paste0("/net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/output/GO/",gse,"_go_pathcor.RDS"))
rm(list=ls())

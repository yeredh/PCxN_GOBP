library(GSEABase)
options(stringsAsFactors = F)

# ==== GO: All ====
# annotation (entrez gene ids) for all GO gene sets from  MSigDB v5.0
go_gsc = getGmt("data/Gene Sets/c5.all.v5.0.entrez.gmt",
                geneIdType=EntrezIdentifier(),
                collectionType=BroadCollection(category = "c5",subCategory = "GO"))

go_gs_lst = lapply(go_gsc, geneIds)
names(go_gs_lst) = names(go_gsc)

# ==== GO: BP ====
# annotation (entrez gene ids) for BP: GO biological process gene sets from  MSigDB v5.0
gobp_gsc = getGmt("data/Gene Sets/c5.bp.v5.0.entrez.gmt",
                  geneIdType=EntrezIdentifier(),
                  collectionType=BroadCollection(category = "c5",subCategory = "BP"))

gobp_gs_lst = lapply(gobp_gsc,geneIds)
names(gobp_gs_lst) = names(gobp_gsc)

# ==== GO: MF ====
# annotation (entrez gene ids) for MF: GO molecular function gene sets from  MSigDB v5.0
gomf_gsc = getGmt("data/Gene Sets/c5.mf.v5.0.entrez.gmt",
                  geneIdType=EntrezIdentifier(),
                  collectionType=BroadCollection(category = "c5",subCategory = "MF"))

gomf_gs_lst = lapply(gomf_gsc,geneIds)
names(gomf_gs_lst) = names(gomf_gsc)

# ==== GO: CC ====
# annotation (entrez gene ids) for CC: GO cellular component gene sets from  MSigDB v5.0
gocc_gsc = getGmt("data/Gene Sets/c5.cc.v5.0.entrez.gmt",
                  geneIdType=EntrezIdentifier(),
                  collectionType=BroadCollection(category = "c5",subCategory = "CC"))

gocc_gs_lst = lapply(gocc_gsc,geneIds)
names(gocc_gs_lst) = names(gocc_gsc)


# helper function to check if the genes are included in the CP collections
checkGS = function(gs_lst){
  res = rep(NA,length(gs_lst))
  names(res) = names(gs_lst)
  for(k in seq_along(gs_lst)){
    res[k] =mean(gs_lst[[k]] %in% unlist(go_gs_lst[names(go_gs_lst) %in% names(gs_lst)[k]]))
  }
  return(res)
}

# check for all gene sets
gobp_check = checkGS(gobp_gs_lst)
mean(gobp_check == 1)
gomf_check = checkGS(gomf_gs_lst)
mean(gomf_check == 1)
gocc_check = checkGS(gocc_gs_lst)
mean(gocc_check == 1)

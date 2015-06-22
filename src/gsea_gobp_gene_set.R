library(GSEABase)

# ==== GO: BP ====
# annotation (entrez gene ids) for BP: GO biological process gene sets from  MSigDB v5.0
gobp_gsc = getGmt("data/Gene Sets/c5.bp.v5.0.entrez.gmt",
                  geneIdType=EntrezIdentifier(),
                  collectionType=BroadCollection(category = "c5",subCategory = "BP"))


# name of first gene set
names(gobp_gsc)[1]
# get Entrez IDs for the first gene set
geneIds(gobp_gsc[[1]])
# more information about the gene st
details(gobp_gsc[[1]])

gobp_gs_lst = lapply(gobp_gsc,geneIds)
names(gobp_gs_lst) = names(gobp_gsc)
# keep gene ids represented in platform
GPL570_ids=readRDS("data/GPL570_ids.RDS")
res = lapply(gobp_gs_lst,function(x){ind = x %in% GPL570_ids;return(x[ind]);})
saveRDS(res,"data/Gene Sets/gobp_gs.RDS")

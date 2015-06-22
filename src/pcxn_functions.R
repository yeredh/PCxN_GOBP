# ==== R Packages =====
library(matrixStats)
library(corpcor)
library(metap)

# ==== Functions ====
OverlapCoefficient <- function(x,y){
  # function to calculate the overlap coefficient between x and y
  # which is defined as the size of the intersection divided by the
  # size of the smaller set
  #
  # Args
  #   x: a vector
  #   y: a vector
  #
  # Returns
  #   the overlap coefficient, a number between 0 and 1
  
  length(intersect(x,y))/min(length(unique(x)),length(unique(y)))
}

ShrinkCor <- function(x,y,method="pearson"){
  # wrapper to estimate the correlation coefficient between x and y using the 
  # shrinkage estimator from Schaffer & Strimmer (2005) [corpcor package]
  # and the corresponding t-statistic and p-value
  #
  # Args
  #   x: a vector with n observations
  #   y: a vector with n observations
  #   method: character to pick either the Pearson or Spearman correlation coefficient
  #
  # Returns
  #   a named vector with the correlation estimate, the sample size n, the t-statistic
  #   and its corresponding p-value
  
  # function to get the t-statistic
  GetStatistic <- function(r,n){r*sqrt((n-2)/(1-r^2))}
  # get sample size
  if(length(x) == length(y)){
    n <- length(x)
  }else{
    cat("x and y have different lengths! >=( \n")
    return(NA)
  }
  # determine method
  selected_method <- match(method,c("pearson","spearman"))
  # Pearson correlation
  if(selected_method == 1){
    estimate <- cor.shrink(cbind(x,y),verbose=F)
    statistic <- GetStatistic(estimate[2,1],n)
    p.value <- 2*pt(-abs(statistic),n-2)
  }else if(selected_method == 2){
    estimate <- cor.shrink(cbind(rank(x),rank(y)),verbose=F)
    statistic <- GetStatistic(estimate[2,1],n)
    p.value <- 2*pt(-abs(statistic),n-2)
  }else{
    cat("invalid method! >=( \n")
    return(NA)
  }
  # prepare results
  res <- c(estimate[2,1],n,statistic,p.value)
  names(res) <- c("estimate","n","statistic","p.value")
  return(res)
}


# shrinkage estimators for the correlation coefficients
ShrinkPCor <- function(x,y,z,method="pearson"){
  # wrapper to estimate the partial correlation coefficient x,y|z using the 
  # shrinkage estimator from Schaffer & Strimmer (2005) [corpcor package]
  # and the corresponding t-statistic and p-value
  #
  # Args
  #   x: a vector with n observations
  #   y: a vector with n observations
  #   z: a vector with n observations
  #   method: character to pick either the Pearson or Spearman partial correlation coefficient
  #
  # Returns
  #   a named vector with the partial correlation estimate, the sample size n, the t-statistic
  #   and its corresponding p-value
  
  # function to get the t-statistic
  GetStatistic <- function(r,n){r*sqrt((n-3)/(1-r^2))}
  # get sample size
  if(length(x) == length(y) & length(z) == length(x)){
    n <- length(x)
  }else{
    cat("x,y and z have different lengths! >=( \n")
    return(NA)
  }
  # determine method
  selected_method <- match(method,c("pearson","spearman"))
  # Pearson correlation
  if(selected_method == 1){
    estimate <- pcor.shrink(cbind(x,y,z),verbose=F)
    statistic <- GetStatistic(estimate[2,1],n)
    p.value <- 2*pt(-abs(statistic),n-3)
  }else if(selected_method == 2){
    estimate <- cor.shrink(cbind(rank(x),rank(y),rank(z)),verbose=F)
    statistic <- GetStatistic(estimate[2,1],n)
    p.value <- 2*pt(-abs(statistic),n-3)
  }else{
    cat("invalid method! >=( \n")
    return(NA)
  }
  # prepare results
  res <- c(estimate[2,1],n,statistic,p.value)
  names(res) <- c("estimate","n","statistic","p.value")
  return(res)
}


GetSummary <- function(dat,gs,sum_fun){
  # function to calculate the summary statistic for the pathway
  #
  # Args.
  #   dat: genes by samples matrix
  #   gs: vector with the names of the genes in the gene set
  #   sum_fun: function to calculate the summary
  #
  # Returns
  #   a 1 by samples vector with the summary statistic for the pathway
  
  if(length(gs) > 1){
    # calculate summary for pathways with more than 1 element
    return(sum_fun(dat[rownames(dat) %in% gs,]))
  }else{
    # return actual value for pathways with a single element
    return(dat[rownames(dat) %in% gs,])
  }
}
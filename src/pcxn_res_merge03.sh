#!/bin/sh 
#SBATCH -J pcxn_merge_res03 # A single job name for the array 
#SBATCH -n 1 # Number of cores 
#SBATCH -N 1 # All cores on one machine 
#SBATCH -p serial_requeue,irizarry # Partition 
#SBATCH --mem-per-cpu 20000 # Memory request 
#SBATCH -t 0-04:00 # (D-HH:MM) 
#SBATCH -o /net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/log/pcxn_merge_res03.out # Standard output 
#SBATCH -e /net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/log/pcxn_merge_res03.err # Standard error   
module load centos6/R-3.1.1 
R CMD BATCH /net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/src/pcxn_res_merge03.R /net/hsphfs1/srv/export/hsphfs1/share_root/hide_lab/PCxN/log/pcxn_merge_res03.Rout

#!/bin/bash
#SBATCH --job-name=pbmc3k_splitRA
#SBATCH --partition=ncpu
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/read-ra_split/splitRA_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/read-ra_split/splitRA_%j.err

set -euo pipefail

RAW_DIR="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/raw"
OUT_DIR="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/raw_standard"
LOG_DIR="/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/read-ra_split"
mkdir -p "$OUT_DIR" 
mkdir -p "$LOG_DIR"

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "RAW_DIR: $RAW_DIR"
echo "OUT_DIR: $OUT_DIR"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

cd "$RAW_DIR"

for RA in read-RA_*.fastq.gz; do

  echo "Splitting $RA ..."

  zcat "$RA" | awk 'NR%4==1{h=$0} NR%4==2{s=$0} NR%4==3{p=$0} NR%4==0{q=$0; if(length(s)==98){print h"\n"s"\n"p"\n"q}}' \
    | gzip > "$OUT_DIR/${RA%.fastq.gz}_R1_biological_transcript.fastq.gz"
  
  zcat "$RA" | awk 'NR%4==1{h=$0} NR%4==2{s=$0} NR%4==3{p=$0} NR%4==0{q=$0; if(length(s)==10){print h"\n"s"\n"p"\n"q}}' \
    | gzip > "$OUT_DIR/${RA%.fastq.gz}_R2_UMI.fastq.gz"

done

echo "End: $(date)"
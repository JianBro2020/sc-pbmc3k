#!/bin/bash
#SBATCH --job-name=pbmc3k_integrateCB_UMI
#SBATCH --partition=ncpu
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/cbumi_make/cbumi_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/cbumi_make/cbumi_%j.err

set -euo pipefail

RAW="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/raw"
RAWSTD="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/raw_standard"
LOGDIR="/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/cbumi_make"

mkdir -p "${LOGDIR}"

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "RAW (I1 CB files): ${RAW}"
echo "RAWSTD (UMI + output): ${RAWSTD}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

cd "${RAW}"

shopt -s nullglob
for I1 in read-I1_*.fastq.gz; do
  stem="${I1%.fastq.gz}"

  # UMI split file lives in raw_standard and matches by si/lane/chunk
  UMI="${RAWSTD}/${stem/read-I1/read-RA}_R2_UMI.fastq.gz"

  if [[ ! -f "$UMI" ]]; then
    echo "ERROR: Missing UMI file for $I1 -> expected $UMI"
    exit 1
  fi

  outfastq="${RAWSTD}/${stem}_CBUMI.fastq.gz"
  echo "Building CBUMI: $I1 + $(basename "$UMI") -> $(basename "$outfastq")"

  paste \
    <(zcat "$I1") \
    <(zcat "$UMI") \
  | awk 'NR%4==1{print $1} NR%4==2{print $1$2} NR%4==3{print "+"} NR%4==0{print $1$2}' \
  | gzip > "$outfastq"
done

echo "End: $(date)"
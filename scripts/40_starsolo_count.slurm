#!/bin/bash
#SBATCH --job-name=pbmc3k_starsolo
#SBATCH --partition=ncpu
#SBATCH --time=08:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/starsolo/starsolo_count_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/starsolo/starsolo_count_%j.err

set -euo pipefail
module purge
ml STAR/2.7.11a-GCC-12.3.0

IDX="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/references/grch38_ensembl106/starsolo_index"
IN="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/raw_standard"
OUT="/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/starsolo/run_${SLURM_JOB_ID}"

mkdir -p "${OUT}"

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "IDX: ${IDX}"
echo "IN: ${IN}"
echo "OUT: ${OUT}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

# cDNA read (98 bp)
R1=$(ls ${IN}/read-RA_*_R1_biological_transcript.fastq.gz | tr '\n' ',')

# barcode read = CB (14bp) + UMI (10bp) -> 24bp
R2=$(ls ${IN}/read-I1_*_CBUMI.fastq.gz | tr '\n' ',')

STAR \
  --runThreadN "${SLURM_CPUS_PER_TASK}" \
  --genomeDir "${IDX}" \
  --readFilesIn "${R1%,}" "${R2%,}" \
  --readFilesCommand zcat \
  --outFileNamePrefix "${OUT}/" \
  --outSAMtype BAM SortedByCoordinate \
  --outSAMattributes NH HI AS nM CB UB \
  --soloType CB_UMI_Simple \
  --soloCBstart 1 --soloCBlen 14 \
  --soloUMIstart 15 --soloUMIlen 10 \
  --soloBarcodeReadLength 0 \
  --soloCBwhitelist None \
  --soloFeatures Gene

echo "End: $(date)"
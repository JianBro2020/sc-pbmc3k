#!/bin/bash
#SBATCH --job-name=pbmc3k_salmon_index
#SBATCH --partition=ncpu
#SBATCH --time=06:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/alevin_fry/logs/salmon_index_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/alevin_fry/logs/salmon_index_%j.err

set -euo pipefail

PROJ="/nemo/lab/schreibera/home/users/wangj/pbmc3k"
REF="${PROJ}/data/references/grch38_ensembl106/alevin_fry"
SPLICI="${REF}/splici_rl98_ref"
IDX="${REF}/salmon_index_splici_rl98"
LOGDIR="${PROJ}/results/alevin_fry/logs"

mkdir -p "${IDX}"

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "SPLICI DIR: ${SPLICI}"
echo "IDX DIR: ${IDX}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

module purge
ml Salmon/1.9.0-GCC-11.3.0

FA="${SPLICI}/splici_fl93.fa"

[[ -f "$FA" ]] || { echo "Missing FASTA: $FA" >&2; exit 1; }

salmon index \
  -t "${FA}" \
  -i "${IDX}" \
  -p "${SLURM_CPUS_PER_TASK}"

echo "End: $(date)"
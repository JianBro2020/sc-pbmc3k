#!/bin/bash
#SBATCH --job-name=pbmc3k_fastqc
#SBATCH --partition=ncpu
#SBATCH --time=02:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/qc/fastqc_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/qc/fastqc_%j.err

set -euo pipefail

FASTQ_DIR="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/raw"
OUT_DIR="/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/qc/fastqc"

mkdir -p "${OUT_DIR}"

module purge
ml FastQC/0.11.8-Java-1.8

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "Running FastQC on: ${FASTQ_DIR}"
echo "Writing results to: ${OUT_DIR}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

fastqc -t "${SLURM_CPUS_PER_TASK}" -o "${OUT_DIR}" "${FASTQ_DIR}"/*.fastq.gz

echo "End: $(date)"
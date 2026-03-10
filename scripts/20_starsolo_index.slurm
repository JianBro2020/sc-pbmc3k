#!/bin/bash
#SBATCH --job-name=starsolo_index_grch38_106
#SBATCH --partition=ncpu
#SBATCH --time=06:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/starsolo/starsolo_index_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/starsolo/starsolo_index_%j.err

set -euo pipefail
module purge
ml STAR/2.7.11a-GCC-12.3.0

FA="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/references/grch38_ensembl106/source/genome.fa"
GTF="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/references/grch38_ensembl106/source/genes.gtf"
IDX="/nemo/lab/schreibera/home/users/wangj/pbmc3k/data/references/grch38_ensembl106/starsolo_index"

mkdir -p "${IDX}"

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "FA: ${FA}"
echo "GTF: ${GTF}"
echo "IDX: ${IDX}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

STAR --runThreadN "${SLURM_CPUS_PER_TASK}" \
     --runMode genomeGenerate \
     --genomeDir "${IDX}" \
     --genomeFastaFiles "${FA}" \
     --sjdbGTFfile "${GTF}" \
     --sjdbOverhang 97

echo "End: $(date)"

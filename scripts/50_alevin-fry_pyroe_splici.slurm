#!/bin/bash
#SBATCH --job-name=pbmc3k_pyroe_splici
#SBATCH --partition=ncpu
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/alevin_fry/logs/pyroe_splici_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/alevin_fry/logs/pyroe_splici_%j.err

set -euo pipefail

PROJ="/nemo/lab/schreibera/home/users/wangj/pbmc3k"
REF="${PROJ}/data/references/grch38_ensembl106"

# alevin-fry branch reference artefacts go here:
AF_REF="${REF}/alevin_fry"
OUTDIR="${AF_REF}/splici_rl98_ref"

# Building splici requires the same reference Genome and GTF files.
FA="${REF}/source/genome.fa"
GTF="${REF}/source/genes.gtf"
READLEN=98

LOGDIR="${PROJ}/results/alevin_fry/logs"

mkdir -p "${REF}" "${AF_REF}" "${OUTDIR}" "${LOGDIR}"

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "FA: ${FA}"
echo "READLEN: ${READLEN}"
echo "OUTDIR: ${OUTDIR}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

module purge
module load Python/3.11.3-GCCcore-12.3.0

PYROE_ENV="${PROJ}/tools/pyroe_env"
if [[ ! -d "${PYROE_ENV}" ]]; then
  echo "ERROR: pyroe venv not found at: ${PYROE_ENV}" >&2
  echo "Tip: create it under ${PROJ}/tools/pyroe_env as you did previously." >&2
  exit 1
fi

source "${PYROE_ENV}/bin/activate"

pyroe make-splici \
  "${FA}" \
  "${GTF}" \
  "${READLEN}" \
  "${OUTDIR}"

echo "End: $(date)"
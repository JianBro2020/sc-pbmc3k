#!/bin/bash
#SBATCH --job-name=pbmc3k_salmon_alevin
#SBATCH --partition=ncpu
#SBATCH --time=08:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --output=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/alevin_fry/logs/salmon_alevin_%j.out
#SBATCH --error=/nemo/lab/schreibera/home/users/wangj/pbmc3k/results/alevin_fry/logs/salmon_alevin_%j.err

set -euo pipefail

PROJ="/nemo/lab/schreibera/home/users/wangj/pbmc3k"
SPLICI="${PROJ}/data/references/grch38_ensembl106/alevin_fry/splici_rl98_ref"
IDX="${PROJ}/data/references/grch38_ensembl106/alevin_fry/salmon_index_splici_rl98"
IN="${PROJ}/data/raw_standard"
OUTROOT="${PROJ}/results/alevin_fry/salmon_alevin"
OUT="${OUTROOT}/run_${SLURM_JOB_ID}"
LOGDIR="${PROJ}/results/alevin_fry/logs"

mkdir -p "${OUTROOT}" "${OUT}" 

echo "JobID: ${SLURM_JOB_ID}"
echo "Start: $(date)"
echo "IDX: ${IDX}"
echo "IN: ${IN}"
echo "OUT: ${OUT}"
echo "CPUs: ${SLURM_CPUS_PER_TASK}"

module purge
ml Salmon/1.9.0-GCC-11.3.0

# Collect Read 1 = CB + UMI (24 bp)
READ1=$(ls -1 "${IN}"/read-I1_*_CBUMI.fastq.gz | sort | paste -sd' ' -)

# Collect Read 2 = transcript (98 bp)
READ2=$(ls -1 "${IN}"/read-RA_*_R1_biological_transcript.fastq.gz | sort | paste -sd' ' -)

[[ -n "${READ1}" ]] || { echo "ERROR: No CBUMI FASTQs found in ${IN}" >&2; exit 1; }
[[ -n "${READ2}" ]] || { echo "ERROR: No transcript FASTQs found in ${IN}" >&2; exit 1; }

echo "READ1 (CB + UMI): $(echo "${READ1}" | wc -w) files"
echo "READ2 (cDNA):     $(echo "${READ2}" | wc -w) files"

# pyroe produced a 3-column map; salmon alevin expects 2 columns.
T2G_3COL="${SPLICI}/splici_fl93_t2g_3col.tsv"
T2G_2COL="${SPLICI}/splici_fl93_t2g_2col.tsv"

[[ -f "${T2G_3COL}" ]] || { echo "ERROR: Missing T2G_3COL: ${T2G_3COL}" >&2; exit 1; }

echo "Using T2G_3COL: ${T2G_3COL}"
echo "Generating T2G_2COL: ${T2G_2COL}"
awk 'BEGIN{OFS="\t"} {print $1,$2}' "${T2G_3COL}" > "${T2G_2COL}"

salmon alevin \
  -i "${IDX}" \
  -l A \
  -1 ${READ1} \
  -2 ${READ2} \
  -p "${SLURM_CPUS_PER_TASK}" \
  -o "${OUT}" \
  --chromium \
  --tgMap "${T2G_2COL}" \

echo "End: $(date)"
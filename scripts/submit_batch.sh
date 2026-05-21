#!/bin/bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/.." && pwd)}"
SCRIPT="$SCRIPT_DIR/run_batch.sh"

START_NUM="${START_NUM:-101}"
BATCH_SIZE="${BATCH_SIZE:-10}"
CONCURRENT_JOBS="${CONCURRENT_JOBS:-1}"
CONDA_ENV="${CONDA_ENV:-emerge_cpu}"
TIMEOUT="${TIMEOUT:-30m}"

echo "========================================================="
echo "Starting batch sequential simulation jobs"
echo "Start seed: $START_NUM"
echo "Batch size: $BATCH_SIZE"
echo "Concurrent jobs: $CONCURRENT_JOBS"
echo "Project: $PROJECT_DIR"
echo "========================================================="

for ((i=0; i<CONCURRENT_JOBS; i++))
do
    CUR_START=$(( START_NUM + (i * BATCH_SIZE) ))
    echo "[Batch $((i+1))] submitting seeds $CUR_START to $((CUR_START + BATCH_SIZE - 1))"
    qsub -N "b${CUR_START}_batch" \
        -v PROJECT_DIR="${PROJECT_DIR}",START_SEED="${CUR_START}",BATCH_SIZE="${BATCH_SIZE}",CONDA_ENV="${CONDA_ENV}",TIMEOUT="${TIMEOUT}" \
        "$SCRIPT"
done

echo "---------------------------------------------------------"
echo "Submission complete."

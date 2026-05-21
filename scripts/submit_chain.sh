#!/bin/bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/.." && pwd)}"
SCRIPT="$SCRIPT_DIR/run_simulation.sh"

START_NUM="${START_NUM:-101}"
MAX_SEED="${MAX_SEED:-104}"
CONCURRENT_JOBS="${CONCURRENT_JOBS:-2}"
CONDA_ENV="${CONDA_ENV:-emerge_cpu}"
TIMEOUT="${TIMEOUT:-30m}"

echo "========================================================="
echo "Starting independent daisy-chain simulation jobs"
echo "Start seed: $START_NUM"
echo "Max seed: $MAX_SEED"
echo "Concurrent chains: $CONCURRENT_JOBS"
echo "Project: $PROJECT_DIR"
echo "========================================================="

for ((i=0; i<CONCURRENT_JOBS; i++))
do
    SEED=$(( START_NUM + i ))
    if [ "$SEED" -le "$MAX_SEED" ]; then
        echo "[Chain $((i+1))] submitting seed $SEED"
        qsub -N "b${SEED}" \
            -v PROJECT_DIR="${PROJECT_DIR}",SEED="${SEED}",STEP="${CONCURRENT_JOBS}",MAX_SEED="${MAX_SEED}",CONDA_ENV="${CONDA_ENV}",TIMEOUT="${TIMEOUT}" \
            "$SCRIPT"
    fi
done

echo "---------------------------------------------------------"
echo "Submission complete."

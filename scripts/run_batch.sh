#!/bin/bash
#PBS -N bpf_batch
#PBS -q base_8
#PBS -l select=1:ncpus=8:mem=150gb
#PBS -l walltime=24:00:00
#PBS -j oe

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${PROJECT_DIR:-$(cd "$SCRIPT_DIR/.." && pwd)}"
SIM_DIR="$PROJECT_DIR/pipelines/random_bpf"
LOG_DIR="$PROJECT_DIR/result/log"

mkdir -p "$LOG_DIR"
cd "$SIM_DIR"

if [ -f /scratch/app/anaconda3/etc/profile.d/conda.sh ]; then
    source /scratch/app/anaconda3/etc/profile.d/conda.sh
    conda activate "${CONDA_ENV:-emerge_cpu}"
fi

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export NUMBA_NUM_THREADS=1

START_SEED="${START_SEED:?START_SEED is required}"
BATCH_SIZE="${BATCH_SIZE:-10}"
TIMEOUT="${TIMEOUT:-30m}"
END_SEED=$(( START_SEED + BATCH_SIZE - 1 ))

echo "================================================="
echo "Batch job: seed $START_SEED to $END_SEED"
echo "Project: $PROJECT_DIR"
echo "Simulation directory: $SIM_DIR"
echo "================================================="

for (( SEED=START_SEED; SEED<=END_SEED; SEED++ ))
do
    echo "-------------------------------------------------"
    echo "[$(date)] Running seed: $SEED"

    timeout "$TIMEOUT" python simulation.py --seed "$SEED" --output "$PROJECT_DIR"
    EXIT_CODE=$?

    if [ "$EXIT_CODE" -eq 124 ]; then
        echo "=> [TimeOut] Seed $SEED exceeded $TIMEOUT and was stopped."
    elif [ "$EXIT_CODE" -ne 0 ]; then
        echo "=> [Error] Seed $SEED failed with exit code $EXIT_CODE. Continuing."
    else
        echo "=> [Success] Seed $SEED completed."
    fi
done

echo "================================================="
echo "Batch job finished."
echo "================================================="

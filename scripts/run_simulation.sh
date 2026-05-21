#!/bin/bash
#PBS -N bpf_chain
#PBS -q base_8
#PBS -l select=1:ncpus=4:mem=100gb
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

SEED="${SEED:?SEED is required}"
STEP="${STEP:-1}"
MAX_SEED="${MAX_SEED:-$SEED}"
TIMEOUT="${TIMEOUT:-30m}"

echo "================================================="
echo "Running seed: $SEED"
echo "Project: $PROJECT_DIR"
echo "Simulation directory: $SIM_DIR"
echo "================================================="

timeout "$TIMEOUT" python simulation.py --seed "$SEED" --output "$PROJECT_DIR"
EXIT_CODE=$?

if [ "$EXIT_CODE" -eq 124 ]; then
    echo "=> [TimeOut] Seed $SEED exceeded $TIMEOUT and was stopped."
elif [ "$EXIT_CODE" -ne 0 ]; then
    echo "=> [Error] Seed $SEED failed with exit code $EXIT_CODE."
else
    echo "=> [Success] Seed $SEED completed."
fi

NEXT_SEED=$(( SEED + STEP ))

if [ "$NEXT_SEED" -le "$MAX_SEED" ]; then
    echo "=> Queueing next seed: $NEXT_SEED"
    sleep 10
    qsub -N "b${NEXT_SEED}" \
        -v PROJECT_DIR="${PROJECT_DIR}",SEED="${NEXT_SEED}",STEP="${STEP}",MAX_SEED="${MAX_SEED}",CONDA_ENV="${CONDA_ENV:-emerge_cpu}",TIMEOUT="${TIMEOUT}" \
        "$SCRIPT_DIR/run_simulation.sh"
else
    echo "=> Chain finished at seed $SEED."
fi

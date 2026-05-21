#!/bin/bash
#PBS -V
#PBS -N seed5
#PBS -q base_32
#PBS -l select=1:ncpus=16:mem=250gb
#PBS -l walltime=05:00:00
#PBS -j oe
# 1. 계정 경로로 이동
cd /scratch/home/jungsu0910/Coral2

# 2. 가상환경 활성화
source /scratch/app/anaconda3/etc/profile.d/conda.sh
conda activate emerge1

# 3. 병렬 연산 최적화 환경변수 (16코어 병렬용 세팅)
export OMP_NUM_THREADS=2
export MKL_NUM_THREADS=2
export NUMBA_NUM_THREADS=1
export MPLBACKEND=Agg
export VTK_DEFAULT_OPENGL_WINDOW=0

python Custome_Simulation.py

# Passive Device Inverse Design

An automated pipeline for **inverse design of RF bandpass filters** using random structure generation, full-wave FEM EM simulation, and deep learning-based prediction.

## Overview

Traditional RF filter design relies on iterative manual tuning. This project builds an **end-to-end data generation and learning pipeline** that:

1. Automatically generates randomized 3D filter structures
2. Runs full-wave EM simulations using [EMerge](https://www.emerge-software.com/) (open-source Python FEM solver)
3. Collects S-parameter datasets for deep learning training
4. (In progress) Trains a deep learning model to predict optimal filter geometry from target frequency response

## Pipeline

```
Random Structure Generation
        |
        v
FEM EM Simulation (EMerge + Gmsh)
        |
        v
S-parameter Dataset
        |
        v
Deep Learning Model (Inverse Design)
```

## Repository Structure

```
passive-device-inverse-design/
├── 01_structure_generation/   # Random bandpass filter geometry generator
│   └── generator_new.py
├── 02_em_simulation/          # Full-wave FEM simulation scripts
│   ├── simulation.py          # Main simulation runner
│   ├── simulation_gmsh.py     # Gmsh mesh generation
│   ├── simulation_pyvista.py  # 3D visualization
│   └── simulation_structure.py
├── 03_hpc_scripts/            # PBS job scripts for HPC cluster
│   ├── run_simulation.sh
│   ├── run_batch.sh
│   ├── submit_batch.sh
│   └── submit_chain.sh
└── 04_deep_learning/          # (Coming soon) Inverse design model
```

## Tech Stack

| Component | Tool |
|---|---|
| EM Simulation | [EMerge](https://www.emerge-software.com/) (Python FEM) |
| Mesh Generation | [Gmsh](https://gmsh.info/) |
| 3D Visualization | [PyVista](https://docs.pyvista.org/) |
| HPC Job Scheduling | PBS (qsub) |
| Deep Learning | PyTorch (in progress) |
| Language | Python 3 |

## Key Features

- **Randomized structure generation**: Parameterized geometry with controllable density probabilities for dataset diversity
- **Automated batch simulation**: PBS shell scripts for parallel job submission on HPC clusters (8-core high-speed processing)
- **Scalable pipeline**: Chain job submission to handle large-scale dataset generation
- **Open-source stack**: Entire pipeline built on open-source tools (no HFSS/COMSOL license required)

## Requirements

```bash
pip install emerge gmsh pyvista numpy
```

## Status

- [x] Random structure generator
- [x] FEM EM simulation pipeline
- [x] HPC batch automation
- [ ] Deep learning model (in progress)
- [ ] Trained model & results

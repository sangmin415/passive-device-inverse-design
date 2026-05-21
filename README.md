# Passive Device Inverse Design

Python pipeline for inverse design data generation of RF bandpass filters. The project generates pixelated passive-device layouts, runs full-wave EM simulations with EMerge/Gmsh, and stores S-parameter datasets for later machine-learning model development.

## What This Repository Contains

This repository is a cleaned portfolio version of the passive-device simulation work. It focuses on reproducible code for:

- random 20 mm x 20 mm bandpass-filter geometry generation
- custom hand-defined pixel-pattern simulation
- full-wave FEM simulation setup using EMerge and Gmsh
- PBS/HPC batch scripts for large-scale dataset generation
- export of `.s2p`, `.png`, and `.npz` results for downstream learning workflows

Large generated simulation artifacts are intentionally excluded from git.

## Repository Layout

```text
passive-device-inverse-design/
├── pipelines/
│   ├── random_bpf/        # Random pixel-layout generation and EM simulation
│   └── custom_bpf/        # Custom fixed-pattern BPF simulation pipeline
├── scripts/               # PBS batch and chain-submission scripts
├── requirements.txt
└── README.md
```

## Technical Overview

The design domain is a 20 mm x 20 mm RF board with a centered 10 mm x 10 mm active pixel region. The random generator uses a 25 x 25 grid with 0.4 mm pixels and variable global density ranges to create diverse conductive layouts.

Simulation settings used by the current pipeline:

| Area | Setting |
|---|---|
| Board size | 20 mm x 20 mm |
| Active pixel area | 10 mm x 10 mm |
| Pixel grid | 25 x 25 |
| Pixel size | 0.4 mm |
| Substrate thickness | 1.2 mm |
| Relative permittivity | 4.0 |
| Loss tangent | 0.013 |
| Conductor | Gold, 17 um |
| Frequency sweep | 0.1 GHz to 30 GHz, 91 points |
| Solver | EMerge FEM with PARDISO |

## Pipeline

```text
Pixel layout generation
        ↓
Geometry construction with Gmsh / OpenCASCADE
        ↓
Full-wave FEM simulation with EMerge
        ↓
S-parameter, layout image, and structure-array export
        ↓
Dataset for inverse-design model training
```

## Main Components

### Random BPF Pipeline

Location: `pipelines/random_bpf/`

- `generator_new.py`: stochastic pixel-layout generator
- `simulation.py`: production EMerge simulation runner
- `simulation_gmsh.py`: Gmsh geometry/mesh helper
- `simulation_pyvista.py`: PyVista visualization helper
- `simulation_structure.py`: structure data model/helper code

Example:

```bash
cd pipelines/random_bpf
python simulation.py --seed 1
```

### Custom BPF Pipeline

Location: `pipelines/custom_bpf/`

This folder keeps the original `Custome_*` filenames because the scripts import each other using those names. It contains a manually specified 25 x 25 pixel pattern and matching EMerge/Gmsh simulation code.

Example:

```bash
cd pipelines/custom_bpf
python Custome_Simulation.py
```

### HPC Batch Scripts

Location: `scripts/`

- `submit_batch.sh`: submit a batch range to PBS
- `run_batch.sh`: sequentially run multiple seeds inside one job
- `run_simulation.sh`: single-seed chained simulation job
- `submit_chain.sh`: start chained PBS submission

These scripts were written for a PBS-based HPC environment and may need path, queue, and conda-environment edits before reuse on another cluster.

## Requirements

Core Python dependencies are listed in `requirements.txt`. The simulation environment also requires a working EMerge installation and Gmsh runtime.

```bash
pip install -r requirements.txt
```

## Notes

- Generated result folders such as `result/`, `s2p/`, `png/`, and `npz/` are ignored by git.
- Simulation output data can become large quickly, so this repository tracks source code and workflow scripts only.
- Some scripts contain cluster-specific absolute paths from the original HPC environment; update those paths before running on a new machine.

## License

This project is licensed under the Apache License 2.0. See [LICENSE](LICENSE) for details.

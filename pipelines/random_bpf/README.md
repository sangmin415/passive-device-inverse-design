# Random BPF Pipeline

Random 20 mm x 20 mm bandpass-filter layout generation and EMerge/Gmsh simulation.

## Files

- `generator_new.py`: creates randomized 25 x 25 pixel layouts in the centered 10 mm x 10 mm active region.
- `simulation.py`: production simulation entrypoint that exports S-parameters, layout images, and structure arrays.
- `simulation_gmsh.py`: Gmsh/OpenCASCADE geometry construction helper.
- `simulation_pyvista.py`: PyVista visualization helper.
- `simulation_structure.py`: shared structure representation utilities.

## Run

```bash
python simulation.py --seed 1
```

The default output path is cluster-specific. Pass or edit the output directory before running outside the original HPC environment.

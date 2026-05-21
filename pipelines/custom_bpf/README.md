# Custom BPF Pipeline

Custom fixed-pattern bandpass-filter simulation pipeline.

The original filenames use the spelling `Custome_*`. They are preserved because the scripts import each other with those module names.

## Files

- `Custome_Layout.py`: custom pixel-layout definition.
- `Custome_Simulation.py`: production EMerge simulation entrypoint.
- `Custome_gmsh.py`: Gmsh geometry helper.
- `Custome_pyvista.py`: PyVista visualization helper.
- `Custome_structure.py`: structure representation utilities.
- `Custome_run.sh`: cluster run script.

## Run

```bash
python Custome_Simulation.py
```

Update the hard-coded output path before running on a different system.

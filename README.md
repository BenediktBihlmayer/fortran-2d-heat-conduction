# fortran-2d-heat-conduction
# 2D Heat Conduction in Fortran

A small Fortran implementation of transient heat conduction in a rectangular
plate using finite differences and explicit time integration.

## Mathematical model

The solver approximates the two-dimensional heat equation with constant
thermal diffusivity and no internal heat source:

$$
\frac{\partial T}{\partial t}
=
\alpha \left(
\frac{\partial^2 T}{\partial x^2}
+
\frac{\partial^2 T}{\partial y^2}
\right).
$$

Spatial derivatives use second-order central differences.
Time integration uses the first-order forward Euler method.

## Simulation setup

| Parameter | Value |
| --- | --- |
| Plate dimensions | 1.0 m × 1.0 m |
| Grid points | 50 × 50, including boundaries |
| Thermal diffusivity | 0.01 m²/s |
| Initial interior temperature | 0.0 °C |
| Left boundary temperature | 100.0 °C |
| Other boundary temperatures | 0.0 °C |
| Time steps | 1000 |

The left boundary includes both left corners. All boundary values remain
fixed throughout the simulation. The initial condition therefore contains
a temperature discontinuity at the heated boundary.

Parameters are defined at the beginning of the source file.

## Stability

For the explicit scheme, the time step must satisfy

$$
r_x + r_y \leq \frac{1}{2},
\qquad
r_x = \frac{\alpha \Delta t}{\Delta x^2},
\qquad
r_y = \frac{\alpha \Delta t}{\Delta y^2}.
$$

The program uses 90% of this upper limit:

$$
\Delta t =
\frac{0.9}
{2\alpha \left(1/\Delta x^2 + 1/\Delta y^2\right)}.
$$

With the default parameters, the time step is approximately 0.009371 s
and the final simulated time is approximately 9.371 s.

## Build and run

Requires a Fortran 2008 compiler, such as GNU Fortran.

```bash
gfortran -std=f2008 -O2 -Wall -Wextra heat_conduction_2d.f90 -o heat_conduction_2d
./heat_conduction_2d
```

For a debug build with runtime checks:

```bash
gfortran -std=f2008 -O0 -g -Wall -Wextra -fcheck=all \
  heat_conduction_2d.f90 -o heat_conduction_2d
```

## Output

The program reports the simulated time and mean interior temperature
every 200 steps.

The final temperature field is written to `temperature.csv` with columns:

- `x_m`
- `y_m`
- `temperature_degC`

The CSV contains one row per grid point. An existing output file is
overwritten when the program runs again.

## Scope and verification status

This is an educational solver for a uniform Cartesian grid and constant
material properties. The final field represents a transient solution.
A steady-state convergence criterion is not implemented.

Compilation, comparison against an analytical reference, and spatial
and temporal convergence studies remain to be documented.

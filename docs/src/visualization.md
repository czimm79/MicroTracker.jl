# Visualization

Along with [Plots.jl and StatsPlots.jl](https://docs.juliaplots.org/latest/generated/statsplots/) for normal plotting of `collapsed_data` in scatter plot form, MicroTracker comes with handy tools to view the full multi-dimensional nature of microbot trajectories.

For full interactivity, use the included Pluto notebook (see the [Pluto](@ref) docs page). This allows input arguments to the [`trajectory_analyzer`](@ref) to be rapidly changed with sliders and drop-down menus.

```@docs
trajectory_analyzer
animate_trajectory_analyzer
```
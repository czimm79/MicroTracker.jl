# Quick Start

This page is an abridged version of the documentation which runs through using MicroTracker with sample data. At the end of each bullet, there will be a link to the full section for more detailed explanation.

- **Install Julia** from their [website](https://julialang.org/downloads/platform/), making sure to add julia to your PATH. ([Download and install Julia](@ref))
- **Open a terminal** in a new empty folder, and type `julia` to open a julia REPL in that directory. ([Open a Julia REPL in a directory](@ref))
- **Create a Julia environment and install MicroTracker** into it using the following two commands. You can paste these into the Julia REPL.
```
] activate .
```
```
add MicroTracker
```
- **Import MicroTracker** into your namespace using the following command. Make sure you press backspace to get out of the [Pkg mode](https://docs.julialang.org/en/v1/stdlib/Pkg/) before running this command.

```julia
using MicroTracker
```

- **Create a new project** with example data using the [`create_project_here`](@ref) function. This populates your empty folder with the structure for easily analyzing microscopy data with MicroTracker. The supplied data is only two videos with two independent variables for demonstration purposes, but MicroTracker is capable of processing hundreds of videos at once. ([Create a MicroTracker project](@ref)). 

```julia
create_project_here()
```

- **Define project specific inputs** like the translation dictionary and filter settings. These variables are formatted for the supplied example data. ([Translation Dictionary](@ref), [Linking Settings](@ref))

```julia
translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, Float64))
linking_settings = (MPP = 0.605, SEARCH_RANGE_MICRONS = 1000, MEMORY = 0, STUBS_SECONDS = 0.5)
```

- **Batch process segmented image data** into linked time-series microbot trajectories using a single function [`batch_particle_data_to_linked_data`](@ref). This combines all the processing steps into a single command that processes an entire experimental array. ([Batch linking](@ref))
```julia
linked_data = batch_particle_data_to_linked_data(translation_dict, linking_settings)
```

- **Collapse/summarize linked data** for comparing microbots across experiments and videos using the [`collapse_data`](@ref) function. ([Collapsing](@ref))
```julia
collapsed_data = collapse_data(linked_data, translation_dict)
```

- **Filter the microbot trajectories** based on their collapsed statistics. Microbots may need to be excluded from the data if they are too small or large for the study, going too slow, or stuck to the substrate. Use [`filter_trajectories`](@ref) for the most common filters. ([Filtering based on collapsed data](@ref)).
```julia
filter_settings = (
    MIN_VELOCITY = 10.0,  # um / s  
    MIN_BOUNDING_RADIUS = 3.38,  # um
    MAX_BOUNDING_RADIUS = 75,  # µm
    MIN_DISPLACEMENT = 0,  # µm
)

fcd = filtered_collapsed_data = filter_trajectories(collapsed_data, filter_settings)
```

- **View the data on a experiment wide scale** with the `collapsed_data`. MicroTracker reexports [Plots.jl](https://docs.juliaplots.org/stable/) and [StatsPlots.jl](https://docs.juliaplots.org/latest/generated/statsplots/) for convenience.
```julia
@df fcd scatter(:R, :V, group=:B_mT, xlims=(0, 40), ylims=(0, 100), xlabel="R (µm)", ylabel="V (µm/s)", leg_title = "B (mT)")
```

- **Or view on a trajectory specific scale** using the [`trajectory_analyzer`](@ref).
```julia
chosen_particle = fcd.particle_unique[2]
trajectory_analyzer(linked_data, collapsed_data, chosen_particle)
```

# What's next?
1. Dive deeper with the included MicroTracker Pluto notebook and the the interactive version of the [`trajectory_analyzer`](@ref) on the [Pluto](@ref) page.
2. Get started with using your own data and experiments in [Experimental](@ref) and [Segmentation](@ref).

# Quick Start

This page is an abridged version of the documentation which runs through using MicroTracker with sample data. At the end of each bullet, there will be a link to the full section for more detailed explanation.

- **Install Julia** from their [website](https://julialang.org/downloads/platform/), making sure to add julia to your PATH. ([Download and install Julia](@ref))
- **Open a terminal** in a new, empty folder, and type `julia` to open a julia REPL in that directory. ([Open a Julia REPL in a directory](@ref))
- **Create a fresh julia environment and install MicroTracker** and Pluto into it using the following two commands you can paste into the Julia REPL.
```
] activate .
```
```
add MicroTracker Pluto PlutoUI
```
- **Import MicroTracker** and Pluto into your namespace using the following command. Make sure you press backspace to get out of the [Pkg mode](https://docs.julialang.org/en/v1/stdlib/Pkg/) before running this command.
```julia
using MicroTracker, Pluto, PlutoUI
```


## Use interactive trajectory analyzer in Pluto

## Use your own data

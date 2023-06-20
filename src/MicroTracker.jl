__precompile__() # this module is safe to precompile
module MicroTracker

# For linking, we use trackpy's linker, so we need an interface to 1 python function
# See PyCall docs on how this was set up
# https://github.com/JuliaPy/PyCall.jl#quick-start

using PyCall  # maybe import conda first?

const np = PyNULL()
const tp = PyNULL()
const pd = PyNULL()

function __init__()
    copy!(np, pyimport_conda("numpy", "numpy"))
    copy!(tp, pyimport_conda("trackpy", "trackpy"))
    copy!(pd, pyimport_conda("pandas", "pandas"))
end

using CSV, DataFrames, DataFramesMeta, Dates  # data manipulation
using Optim, Statistics, FFTW  # FFT
using Reexport
#using CairoMakie, GLMakie, AlgebraOfGraphics  # plotting for publication and interactives

@reexport using DataFramesMeta  # This also reexports DataFrames for users

include("numerical.jl")

include("developer_utilities.jl")
export get_assets_path

include("particle_data.jl")

include("linked_data.jl")
export particle_data_to_linked_data, batch_particle_data_to_linked_data, save_linked_data_with_timestamp

include("collapsed_data.jl")
export load_linked_data, collapse_data, filter_trajectories

include("fft.jl")
export fit_line, fftclean

include("project_creation.jl")
export create_project

#include("plotting.jl")
#export basic_plot, example_plot

end

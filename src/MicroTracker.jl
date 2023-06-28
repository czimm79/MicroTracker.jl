__precompile__() # this module is safe to precompile, needed for pycall
module MicroTracker

# For linking, we use trackpy's linker, so we need an interface to 1 python function
# See PyCall docs on how this was set up
# https://github.com/JuliaPy/PyCall.jl#quick-start

using Conda, PyCall 

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
using CairoMakie

@reexport using DataFramesMeta  # This also reexports DataFrames for users

include("numerical.jl")
export fit_line, fftclean

include("developer_utilities.jl")
export get_assets_path

include("project_creation.jl")
export create_project_here, create_imagej_macro_here

include("image_manipulation.jl")
export loadframe, getvideoresolution

include("particle_data.jl")

include("linked_data.jl")
export particle_data_to_linked_data, batch_particle_data_to_linked_data, save_linked_data_with_metadata
export find_trajectory_bounds, clip_trajectory_edges

include("collapsed_data.jl")
export load_linked_data, collapse_data, filter_trajectories

end

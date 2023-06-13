__precompile__() # this module is safe to precompile
module MicroTracker

# For linking, we use trackpy's linker, so we need an interface to 1 python function
# See PyCall docs on how this was set up
# https://github.com/JuliaPy/PyCall.jl#quick-start

using PyCall

const np = PyNULL()
const tp = PyNULL()
const pd = PyNULL()

function __init__()
    copy!(np, pyimport_conda("numpy", "numpy"))
    copy!(tp, pyimport_conda("trackpy", "trackpy"))
    copy!(pd, pyimport_conda("pandas", "pandas"))
end

using CSV, DataFrames, DataFramesMeta
using Optim, Statistics, FFTW
using Reexport

@reexport using DataFramesMeta  # This also reexports DataFrames for users

include("numerical.jl")

include("developer_utilities.jl")
export get_assets_path

include("particle_data.jl")

include("linked_data.jl")

include("collapsed_data.jl")
export read_linked_csv, collapse_time_data

include("fft.jl")
export fit_line, fftclean

include("project_creation.jl")
export create_project


end

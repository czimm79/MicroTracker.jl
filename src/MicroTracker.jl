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
    # Set the PYTHON environment variable to use Conda's Python
    @info "Setting PyCall to use the Python in the root Conda.jl environment."
    # 1. Use the environment variable CONDA_PREFIX if available, fallback to root env otherwise
    default_env = get(ENV, "CONDA_PREFIX", Conda.ROOTENV)
    # 2. Use the environment variable MICROTRACKER_PREFIX if available, fallback to conda_env otherwise
    env = get(ENV, "MICROTRACKER_JL_PREFIX", default_env)
    
    python_in_env = joinpath(env, "bin", Sys.iswindows() ? "python.exe" : "python")
    if isfile(python_in_env)
        default_python = python_in_env
    else
        # Python is not where we expect it to be. Fallback to conservative defaults.
        default_python = joinpath(Conda.PYTHONDIR, "python")
        env = Conda.ROOTENV
    end
    # Do not override user if they have already set ENV["PYTHON"]
    ENV["PYTHON"] = get(ENV, "PYTHON", default_python)
    
    @info "MicroTracker.jl is using Python located at $(ENV("PYTHON")) with the environment prefix $env."

    if !all(["numpy", "trackpy", "pandas"] .∈ Ref(collect(Conda._installed_packages(env))))
        # if the needed python packages are not installed in the root Conda.jl env
        
        # Adding trackpy from the conda-forge channel
        Conda.add_channel("conda-forge", env)
        
        # Add Conda packages
        Conda.add("numpy", env)
        Conda.add("pandas", env)
        Conda.add("trackpy", env)
    end

    copy!(np, pyimport("numpy"))
    copy!(tp, pyimport("trackpy"))
    copy!(pd, pyimport("pandas"))
    
end

using CSV, DataFrames, DataFramesMeta  # data manipulation
using Optim, Statistics, FFTW  # FFT
using Reexport
using ImageIO, FileIO  # image loading, can also use Images but this is more lightweight
@reexport using DataFramesMeta  # This also reexports DataFrames for users
@reexport using StatsPlots  # also reexports Plots

include("numerical.jl")
export fit_line, fftclean, estimate_omega

include("developer_utilities.jl")
export get_assets_path

include("project_creation.jl")
export create_project_here, create_imagej_macro_here

include("image_manipulation.jl")
export loadframe, getvideoresolution

include("particle_data.jl")
export load_particle_data, add_info_columns_from_filename, add_resolution_column!

include("linked_data.jl")
export particle_data_to_linked_data, batch_particle_data_to_linked_data, save_linked_data_with_metadata
export find_trajectory_bounds, clip_trajectory_edges, link, add_useful_columns

include("collapsed_data.jl")
export load_linked_data, collapse_data, filter_trajectories

include("plotting.jl")
export trajectory_analyzer,  plotannotatedframe, plotannotatedframe_single, animate_trajectory_analyzer
end

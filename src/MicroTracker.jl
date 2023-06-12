__precompile__() # this module is safe to precompile
module MicroTracker

# For linking, we use trackpy's linker, so we need an interface to 1 python function
# See PyCall docs on how this was set up
# https://github.com/JuliaPy/PyCall.jl#quick-start

using PyCall

const np = PyNULL()
const tp = PyNULL()

function __init__()
    copy!(np, pyimport_conda("numpy", "numpy"))
    copy!(tp, pyimport_conda("trackpy", "trackpy"))
end


include("linking.jl")

include("data_wrangling.jl")
export read_linked_csv, collapse_time_data

include("fft.jl")
export fit_line, fftclean

include("project_creation.jl")
export create_project


end

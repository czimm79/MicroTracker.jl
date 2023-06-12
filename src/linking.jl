# Main hurdle is incorporating a small python version in this package - should do a micro test
using PythonCall, CondaPkg

# See PythonCall docs on how this was set up
# https://cjdoris.github.io/PythonCall.jl/stable/pythoncall/#pythoncall-config

const np = PythonCall.pynew()
const tp = PythonCall.pynew()

function __init__()
    # numpy
    PythonCall.pycopy!(np, pyimport("numpy"))

    # trackpy
    #CondaPkg.add("trackpy")
    #PythonCall.pycopy!(tp, pyimport("trackpy"))
end

"""
    npsin(a)

Placeholder test function that wraps `np.sin` from Python's numpy library.
"""
function npsin(a)
    np.sin(a)
end

"""
    get_particle_csvs()

Return a list of all `.csv` files contained in the `particle_data` folder.
"""
function get_particle_csvs()
    filter!(x->occursin(".csv", x), readdir("particle_data"))
end


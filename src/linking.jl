# Main hurdle is incorporating a small python version in this package - should do a micro test
using PythonCall, CondaPkg

# See PythonCall docs on how this was set up
# https://cjdoris.github.io/PythonCall.jl/stable/pythoncall/#pythoncall-config

const np = PythonCall.pynew()
const tp = PythonCall.pynew()

# function __init__()
#     # numpy
#     PythonCall.pycopy!(np, pyimport("numpy"))

#     # trackpy
#     CondaPkg.add("trackpy")
#     PythonCall.pycopy!(tp, pyimport("trackpy"))
# end

# function npsin(a)
#     np.sin(a)
# end
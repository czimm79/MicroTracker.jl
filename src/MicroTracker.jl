module MicroTracker

# Load in python for trackpy linking
include("linking.jl")
export(pyconvert)

include("data_wrangling.jl")
export read_linked_csv, collapse_time_data

include("fft.jl")
export fit_line, fftclean

include("project_creation.jl")
export create_project



"""
    add_three(x)

Compute `x+3`. Used as an example test function to ensure tests are working correctly.
"""
function add_three(x)
    x + 3
end

export add_three
end

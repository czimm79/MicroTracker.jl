module MicroTracker

include("data_wrangling.jl")
export read_linked_csv, collapse_time_data

include("fft.jl")
include("project_creation.jl")

export fit_line, fftclean
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

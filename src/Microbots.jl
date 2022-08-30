module Microbots

# Write your package code here.
include("fft.jl")

export fit_line, fftclean

"""
    add_three(x)

Compute `x+3`. Used as an example test function to ensure tests are working correctly.
"""
function add_three(x)
    x + 3
end

export add_three
end

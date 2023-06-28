"""
    get_asset_path()

Always returns the path to the assets folder in the package root directory.

This works from the dev's, test suite's, or user's perspective.
"""
function get_assets_path()
    # four cases: actively developing, running project creation test, running other tests, or using the package
    # actively developing
    if isdir("src")  # we're in the package root
        assets_path = joinpath(pwd(), "assets")
    
    # we're running project creation test
    elseif occursin("deletethis", pwd())
        assets_path = joinpath(dirname(dirname(pwd())), "assets") # go up two directories
   
    # we're running tests
    elseif basename(pwd()) == "test"
        assets_path = joinpath(dirname(pwd()), "assets")
    
     # we're using the package
    else
        microtracker_path = pathof(@__MODULE__) |> dirname |> dirname  # go up two directories
        assets_path = joinpath(microtracker_path, "assets")  # here's where the examples live!
    end

    return assets_path
end

"""
    pydf_to_jldf(pydf)

Convert a `pandas.DataFrame` to a `DataFrame` (from `DataFrames.jl`). Used internally to interface with
`trackpy`.
"""
function pydf_to_jldf(pydf)
    jldf = CSV.File(IOBuffer(pydf.to_csv())) |> DataFrame
    # when converting, the python index is created as a new column named "column1". Delete it.
    "Column1" in names(jldf) && select!(jldf, Not("Column1"))
    
    return jldf
end

"""
    jldf_to_pydf(jldf)

Convert a `DataFrame` (from `DataFrames.jl`) to a `pandas.DataFrame`. Used internally to interface with
`trackpy`.
"""
function jldf_to_pydf(jldf)
    io = IOBuffer()
    CSV.write(io, jldf)
    seekstart(io)
    pydf = pd.read_csv(io)
    
    return pydf
end

"""
    translation_dict_to_string(translation_dict::Dict)

Convert a dictionary into a string that can be used as a filename. Used internally to save linked_data.

# Example
```jldoctest
julia> test_translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, Float64));

julia> MicroTracker.translation_dict_to_string(test_translation_dict)
"B_mT=(2, Float64), FPS=(3, Float64), f_Hz=(1, Int64)"
```
"""
function translation_dict_to_string(translation_dict::Dict)
    return join([string(k, "=", repr(v)) for (k, v) in translation_dict], ", ")
end


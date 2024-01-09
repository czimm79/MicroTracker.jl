"""
    get_assets_path()

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

"""
    parse_to_tuple(s::AbstractString)

Convert a string to a Tuple{Int64, Int64}. Internal function used in [`load_linked_data`](@ref).
"""
function parse_to_tuple(s::AbstractString)
    # remove the parenthesis and split the string by comma
    str_numbers = split(replace(s, r"[()]" => ""), ",") 
    # convert the string numbers to integers
    numbers = parse.(Int64, str_numbers)
    # convert the array to a tuple
    return Tuple(numbers)
end

"""
    download_original_video_artifact()

Use the Artifacts Pkg system to fetch the example video and download into the assets folder.
"""
function download_original_video_artifact()
    @info "Downloading example videos..."
    artifact_path = artifact"original_video"  # origin
    video_names = filter(s->!startswith(s, "."), readdir("$artifact_path/original_video"))

    assets_path = get_assets_path()  # destination

    # check if they've already been downloaded
    if isdir("$assets_path/original_video")
        if verify_download()
            @info "Download verified."
            return
        end
    end

    mkdir("$assets_path/original_video")
    for vidname in video_names
        video_artifact_path = "$artifact_path/original_video/$vidname"
        imgnames = filter(s->!startswith(s, "."), readdir(video_artifact_path))  # array of tif names
        mkdir("$assets_path/original_video/$vidname")
        for i in imgnames
            cp("$video_artifact_path/$i", "$assets_path/original_video/$vidname/$i")
        end    
    end
    @info "Example videos successfully copied."
    
end

"""
    verify_download()

Verify that the example videos are downloaded into the MicroTracker assets folder in their entirety.

Returns true or false.
"""
function verify_download()
    assets_path = get_assets_path()
    
    # check if everything is there. If all pass, return true.
    original_video_dirname = "$assets_path/original_video"
    if isdir(original_video_dirname)
        measured_video_names = readdir(original_video_dirname)
        if all(["5_13p5_61p35", "5_8p4_28p68"] .∈ Ref(measured_video_names))
            # the video folders exist. now check the tifs in each.
            imgnames_513 = ["a$(string(num,pad=4)).tif" for num in 0:362]
            imgnames_584 = ["a$(string(num,pad=4)).tif" for num in 0:40]

            measured_imgnames_513 = readdir("$original_video_dirname/5_13p5_61p35")
            measured_imgnames_584 = readdir("$original_video_dirname/5_8p4_28p68")

            for (actual, measured) in zip([imgnames_513, imgnames_584], [measured_imgnames_513, measured_imgnames_584])
                if !(all(measured .∈ Ref(actual)))
                    return false
                end
            end
            # Everything passed!
            return true
        end
    end
    return false
end

"""
    check_working_directory()

Check if the MicroTracker folders are accessible from the current working directory.
    
Return true if folders are there, throws an error if not.
"""
function check_working_directory()
    microtracker_folders = ["particle_data", "linked_data", "original_video"]
    bitvector = map(i->isdir(i), microtracker_folders)
    if !(all(bitvector))
        error("""Cannot find the MicroTracker folders in the current directory.
        1. Have you used the `create_project_here` function?
        2. Are you in the correct directory? Use the `pwd` function to check.""")
    else
        return true
    end
end
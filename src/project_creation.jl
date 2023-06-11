using Git

"""
    create_project(folder::String, include_examples=true)

Create the project!
"""
function create_project(folder::AbstractString; include_examples=true)
    if include_examples
        run(git(["clone", "https://github.com/czimm79/ExampleMicroTrackerData"]))
        mv("ExampleMicroTrackerData", folder)  # rename
    else
        mkdir(folder)
        mkdir("$folder/imagej_data")
        mkdir("$folder/linked_results")
        mkdir("$folder/original_video")
    end
end


function copy_examples_into_pwd()
    # get dir of microtracker assets folder
    microtracker_path = pathof(@__MODULE__) |> dirname |> dirname
    assets_path = joinpath(microtracker_path, "assets")

    # Which file/files should be copied into the pwd
    filename = "test_example_script.jl"

    # do it
    cp(joinpath(assets_path, filename), joinpath(pwd(), filename))
end
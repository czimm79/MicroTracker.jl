
function create_project(folder::AbstractString; include_examples=false)
    # make the general structure
    isdir(folder) && @error "The folder $folder already exists! This command creates a new folder for the project."

    mkdir(folder)
    mkdir("$folder/particle_data")
    mkdir("$folder/linked_results")
    mkdir("$folder/original_video")

    if include_examples
        # find the path to the assets in the package
        microtracker_path = pathof(@__MODULE__) |> dirname |> dirname  # go up two directories
        assets_path = joinpath(microtracker_path, "assets")  # here's where the examples live!
 
        # copy over particle data
        example_data_path = joinpath(assets_path, "particle_data")
        example_data_paths = [joinpath(example_data_path, i) for i in readdir(example_data_path)]

        for data_path in example_data_paths
            cp(data_path, joinpath(folder, "particle_data", basename(data_path)))
        end

        # copy over videos
        example_original_video_path = joinpath(assets_path, "original_video")
        example_video_paths = [joinpath(example_original_video_path, i) for i in readdir(example_original_video_path)]

        for video_path in example_video_paths
            cp(video_path, joinpath(folder, "original_video", basename(video_path)))
        end
    end

end

function simple_example_asset_copy()
    # get dir of microtracker assets folder
    microtracker_path = pathof(@__MODULE__) |> dirname |> dirname
    assets_path = joinpath(microtracker_path, "assets")

    # Which file/files should be copied into the pwd
    filename = "test_example_script.jl"

    # do it
    cp(joinpath(assets_path, filename), joinpath(pwd(), filename))
end

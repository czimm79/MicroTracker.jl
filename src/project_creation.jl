function create_project(folder::AbstractString; include_examples=false)
    # make the general structure
    isdir(folder) && @error "The folder $folder already exists! This command creates a new folder for the project."

    mkdir(folder)
    mkdir("$folder/particle_data")
    mkdir("$folder/linked_data")
    mkdir("$folder/original_video")

    if include_examples
        assets_path = get_assets_path()
 
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


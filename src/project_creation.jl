"""
    create_project_here(;include_examples=false)

Create the folder structure for a MicroTracker project *in the current working directory*.

If `include_examples` is true, then example particle data and videos will be included.
"""
function create_project_here(;include_examples=false)
    # make the general structure
    mkdir("particle_data")
    mkdir("linked_data")
    mkdir("original_video")

    if include_examples
        assets_path = get_assets_path()

        # copy over particle data
        example_data_path = joinpath(assets_path, "particle_data")
        example_data_paths = [joinpath(example_data_path, i) for i in readdir(example_data_path)]

        for data_path in example_data_paths
            cp(data_path, joinpath("particle_data", basename(data_path)))
        end

        # copy over videos
        example_original_video_path = joinpath(assets_path, "original_video")
        example_video_paths = [joinpath(example_original_video_path, i) for i in readdir(example_original_video_path)]

        for video_path in example_video_paths
            cp(video_path, joinpath("original_video", basename(video_path)))
        end

        # copy over linked data
        example_linked_data_path = joinpath(assets_path, "linked_data")
        example_linked_data_paths = [joinpath(example_linked_data_path, i) for i in readdir(example_linked_data_path)]

        for linked_data_path in example_linked_data_paths
            cp(linked_data_path, joinpath("linked_data", basename(linked_data_path)))
        end
    end
    @info "New MicroTracker project created in $(pwd())"
end

function create_imagej_macro_here(;MPP, minimum_segmentation_diameter)
    filename = "imagej_macro.ijm"
    io = open(filename, "w")

    # write some text to the file
    text = """
    Hello, world! I am in:
    $(pwd())
    I have a MPP of $MPP and a minimum segmentation diameter of $minimum_segmentation_diameter.
    """
    print(io, text)

    # close the file
    close(io)
end
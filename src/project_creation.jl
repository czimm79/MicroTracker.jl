"""
    create_project_here()
    create_project_here(include_examples=false)

Create the folder structure for a MicroTracker project *in the current working directory*.

If `include_examples` is false, then example particle data and videos will not be included.

# Example
```julia-repl
julia> pwd()
"~/tutorial"

julia> create_project_here()
[ Info: New MicroTracker project created in ~/tutorial
```
"""
function create_project_here(;include_examples=true)
    # make the general structure
    mkdir("particle_data")
    mkdir("linked_data")
    mkdir("original_video")

    assets_path = get_assets_path()

    # copy over notebook
    notebook_path = joinpath(assets_path, "notebook.jl")
    cp(notebook_path, joinpath(pwd(), "notebook.jl"))

    if include_examples
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

"""
    create_imagej_macro_here(;MPP::Float64, minimum_segmentation_diameter::Float64)

Create a macro script for batch segmenting videos in `original_video` with Fiji.

Required keyword arguments:
- `MPP` : microns per pixel, `Float64` (unique to your microscope setup!)
- `minimum_segmentation_diameter` : only particles above this diameter*1.5 in microns will be segmented, `Float64`. See the following reference for why the 1.5:

J. Baumgartl, J. L. Arauz-Lara, and C. Bechinger, “Like-charge attraction in confinement: myth or truth?,”  
Soft Matter, vol. 2, no. 8, p. 631, 2006, doi: 10.1039/b603052a.

# Example
```julia-repl
julia> create_imagej_macro_here(MPP=0.605, minimum_segmentation_diameter=4.5)
[ Info: ImageJ macro created at ~/tutorial/imagej_macro.ijm. See MicroTracker segmentation docs for instructions on how to use it. 
```
"""
function create_imagej_macro_here(;MPP::Float64, minimum_segmentation_diameter::Float64)
    filename = "imagej_macro.ijm"
    io = open(filename, "w")

    # write some text to the file
    text = """
    microtracker_directory = "$(pwd())"

    input_folder = microtracker_directory + "/original_video"
    output_folder = microtracker_directory + "/particle_data"

    // min_size Calculation and Explanation
    // I want to exclude imaging artifacts (dust, speck on camera) that would be less than a monomer, accounting for
    // optical imaging artifacts. The corona of the colloid extends to about 1.5sigma, or 6.75 um diameter.
    // If you're not getting monomers tracked, decrease minimum_segmentation_diameter by ~20% until they are!
    // You'll have another chance to filter based on size when linking, so I see this as the 'coarse' step.
    bead_d = $minimum_segmentation_diameter  // µm
    MPP = $MPP  // microns per pixel. unique to your microscope setup!
    min_size_guess = PI * (bead_d * 1.5 / MPP / 2)^2   // pixels^2
    min_size = min_size_guess  // pixels^2

    THRESHOLD = 110  // ONLY used if constant threshold binary is enabled. Commented out by default.

    function batch(input_folder, output_folder) {
        // Looks inside input_folder and for each image stack, uses the process function on it.
        list = getFileList(input_folder);
        //print(list.length);
        for (i = 0; i < list.length; i++){
            name = substring(list[i], 0, lengthOf(list[i]) - 1);  // removes trailing bracket
            process(name, input_folder, output_folder);
    }
    }

    function process(stack_name, input_folder, output_folder) {
        // Do image processing on stack_name and output results in a csv to output_folder.
        stack_path = input_folder + "/" + stack_name + "/";
        output_path = output_folder + "/" + stack_name + ".csv";
        
        // Process
        print(stack_name);
        run("Image Sequence...", "select=&stack_path dir=&stack_path sort");

        // Constant threshold binary
    //	run("Threshold...");
    //	setThreshold(0, THRESHOLD);
    //	setOption("BlackBackground", true);
    //	run("Convert to Mask", "method=Default background=Light black");
    //	run("Close");

        // Other way of making binary without choosing a threshold. Works similar, can use this if wanted.
        run("Make Binary", "method=Default background=Default calculate black");
        
        run("Set Measurements...", "area centroid center circularity fit display redirect=None decimal=3");
        run("Analyze Particles...", "size=min_size-Infinity show=Outlines display clear stack");

        run("Close");
        run("Close");
        saveAs("Results", output_path);
    }


    batch(input_folder, output_folder)
    """
    print(io, text)

    # close the file
    close(io)

    @info "ImageJ macro created at $(pwd())/$filename. See MicroTracker segmentation docs for instructions on how to use it."
end
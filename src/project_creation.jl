using Git

"""
    create_project(folder::String, include_examples=true)

Create the project!
"""
function create_project(folder::String; include_examples=true)
    if include_examples
        run(git(["clone", "https://github.com/czimm79/ExampleMicroTrackerData"]))
        # need to make the include examples look the same as the one without
    
    else
        mkdir(folder)
        mkdir("$folder/imagej_data")
        mkdir("$folder/linked_results")
        mkdir("$folder/original_video")

    end
end

#b = download("https://github.com/czimm79/ExampleMicroTrackerData/blob/main/original_video/aero_1_0714")


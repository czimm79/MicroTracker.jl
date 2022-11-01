function create_project(folder::AbstractString, include_examples=true)
    mkdir(folder)
    mkdir("$folder/imagej_data")
    mkdir("$folder/linked_results")
    mkdir("$folder/original_video")

end

#b = download("https://github.com/czimm79/ExampleMicroTrackerData/blob/main/original_video/aero_1_0714")


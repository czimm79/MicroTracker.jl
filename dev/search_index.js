var documenterSearchIndex = {"docs":
[{"location":"api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"api/","page":"API","title":"API","text":"I see this as a section that contains the function docstrings for everything in the package.\nI'll have to think about how to break it down into modules so its sorted here and easily digestible.","category":"page"},{"location":"api/","page":"API","title":"API","text":"Modules = [MicroTracker]","category":"page"},{"location":"api/#MicroTracker.add_info_columns_from_filename-Tuple{AbstractDataFrame, Dict}","page":"API","title":"MicroTracker.add_info_columns_from_filename","text":"add_info_columns_from_filename(particle_data::AbstractDataFrame, translation_dict::AbstractDict)\n\nExtract experimental metadata from the filename column and create a new column for each.\n\nAssumes the filename is separated by underscores and periods are denoted by p. The translation_dict details the filename format. For full explanation, see the MicroTracker docs (ref needed).\n\nExample\n\njulia> test_filename = \"5_13p5_61p35\"\n\"5_13p5_61p35\"\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.add_resolution_column!-Tuple{AbstractDataFrame}","page":"API","title":"MicroTracker.add_resolution_column!","text":"add_resolution_column(particle_data::AbstractDataFrame)\n\nLook at a frame of the video in original_video which corresponds to the data and add a column.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.add_useful_columns-Tuple{AbstractDataFrame, NamedTuple}","page":"API","title":"MicroTracker.add_useful_columns","text":"add_useful_columns(linked_data::AbstractDataFrame, linking_settings::NamedTuple)\n\nAfter linking, add some useful columns to the dataframe. \n\nThese include dx, dy, dp (velocity), and size measurements in microns.  (more detailed docs needed if this is an interface for users)\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.batch_particle_data_to_linked_data-Tuple{Dict, NamedTuple}","page":"API","title":"MicroTracker.batch_particle_data_to_linked_data","text":"batch_particle_data_to_linked_data(translation_dict::Dict, linking_settings::NamedTuple)\n\nProcess all .csv files in particle_data into linked trajectory data and concatenate the results.\n\nReturns a DataFrame containing all linked data for the entire experimental array. This is also saved to linked_data  using save_linked_data_with_timestamp for further analysis.\n\nThe translation_dict` is a dictionary detailing the information contained in the filename. For full explanation,  see the MicroTracker docs (ref needed).\n\njulia> 1 + 1\n2\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.clip_trajectory_edges-Tuple{AbstractDataFrame, NamedTuple}","page":"API","title":"MicroTracker.clip_trajectory_edges","text":"clip_trajectory_edges(linked_data::AbstractDataFrame)\n\nIterate through each trajectory and remove the tracking data where the particle is out of frame.\n\nThe particle is out of frame when the center is within the radius of the particle from the edge of the video.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.collapse_data-Tuple{AbstractDataFrame}","page":"API","title":"MicroTracker.collapse_data","text":"collapse_data(linked_data::AbstractDataFrame)\n\nCollapse each time-series microbot trajectory into a single row of summary data for each microbot.\n\nFor full description of each output variable, see these docs (ref needed).\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.create_project_here-Tuple{}","page":"API","title":"MicroTracker.create_project_here","text":"create_project_here(;include_examples=false)\n\nIn the current working directory, create the folder structure for a MicroTracker project.\n\nIf include_examples is true, then example particle data and videos will be included.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.detrend-Tuple{AbstractVector}","page":"API","title":"MicroTracker.detrend","text":"detrend(y::AbstractVector)\n\nRemove a linear trend in y.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.estimate_omega-Tuple{AbstractVector, AbstractVector}","page":"API","title":"MicroTracker.estimate_omega","text":"estimate_omega(x::AbstractVector, y::AbstractVector)\n\nGet the highest frequency peak of x, y data and return the corresponding xf divided by 2.\n\nThis works for rolling microbots when the y data exhibits two peaks every rotation. Depending on the data, this could be the Angle, Major_m, or V columns.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.extract_frame_from_label-Tuple{AbstractString}","page":"API","title":"MicroTracker.extract_frame_from_label","text":"extract_frame_from_label(label::AbstractString)\n\nWhen using ImageJ data, the frame column does not exist, so we need to pull it out of the label column.\n\nThis function assumes the frame number is at the end of the label, and that it is the only number in the label.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.fftclean-Tuple{AbstractVector, AbstractVector}","page":"API","title":"MicroTracker.fftclean","text":"fftclean(x::AbstractVector, y::AbstractVector)\n\nTransform time data x, y into the frequency domain. Returns xf, yf.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.filter_trajectories-Tuple{AbstractDataFrame, NamedTuple}","page":"API","title":"MicroTracker.filter_trajectories","text":"filter_trajectories(collapsed_data::AbstractDataFrame, filter_settings::NamedTuple)\n\nDocs needed.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.find_relevant_FPS-Tuple{AbstractDataFrame, NamedTuple}","page":"API","title":"MicroTracker.find_relevant_FPS","text":"find_relevant_FPS(particle_data::AbstractDataFrame, linking_settings::NamedTuple)\n\nUsed to allow for the FPS to be specified in the filename, or in the linking_settings. \n\nIf FPS is in the particledata, it will be used. If FPS is in the linkingsettings, it will be used. If FPS is in both, an error will be thrown.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.find_trajectory_bounds-Tuple{AbstractDataFrame}","page":"API","title":"MicroTracker.find_trajectory_bounds","text":"find_trajectory_bounds(df_1particle::AbstractDataFrame, video_resolution::Tuple{Int, Int})\n\nReturn a tuple of frame numbers, (low, high) where all trajectory points are in bounds.\n\nThis calculates the radius of the particle, then iterates forward and backward from the center of the trajectory until it finds a point that is out of bounds. This is the high and low bound of the trajectory.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.fit_line-Tuple{AbstractVector, AbstractVector}","page":"API","title":"MicroTracker.fit_line","text":"fit_line(x::AbstractVector, y::AbstractVector)\n\nFit a linear equation to data x, y. Returns m, b.\n\ny = mx + b\n\nDependent on Optim.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.get_assets_path-Tuple{}","page":"API","title":"MicroTracker.get_assets_path","text":"get_asset_path()\n\nAlways returns the path to the assets folder in the package root directory.\n\nThis works from the dev's, test suite's, or user's perspective.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.get_names_in_particle_data-Tuple{}","page":"API","title":"MicroTracker.get_names_in_particle_data","text":"get_names_in_particle_data()\n\nReturn a list of all .csv files contained in the particle_data folder.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.getfileextension-Tuple{AbstractString}","page":"API","title":"MicroTracker.getfileextension","text":"getfileextension(imagename::AbstractString)\n\nGet the file extension from the image name.\n\nExample\n\njulia> MicroTracker.getfileextension(\"a0001.tif\")\n\"tif\"\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.getframenumfromimagename-Tuple{AbstractString}","page":"API","title":"MicroTracker.getframenumfromimagename","text":"getframenumfromimagename(imagename::AbstractString)\n\nGet the relevant frame number from the name of an image.  Does not necessarily match the real frame number in the data.\n\nExample\n\njulia> MicroTracker.getframenumfromimagename(\"5 24p9 1 2022-04-04-16-30-31-16-a-985.tif\")\n985\n\njulia> MicroTracker.getframenumfromimagename(\"05_23_8_2 kept stack0001.tif\")\n1\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.getimagenamedigitlength-Tuple{AbstractString}","page":"API","title":"MicroTracker.getimagenamedigitlength","text":"getimagenamedigitlength(tifname::AbstractString)\n\nGet the length of the digits quantifying the frame in the image name. Used to catch leading zeros.\n\nExample\n\njulia> MicroTracker.getimagenamedigitlength(\"05_23_8_2 kept stack0001.tif\")\n4\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.getprefixfromimagename-Tuple{AbstractString}","page":"API","title":"MicroTracker.getprefixfromimagename","text":"getprefixfromimagename(imagename::AbstractString)\n\nReturn the prefix from the name of an image. This is everything besides the <framenumbers>.tif.\n\nExample\n\njulia> MicroTracker.getprefixfromimagename(\"5 24p9 1 2022-04-04-16-30-31-16-a-985.tif\")\n\"5 24p9 1 2022-04-04-16-30-31-16-a-\"\n\njulia> MicroTracker.getprefixfromimagename(\"05_23_8_2 kept stack0001.tif\")\n\"05_23_8_2 kept stack\"\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.getvideoresolution-Tuple{AbstractString}","page":"API","title":"MicroTracker.getvideoresolution","text":"getvideoresolution(video_name::AbstractString)\n\nLoad in 1 frame of video_name and return the resolution of the video as a Tuple{Int, Int}\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.inbounds-Tuple{DataFrameRow, AbstractFloat, Tuple{Int64, Int64}}","page":"API","title":"MicroTracker.inbounds","text":"inbounds(row::DataFrameRow, radius::AbstractFloat, video_resolution::Tuple{Int, Int})\n\nCheck if dataframe row is in bounds. This is a single row in a dataframe of a single particle's trajectory.\n\nThis looks at x and y coordinates and checks if they are within radius of the edge of the video.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.jldf_to_pydf-Tuple{Any}","page":"API","title":"MicroTracker.jldf_to_pydf","text":"jldf_to_pydf(jldf)\n\nConvert a DataFrame (from DataFrames.jl) to a pandas.DataFrame. Used internally to interface with trackpy.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.link-Tuple{AbstractDataFrame, NamedTuple}","page":"API","title":"MicroTracker.link","text":"link(particle_data::AbstractDataFrame, linking_settings::NamedTuple)\n\nUse trackpy to link particle data into trajectories across frames.\n\nlinking_settings is a NamedTuple with the following all caps fields:\n\nSEARCH_RANGE_MICRONS::Float64:  microns/s. Fastest a particle could be traveling.\nMPP::Float64: Microns per pixel, scale of objective.\nFPS::Float64: Frames per second. Can omit if the FPS has been specified in the filename.\nSTUBS_SECONDS::Float64: seconds. All trajectories that exist less than this will be removed.\nMEMORY::Int64: Number of frames the particle can dissapear and still be remembered.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.load_linked_data-Tuple{Any}","page":"API","title":"MicroTracker.load_linked_data","text":"load_linked_data(filename)\n\nRead a linked data .csv file into a DataFrame. Assumes the .csv file is in the linked_data folder.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.load_particle_data-Tuple{AbstractString}","page":"API","title":"MicroTracker.load_particle_data","text":"load_particle_data(video_name::AbstractString)\n\nRead a particle data .csv into a DataFrame. Assumes the .csv file is in the particle_data folder.\n\nIf the .csv file is from ImageJ, it will:\n\nExtract the frame number from the label column and add it as a new column.\nRename the X and Y columns to x and y so it works with trackpy.\nRemove any blank columns.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.loadframe-Tuple{AbstractString, Integer}","page":"API","title":"MicroTracker.loadframe","text":"loadframe(vidname::AbstractString, framenumber::Integer)\n\nReturn an image corresponding to the framenumber frame in the video vidname. Must be present in the original_video folder.\n\nIt looks at the way the tifs are automatically named and matches the pattern. Does not necessarily match the real frame number in the data, especially if there is no particle in the first frame.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.numerical_derivative-Tuple{AbstractVector}","page":"API","title":"MicroTracker.numerical_derivative","text":"numerical_derivative(x::AbstractVector)\n\nReturn the derivative of a Vector with spacing h = 1. Use on x and y columns of tracking data. Similar to Python's np.gradient function, but 61x faster here.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.particle_data_to_linked_data-Tuple{AbstractString, Dict, NamedTuple}","page":"API","title":"MicroTracker.particle_data_to_linked_data","text":"particle_data_to_linked_data(video_name::AbstractString, translation_dict::Dict, linking_settings::NamedTuple)\n\nProcess particle data into linked trajectory data while calculating instantaneous velocity and other salient data. Returns a DataFrame that can then be saved to linked_data using save_linked_data_with_timestamp.\n\nA particle data csv corresponding to video_name must be present in the particle_data folder. The translation_dict` is a dictionary detailing the information contained in the filename. For full explanation,  see the MicroTracker docs (ref needed).\n\njulia> 1 + 1\n2\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.pydf_to_jldf-Tuple{Any}","page":"API","title":"MicroTracker.pydf_to_jldf","text":"pydf_to_jldf(pydf)\n\nConvert a pandas.DataFrame to a DataFrame (from DataFrames.jl). Used internally to interface with trackpy.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.save_linked_data_with_timestamp-Tuple{AbstractDataFrame}","page":"API","title":"MicroTracker.save_linked_data_with_timestamp","text":"save_linked_data_with_timestamp(linked_data::AbstractDataFrame)\n\nSave final linked data to linked_data folder with a timestamped filename.\n\n\n\n\n\n","category":"method"},{"location":"api/#MicroTracker.total_displacement-Tuple{AbstractVector, AbstractVector}","page":"API","title":"MicroTracker.total_displacement","text":"total_displacement(x::AbstractVector, y::AbstractVector)\n\nReturn the total displacement of the particle in pixels.\n\n\n\n\n\n","category":"method"},{"location":"experimental/#Experimental","page":"Experimental","title":"Experimental","text":"","category":"section"},{"location":"experimental/#Setup","page":"Experimental","title":"Setup","text":"","category":"section"},{"location":"experimental/","page":"Experimental","title":"Experimental","text":"A study contains multiple independent variables (temperature, field strength, microbot design, viscosity, geometry). You'll have a separate video for each of these.","category":"page"},{"location":"experimental/","page":"Experimental","title":"Experimental","text":"An example! Lets say we're studying temperature and field strength. Name your video names accordingly. Talk about file naming formats.","category":"page"},{"location":"experimental/#Crop-and-clip-your-video","page":"Experimental","title":"Crop and clip your video","text":"","category":"section"},{"location":"experimental/","page":"Experimental","title":"Experimental","text":"ImageJ (Fiji) is used to look at microscopy vids","category":"page"},{"location":"experimental/#Segment-and-make-binary-through-thresholding","page":"Experimental","title":"Segment and make binary through thresholding","text":"","category":"section"},{"location":"experimental/","page":"Experimental","title":"Experimental","text":"Have a macro here to do that:","category":"page"},{"location":"segmenting/#Segmenting-video-for-use-with-MicroTracker","page":"Segmenting video for use with MicroTracker","title":"Segmenting video for use with MicroTracker","text":"","category":"section"},{"location":"segmenting/#Intro","page":"Segmenting video for use with MicroTracker","title":"Intro","text":"","category":"section"},{"location":"segmenting/","page":"Segmenting video for use with MicroTracker","title":"Segmenting video for use with MicroTracker","text":"Image segmentation is the process of separating the image background (stuff we don't care about) from the foreground (stuff we care about). Here, our foreground are the microbots.","category":"page"},{"location":"segmenting/","page":"Segmenting video for use with MicroTracker","title":"Segmenting video for use with MicroTracker","text":"Segmentation can be performed with a variety of methods, from simple (thresholding), to advanced (training neural nets). MicroTracker does not segment videos, due to the variety of softwares and methods available that are specific to the microscopy techniques used. In this guide, we will use ImageJ/Fiji due to its simplicity, flexibility, and established use. However, you may use other software such as illastik if more advanced segmentation is needed, but a walkthrough of that is out of scope of this guide.","category":"page"},{"location":"segmenting/","page":"Segmenting video for use with MicroTracker","title":"Segmenting video for use with MicroTracker","text":"info: Info\nOn this page, we will process raw microscopy video into a .csv file that contains a row for each observation of a particle. This data does not contain any information about the video, like that the particles are moving/rotating between frames. That's where MicroTracker comes in.","category":"page"},{"location":"segmenting/#Setup","page":"Segmenting video for use with MicroTracker","title":"Setup","text":"","category":"section"},{"location":"segmenting/","page":"Segmenting video for use with MicroTracker","title":"Segmenting video for use with MicroTracker","text":"Make sure you're in the project folder, etc. docs for this section needed.","category":"page"},{"location":"overview/#Overview","page":"Overview","title":"Overview","text":"","category":"section"},{"location":"overview/","page":"Overview","title":"Overview","text":"So you have a suite of microscopy video of microbots? Here's how to go start to finish to analyze the data and create publication ready figures.","category":"page"},{"location":"overview/","page":"Overview","title":"Overview","text":"Here's a summary of what will happen in the following sections:","category":"page"},{"location":"overview/","page":"Overview","title":"Overview","text":"data preparation outside of this package\nstart using MicroTracker.jl\nanalyze data\nmake publication figures","category":"page"},{"location":"overview/#Installation","page":"Overview","title":"Installation","text":"","category":"section"},{"location":"overview/","page":"Overview","title":"Overview","text":"To install the package type:","category":"page"},{"location":"overview/","page":"Overview","title":"Overview","text":"julia> ] add MicroTracker","category":"page"},{"location":"overview/","page":"Overview","title":"Overview","text":"To use the package type","category":"page"},{"location":"overview/","page":"Overview","title":"Overview","text":"julia> using MicroTracker","category":"page"},{"location":"settingup/#Setting-Up-(for-beginners)","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"","category":"section"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"Using a notebook environment like Pluto or Jupyter doesn't work well when developing and contributing to an open source package. This page is a quick set up guide for using Visual Studio Code (VSCode) with the Julia extension to develop MicroTracker.jl.","category":"page"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"note: Note\nThis is by no means the only way to accomplish this. This is just the method I prefer and have found the easiest while developing MicroTracker.","category":"page"},{"location":"settingup/#VS-Code","page":"Setting Up (for beginners)","title":"VS Code","text":"","category":"section"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"Install Visual Studio Code and the Julia extension. \nEnsure you can run a hello world julia script, detailed in the getting started page.\nGet accustomed to running code in the integrated Julia REPL in VSCode using keybinds like shift+enter and ctrl+enter. This is also detailed in the extension docs here.\nAdd Revise.jl to your base Julia environment. By default, the VSCode Julia extension detects that its available and automatically loads it when starting a Julia extension integrated REPL in VSCode.","category":"page"},{"location":"settingup/#GitHub-Desktop","page":"Setting Up (for beginners)","title":"GitHub Desktop","text":"","category":"section"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"Download Github Desktop.\nFile -> Clone Repository -> paste in the URL for MicroTracker.jl. https://github.com/czimm79/MicroTracker.jl.\nRight click on Current Repository (MicroTracker.jl) -> Open in Visual Studio Code.","category":"page"},{"location":"settingup/#Setting-up-environment","page":"Setting Up (for beginners)","title":"Setting up environment","text":"","category":"section"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"The dependent packages for MicroTracker normally automatically install behind the scenes when you use ] add MicroTracker in the REPL. When developing, we need to instantiate that dependency environment.","category":"page"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"Open the command palette in VSCode (ctrl+shift+p) and select Julia: Start REPL. Activate the MicroTracker environment:","category":"page"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"(v1.8) pkg> activate .","category":"page"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"You should be able to run the test command in the pkg mode and all tests should pass. You are now ready to make changes!","category":"page"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"note: Note\nWhen opening the package, sometimes VSCode will automatically recognize that the MicroTracker environment should be activated, and do it for you. If this is the case, instead of (v1.8), you'll see MicroTracker, and you can skip step 2.","category":"page"},{"location":"settingup/#Common-hiccups","page":"Setting Up (for beginners)","title":"Common hiccups","text":"","category":"section"},{"location":"settingup/","page":"Setting Up (for beginners)","title":"Setting Up (for beginners)","text":"Sometimes when changing the dependencies of MicroTracker, the CI for the docs will fail. I fixed this by activating the docs env using activate ./docs and then resolve.","category":"page"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = MicroTracker","category":"page"},{"location":"#Home","page":"Home","title":"Home","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Welcome to the documentation for MicroTracker - a Julia package for analyzing microscopy videos of microbots.","category":"page"},{"location":"","page":"Home","title":"Home","text":"warning: Warning\nThis repository is under construction and not ready for use.","category":"page"},{"location":"#What-can-it-do?","page":"Home","title":"What can it do?","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"At its core, this package links together segmented microscopy video of microbots.","category":"page"},{"location":"","page":"Home","title":"Home","text":"This yields individual trajectories with time, position, and shape. Critical measurements like velocity, rotation rate, and traction can be obtained for an arbitrary amount of microbots across many experimental conditions.","category":"page"},{"location":"#Why-this-package?","page":"Home","title":"Why this package?","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"The alternatives for colloid particle tracking, like TrackPy and TrackMate, do not normally measure the shape or size of particles. For microbots that roll, swim, or walk, these measurements are essential. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"Additionally, with the explosion of the field of microrobotics and nano 3D printing, new designs are frequently reported. Every study of these new microbots involves the same measurements: velocity and swimming efficiency.","category":"page"},{"location":"#Why-Julia?","page":"Home","title":"Why Julia?","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In short, Julia is easy to read and write, yet retains the speed of statically compiled languages like C and Fortran. It also provides Pluto.jl, a reactive notebook environment that solves all the frustration I've had with Jupyter notebooks and Mathematica. For a more eloquent explanation, see the Julia introduction.","category":"page"},{"location":"","page":"Home","title":"Home","text":"If you don't know Julia, don't worry. It is similar and as easy as Python (I'd argue easier). The best learning source is the Computational Thinking course from MIT.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Lastly, the Pluto notebooks included with this package allow you to tinker with established workflows, minimizing the need to reinvent the wheel.","category":"page"}]
}
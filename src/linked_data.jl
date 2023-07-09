# Functions relating to the linking of particle data and subsequent wrangling of those linked results.

"""
    find_relevant_FPS(particle_data::AbstractDataFrame, linking_settings::NamedTuple)

Used to allow for the FPS to be specified either in the filename or in the linking_settings. 

If FPS is in the particle_data, it will be used. If FPS is in the linking_settings, it will be used. If FPS is in both, an error will be thrown.
"""
function find_relevant_FPS(particle_data::AbstractDataFrame, linking_settings::NamedTuple)
    # two cases: FPS has already been added by [`add_info_columns_from_filename`](@ref), or it is in the named tuple
    is_FPS_in_linking_settings = haskey(linking_settings, :FPS)
    is_FPS_in_particle_data = "FPS" in names(particle_data)

    if is_FPS_in_linking_settings && is_FPS_in_particle_data
        error("""FPS is in both the particle_data and the linking_settings. FPS should only be in one or the other.
        1) If your videos are all the same FPS, just put the FPS in the linking_settings. Do not have it in the translation_dict.
        2) If your videos are different FPS, FPS should not be in the linking_settings. It should be in the translation_dict to be parsed from the filename.
        """)

    elseif is_FPS_in_particle_data
        typeof(particle_data.FPS[1]) <: AbstractFloat || error("FPS in particle_data is not a Float. Is it being parsed as a string?")
        return particle_data.FPS[1]
    
    elseif is_FPS_in_linking_settings
        return linking_settings.FPS
    
    else # FPS is not in either
        error("FPS is not in either the particle_data or the linking_settings. FPS should be in one or the other.")
    end

end

"""
    link(particle_data::AbstractDataFrame, linking_settings::NamedTuple; trackpykwargs...)

Use trackpy to link particle data into trajectories across frames.

See the [Linking Settings](@ref) docs for the fields and format of `linking_settings`. Any kwargs will be passed to the trackpy.link
function [trackpy.link](https://soft-matter.github.io/trackpy/v0.6.1/generated/trackpy.link.html#trackpy.link).

# Example
```julia-repl
julia> link(particle_data, linking_settings)
```
"""
function link(particle_data::AbstractDataFrame, linking_settings::NamedTuple; trackpykwargs...)
    SEARCH_RANGE_MICRONS = linking_settings.SEARCH_RANGE_MICRONS
    MPP = linking_settings.MPP
    FPS = find_relevant_FPS(particle_data, linking_settings)
    STUBS_SECONDS = linking_settings.STUBS_SECONDS
    MEMORY = linking_settings.MEMORY
    filename = particle_data.filename[1]

    # convert settings in µm to pixels for linker
    SEARCH_RANGE = trunc(Int, SEARCH_RANGE_MICRONS / MPP / FPS)  # pixels::Int
	STUBS = trunc(Int64, STUBS_SECONDS * FPS)  # frames

    # As long as we have it, add FPS as a column before linking
    @transform!(particle_data, :FPS = FPS)

    # This function takes a julia DataFrame, so we need to convert it to python for trackpy
    py_particle_data = jldf_to_pydf(particle_data)

    @info "Linking $(filename) ..."
    tp.quiet()  # make it quiet, I don't need to see the result of every frame
    linked = tp.link(py_particle_data, search_range=SEARCH_RANGE, memory=MEMORY, trackpykwargs...)
    linked_without_stubs = tp.filter_stubs(linked, STUBS)

    @info """  
        Done! $(linked.particle.nunique()) trajectories present.
        Filtered out stub trajectories < $(STUBS_SECONDS)s resulting in $(linked_without_stubs.particle.nunique()) trajectories.
        \n""" 

    linked_without_stubs.particle.nunique() == 0 && error("No trajectories left after filtering stubs! Try decreasing STUBS_SECONDS.")

    jldf = pydf_to_jldf(linked_without_stubs)

    # seems trackpy adds another frame column, remove it for cleanliness
    if "frame_1" in names(jldf)

        if  jldf.frame == jldf.frame_1
            select!(jldf, Not("frame_1"))
        else
            error("internal error: frame_1 column does not match frame column after linking")
        end
    end

    return jldf
end

"""
    add_useful_columns(linked_data::AbstractDataFrame, linking_settings::NamedTuple)

After linking, add some useful columns to the dataframe, like include dx, dy, dp (speed), and size measurements in microns. 

Uses the [`numerical_derivative`](@ref) and [`total_displacement`](@ref) functions.

# Definitions
- `particle_unique` : a string which uniquely identifies a particle. This is a combination of the filename and the particle number.
- `dx` : numerical derivative of `x`, i.e. instantaneous velocity in the x direction. Units of pixels/frame.
- `dy` : numerical derivative of `y`, i.e. instantaneous velocity in the y direction. Units of pixels/frame.
- `dp` : instantaneous speed. √(dx^2 + dy^2). Units of pixels/frame.
- `dx_um` : dx converted to µm/s.
- `dy_um` : dy converted to µm/s.
- `dp_um` : dp converted to µm/s.
- `total_displacement_um` : total displacement of the microbot. Constant on every row, since this is a total. Units of µm.
- `Area_um` : area of the microbot. Units of µm^2.
- `time` : time, converted from the frame column. Units of seconds.
- `Major_um` : major axis of the fit ellipse of the microbot. Units of µm.
- `Minor_um` : minor axis of the fit ellipse of the microbot. Units of µm.
"""
function add_useful_columns(linked_data::AbstractDataFrame, linking_settings::NamedTuple)
    MPP = linking_settings.MPP
    filename = linked_data.filename[1]

    output = @chain linked_data begin
		@transform(:particle_unique = filename * "-" .* string.(:particle))
		
		groupby(:particle_unique)
		@transform(:dx = numerical_derivative(:x),
				   :dy = numerical_derivative(:y),
				   :total_displacement_um = total_displacement(:x, :y) * MPP)
		@transform(:dp = @. √(:dx^2 + :dy^2))
		@transform(:time = :frame ./ :FPS,
				   :dx_um = :dx .* :FPS * MPP,
				   :dy_um = :dy .* :FPS * MPP,
				   :dp_um = :dp .* :FPS * MPP,
				   :Area_um = :Area * MPP .^2,
				   :Major_um = :Major * MPP,
				   :Minor_um = :Minor * MPP)
	end
	
	return output
end

"""
    particle_data_to_linked_data(video_name::AbstractString, translation_dict::Dict, linking_settings::NamedTuple)

Process particle data into linked trajectory data while calculating instantaneous velocity and other salient data.
Returns a `DataFrame` that can then be saved to `linked_data` using [`save_linked_data_with_metadata`](@ref).

A particle data csv corresponding to `video_name` must be present in the `particle_data` folder.
The `translation_dict`` is a dictionary detailing the information contained in the filename. For full explanation, 
see the MicroTracker docs (ref needed).
"""
function particle_data_to_linked_data(video_name::AbstractString, translation_dict::Dict, linking_settings::NamedTuple)
    particle_data = load_particle_data(video_name)
    particle_data_with_exp_info = add_info_columns_from_filename(particle_data, translation_dict)
    linked_data = link(particle_data_with_exp_info, linking_settings)
    MicroTracker.add_resolution_column!(linked_data) # add resolution column inplace
    linked_data_with_useful_columns = add_useful_columns(linked_data, linking_settings)
    clipped_linked_data = clip_trajectory_edges(linked_data_with_useful_columns, linking_settings)

    return clipped_linked_data
end

"""
    batch_particle_data_to_linked_data(translation_dict::Dict, linking_settings::NamedTuple; save_to_csv=true)

Process all `.csv` files in `particle_data` into linked trajectory data and concatenate the results.

Returns a `DataFrame` containing all linked data for the entire experimental array. This is also saved to `linked_data` 
using [`save_linked_data_with_metadata`](@ref) for record keeping and further analysis.

The `translation_dict` is a dictionary detailing the information contained in the filename. `linking_settings` contains the input
parameters for the linking algorithm and microscope information. Only one of these arguments may contain the `FPS`.
    
For full explanation, see the MicroTracker [Linking](@ref) docs.
"""
function batch_particle_data_to_linked_data(translation_dict::Dict, linking_settings::NamedTuple; save_to_csv=true)
    all_names = get_names_in_particle_data()

    output = DataFrame()  # create empty dataframe to store all linked df's
    for video_name in all_names
        linked_data = particle_data_to_linked_data(video_name, translation_dict, linking_settings)
        output = vcat(output, linked_data)
    end

    if save_to_csv
        save_linked_data_with_metadata(output, translation_dict, linking_settings)
    end

    return output
end

"""
    save_linked_data_with_metadata(linked_data::AbstractDataFrame, translation_dict::Dict, linking_settings::NamedTuple)

Save linked data with the `translation_dict` and `linking_settings` in the filename. Will overwrite existing file.
"""
function save_linked_data_with_metadata(linked_data::AbstractDataFrame, translation_dict::Dict, linking_settings::NamedTuple)
    dictstring = MicroTracker.translation_dict_to_string(translation_dict)
    filename = "($dictstring) - $(string(linking_settings))"
    path = "linked_data/$filename.csv"

    if isfile(path)
        rm(path)
        CSV.write(path, linked_data)
    else
        CSV.write(path, linked_data)
    end
    @info "Linked data saved to linked_data/$filename.csv"
end

# Trajectory clipping functions

"""
    inbounds(row::DataFrameRow, radius::AbstractFloat, video_resolution::Tuple{Int, Int})
Check if dataframe row is in bounds. This is a single row in a dataframe of a single particle's trajectory.
    
This looks at x and y coordinates and checks if they are within `radius` of the edge of the video.
"""
function inbounds(row::DataFrameRow, radius::AbstractFloat, video_resolution::Tuple{Int, Int})
	if (row.x < radius) | (row.x > video_resolution[1]-radius)
		# X is out of bounds
		return false
	elseif (row.y < radius) | (row.y > video_resolution[2]-radius)
		# Y is out of bounds
		return false
	else
		return true
	end
end

"""
	find_trajectory_bounds(df_1particle::AbstractDataFrame, video_resolution::Tuple{Int, Int})
Return a tuple of frame numbers, `(low, high)` where all trajectory points are in bounds.

This calculates the radius of the particle, then iterates forward and backward from the center of the trajectory
until it finds a point that is out of bounds. This is the high and low bound of the trajectory.
"""
function find_trajectory_bounds(df_1particle::AbstractDataFrame)
    unique(df_1particle.particle_unique) |> length > 1 && error("More than one particle in df_1particle")
    video_resolution = df_1particle.video_resolution[1]
	# particle name
    particle_name = df_1particle.particle_unique[1]

    # find radius for clipping region. Will set equal to radius * 2 to allow for a buffer region
	radius = quantile(df_1particle.Major, 0.95)

	# Find midpoint, or center of trajectory idxs
	nrows, ncols = size(df_1particle)
	center_idx = trunc(Int, (nrows - 1) / 2)

	# initialize idxs
	high_break_idx = nrows
	low_break_idx = 1

	# iterate forward
	for (idx, i) in pairs(eachrow(df_1particle)[center_idx:end-1])
		if !inbounds(i, radius, video_resolution)
			if idx == 1 
				@warn "Center point of trajectory $particle_name is out of bounds."
                return (-1, -1)
			end
			
			high_break_idx = center_idx + idx - 2
			break
		end
	end

	# iterate backwards
	for (idx, i) in pairs(reverse(eachrow(df_1particle)[2:center_idx]))
		if !inbounds(i, radius, video_resolution)
			low_break_idx = center_idx - idx + 2
			break
		end
	end

	return (df_1particle.frame[low_break_idx], df_1particle.frame[high_break_idx])
end

"""
	clip_trajectory_edges(linked_data::AbstractDataFrame, linking_settings::NamedTuple)
Iterate through each trajectory and remove the tracking data where the particle is out of frame.

The particle is out of frame when the center is within the radius of the particle from the edge of the video.

Uses [`find_trajectory_bounds`](@ref) to find the bounds of the trajectory with [`inbounds`](@ref).
"""
function clip_trajectory_edges(linked_data::AbstractDataFrame, linking_settings::NamedTuple)
    STUBS_SECONDS = linking_settings.STUBS_SECONDS

	gdf = groupby(linked_data, :particle_unique)
	snipped_trajectory_dfs = DataFrame[]
	
	for i in gdf
        FPS = i.FPS[1]
        STUBS = STUBS = trunc(Int64, STUBS_SECONDS * FPS)  # frames
        
		frames = find_trajectory_bounds(i)
		#@info "Clipping info" frames first(i.particle_unique)
		j = @subset(i, :frame .> frames[1], :frame .< frames[2])
		if size(j)[1] < STUBS
			@warn "Snipped trajectory from $(first(i.particle_unique)) is now too short. Deleting."
			continue
		end
		push!(snipped_trajectory_dfs, j)
	end
	
	reduce(vcat, snipped_trajectory_dfs)
end
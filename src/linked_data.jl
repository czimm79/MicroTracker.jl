# Functions relating to the linking of particle data and subsequent wrangling of those linked results.

"""
    link(particle_data::AbstractDataFrame, linking_settings::NamedTuple)

Use trackpy to link particle data into trajectories across frames.

`linking_settings` is a `NamedTuple` with the following all caps fields:
- `SEARCH_RANGE_MICRONS::Float64`:  microns/s. Fastest a particle could be traveling.
- `MPP::Float64`: Microns per pixel, scale of objective.
- `FPS::Float64`: Frames per second.
- `STUBS_SECONDS::Float64`: seconds. All trajectories that exist less than this will be removed.
- `MEMORY::Int64`: Number of frames the particle can dissapear and still be remembered.
"""
function link(particle_data::AbstractDataFrame, linking_settings::NamedTuple)
    SEARCH_RANGE_MICRONS = linking_settings.SEARCH_RANGE_MICRONS
    MPP = linking_settings.MPP
    FPS = linking_settings.FPS
    STUBS_SECONDS = linking_settings.STUBS_SECONDS
    MEMORY = linking_settings.MEMORY
    filename = particle_data.filename[1]

    # convert settings in µm to pixels for linker
    SEARCH_RANGE = trunc(Int, SEARCH_RANGE_MICRONS / MPP / FPS)  # pixels::Int
	STUBS = trunc(Int64, STUBS_SECONDS * FPS)  # frames

    # This function takes a julia DataFrame, so we need to convert it to python for trackpy
    py_particle_data = jldf_to_pydf(particle_data)

    @info "Linking $(particle_data.filename[1]) ..."
    tp.quiet()  # make it quiet, I don't need to see the result of every frame
    linked = tp.link(py_particle_data, search_range=SEARCH_RANGE, memory=MEMORY)
    linked_without_stubs = tp.filter_stubs(linked, STUBS)

    @info """  
        Done! $(linked.particle.nunique()) trajectories present.
        Filtered out stub trajectories < $(STUBS_SECONDS)s resulting in $(linked_without_stubs.particle.nunique()) trajectories.
        \n""" 

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

After linking, add some useful columns to the dataframe. 

These include dx, dy, dp (velocity), and size measurements in microns. 
(more detailed docs needed if this is an interface for users)
"""
function add_useful_columns(linked_data::AbstractDataFrame, linking_settings::NamedTuple)
    MPP = linking_settings.MPP
    FPS = linking_settings.FPS
    filename = linked_data.filename[1]

    output = @chain linked_data begin
		@transform(:particle_unique = filename * "-" .* string.(:particle))
		
		groupby(:particle)
		@transform(:dx = numerical_derivative(:x),
				   :dy = numerical_derivative(:y),
				   :total_displacement_um = total_displacement(:x, :y) * MPP)
		@transform(:dp = @. √(:dx^2 + :dy^2))
		@transform(:time = :frame / FPS,
				   :dx_um = :dx * FPS * MPP,
				   :dy_um = :dy * FPS * MPP,
				   :dp_um = :dp * FPS * MPP,
				   :Area_um = :Area * MPP .^2,
				   :Major_um = :Major * MPP,
				   :Minor_um = :Minor * MPP,
				   :FPS = FPS)
	end
	
	return output
end

"""
    particle_data_to_linked_data(video_name::AbstractString, translation_dict::Dict, linking_settings::NamedTuple)

Process particle data into linked trajectory data while calculating instantaneous velocity and other salient data.
Returns a `DataFrame` that can then be saved to `linked_data` using [`save_linked_data_with_timestamp`](@ref).

A particle data csv corresponding to `video_name` must be present in the `particle_data` folder.
The `translation_dict`` is a dictionary detailing the information contained in the filename. For full explanation, 
see the MicroTracker docs (ref needed).

```jldoctest
julia> 1 + 1
2
```
"""
function particle_data_to_linked_data(video_name::AbstractString, translation_dict::Dict, linking_settings::NamedTuple)
    particle_data = load_particle_data(video_name)
    particle_data_with_exp_info = add_info_columns_from_filename(particle_data, translation_dict)
    linked_data = link(particle_data_with_exp_info, linking_settings)
    linked_data_with_useful_columns = add_useful_columns(linked_data, linking_settings)

    return linked_data_with_useful_columns
end


"""
    batch_particle_data_to_linked_data(translation_dict::Dict, linking_settings::NamedTuple)

Process all `.csv` files in `particle_data` into linked trajectory data and concatenate the results.

Returns a `DataFrame` containing all linked data for the entire experimental array. This is also saved to `linked_data` 
using [`save_linked_data_with_timestamp`](@ref) for further analysis.

The `translation_dict`` is a dictionary detailing the information contained in the filename. For full explanation, 
see the MicroTracker docs (ref needed).

```jldoctest
julia> 1 + 1
2
```
"""
function batch_particle_data_to_linked_data(translation_dict::Dict, linking_settings::NamedTuple; save_to_csv=true)
    all_names = get_names_in_particle_data()

    output = DataFrame()  # create empty dataframe to store all linked df's
    for video_name in all_names
        linked_data = particle_data_to_linked_data(video_name, translation_dict, linking_settings)
        output = vcat(output, linked_data)
    end

    if save_to_csv
        save_linked_data_with_timestamp(output)
    end

    return output
end


"""
    save_linked_data_with_timestamp(linked_data::AbstractDataFrame)

Save final linked data to `linked_data` folder with a timestamped filename.
"""
function save_linked_data_with_timestamp(linked_data::AbstractDataFrame)
    datetime = Dates.format(Dates.now(), "yyyy-mm-dd_THH-MM")
	CSV.write("linked_data/$(datetime).csv", linked_data)
    @info "Saved to linked_data/$(datetime).csv"
end
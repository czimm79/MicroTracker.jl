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
				   :total_displacement_um = abs(total_displacement(:x, :y)) * MPP)
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

# FILTER


# DO IT ALL

# function particle_data_to_linked_results(video_name::AbstractString, translation_dict::Dict)
#     df = load_particle_data(video_name)
#     df = add_info_columns_from_filename(df, translation_dict)
#     return df
# end
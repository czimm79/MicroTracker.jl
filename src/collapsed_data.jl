"""
    load_linked_data(filename)

Read a linked data `.csv` file into a `DataFrame`. Assumes the `.csv` file is in the `linked_data` folder.
"""
function load_linked_data(filename)
    df = CSV.read("linked_data/$filename", DataFrame)
    return df
end

"""
    collapse_data(linked_data::AbstractDataFrame)

Collapse each time-series microbot trajectory into a single row of summary data for each microbot.

For full description of each output variable, see the [Collapsing](@ref) docs.
"""
function collapse_data(linked_data::AbstractDataFrame)
    output = @chain linked_data begin  # start a processing pipeline. each line takes the result of the last.
	
        # Collapse the time series data using a groupby
        groupby(:particle_unique)  # mini-dataframes for each particle
        @combine(
            :filename = first(:filename),
            :FPS = first(:FPS),
            :V = mean(:dp_um), # μm/s,
            :Vx = mean(:dx_um),
            :Vy = mean(:dy_um),
            :Area_um_mean = mean(:Area_um),  # μm^2
            :Ω_est = estimate_omega(:time, :Major_um),  # Hz
            :R = quantile(:Major_um, 0.95) / 2,  # μm, quantile prevents outliers from skewing the result
            :Circularity = mean(:Circ),
            :total_displacement_um = first(:total_displacement_um),
        )

    end
    return output
end

"""
    filter_trajectories(collapsed_data::AbstractDataFrame, filter_settings::NamedTuple)

Filter out microbots that may be too small or large, going too slow, or stuck to the substrate.

The `filter_settings` is a `NamedTuple` with the following fields:
- `MIN_VELOCITY` : minimum velocity in um/s
- `MIN_BOUNDING_RADIUS` : minimum bounding radius in um
- `MAX_BOUNDING_RADIUS` : maximum bounding radius in um
- `MIN_DISPLACEMENT` : minimum total displacement in um

# Example
```julia
filter_settings = (
    MIN_VELOCITY = 10.0,  # um / s  
    MIN_BOUNDING_RADIUS = 3.38,  # um
    MAX_BOUNDING_RADIUS = 75,  # µm
    MIN_DISPLACEMENT = 0,  # µm
)

filtered_collapsed_data = filter_trajectories(collapsed_data, filter_settings)
```
"""
function filter_trajectories(collapsed_data::AbstractDataFrame, filter_settings::NamedTuple)
    
	n_before_filtering = size(collapsed_data)[1]
	just_right_data = @subset(collapsed_data, 
		:R .< filter_settings.MAX_BOUNDING_RADIUS,
		:R .> filter_settings.MIN_BOUNDING_RADIUS, 
		:V .> filter_settings.MIN_VELOCITY,
		:total_displacement_um .> filter_settings.MIN_DISPLACEMENT)
    
    n_after_filtering = size(just_right_data)[1]

	@info "filtered trajectories $(n_before_filtering) -> $(n_after_filtering)"

	return just_right_data
end



# filtered_linked_data = MicroTracker.filter_particles(linked_data_with_newcols, filter_settings)
"""
    read_linked_csv(filename)

Read a linked_csv into a `DataFrame`. Assumes the `.csv` file is in the `linked_data` folder.
"""
function read_linked_csv(filename)
    df = CSV.read("linked_data/$filename", DataFrame)
    return df
end

# function filter_particles(linked_data::AbstractDataFrame, filter_settings::NamedTuple)
#     MIN_AREA = filter_settings.MIN_AREA
#     MAX_AREA = filter_settings.MAX_AREA
#     MIN_VELOCITY = filter_settings.MIN_VELOCITY
#     MIN_DISPLACEMENT = filter_settings.MIN_DISPLACEMENT
    
# 	collapsed_data = @by(linked_data, :particle_u, :Area_m_mean = mean(:Area_m), :dp_m_mean = mean(:dp_m),
#                              :total_displacement_m = first(:total_displacement_m))

# 	n_before_filtering = size(mean_area_df)[1]
# 	just_right_particles = @subset(mean_area_df, 
# 		:Area_m_mean .< MAX_AREA,
# 		:Area_m_mean .> MIN_AREA, 
# 		:dp_m_mean .> MIN_VELOCITY,
# 		:total_displacement_m .> MIN_DISPLACEMENT)

# 	@info "filtered by parameters $(size(mean_area_df)[1]) -> $(size(just_right_particles)[1])"

# 	return @subset(linked_data, :particle_u .∈ [just_right_particles.particle_u])
# end

# filter_settings = (
#     MIN_VELOCITY = 10.0,  # um / s  
#     MIN_DIAMETER = 6.75,  # um
# 	MAX_DIAMETER = 150,  # µm
# 	MIN_DISPLACEMENT = 300,  # µm
# )

# filtered_linked_data = MicroTracker.filter_particles(linked_data_with_newcols, filter_settings)


"""
    collapse_time_data(df)

Collapse each time-series microbot trajectory into a single row of data for each microbot.

For full description of each output variable, see these docs (ref needed).
"""
# function collapse_time_data(df)
#     @chain df begin  # start a processing pipeline. each line takes the result of the last.
	
#         # First, collapse the time series data
#         groupby(:particle_u)  # mini-dataframes for each particle
#         @combine(
#             :filename = first(:filename),
#             :FPS = first(:FPS),
#             :V = mean(:dv_m), # μm/s,
#             :Vx = mean(:dx_m),
#             :Vy = mean(:dy_m),
#             :Area_m_mean = mean(:Area_m),  # μm^2
#             #:Ω_est = estimate_omega(:time, :Major_m),  # Hz
#             :R = maximum(:Major_m) / 2,  # μm
#             :Circularity = mean(:Circ),
#         )

#     end
# end

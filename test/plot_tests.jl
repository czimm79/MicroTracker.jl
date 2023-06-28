# # Plotting
# linked_data = cd(() -> load_linked_data("linked_example.csv"), get_assets_path())

# # filter that collapsed data
# filter_settings = (
#     MIN_VELOCITY = 10.0,  # um / s  
#     MIN_BOUNDING_RADIUS = 3.38,  # um
#     MAX_BOUNDING_RADIUS = 75,  # µm
#     MIN_DISPLACEMENT = 0,  # µm
# )
# collapsed_data = filter_trajectories(collapse_data(linked_data), filter_settings)

# MicroTracker.CairoMakie.activate!()
# MicroTracker.basic_plot(collapsed_data, :R, :V, :filename)

# MicroTracker.GLMakie.activate!()
# MicroTracker.example_plot()
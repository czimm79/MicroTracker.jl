@testset "Collapsed data" begin
    linked_data = cd(() -> load_linked_data("(B_mT=(2, Float64), FPS=(3, Float64), f_Hz=(1, Int64)) - (MPP = 0.605, SEARCH_RANGE_MICRONS = 1000, MEMORY = 0, STUBS_SECONDS = 0.5).csv"), get_assets_path())  # load test data from assets
    @test "x" in names(linked_data)  # dataframe is successfully loaded
    @test "particle_unique" in names(linked_data)

    # Collapsing time data
    collapsed_data = collapse_data(linked_data)
    @test "V" in names(collapsed_data)

    # filter that collapsed data
    filter_settings = (
        MIN_VELOCITY = 10.0,  # um / s  
        MIN_BOUNDING_RADIUS = 3.38,  # um
        MAX_BOUNDING_RADIUS = 75,  # µm
        MIN_DISPLACEMENT = 0,  # µm
    )

    @test size(filter_trajectories(collapsed_data, filter_settings))[1] == 26

end

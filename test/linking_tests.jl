@testset "Particle data to linked data" begin
    # test that the particle data is accessible
    video_names = cd(MicroTracker.get_names_in_particle_data, get_assets_path())  # load test data from assets
    @test video_names == ["5_13p5_61p35", "5_8p4_28p68"]

    # test that the frame number can be extracted from a Label that ImageJ generates
    test_label = "5_13p5_61p35:slice:363"
    test_label2 = "5_8p3_1:a_00001"
    @test MicroTracker.extract_frame_from_label(test_label) == 363
    @test MicroTracker.extract_frame_from_label(test_label2) == 1

    # test that the particle data can be loaded into a dataframe
    particle_data = cd(() -> MicroTracker.load_particle_data("5_13p5_61p35"), get_assets_path())
    @test "x" in names(particle_data)

    # test that info columns can be added to the dataframe, make sure one is a string
    test_filename = "5_13p5_61p35"
    test_translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, String))

    particle_data_with_added_cols = MicroTracker.add_info_columns_from_filename(particle_data, test_translation_dict)
    # checking if all keys are present as columns
    @test all(collect(keys(test_translation_dict)) .∈ Ref(names(particle_data_with_added_cols)))

    # Linking with trackpy
    linking_settings = (
        FPS = 61.35,
        MPP = 0.605,  # Microns per pixel, scale of objective.
        SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling.
                                    # Determines "how far" to look to link.
        MEMORY = 10,  # number of frames the blob can dissapear and still be remembered
        STUBS_SECONDS = 2.0,  # trajectory needs to exist for at least this many seconds 
    )

    fresh_linked_data = MicroTracker.link(particle_data_with_added_cols, linking_settings)
    @test fresh_linked_data.particle |> unique |> length == 16  # 16 particles in the test data with stubs of 2 seconds

    # Add useful columns like dx, dy, dp (velocity), and size measurements in microns
    linked_data_with_newcols = MicroTracker.add_useful_columns(fresh_linked_data, linking_settings)
    @test "dx" in names(linked_data_with_newcols)

    # test the do it all function
    final_linked_data = cd( () -> particle_data_to_linked_data("5_13p5_61p35", test_translation_dict, linking_settings),
        get_assets_path())

    @test final_linked_data == linked_data_with_newcols

    # test that the batch process function works
    batch_final_linked_data = cd( () -> batch_particle_data_to_linked_data(test_translation_dict, linking_settings; save_to_csv=false),
        get_assets_path())
    @test size(batch_final_linked_data) == (11834, 30)
end

#@testset "Trajectory clipping" begin
    # setup
    sample_video_resolution = (2000, 2000)

    # particle 1, all out of bounds
    xs_1 = 0:2000
    ys_1 = fill(20, length(xs_1))
    name_1 = "test-1"
    Major_1 = 200.0
    frame_1 = 1:length(xs_1)

    # particle 2, all in bounds
    xs_2 = 400:800
    ys_2 = 1 * xs_2
    name_2 = "test-2"
    Major_2 = 50.0
    frame_2 = 1:length(xs_2)

    # particle 3, partially in bounds
    xs_3 = 0:2000
    ys_3 = 0:2000
    name_3 = "test-3"
    Major_3 = 60.0
    frame_3 = 1:length(xs_3)

    # create a test dataframe
    trajectory_clip_test_df = DataFrame(x = vcat(xs_1, xs_2, xs_3), y = vcat(ys_1, ys_2, ys_3), 
        particle_unique = vcat(fill(name_1, length(xs_1)), fill(name_2, length(xs_2)),  fill(name_3, length(xs_3))),
        Major = vcat(fill(Major_1, length(xs_1)), fill(Major_2, length(xs_2)), fill(Major_3, length(xs_3))),
        frame = vcat(frame_1, frame_2, frame_3))

    # groupby particle
    gdf = groupby(trajectory_clip_test_df, :particle_unique)

    # inbounds
    @test MicroTracker.inbounds(gdf[1][1, :], 50.0, sample_video_resolution) == false
    @test MicroTracker.inbounds(gdf[1][1, :], 20.0, sample_video_resolution) == false
    @test MicroTracker.inbounds(gdf[2][1, :], 100.0, sample_video_resolution) == true

    # find bounds
    @test MicroTracker.find_trajectory_bounds(gdf[1], sample_video_resolution) == (-1, -1) # all out of bounds
    @test MicroTracker.find_trajectory_bounds(gdf[2], sample_video_resolution) == (1, 401) # all inbounds
    @test MicroTracker.find_trajectory_bounds(gdf[3], sample_video_resolution) == (31, 1971) # clip both sides



#end
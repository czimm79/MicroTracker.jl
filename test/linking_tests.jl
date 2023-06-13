@testset "Particle data manipulation" begin
    # test that the particle data is accessible
    particle_csvs = cd(MicroTracker.get_particle_csvs, get_assets_path())  # load test data from assets
    @test particle_csvs == ["5_13p5_61p35.csv", "5_8p4_28p68.csv"]

    # test that the particle data can be loaded into a dataframe
    df_test = cd(() -> MicroTracker.load_particle_data("5_13p5_61p35"), get_assets_path())
    @test "x" in names(df_test)

    # test that the frame number can be extracted from the label
    test_label = "5_13p5_61p35:slice:363"
    test_label2 = "5_8p3_1:a_00001"
    @test MicroTracker.extract_frame_from_label(test_label) == 363
    @test MicroTracker.extract_frame_from_label(test_label2) == 1

    # test that info columns can be added to the dataframe, make sure one is a string
    test_filename = "5_13p5_61p35"
    test_translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, String))

    df_with_added_cols = MicroTracker.add_info_columns_from_filename(df_test, test_translation_dict)
    # checking if all keys are present as columns
    @test all(collect(keys(test_translation_dict)) .∈ Ref(names(df_with_added_cols)))
end

@testset "Linking and linked data manipulation" begin
    # Linking with trackpy
    linking_settings = (
        FPS = 61.35,
        MPP = 0.605,  # Microns per pixel, scale of objective.
        SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling.
                                    # Determines "how far" to look to link.
        MEMORY = 10,  # number of frames the blob can dissapear and still be remembered
        STUBS_SECONDS = 2.0,  # trajectory needs to exist for at least this many seconds 
    )

    particle_data = cd(() -> MicroTracker.load_particle_data("5_13p5_61p35"), get_assets_path())

    fresh_linked_data = MicroTracker.link(particle_data, linking_settings)
    @test fresh_linked_data.particle |> unique |> length == 16  # 16 particles in the test data with stubs of 2 seconds

    # Add useful columns like dx, dy, dp (velocity), and size measurements in microns
    linked_data_with_newcols = MicroTracker.add_useful_columns(fresh_linked_data, linking_settings)

    @test "dx" in names(linked_data_with_newcols)
end

# filter_settings = (
#     MIN_VELOCITY = 10.0,  # um / s  
#     MIN_DIAMETER = 6.75,  # um
# 	MAX_DIAMETER = 150,  # µm
# 	MIN_DISPLACEMENT = 300,  # µm
# )
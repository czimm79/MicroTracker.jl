@testset "particle data processing" begin
    # test that the particle data is accessible
    particle_csvs = cd(MicroTracker.get_particle_csvs, get_assets_path())  # load test data from assets
    @test particle_csvs == ["5_13p5_61p35.csv", "5_8p4_28p68.csv"]

    # test that the particle data can be loaded into a dataframe
    df_test = cd(() -> MicroTracker.load_particle_data("5_13p5_61p35"), get_assets_path())
    @test "x" in names(df_test)

    # test that the frame number can be extracted from the label
    test_label = df_test.Label[1]
    test_label2 = "5_8p3_1:a_00001"
    @test MicroTracker.extract_frame_from_label(test_label) == 1
    @test MicroTracker.extract_frame_from_label(test_label2) == 1

    # test that info columns can be added to the dataframe, make sure one is a string
    test_filename = "5_13p5_61p35"
    test_translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, String))

    df_with_added_cols = MicroTracker.add_info_columns_from_filename(df_test, test_translation_dict)
    # checking if all keys are present as columns
    @test all(collect(keys(test_translation_dict)) .∈ Ref(names(df_with_added_cols)))
end

@testset "Linking" begin
linking_settings = (
    FPS = 61.35,
    MPP = 0.605,  # Microns per pixel, scale of objective.
    
    SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling.
								# Determines "how far" to look to link.
    MEMORY = 10,  # number of frames the blob can dissapear and still be remembered
    STUBS_SECONDS = 2.0,  # trajectory needs to exist for at least this many seconds 
)

df_test = cd(() -> MicroTracker.load_particle_data("5_13p5_61p35"), get_assets_path())

df_linked = MicroTracker.link(df_test, linking_settings)
@test df_linked.particle |> unique |> length == 16  # 16 particles in the test data with stubs of 2 seconds

end

# filter_settings = (
#     MIN_VELOCITY = 10.0,  # um / s  
#     MIN_DIAMETER = 6.75,  # um
# 	MAX_DIAMETER = 150,  # µm
# 	MIN_DISPLACEMENT = 300,  # µm
# )
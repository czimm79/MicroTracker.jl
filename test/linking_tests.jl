test_linking_settings = (
    MPP = 0.605,  # Microns per pixel, scale of objective.
    SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling. # Determines "how far" to look to link.
    MEMORY = 0,  # number of frames the blob can dissapear and still be remembered
    STUBS_SECONDS = 0.5,  # trajectory needs to exist for at least this many seconds 
)

bad_linking_settings = (
    FPS = 61.35,
    MPP = 0.605,  # Microns per pixel, scale of objective.
    SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling. # Determines "how far" to look to link.
    MEMORY = 0,  # number of frames the blob can dissapear and still be remembered
    STUBS_SECONDS = 2.0,  # trajectory needs to exist for at least this many seconds 
)

test_translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, Float64))
FPSstring_translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, String))

@testset "Particle data to linked data" begin
    # Is there example particle data?
    video_names = cd(MicroTracker.get_names_in_particle_data, get_assets_path())  # load test data from assets
    @test video_names == ["5_13p5_61p35", "5_8p4_28p68"]

    # Can the frame number can be extracted from a Label that ImageJ generates?
    test_label = "5_13p5_61p35:slice:363"
    test_label2 = "5_8p3_1:a_00001"
    @test MicroTracker.extract_frame_from_label(test_label) == 363
    @test MicroTracker.extract_frame_from_label(test_label2) == 1

    # Can the particle data be loaded into a dataframe?
    particle_data = cd(() -> MicroTracker.load_particle_data("5_13p5_61p35"), get_assets_path())
    @test "x" in names(particle_data)

    # test that info columns can be added to the dataframe, make sure one is a string
    test_filename = "5_13p5_61p35"

    particle_data_with_added_cols_strFPS = MicroTracker.add_info_columns_from_filename(particle_data, FPSstring_translation_dict)
    @test particle_data_with_added_cols_strFPS.FPS[1] == "61.35"

    particle_data_with_added_cols = MicroTracker.add_info_columns_from_filename(particle_data, test_translation_dict)
    # checking if all keys are present as columns
    @test all(collect(keys(test_translation_dict)) .∈ Ref(names(particle_data_with_added_cols)))
    @test particle_data_with_added_cols.FPS[1] == 61.35

    # Can the relevant FPS be found, in the variable FPS case and the constant FPS case?
    @test_throws ErrorException MicroTracker.find_relevant_FPS(particle_data_with_added_cols_strFPS, (;FPS=30.0)) # in both
    @test_throws ErrorException MicroTracker.find_relevant_FPS(particle_data_with_added_cols_strFPS, (;BLAH="meaningless")) # FPS is a string
    @test_throws ErrorException MicroTracker.find_relevant_FPS(select(particle_data_with_added_cols, Not(:FPS)), (;BLAH="meaningless")) # FPS is nowhere
    @test MicroTracker.find_relevant_FPS(select(particle_data_with_added_cols, Not(:FPS)), (;FPS=30.0)) == 30.0 # FPS is constant in tuple
    @test MicroTracker.find_relevant_FPS(particle_data_with_added_cols, (;BLAH="meaningless")) == 61.35 # FPS is in the dataframe from the filename

    # add resolution
    cd(()->MicroTracker.add_resolution_column!(particle_data_with_added_cols), get_assets_path())
    @test particle_data_with_added_cols.video_resolution[1] == (753, 715)

    # Linking with trackpy
    fresh_linked_data = MicroTracker.link(particle_data_with_added_cols, test_linking_settings)
    @test fresh_linked_data.particle |> unique |> length == 21  # 21 particles in the test data with stubs of 0.5 seconds

    # Add useful columns like dx, dy, dp (velocity), and size measurements in microns
    linked_data_with_newcols = MicroTracker.add_useful_columns(fresh_linked_data, test_linking_settings)
    @test "dx" in names(linked_data_with_newcols)

    # test the do it all function
    final_linked_data = cd( () -> particle_data_to_linked_data("5_13p5_61p35", test_translation_dict, test_linking_settings),
        get_assets_path())

    @test final_linked_data == linked_data_with_newcols

    # test that the batch process function works
    @test_throws ErrorException cd(()->batch_particle_data_to_linked_data(test_translation_dict, bad_linking_settings; save_to_csv=false),
        get_assets_path())  # FPS is a string and stubs is too large

    batch_final_linked_data = cd(()->batch_particle_data_to_linked_data(test_translation_dict, test_linking_settings; save_to_csv=false),
        get_assets_path())
    @test size(batch_final_linked_data) == (5147, 31)

end

@testset "Trajectory clipping" begin

    # particle 1, all out of bounds
    xs_1 = 0:2000
    ys_1 = fill(20, length(xs_1))
    name_1 = "test-1"
    Major_1 = 200.0
    frame_1 = 1:length(xs_1)
    video_resolution_1 = (2000, 2000)

    # particle 2, all in bounds
    xs_2 = 400:800
    ys_2 = 1 * xs_2
    name_2 = "test-2"
    Major_2 = 50.0
    frame_2 = 1:length(xs_2)
    video_resolution_2 = (2000, 2000)

    # particle 3, partially in bounds
    xs_3 = 0:2000
    ys_3 = 0:2000
    name_3 = "test-3"
    Major_3 = 60.0
    frame_3 = 1:length(xs_3)
    video_resolution_3 = (2000, 2000)

    # create a test dataframe
    trajectory_clip_test_df = DataFrame(x = vcat(xs_1, xs_2, xs_3), y = vcat(ys_1, ys_2, ys_3), 
        particle_unique = vcat(fill(name_1, length(xs_1)), fill(name_2, length(xs_2)),  fill(name_3, length(xs_3))),
        Major = vcat(fill(Major_1, length(xs_1)), fill(Major_2, length(xs_2)), fill(Major_3, length(xs_3))),
        frame = vcat(frame_1, frame_2, frame_3),
        video_resolution = vcat(fill(video_resolution_1, length(xs_1)), fill(video_resolution_2, length(xs_2)), fill(video_resolution_3, length(xs_3))))

    # add fps column, assume constant for here
    @transform!(trajectory_clip_test_df, :FPS = 30.0)
    
    # groupby particle
    gdf = groupby(trajectory_clip_test_df, :particle_unique)

    # inbounds
    @test MicroTracker.inbounds(gdf[1][1, :], 50.0, video_resolution_1) == false
    @test MicroTracker.inbounds(gdf[1][1, :], 20.0, video_resolution_1) == false
    @test MicroTracker.inbounds(gdf[2][1, :], 100.0, video_resolution_2) == true

    # find bounds
    @test find_trajectory_bounds(gdf[1]) == (-1, -1) # all out of bounds
    @test find_trajectory_bounds(gdf[2]) == (1, 401) # all inbounds
    @test find_trajectory_bounds(gdf[3]) == (31, 1971) # clip both sides
    @test_throws ErrorException find_trajectory_bounds(trajectory_clip_test_df) # didn't supply a 1 particle df

    ## snip trajectories 
    after_snipping = clip_trajectory_edges(trajectory_clip_test_df, test_linking_settings)
    @test after_snipping[end, :frame] == 1970  # last frame of particle 3 clipped to 1970
    
end
macro isplot(ex) # @isplot macro to streamline tests, from Plots.jl
    :(@test $(esc(ex)) isa Plots.Plot)
end

@testset "plotting" begin
    linked_data = cd(()->load_linked_data("(B_mT=(2, Float64), FPS=(3, Float64), f_Hz=(1, Int64)) - (MPP = 0.605, SEARCH_RANGE_MICRONS = 1000, MEMORY = 0, STUBS_SECONDS = 0.5).csv"),
        get_assets_path())
    test_translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, Float64))
    collapsed_data = collapse_data(linked_data, test_translation_dict)

    all_particle_names = linked_data.particle_unique |> unique

    @isplot cd(()->plotannotatedframe(linked_data, "5_13p5_61p35", 30, showimage=true), get_assets_path())
    @test_throws ErrorException cd(()->plotannotatedframe(linked_data, "doesntexist", 30, showimage=true), get_assets_path())
    @isplot cd(()->plotannotatedframe_single(linked_data, "5_13p5_61p35-3", 30, showimage=true), get_assets_path())
    
    @isplot cd(()->trajectory_analyzer(linked_data, collapsed_data, all_particle_names[1]), get_assets_path())
    @isplot cd(()->trajectory_analyzer(linked_data, collapsed_data, all_particle_names[1], 500), get_assets_path())
    @isplot cd(()->trajectory_analyzer(linked_data, collapsed_data, all_particle_names[1], 120), get_assets_path())

    # animations
    cd(()->animate_trajectory_analyzer(linked_data, collapsed_data, all_particle_names[1], "test_animation.mp4", 120:121), get_assets_path())
    @test cd(()->isfile("test_animation.mp4"), get_assets_path())
    cd(()->rm("test_animation.mp4"), get_assets_path())
end

macro isplot(ex) # @isplot macro to streamline tests, from Plots.jl
    :(@test $(esc(ex)) isa Plots.Plot)
end

@testset "plotting" begin
    linked_data = cd(()->load_linked_data("(B_mT=(2, Float64), FPS=(3, Float64), f_Hz=(1, Int64)) - (MPP = 0.605, SEARCH_RANGE_MICRONS = 1000, MEMORY = 0, STUBS_SECONDS = 0.5).csv"),
        get_assets_path())
    collapsed_data = collapse_data(linked_data)

    all_particle_names = linked_data.particle_unique |> unique

    @isplot cd(()->plotannotatedframe(linked_data, "5_13p5_61p35", 30, showimage=true), get_assets_path())
    @test_throws ErrorException cd(()->plotannotatedframe(linked_data, "doesntexist", 30, showimage=true), get_assets_path())
    @isplot cd(()->plotannotatedframe_single(linked_data, "5_13p5_61p35-3", 30, showimage=true), get_assets_path())
    
    @isplot cd(()->trajectory_analyzer_scrubbable(linked_data, collapsed_data, all_particle_names[3], 150), get_assets_path())
    @isplot cd(()->trajectory_analyzer(linked_data, collapsed_data, all_particle_names[3]), get_assets_path())
end
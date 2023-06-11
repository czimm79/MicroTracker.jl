@testset "particle data processing" begin
    assets_path = joinpath(dirname(pwd()), "assets")
    particle_csvs = cd(MicroTracker.get_particle_csvs, assets_path)  # load test data from assets
    @test particle_csvs == ["5_13p5_61p35.csv", "5_8p4_28p68.csv"]
end
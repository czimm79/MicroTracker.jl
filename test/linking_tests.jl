@testset "particle data processing" begin
    particle_csvs = cd(MicroTracker.get_particle_csvs, "assets")  # load test data from assets
    @test particle_csvs == ["5_13p5_61p35.csv", "5_8p4_28p68.csv"]
end
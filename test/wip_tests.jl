using MicroTracker
using Test


@testset "Data Wrangling" begin
    df = cd(() -> MicroTracker.read_linked_csv("2023-02-20_T15-48.csv"), "assets")  # load test data from assets
    @test "x" in names(df)  # dataframe is successfully loaded
    @test "particle_u" in names(df)

    # Collapsing time data
    dfg = MicroTracker.collapse_time_data(df)
    @test "V" in names(dfg)
end 

@testset "Numpy" begin
    @test pyconvert(Float32, MicroTracker.npsin(1.0)) ≈ 0.84147098
end
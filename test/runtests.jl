using MicroTracker
using Test

@testset "FFT" begin
    error_tolerance = 0.055

    # setup waveform with linear trend
    f1 = 3
    f2 = 5
    a1 = 1
    a2 = 0.5
    m_true = 8
    b_true = 3

    f(x) = a1*sin(f1*2π*x) + a2*sin(f2*2π*x) + m_true*x + b_true

    x = range(0, 2π, length=100)
    y = f.(x)

    # fit_line
    m, b = fit_line(x, y)

    @test isapprox(m, m_true, atol=error_tolerance)
    @test isapprox(b, b_true, atol=error_tolerance)

    # detrend
    y_detrended = MicroTracker.detrend(y)
    
    @test isapprox(fit_line(x, y_detrended)[1], 0.0, atol=error_tolerance)

    # fft
    xf, yf = fftclean(x, y)
    @test isapprox(yf[argmax(yf)], a1, atol=error_tolerance)
    @test isapprox(xf[argmax(yf)], f1, atol=error_tolerance)

    # estimating omega. should return the highest amplitude peak frequency / 2. So f1 / 2 ≈ 1.5   
    @test isapprox(MicroTracker.estimate_omega(x, y), f1 / 2, atol=error_tolerance)
end

@testset "Project Creation" begin
    # use the create project function and then check that the folders are there
    testfolder = "deletethis"
    create_project(testfolder, include_examples=true)

    @test isdir(testfolder)
    @test isdir("$testfolder/particle_data")
    @test isdir("$testfolder/linked_results")
    @test isdir("$testfolder/original_video")

    @test isdir("$testfolder/original_video/5_8p4_28p68")

    rm(testfolder, recursive=true)

end

@testset "simple asset copy" begin
    MicroTracker.simple_example_asset_copy()
    @test isfile("test_example_script.jl")
    rm("test_example_script.jl")
end

@testset "Data Wrangling" begin
    assets_path = joinpath(dirname(pwd()), "assets")
    df = cd(() -> MicroTracker.read_linked_csv("2023-02-20_T15-48.csv"), assets_path)  # load test data from assets
    @test "x" in names(df)  # dataframe is successfully loaded
    @test "particle_u" in names(df)

    # Collapsing time data
    dfg = MicroTracker.collapse_time_data(df)
    @test "V" in names(dfg)
end 

include("linking_tests.jl")
include("python_interactions.jl")
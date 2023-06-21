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
    mkdir(testfolder)
    cd(testfolder)

    create_project_here(include_examples=true)

    @test isdir("particle_data")
    @test isdir("linked_data")
    @test isdir("original_video")
    @test isdir("original_video/5_8p4_28p68")

    # create an imagej macro
    create_imagej_macro_here(MPP=0.605, minimum_segmentation_diameter=4.5)
    @test isfile("imagej_macro.ijm")
    cd("..")
    rm(testfolder, recursive=true)

end

@testset "Image loading and manipulation" begin
    # image name parsing
    @test MicroTracker.getframenumfromimagename("a0001.tif") == 1
    @test MicroTracker.getframenumfromimagename("a0001.png") == 1
    @test MicroTracker.getframenumfromimagename("5 24p9 1 2022-04-04-16-30-31-16-a-985.tif") == 985
    @test MicroTracker.getframenumfromimagename("05_23_8_2 kept stack0005.tif") == 5

    @test MicroTracker.getimagenamedigitlength("05_23_8_2 kept stack0001.tif") == 4
    @test MicroTracker.getimagenamedigitlength("05_23_8_2 kept stack00001.tif") == 5
    @test MicroTracker.getimagenamedigitlength("a0003.png") == 4

    @test MicroTracker.getfileextension("a0001.tif") == "tif"
    @test MicroTracker.getfileextension("05_23_8_2 kept stack0001.png") == "png"

    @test MicroTracker.getprefixfromimagename("05_23_8_2 kept stack0001.tif") == "05_23_8_2 kept stack"
    @test MicroTracker.getprefixfromimagename("a0001.tif") == "a"
    @test MicroTracker.getprefixfromimagename("5 24p9 1 2022-04-04-16-30-31-16-a-985.tif") == "5 24p9 1 2022-04-04-16-30-31-16-a-"
    
    @test cd(()->loadframe("5_8p4_28p68", 3), get_assets_path()) |> size == (1312, 1312)
    @test_throws ErrorException cd(()->loadframe("this_doesnt_exist", 3), get_assets_path())

    @test cd(()->getvideoresolution("5_8p4_28p68"), get_assets_path()) == (1312, 1312)
end

include("linking_tests.jl")
include("python_interactions.jl")

@testset "numerical functions" begin
    xs = 1.0:201 |> collect
    ys = 2:500 |> collect

    @test MicroTracker.total_displacement(xs, ys) ≈ 536.6600414

    t = 0:200 # 200 frames
    v_actual = 3.0  # constant velocity
    p = v_actual .* t .+ 50.0
    @test all(MicroTracker.numerical_derivative(p) .== v_actual)
end

include("collapsed_tests.jl")
include("plot_tests.jl")
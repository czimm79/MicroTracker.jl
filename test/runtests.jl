using MicroTracker
using Test

include("numerical_tests.jl")

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
    example_linked_data_filename = "(B_mT=(2, Float64), FPS=(3, Float64), f_Hz=(1, Int64)) - (MPP = 0.605, SEARCH_RANGE_MICRONS = 1000, MEMORY = 0, STUBS_SECONDS = 0.5).csv"
    @test isfile("linked_data/$example_linked_data_filename")
    @test isfile("microtracker+pluto.jl")

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

include("python_interactions.jl")
include("linking_tests.jl")
include("collapsed_tests.jl")
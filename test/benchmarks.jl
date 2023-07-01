using MicroTracker
using BenchmarkTools

#let
    t = 0:200 # 200 frames
    v_actual = 3.0  # constant velocity
    p = v_actual .* t .+ 50.0

    pytime = @btime MicroTracker.np.gradient(p)
    jltime = @btime MicroTracker.numerical_derivative(p)

    # 61x faster, but does have the overhead of calling python
#end

using Plots
plotstime = @btime plot(t, p.*sin.(t))

using CairoMakie
cairotime = @btime lines(t, p.*sin.(t))

using Images

img = load("$(pwd())/assets/original_video/5_8p4_28p68/a0000.tif")

@btime load("$(pwd())/assets/original_video/5_8p4_28p68/a0000.tif")

@btime image(img)

@btime plot(img)

# plots is now 16.35/5.16 = 3.17x faster...
16.35/5.16
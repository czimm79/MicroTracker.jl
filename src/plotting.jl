"""
    plotannotatedframe(linked_data::AbstractDataFrame, filename::AbstractString, framenumber::Int; showimage=true, showellipse=true, plotkwargs...)

Display a single frame of a video with all microbot trajectories overlaid. Optionally, hide the fit ellipses or the image.

To plot a single microbot's trajectory, use [`plotannotatedframe_single`](@ref). `plotkwargs` are passed to `plot!()` and are intended to change the appearance of the plot.
"""
function plotannotatedframe(linked_data::AbstractDataFrame, filename::AbstractString, framenumber::Int; showimage=true, showellipse=true, plotkwargs...)
    filename ∈ linked_data.filename || error("The filename $filename was not found in linked_data")
    df = @subset(linked_data, :filename .== filename, :frame .<= framenumber)
    video_resolution = first(df.video_resolution)
    
    if typeof(video_resolution) <: AbstractString   # catch if its not a tuple
        video_resolution = parse_to_tuple(video_resolution)
    end

    if showimage
        img = loadframe(filename, framenumber)
        p = plot(img)
    else
        p = plot()
    end

    for i in unique(df.particle_unique)
        df_sub = @subset(df, :particle_unique .== i)
        plot!(df_sub.x, df_sub.y, legend=false)

        if showellipse
            major = df_sub.Major[end]
            minor = df_sub.Minor[end]
            pos = [df_sub.x[end], df_sub.y[end]]
            angle = deg2rad(180 - df_sub.Angle[end])
            #@info major, minor, pos, angle
            ellipse_xs, ellipse_ys = ellipse(major, minor, pos, angle)
            plot!(ellipse_xs, ellipse_ys, lw=1, color=:cyan, α=0.8)
        end
    end

    if showimage == false  # make the limits view the entire video by default
        plot!(;xlims=(-100, video_resolution[1]+100), yflip=true, ylims=(-100, video_resolution[2]+100))
    end

    plot!(;titlefontsize=8, plotkwargs...)
    p
end

"""
    plotannotatedframe_single(linked_data::AbstractDataFrame, particle_unique::AbstractString, framenumber::Int; showimage=true, showellipse=true, plotkwargs...)

Display a single frame of a video, with a single chosen microbot trajectory overlaid. Optionally, hide the fit ellipses or the image.

To plot all microbot trajectories, use [`plotannotatedframe`](@ref). `plotkwargs` are passed to `plot!()` and are intended to change the appearance of the plot.
"""
function plotannotatedframe_single(linked_data::AbstractDataFrame, particle_unique::AbstractString, framenumber::Int; showimage=true, showellipse=true, plotkwargs...)
    df_single = @subset(linked_data, :particle_unique .== particle_unique, :frame .<= framenumber)
    filename = df_single.filename |> first

    plotannotatedframe(df_single, filename, framenumber; showimage=showimage, showellipse=showellipse, plotkwargs...)
end

"""
    trajectory_analyzer(linked_data, collapsed_data, particle_unique::AbstractString, [framenumber; [size_variable="Major_um"], [annotationkwargs...])

Display a comphrehensive dashboard of a single microbot, including instantaneous velocity, a chosen `size_variable`, and the FFT of the `size_variable`.

# Arguments
- `linked_data` : `AbstractDataFrame`, time-series linked data, as returned by [`load_linked_data`](@ref) or [`batch_particle_data_to_linked_data`](@ref).
- `collapsed_data` : `AbstractDataFrame`, collapsed data with a row per microbot, as returned by [`collapse_data`](@ref).
- `particle_unique` : `AbstractString`. The unique identifier of the microbot to be analyzed.
- `framenumber` : (Optional) `Int` The frame number to be displayed. If not provided, the last frame is used.
- `size_variable` : (Optional) `AbstractString`, The column name of the size variable to be displayed. Defaults to `"Major_um"`.
- `annotationkwargs` : (Optional) Keyword arguments passed to [`plotannotatedframe_single()`](@ref).
"""
function trajectory_analyzer(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, particle_unique::AbstractString; 
    size_variable="Major_um", annotationkwargs...)

    df_particle = @subset(linked_data, :particle_unique .== particle_unique)
    lastframe = maximum(df_particle.frame) - 1  # some microscopes index with 0
    trajectory_analyzer(linked_data, collapsed_data, particle_unique, lastframe; size_variable=size_variable, annotationkwargs...)
end

function trajectory_analyzer(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, 
    particle_unique::AbstractString, framenumber::Int; size_variable="Major_um", annotationkwargs...)

    size_variable ∈ names(linked_data) || error("$size_variable is not a valid column in linked_data.")
    # Get relevant data
    df = @subset(linked_data, :particle_unique .== particle_unique)
    dfavg = @subset(collapsed_data, :particle_unique .== particle_unique)

    # Average values from collapsed_data
    V̄ = first(dfavg.V)
    R = first(dfavg.R)
    Ω_est = first(dfavg.Ω_est)

    # check if framenumber is valid
    if framenumber > df.frame[end]
        @warn "framenumber $framenumber is greater than the last frame in the data, $(df.frame[end]). Using the last frame instead."
        framenumber = df.frame[end]
    end

    # find the time that corresponds to the framenumber
    idx = findfirst(df.frame .== framenumber)
    t = df[idx, :time]

    # Instantaneous velocity plot
    p1 = plot(df.time, df.dp_um, xlabel="Time (s)", ylabel="Speed (µm/s)")
    hline!([V̄], ls=:dot, lw=2, color=:black)
    vline!([t], color=:grey, lw=1)
    annotate!(upperright(p1)..., text("Mean = $(round(V̄, digits=2)) μm/s", 7, :right))

    # Size
    p2 = plot(df[!,:time], df[!, size_variable], xlabel="Time (s)", ylabel=size_variable)
    if size_variable == "Major_um"
        ylabel!("Major axis (µm)")
    end
    vline!([t], color=:grey, lw=1)
    annotate!(upperright(p2)..., text("R = $(round(R, digits=1)) μm", 7, :right))

    # fft
    xf, yf = fftclean(df.time, df[!, size_variable])
    p3 = plot(xf, yf, xlabel="Frequency (Hz)", ylabel="Amplitude")
    annotate!(upperright(p3)..., text("Estimated Ω = $(round(Ω_est, digits=1)) Hz", 7, :right))

    # trajectory
    p4 = plotannotatedframe_single(@subset(linked_data, :frame .<= framenumber), particle_unique, framenumber; annotationkwargs...)
    title!(particle_unique)

    # all together
    l = @layout [[grid(3,1)] b{0.5w}]
    plot(p1, p2, p3, p4, layout=l, guidefontsize=9, dpi=400, legend=false)
end

"""
    upperright(p::Plots.Plot)

Return a tuple of coordinates corresponding to the upper right corner of a plot, plus an increase of `oob` percentage in the y direction.
"""
function upperright(p::Plots.Plot; oob=0.03)
    (xlims(p)[2], ylims(p)[2] * (1+oob))
end


"""
    animate_trajectory_analyzer(linked_data, collapsed_data, particle_unique, savepath, [framerange]; animation_speed_multiplier=1, size_variable="Major_um", annotationkwargs...)

Export an animation of the trajectory analyzer and save it to `savepath`.

# Arguments
- `linked_data` : `AbstractDataFrame`, time-series linked data, as returned by [`load_linked_data`](@ref) or [`batch_particle_data_to_linked_data`](@ref).
- `collapsed_data` : `AbstractDataFrame`, collapsed data with a row per microbot, as returned by [`collapse_data`](@ref).
- `particle_unique` : `AbstractString`. The unique identifier of the microbot to be analyzed.
- `savepath` : `AbstractString`. The path to save the animation to.
- `framerange` : (Optional) `UnitRange{Int64}`. The range of frames to be displayed. If not provided, the entire trajectory is animated.
- `animation_speed_multiplier` : (Optional) `Int`. The speed of the animation. Defaults to 1.
- `size_variable` : (Optional) `AbstractString`, The column name of the size variable to be displayed. Defaults to `"Major_um"`.
- `annotationkwargs` : (Optional) Keyword arguments passed to [`plotannotatedframe_single()`](@ref).

# Example
```julia-repl
julia> trajectory_analyzer(linked_data, collapsed_data, "5_13p5_61p35-2", "my_animation.mp4")
[ Info: Creating animation: Frame = 5
...
[ Info: Saved animation to ~/myanimation.gif
```
"""
function animate_trajectory_analyzer(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, 
    particle_unique::AbstractString, savepath::AbstractString; animation_speed_multiplier=1, size_variable="Major_um", annotationkwargs...)

    df = @subset(linked_data, :particle_unique .== particle_unique)
    firstframe = minimum(df.frame)
    lastframe = maximum(df.frame)
    framerange = firstframe:lastframe

    animate_trajectory_analyzer(linked_data, collapsed_data, particle_unique, savepath, framerange; 
        animation_speed_multiplier=animation_speed_multiplier, size_variable=size_variable, annotationkwargs...)

end

function animate_trajectory_analyzer(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, 
    particle_unique::AbstractString, savepath::AbstractString, framerange::UnitRange{Int64}; animation_speed_multiplier=1, size_variable="Major_um", annotationkwargs...)

    df = @subset(linked_data, :particle_unique .== particle_unique)
    FPS = df.FPS[1]

    anim = Animation()
    for framenumber in framerange
        mod(framenumber, 5) == 0 && @info "Creating animation: Frame = $(framenumber)"
        p = trajectory_analyzer(linked_data, collapsed_data, particle_unique, framenumber; size_variable=size_variable, annotationkwargs...)
        frame(anim)
    end
    mp4(anim, savepath, fps=FPS*animation_speed_multiplier)
end
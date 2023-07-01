"""
    plotannotatedframe(linked_data::AbstractDataFrame, filename::AbstractString, framenumber::Int; showimage=true, showellipse=true, plotkwargs...)

Display a single frame of a video with all microbot trajectories overlaid. Optionally, hide the fit ellipses or the image.

To plot a single microbot's trajectory, use [`plotannotatedframe_single`](@ref). `plotkwargs` are passed to `plot!()` and are intended to change the appearance of the plot.
"""
function plotannotatedframe(linked_data::AbstractDataFrame, filename::AbstractString, framenumber::Int; showimage=true, showellipse=true, plotkwargs...)
    filename ∈ linked_data.filename || error("The filename $filename was not found in linked_data")
    df = @subset(linked_data, :filename .== filename, :frame .<= framenumber)

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
    plot!(;plotkwargs...)
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
    trajectory_analyzer_scrubbable(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, particle_unique::AbstractString, framenumber::Int; size_variable="Major_um", annotationkwargs...)

Display a comphrehensive dashboard of a single microbot, including instantaneous velocity, a chosen `size_variable`, and the FFT of the `size_variable`.

This version is scrubbable, i.e. a certain frame can be chosen for the video display and highlighted data point. This is highly recommended for use in a Pluto notebook.
`annotationkwargs` are passed to [`plotannotatedframe_single()`](@ref).

To see a static last frame version of this plot, use [`trajectory_analyzer`](@ref).
"""
function trajectory_analyzer_scrubbable(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, 
                                        particle_unique::AbstractString, framenumber::Int; size_variable="Major_um", showpoints=true, annotationkwargs...)

    size_variable ∈ names(linked_data) || error("$size_variable is not a valid column in linked_data.")

    # Get relevant data
    df = @subset(linked_data, :particle_unique .== particle_unique)
    dfavg = @subset(collapsed_data, :particle_unique .== particle_unique)
    V̄ = first(dfavg.V)

    # Instantaneous velocity plot
    p1 = plot(df.time, df.dp_um, xlabel="Time (s)", ylabel="Speed (µm/s)", title=particle_unique, titlefontsize=8)
    hline!([V̄], ls=:dot, lw=2, color=:black)
    showpoints && scatter!([df[framenumber, :time]], [df[framenumber, :dp_um]], ms=3, color=:orange)

    # Size
    p2 = plot(df[!,:time], df[!, size_variable], xlabel="Time (s)", ylabel=size_variable)
    showpoints && scatter!([df[framenumber, :time]], [df[framenumber, size_variable]], ms=3, color=:orange)

    # fft
    xf, yf = fftclean(df.time, df[!, size_variable])
    p3 = plot(xf, yf, xlabel="Frequency (Hz)", ylabel="Amplitude")

    # trajectory
    p4 = plotannotatedframe_single(@subset(linked_data, :frame .<= framenumber), particle_unique, framenumber; annotationkwargs...)

    # all together
    l = @layout [[grid(3,1)] b{0.5w}]
    plot(p1, p2, p3, p4, layout=l, guidefontsize=9, dpi=400, legend=false)
end

"""
    trajectory_analyzer(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, particle_unique::AbstractString; size_variable="Major_um", annotationkwargs...)

Display a comphrehensive dashboard of a single microbot, including instantaneous velocity, a chosen `size_variable`, and the FFT of the `size_variable`.

This version is static, i.e. the last frame is chosen for the video display. For an interactive version for use in a Pluto notebook, use [`trajectory_analyzer_scrubbable`](@ref).
"""
function trajectory_analyzer(linked_data::AbstractDataFrame, collapsed_data::AbstractDataFrame, particle_unique::AbstractString; size_variable="Major_um", annotationkwargs...)
    df_particle = @subset(linked_data, :particle_unique .== particle_unique)
    lastframe = maximum(df_particle.frame) - 1  # some microscopes index with 0
    trajectory_analyzer_scrubbable(linked_data, collapsed_data, particle_unique, lastframe; size_variable=size_variable, showpoints=false, annotationkwargs...)
end
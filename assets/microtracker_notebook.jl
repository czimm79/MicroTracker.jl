### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ f5d8a43d-5ef4-47f1-bbd9-1627e7773db1
begin
    import Pkg
    # careful: this is _not_ a reproducible environment
    # activate the global environment
    Pkg.activate()

    using MicroTracker, PlutoUI, StatsPlots
end

# ╔═╡ 02de8d90-1ab0-11ee-1335-7982d8fffea9
md"# 🔎 MicroTracker Notebook

If you're unfamiliar with Pluto, see their [ReadMe](https://github.com/fonsp/Pluto.jl) or better yet, open the **Getting Started** notebook on the landing page when you launched Pluto.

#### Intializing packages
_When running this notebook for the first time, Pluto installs any packages you haven't already added to a Julia environment on your system. Hang in there!_
"

# ╔═╡ 53326ece-181f-4237-b78a-ee30534e0da9
md"# 🔗 Link"

# ╔═╡ b44f000b-9292-46ce-af95-e8cde7cab7f3
md"## Define input parameters
Follow the [input parameters](https://czimm79.github.io/MicroTracker.jl/dev/linking/#Input-parameters) documentation to modify `translation_dict` and `linking_settings` according to your experimental setup.
"

# ╔═╡ 1f1e92c2-44a8-44db-a1e9-84d64093c026
translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, Float64))

# ╔═╡ 29734e9c-3e83-4d2e-a97a-ea58917b300f
linking_settings = (
    MPP = 0.605,  # Microns per pixel, scale of objective.
    SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling. 								 # Determines "how far" to look to link.
    MEMORY = 0,  # number of frames the blob can dissapear and still be remembered
    STUBS_SECONDS = 0.5,  # trajectory needs to exist for at least this many seconds 
)

# ╔═╡ 8f6c8e85-a02c-41e4-b5d8-e96c9f92e564
md"## Batch link all data into trajectories
MicroTracker has detailed docstrings! Click the *Live Docs* button in the bottom right of Pluto and put your cursor in the `batch_particle_data_to_linked_data` function in the cell below to see the docs.
"

# ╔═╡ e531be81-31c6-4451-9b88-c6b726c50772
linked_data = batch_particle_data_to_linked_data(
	translation_dict, linking_settings, save_to_csv=false
)

# ╔═╡ 1e35353f-0b77-4931-a2e7-60cb1fcec40c
md"# 💥 Collapse time data"

# ╔═╡ 413f3235-6b33-458e-8c51-94761e3390e0
collapsed_data = collapse_data(linked_data, translation_dict)

# ╔═╡ 1d7399e7-3f36-48e5-9b7e-ccbf520716ac
md"## Filter based on summary statistics"

# ╔═╡ 97e9c0eb-e4d2-4b25-a4c9-11e77fc4ef82
filter_settings = (
    MIN_VELOCITY = 10.0,  # um / s  
    MIN_BOUNDING_RADIUS = 3.38,  # um
    MAX_BOUNDING_RADIUS = 75,  # µm
    MIN_DISPLACEMENT = 0,  # µm
)

# ╔═╡ add27f21-3813-49f6-8866-0051cbd6bf9f
fcd = filtered_collapsed_data = filter_trajectories(collapsed_data, filter_settings)

# ╔═╡ 28ff2912-6b6c-4a4d-9822-451e1caa9858
names(fcd)

# ╔═╡ 0cbcf260-e543-4a21-9cc7-27bf49931aa9
md"## Custom filters

If you want to apply additional filters, use the syntax from [DataFramesMeta](https://juliadata.github.io/DataFramesMeta.jl/dev/#@subset-and-@subset!) like so.

*Note: a semicolon supresses the output in Julia.*
"

# ╔═╡ d0e906bf-3fe1-4be7-a1ac-80ccce44233e
fcd2 = @subset(fcd, :Circularity .< 0.6);

# ╔═╡ 33fb03a4-648d-4388-aaa3-3f91c59cf760
md"# 📈 Plot and Analyze
I recommend using [Plots/StatsPlots.jl](https://docs.juliaplots.org/latest/generated/statsplots/) to generate custom plots for publications. Note that Pluto *does not* require cells to be in the correct order. To see where a variable might be defined, `Ctrl+click` it.
"

# ╔═╡ 8e6c903d-e1fa-4e7b-80cd-1943df291438
@df fcd scatter(:R, :V, group=:B_mT, xlims=(0, 40), ylims=(0, 100), xlabel="R (µm)", ylabel="V (µm/s)", leg_title = "B (mT)")

# ╔═╡ 0cb72709-264b-450a-a80c-683e7fc9eca4
md"## Trajectory analyzer"

# ╔═╡ d5b3e4f5-3934-49b5-8cf2-00e5de35f189
@bind showimage CheckBox()

# ╔═╡ 62dd7a92-6988-4bef-81cf-2411ecbe004a
@bind chosen_particle_num Slider(1:length(fcd.particle_unique))

# ╔═╡ c9ab5efc-f170-45aa-812d-a311ed71073f
chosenparticle = fcd.particle_unique[chosen_particle_num]

# ╔═╡ dff948e4-303f-480b-8de2-3af2ea90579c
begin
	dfparticle = @subset(linked_data, :particle_unique .== chosenparticle)
	minframe = dfparticle.frame |> minimum
	maxframe = dfparticle.frame |> maximum
	@bind framenumber Slider(minframe:maxframe, show_value=true)

end

# ╔═╡ e5a49cd2-49a1-4d13-9eec-dd68acc137b0
trajectory_analyzer(linked_data, fcd, chosenparticle, framenumber, showimage=showimage)

# ╔═╡ 10ac26f2-c153-4a67-aa6e-90e123dc7a96
dfparticle

# ╔═╡ 47d46061-0042-48a8-bf42-ca3530109d29
md"# Appendix"

# ╔═╡ f012dd89-292a-4e54-a2f7-8537a980b8c2
PlutoUI.TableOfContents()

# ╔═╡ Cell order:
# ╟─02de8d90-1ab0-11ee-1335-7982d8fffea9
# ╠═f5d8a43d-5ef4-47f1-bbd9-1627e7773db1
# ╟─53326ece-181f-4237-b78a-ee30534e0da9
# ╟─b44f000b-9292-46ce-af95-e8cde7cab7f3
# ╠═1f1e92c2-44a8-44db-a1e9-84d64093c026
# ╠═29734e9c-3e83-4d2e-a97a-ea58917b300f
# ╟─8f6c8e85-a02c-41e4-b5d8-e96c9f92e564
# ╠═e531be81-31c6-4451-9b88-c6b726c50772
# ╟─1e35353f-0b77-4931-a2e7-60cb1fcec40c
# ╠═413f3235-6b33-458e-8c51-94761e3390e0
# ╟─1d7399e7-3f36-48e5-9b7e-ccbf520716ac
# ╠═97e9c0eb-e4d2-4b25-a4c9-11e77fc4ef82
# ╠═add27f21-3813-49f6-8866-0051cbd6bf9f
# ╠═28ff2912-6b6c-4a4d-9822-451e1caa9858
# ╟─0cbcf260-e543-4a21-9cc7-27bf49931aa9
# ╠═d0e906bf-3fe1-4be7-a1ac-80ccce44233e
# ╟─33fb03a4-648d-4388-aaa3-3f91c59cf760
# ╠═8e6c903d-e1fa-4e7b-80cd-1943df291438
# ╟─0cb72709-264b-450a-a80c-683e7fc9eca4
# ╠═e5a49cd2-49a1-4d13-9eec-dd68acc137b0
# ╠═d5b3e4f5-3934-49b5-8cf2-00e5de35f189
# ╠═62dd7a92-6988-4bef-81cf-2411ecbe004a
# ╠═dff948e4-303f-480b-8de2-3af2ea90579c
# ╟─c9ab5efc-f170-45aa-812d-a311ed71073f
# ╠═10ac26f2-c153-4a67-aa6e-90e123dc7a96
# ╟─47d46061-0042-48a8-bf42-ca3530109d29
# ╠═f012dd89-292a-4e54-a2f7-8537a980b8c2

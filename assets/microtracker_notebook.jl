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

# ╔═╡ 5f58ee8d-7b44-48d6-b7b4-3fb484e4b423
begin
	using Pkg; Pkg.activate(".")
	using MicroTracker  # re-exports DataFramesMeta and Plots
	using PlutoUI
end

# ╔═╡ 02de8d90-1ab0-11ee-1335-7982d8fffea9
md"# MicroTracker Example Notebook
*Use with MicroTracker v0.1.0*
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

# ╔═╡ e531be81-31c6-4451-9b88-c6b726c50772
linked_data = batch_particle_data_to_linked_data(
	translation_dict, linking_settings, save_to_csv=false
)

# ╔═╡ 413f3235-6b33-458e-8c51-94761e3390e0
collapsed_data = collapse_data(linked_data)

# ╔═╡ 97e9c0eb-e4d2-4b25-a4c9-11e77fc4ef82
filter_settings = (
    MIN_VELOCITY = 10.0,  # um / s  
    MIN_BOUNDING_RADIUS = 3.38,  # um
    MAX_BOUNDING_RADIUS = 75,  # µm
    MIN_DISPLACEMENT = 0,  # µm
)

# ╔═╡ add27f21-3813-49f6-8866-0051cbd6bf9f
fcd = filtered_chosen_data = filter_trajectories(collapsed_data, filter_settings)

# ╔═╡ 28ff2912-6b6c-4a4d-9822-451e1caa9858
names(fcd)

# ╔═╡ 8e6c903d-e1fa-4e7b-80cd-1943df291438
# begin
# 	@df fcd scatter(:R, :V, group=:f, xlabel="R (µm)", ylabel="V (µm/s)")
# 	#xlims!(0, 40)
# 	#ylims!(0, 100)
# end

# ╔═╡ c23ea078-f32c-4491-ab40-391d93c0391d
fcd.particle_unique

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
trajectory_analyzer(linked_data, fcd, chosenparticle, framenumber, showimage=false, xlims=(0, 1200), ylims=(0, 1200))

# ╔═╡ 10ac26f2-c153-4a67-aa6e-90e123dc7a96
dfparticle

# ╔═╡ Cell order:
# ╠═02de8d90-1ab0-11ee-1335-7982d8fffea9
# ╠═5f58ee8d-7b44-48d6-b7b4-3fb484e4b423
# ╠═1f1e92c2-44a8-44db-a1e9-84d64093c026
# ╠═29734e9c-3e83-4d2e-a97a-ea58917b300f
# ╠═e531be81-31c6-4451-9b88-c6b726c50772
# ╠═413f3235-6b33-458e-8c51-94761e3390e0
# ╠═97e9c0eb-e4d2-4b25-a4c9-11e77fc4ef82
# ╠═add27f21-3813-49f6-8866-0051cbd6bf9f
# ╠═28ff2912-6b6c-4a4d-9822-451e1caa9858
# ╠═8e6c903d-e1fa-4e7b-80cd-1943df291438
# ╠═c23ea078-f32c-4491-ab40-391d93c0391d
# ╠═e5a49cd2-49a1-4d13-9eec-dd68acc137b0
# ╠═62dd7a92-6988-4bef-81cf-2411ecbe004a
# ╠═dff948e4-303f-480b-8de2-3af2ea90579c
# ╟─c9ab5efc-f170-45aa-812d-a311ed71073f
# ╠═10ac26f2-c153-4a67-aa6e-90e123dc7a96

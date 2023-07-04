### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ 5f58ee8d-7b44-48d6-b7b4-3fb484e4b423
begin
	using Pkg; Pkg.activate(".")
	using MicroTracker
end

# ╔═╡ 02de8d90-1ab0-11ee-1335-7982d8fffea9
md"# Test"

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
my_linked_data = batch_particle_data_to_linked_data(
	translation_dict, linking_settings, save_to_csv=false
)

# ╔═╡ 413f3235-6b33-458e-8c51-94761e3390e0
collapse_data(my_linked_data)

# ╔═╡ Cell order:
# ╠═02de8d90-1ab0-11ee-1335-7982d8fffea9
# ╠═5f58ee8d-7b44-48d6-b7b4-3fb484e4b423
# ╠═1f1e92c2-44a8-44db-a1e9-84d64093c026
# ╠═29734e9c-3e83-4d2e-a97a-ea58917b300f
# ╠═e531be81-31c6-4451-9b88-c6b726c50772
# ╠═413f3235-6b33-458e-8c51-94761e3390e0

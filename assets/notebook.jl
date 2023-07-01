### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# ╔═╡ b1e6e20a-5d98-409c-ae4d-48b658448c4e
begin
	using Pkg; Pkg.activate(".")
	using MicroTracker
end

# ╔═╡ 36cc4cb0-15fa-11ee-170c-439679fed71b
md"""
# MicroTracker.jl
Welcome to the [Pluto](https://github.com/fonsp/Pluto.jl) notebook for [MicroTracker](https://github.com/czimm79/MicroTracker.jl)! This notebook contains the code for a basic microbot tracking and analyzing workflow. It also assumes you've already followed the [Setting Up] docs and created a project folder and Julia environment for your project.
"""

# ╔═╡ 0488a56e-a214-412b-a2e6-a65d55abc7bf
md"## Filename pattern
Follow docs [here] that match how you name your microscopy videos.
"

# ╔═╡ 8559277c-992e-4b8a-89d4-9de2071e78ba
translation_dict = Dict("f_Hz"=>(1, Int64), "B_mT"=>(2, Float64), "FPS"=>(3, Float64))

# ╔═╡ 4c3b411b-7121-4dba-bf08-965ba855b34a
md"## Linking settings
Follow docs [here] and set tracking parameters. If FPS is constant across all videos, it should be defined in `linking_settings`. If FPS is not constant and changes video to video, it should be listed in the `translation_dict`.
"

# ╔═╡ bde8a3d1-bc2a-4611-a7c5-7daaf6cb6e3b
linking_settings = (
    MPP = 0.605,  # Microns per pixel, scale of objective.
    SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling. 								 # Determines "how far" to look to link.
    MEMORY = 0,  # number of frames the blob can dissapear and still be remembered
    STUBS_SECONDS = 0.5,  # trajectory needs to exist for at least this many seconds 
)

# ╔═╡ 5de0c1d8-785e-4737-baec-2450f7c28936
md"""
## Process all particle data into linked data
"""

# ╔═╡ f9f6919f-6143-412e-895f-38ba2382f5a4
my_linked_data = batch_particle_data_to_linked_data(
	translation_dict, linking_settings, save_to_csv=false
)

# ╔═╡ bf5170c0-aeff-4370-ba96-1c3222a68771
md"# Summarize/collapse linked_data"

# ╔═╡ d5f30ffd-030b-44dd-b219-792e329a3db9
collapse_data(my_linked_data)

# ╔═╡ Cell order:
# ╟─36cc4cb0-15fa-11ee-170c-439679fed71b
# ╠═b1e6e20a-5d98-409c-ae4d-48b658448c4e
# ╟─0488a56e-a214-412b-a2e6-a65d55abc7bf
# ╠═8559277c-992e-4b8a-89d4-9de2071e78ba
# ╟─4c3b411b-7121-4dba-bf08-965ba855b34a
# ╠═bde8a3d1-bc2a-4611-a7c5-7daaf6cb6e3b
# ╟─5de0c1d8-785e-4737-baec-2450f7c28936
# ╠═f9f6919f-6143-412e-895f-38ba2382f5a4
# ╟─bf5170c0-aeff-4370-ba96-1c3222a68771
# ╠═d5f30ffd-030b-44dd-b219-792e329a3db9

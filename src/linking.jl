"""
    get_particle_csvs()

Return a list of all `.csv` files contained in the `particle_data` folder.
"""
function get_particle_csvs()
    filter!(x->occursin(".csv", x), readdir("particle_data"))
end


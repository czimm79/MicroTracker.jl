"""
    get_particle_csvs()

Return a list of all `.csv` files contained in the `particle_data` folder.
"""
function get_particle_csvs()
    filter!(x->occursin(".csv", x), readdir("particle_data"))
end

"""
    extract_frame_from_label(label::AbstractString)

When using ImageJ data, the frame column does not exist, so we need to pull it out of the label column.

This function assumes the frame number is at the end of the label, and that it is the only number in the label.
"""
function extract_frame_from_label(label::AbstractString)
    re = r"[0-9]+$" # regex to find digits at end of string
	digit_indexes = findfirst(re, String(label))  # gets location of frame in label
	digits = label[digit_indexes]  # pulls out digits
	return parse(Int, digits)  # always returns Int
end

"""
    load_particle_data(video_name::AbstractString)
    
Read a particle data `.csv` into a `DataFrame`. Assumes the `.csv` file is in the `particle_data` folder.
"""
function load_particle_data(video_name::AbstractString)
    @info "loading particle data for $video_name"

    df = CSV.read("particle_data/$video_name.csv", DataFrame)
    @transform!(df, :filename = video_name) # add filename column

    if "X" in names(df)  # lets lowercase the column names so it works with trackpy
        @info " -> looks like ImageJ data, renaming X Y columns to lowercase"
        rename!(df, Dict("X" => "x", "Y" => "y"))
    end

    if "frame" ∉ names(df)
        @info " -> frame column not found, extracting from label"
        df.frame = [extract_frame_from_label(label) for label in df.Label]
    end

    if " " ∈ names(df)
        @info " -> blank column found, removing"
        select!(df, Not(" "))
    end

    return df
end

"""
    add_info_columns_from_filename(df::AbstractDataFrame, translation_dict::AbstractDict)

Extract experimental metadata from the `filename` column and create a new column for each.

Assumes the filename is separated by underscores and periods are denoted by `p`. The `translation_dict`
details the filename format. For full explanation, see the MicroTracker docs (ref needed).

# Example
```jldoctest
julia> test_filename = "5_13p5_61p35"
"5_13p5_61p35"
```
"""
function add_info_columns_from_filename(df::AbstractDataFrame, translation_dict::Dict)
    @info "adding info columns: $(keys(translation_dict))"

    df_new = copy(df)

    filename = df.filename[1]
    filename_with_periods = replace(filename, "p" => ".")
    split_filename = split(filename_with_periods, "_")

    for (key, val) in translation_dict
        if val[2] == String
            column_entry = split_filename[val[1]] |> string
        else  # floats, ints
            column_entry = parse(val[2], split_filename[val[1]])
        end

        insertcols!(df_new, 1, key => column_entry)
    end
    return df_new
end

function link(particle_data::AbstractDataFrame, linking_settings::NamedTuple)
    SEARCH_RANGE_MICRONS = linking_settings.SEARCH_RANGE_MICRONS
    MPP = linking_settings.MPP
    FPS = linking_settings.FPS
    STUBS_SECONDS = linking_settings.STUBS_SECONDS
    MEMORY = linking_settings.MEMORY
    filename = particle_data.filename[1]

    # convert settings in µm to pixels for linker
    SEARCH_RANGE = trunc(Int, SEARCH_RANGE_MICRONS / MPP / FPS)  # pixels::Int
	STUBS = trunc(Int64, STUBS_SECONDS * FPS)  # frames

    # This function takes a julia DataFrame, so we need to convert it to python for trackpy
    py_particle_data = jldf_to_pydf(particle_data)

    @info "Linking $(particle_data.filename[1]) ..."
    tp.quiet()  # make it quiet, I don't need to see the result of every frame
    linked = tp.link(py_particle_data, search_range=SEARCH_RANGE, memory=MEMORY)
    linked_without_stubs = tp.filter_stubs(linked, STUBS)

    @info """  
        Done! $(linked.particle.nunique()) trajectories present.
        Filtered out stub trajectories < $(STUBS_SECONDS)s resulting in $(linked_without_stubs.particle.nunique()) trajectories.
        \n""" 

    jldf = pydf_to_jldf(linked_without_stubs)

    # seems trackpy adds another frame column, remove it for cleanliness
    if "frame_1" in names(jldf)

        if  jldf.frame == jldf.frame_1
            select!(jldf, Not("frame_1"))
        else
            error("internal error: frame_1 column does not match frame column after linking")
        end
    end

    return jldf
end


# Functions relating to working on particle_data. I.E., segmented data from ImageJ or illastik.

"""
    get_names_in_particle_data()

Return a list of all `.csv` files contained in the `particle_data` folder.
"""
function get_names_in_particle_data()
    csv_vector = filter!(x->occursin(".csv", x), readdir("particle_data"))
    [split(x, ".")[1] for x in csv_vector]  # remove the .csv extension
end

"""
    extract_frame_from_label(label::AbstractString)

When using ImageJ data, the frame column does not exist, so we need to pull it out of the label column.

This function assumes the frame number is at the end of the label.

# Example
```jldoctest
julia> MicroTracker.extract_frame_from_label("5_8p4_28p68:slice:51")
51
```
"""
function extract_frame_from_label(label::AbstractString)
    re = r"[0-9]+$" # regex to find digits at end of string
	digit_indexes = findfirst(re, String(label))  # gets location of frame in label
	digits = label[digit_indexes]  # pulls out digits
	return parse(Int, digits)  # always returns Int
end

"""
    load_particle_data(video_name::AbstractString)
    
Read a particle data `.csv` located in `/particle_data` into a `DataFrame`.

If the `.csv` file is from ImageJ (contains X, Y, and Label columns, not x, y, and frame), it will:
1. Extract the frame number from the label column and add it as a new column using [`extract_frame_from_label`](@ref)
2. Rename the `X` and `Y` columns to `x` and `y` so it works with [`link`](@ref).
3. Remove any columns with a blank name.
4. Rename the `Circ.` column to `Circ` so it works with Julia symbol notation.
"""
function load_particle_data(video_name::AbstractString)
    @info "Loading particle data for $video_name"

    df = CSV.read("particle_data/$video_name.csv", DataFrame)
    @transform!(df, :filename = video_name) # add filename column

    if "X" in names(df)  # lets lowercase the column names so it works with trackpy
        @info " -> looks like ImageJ data, extracting frame column and making X Y lowercase."
        rename!(df, Dict("X" => "x", "Y" => "y"))
    end

    if "frame" ∉ names(df)
        #@info " -> frame column not found, extracting from label"
        df.frame = [extract_frame_from_label(label) for label in df.Label]

        # after we have the frame column, we don't need the Label column anymore
        select!(df, Not(:Label))
    end

    if " " ∈ names(df)
        #@info " -> blank column found, removing"
        select!(df, Not(" "))
    end

    if "Circ." in names(df)  # imageJ puts a period in this column and it screws with things
        rename!(df, Dict("Circ." => "Circ"))
    end

    return df
end

"""
    add_info_columns_from_filename(particle_data::AbstractDataFrame, translation_dict::AbstractDict)

Extract experimental metadata from the `filename` column and create a new column for each in `particle_data`. Returns
a new `DataFrame`.

Assumes the filename is separated by underscores and periods are denoted by `p`. The `translation_dict`
details the filename format. For full explanation, see the MicroTracker docs: [Translation Dictionary](@ref).
"""
function add_info_columns_from_filename(particle_data::AbstractDataFrame, translation_dict::Dict)
    @info "adding info columns: $(keys(translation_dict))"

    df_new = copy(particle_data)

    filename = particle_data.filename[1]
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

"""
    add_resolution_column!(particle_data::AbstractDataFrame)

Look at a frame of the video in `original_video` which corresponds to the data and add a column for the resolution
of type Tuple{Int, Int}. Modifies `particle_data` in place, signfified by the `!` in the function name.

Uses [`getvideoresolution`](@ref).
"""
function add_resolution_column!(particle_data::AbstractDataFrame)
        res = getvideoresolution(particle_data.filename[1])
        @transform!(particle_data, :video_resolution = res)
end
"""
    load_linked_data(filename)

Read a linked data `.csv` file into a `DataFrame`. Assumes the `.csv` file is in the `linked_data` folder.
"""
function load_linked_data(filename)
    df = CSV.read("linked_data/$filename", DataFrame)

    # make sure the video_resolution column is the correct Tuple type
    df[!, :video_resolution] .= MicroTracker.parse_to_tuple.(df[!, :video_resolution])
    return df
end

"""
    collapse_experimental(dfg::GroupedDataFrame, translation_dict::Dict)

Take a single value from each experimental column per particle and assemble it into a dataframe.

Takes a grouped dataframe of the linked_data. Internal function used in [`collapse_data`](@ref).

# Example
```julia-repl
julia> collapse_experimental(groupby(linked_data, :particle_unique), translation_dict)
37×4 DataFrame
 Row │ particle_unique  B_mT     FPS      f_Hz  
     │ String15         Float64  Float64  Int64
─────┼──────────────────────────────────────────
   1 │ 5_13p5_61p35-0      13.5    61.35      5
   2 │ 5_13p5_61p35-1      13.5    61.35      5
   3 │ 5_13p5_61p35-2      13.5    61.35      5
   4 │ 5_13p5_61p35-3      13.5    61.35      5
   5 │ 5_13p5_61p35-4      13.5    61.35      5
   6 │ 5_13p5_61p35-5      13.5    61.35      5
   7 │ 5_13p5_61p35-6      13.5    61.35      5
   8 │ 5_13p5_61p35-7      13.5    61.35      5
  ⋮  │        ⋮            ⋮        ⋮       ⋮
  31 │ 5_8p4_28p68-9        8.4    28.68      5
  32 │ 5_8p4_28p68-10       8.4    28.68      5
  33 │ 5_8p4_28p68-11       8.4    28.68      5
  34 │ 5_8p4_28p68-12       8.4    28.68      5
  35 │ 5_8p4_28p68-13       8.4    28.68      5
  36 │ 5_8p4_28p68-14       8.4    28.68      5
  37 │ 5_8p4_28p68-15       8.4    28.68      5
                                 22 rows omitted
```
"""
function collapse_experimental(dfg::GroupedDataFrame, translation_dict::Dict)
    translation_keys = Symbol.(keys(translation_dict))

    edf = DataFrame()  # experimental dataframe
    # Now add the experimental columns
    for df_particle in dfg
        edf_particle = DataFrame(particle_unique = first(df_particle[!, :particle_unique]))

        for key in translation_keys
            edf_particle[!, key] .= first(df_particle[!, key])
        end

        if :FPS ∉ translation_keys
            edf_particle[!, :FPS] .= first(df_particle[!, :FPS])
        end

        append!(edf, edf_particle)
    end

    return edf
end


"""
    collapse_data(linked_data::AbstractDataFrame, translation_dict::Dict)

Collapse each time-series microbot trajectory into a single row of summary data for each microbot. 

Uses the translation_dict from [Translation Dictionary](@ref) to include the experimental data.

# Output column definitions
- `V` : The mean of the instantaneous speed, `dp_um`. Always positive, as it is a magnitude. Units of µm/s.
- `Vx` : The mean of the numerical derivative of the x-position. Can be positive or negative. Units of µm/s.
- `Vy` : The mean of the numerical derivative of the y-position. Can be positive or negative. Units of µm/s.
- `Area_um_mean` : The mean of the area of the microbot. Units of µm^2.
- `Ω_est` : The estimated rotation rate extracted from the FFT of the `Major_um` column in the linked data. Performed using the [`estimate_omega`](@ref) function. Units of Hz.
- `R` : The bounding-circle radius/radius of gyration. Calculated as the 95th percentile of the major axis `Major_um` divided by 2. Units of µm.
- `Circularity` : A quantifier based on the aspect ratio of the fit ellipse. Calculated from ImageJ. See [their docs](https://imagej.nih.gov/ij/docs/menus/analyze.html). Unitless.
- `total_displacement_um` : The total displacement of the microbot over its *entire trajectory*. This is already constant in `linked_data`, so just take one of the values. Units of µm.

# Example
```julia-repl
julia> collapse_data(linked_data, translation_dict)
37×13 DataFrame
 Row │ particle_unique  filename      V          Vx           Vy           Area_um_mean  Ω_est      R         Circularity  total_displacement_um  B_mT     FPS      f_Hz  
     │ String15         String15      Float64    Float64      Float64      Float64       Float64    Float64   Float64      Float64                Float64  Float64  Int64
─────┼────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 5_13p5_61p35-0   5_13p5_61p35  88.7683    73.1812      -0.533202       524.844    0.0866525  28.8823      0.466515            425.447         13.5    61.35      5
   2 │ 5_13p5_61p35-1   5_13p5_61p35  84.2168    75.1932      -1.43098        723.553    0.184789   37.7608      0.447464            204.647         13.5    61.35      5
   3 │ 5_13p5_61p35-2   5_13p5_61p35  34.589     25.285        3.95886         66.7345   4.94208    12.1932      0.706898            151.268         13.5    61.35      5
   4 │ 5_13p5_61p35-3   5_13p5_61p35  61.7119    51.8247      -3.01578         80.8338   5.06137    14.7728      0.647094            170.821         13.5    61.35      5
   5 │ 5_13p5_61p35-4   5_13p5_61p35  20.6538     7.68584      0.0244971       23.9995   2.51434     2.91041     0.984024             15.7076        13.5    61.35      5
   6 │ 5_13p5_61p35-5   5_13p5_61p35  21.9972     7.1295      -0.320993        24.6687   2.48485     2.94544     0.98336              41.961         13.5    61.35      5
   7 │ 5_13p5_61p35-6   5_13p5_61p35  22.2261     6.78449     -0.353836        24.5469   2.47104     2.94414     0.982008             40.0362        13.5    61.35      5
   8 │ 5_13p5_61p35-7   5_13p5_61p35  22.2123     6.55907      0.46061         24.4111   2.46496     2.94133     0.983553             36.1651        13.5    61.35      5
  ⋮  │        ⋮              ⋮            ⋮           ⋮            ⋮            ⋮            ⋮         ⋮           ⋮                 ⋮               ⋮        ⋮       ⋮
  31 │ 5_8p4_28p68-9    5_8p4_28p68   40.4129    15.381       35.4248          85.391    5.28316    14.6976      0.628366             54.0731         8.4    28.68      5
  32 │ 5_8p4_28p68-10   5_8p4_28p68   40.729     20.3822      33.0557         566.571    1.88684    26.3958      0.491463             54.3218         8.4    28.68      5
  33 │ 5_8p4_28p68-11   5_8p4_28p68   41.6894    18.5982      35.8152         707.16     1.50947    28.0554      0.509829             56.0121         8.4    28.68      5
  34 │ 5_8p4_28p68-12   5_8p4_28p68    0.700078  -0.0662316   -0.00804089      21.3812   2.64158     2.94514     0.96161               0.0593394      8.4    28.68      5
  35 │ 5_8p4_28p68-13   5_8p4_28p68   39.0276    18.1646      31.7101         660.916    1.50947    27.9988      0.504366             51.1676         8.4    28.68      5
  36 │ 5_8p4_28p68-14   5_8p4_28p68   12.5579    -0.761769     0.545299        15.3284   0.377368    2.89432     0.917512              1.12274        8.4    28.68      5
  37 │ 5_8p4_28p68-15   5_8p4_28p68   47.225     17.9276      40.9265         152.034    5.28316    19.533       0.609                62.9841         8.4    28.68      5
                                                                                                                                                           22 rows omitted
```
"""
function collapse_data(linked_data::AbstractDataFrame, translation_dict::Dict)
    grouped_data = groupby(linked_data, :particle_unique) # mini-dataframes for each particle
    collapsed = @chain grouped_data begin  # start a processing pipeline. each line takes the result of the last.
	
        # Collapse the time series data using a groupby -> combine
        @combine(
            :filename = first(:filename),
            :V = mean(:dp_um), # μm/s,
            :Vx = mean(:dx_um),
            :Vy = mean(:dy_um),
            :Area_um_mean = mean(:Area_um),  # μm^2
            :Ω_est = estimate_omega(:time, :Major_um),  # Hz
            :R = quantile(:Major_um, 0.95) / 2,  # μm, quantile prevents outliers from skewing the result
            :Circularity = mean(:Circ),
            :total_displacement_um = first(:total_displacement_um)
        )
    end

    # Add experimental data
    experimental_data = collapse_experimental(grouped_data, translation_dict)

    return innerjoin(collapsed, experimental_data, on = :particle_unique)
end

"""
    filter_trajectories(collapsed_data::AbstractDataFrame, filter_settings::NamedTuple)

Filter out microbots that may be too small or large, going too slow, or stuck to the substrate.

The `filter_settings` is a `NamedTuple` with the following fields:
- `MIN_VELOCITY` : minimum velocity in um/s
- `MIN_BOUNDING_RADIUS` : minimum bounding radius in um
- `MAX_BOUNDING_RADIUS` : maximum bounding radius in um
- `MIN_DISPLACEMENT` : minimum total displacement in um

# Example
```julia
filter_settings = (
    MIN_VELOCITY = 10.0,  # um / s  
    MIN_BOUNDING_RADIUS = 3.38,  # um
    MAX_BOUNDING_RADIUS = 75,  # µm
    MIN_DISPLACEMENT = 0,  # µm
)

filtered_collapsed_data = filter_trajectories(collapsed_data, filter_settings)
```
"""
function filter_trajectories(collapsed_data::AbstractDataFrame, filter_settings::NamedTuple)
    
	n_before_filtering = size(collapsed_data)[1]
	just_right_data = @subset(collapsed_data, 
		:R .< filter_settings.MAX_BOUNDING_RADIUS,
		:R .> filter_settings.MIN_BOUNDING_RADIUS, 
		:V .> filter_settings.MIN_VELOCITY,
		:total_displacement_um .> filter_settings.MIN_DISPLACEMENT)
    
    n_after_filtering = size(just_right_data)[1]

	@info "filtered trajectories $(n_before_filtering) -> $(n_after_filtering)"

	return just_right_data
end



# filtered_linked_data = MicroTracker.filter_particles(linked_data_with_newcols, filter_settings)
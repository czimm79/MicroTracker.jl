# Collapsing

On this page, you'll process the time-series `linked_data` into `collapsed_data` which summarizes each microbot into a single row.

## Collapse data
The convenient function [`collapse_data`](@ref) calculates the most common metrics used from the metrics calculated from ImageJ [Segmentation](@ref). To see the source code, click on the link to the function and click the blue "source" button to see exactly how they are calculated.

```julia-repl
julia> collapsed_data = collapse_data(linked_data)
37×11 DataFrame
 Row │ particle_unique  filename      FPS      V          Vx           Vy           Area_um_mean  Ω_est       R        ⋯
     │ String15         String15      Float64  Float64    Float64      Float64      Float64       Float64     Float64  ⋯
─────┼──────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1 │ 5_13p5_61p35-0   5_13p5_61p35    61.35  88.7683    73.1812      -0.533202       524.844     0.0866525  30.1871  ⋯
   2 │ 5_13p5_61p35-1   5_13p5_61p35    61.35  84.2168    75.1932      -1.43098        723.553     0.184789   39.8465
   3 │ 5_13p5_61p35-2   5_13p5_61p35    61.35  34.589     25.285        3.95886         66.7345    4.94208    12.4914
   4 │ 5_13p5_61p35-3   5_13p5_61p35    61.35  61.7119    51.8247      -3.01578         80.8338    5.06137    15.06
   5 │ 5_13p5_61p35-4   5_13p5_61p35    61.35  20.6538     7.68584      0.0244971       23.9995    2.51434     2.98598 ⋯
   6 │ 5_13p5_61p35-5   5_13p5_61p35    61.35  21.9972     7.1295      -0.320993        24.6687    2.48485     3.94248
   7 │ 5_13p5_61p35-6   5_13p5_61p35    61.35  22.2261     6.78449     -0.353836        24.5469    2.47104     3.94248
   8 │ 5_13p5_61p35-7   5_13p5_61p35    61.35  22.2123     6.55907      0.46061         24.4111    2.46496     3.94248
   9 │ 5_13p5_61p35-8   5_13p5_61p35    61.35  33.6507    25.6817      -3.06842         43.5993    4.94208     7.46025 ⋯
  10 │ 5_13p5_61p35-9   5_13p5_61p35    61.35   1.99297   -0.3504       0.0640706        7.94797   2.30063     1.84555
  11 │ 5_13p5_61p35-10  5_13p5_61p35    61.35  12.4556     2.40331     -0.227096        17.7137    2.55625     3.02833
  ⋮  │        ⋮              ⋮           ⋮         ⋮           ⋮            ⋮            ⋮            ⋮          ⋮     ⋱
  28 │ 5_8p4_28p68-6    5_8p4_28p68     28.68  47.4422    24.4107      38.7753         100.05      5.28316    17.4016
  29 │ 5_8p4_28p68-7    5_8p4_28p68     28.68  48.9004    24.822       39.8771         113.075     5.28316    19.7883  ⋯
  30 │ 5_8p4_28p68-8    5_8p4_28p68     28.68  37.2317    16.4921      30.9989          84.275     5.28316    15.0636
  31 │ 5_8p4_28p68-9    5_8p4_28p68     28.68  40.4129    15.381       35.4248          85.391     5.28316    14.8954
  32 │ 5_8p4_28p68-10   5_8p4_28p68     28.68  40.729     20.3822      33.0557         566.571     1.88684    26.7924
  33 │ 5_8p4_28p68-11   5_8p4_28p68     28.68  41.6894    18.5982      35.8152         707.16      1.50947    28.3004  ⋯
  34 │ 5_8p4_28p68-12   5_8p4_28p68     28.68   0.700078  -0.0662316   -0.00804089      21.3812    2.64158     2.95058
  35 │ 5_8p4_28p68-13   5_8p4_28p68     28.68  39.0276    18.1646      31.7101         660.916     1.50947    28.8319
  36 │ 5_8p4_28p68-14   5_8p4_28p68     28.68  12.5579    -0.761769     0.545299        15.3284    0.377368    2.91731
  37 │ 5_8p4_28p68-15   5_8p4_28p68     28.68  47.225     17.9276      40.9265         152.034     5.28316    19.8286  ⋯
                                                                                           2 columns and 16 rows omitted

julia> names(collapsed_data)
11-element Vector{String}:
 "particle_unique"
 "filename"
 "FPS"
 "V"
 "Vx"
 "Vy"
 "Area_um_mean"
 "Ω_est"
 "R"
 "Circularity"
 "total_displacement_um"
```

- `V` : The mean of the instantaneous speed, `dp_um`. Always positive, as it is a magnitude. Units of µm/s.
- `Vx` : The mean of the numerical derivative of the x-position. Can be positive or negative. Units of µm/s.
- `Vy` : The mean of the numerical derivative of the y-position. Can be positive or negative. Units of µm/s.
- `Area_um_mean` : The mean of the area of the microbot. Units of µm^2.
- `Ω_est` : The estimated rotation rate extracted from the FFT of the `Major_um` column in the linked data. Performed using the [`estimate_omega`](@ref) function. Units of Hz.
- `R` : The bounding-circle radius/radius of gyration. Calculated as the 95th percentile of the major axis `Major_um` divided by 2. Units of µm.
- `Circularity` : A quantifier based on the aspect ratio of the fit ellipse. Calculated from ImageJ. See [their docs](https://imagej.nih.gov/ij/docs/menus/analyze.html). Unitless.
- `total_displacement_um` : The total displacement of the microbot over its *entire trajectory*. This is already constant in `linked_data`, so just take one of the values. Units of µm.

## Filtering based on collapsed data
After collapsing the data, its common to filter out microbots that may be too small or large, going too slow, or stuck to the substrate. This can be performed using the [`filter_trajectories`](@ref) function.

```@docs
filter_trajectories
```


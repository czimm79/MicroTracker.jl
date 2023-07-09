# Collapsing

On this page, you'll process the time-series `linked_data` into `collapsed_data` which summarizes each microbot into a single row.

## Collapse data
The convenient function [`collapse_data`](@ref) calculates the most common metrics used from the metrics calculated from ImageJ [Segmentation](@ref). To see the source code, click the blue "source" button.

```@docs
collapse_data
```

## Filtering based on collapsed data
After collapsing the data, its common to filter out microbots that may be too small or large, going too slow, or stuck to the substrate. This can be performed using the [`filter_trajectories`](@ref) function.

```@docs
filter_trajectories
```


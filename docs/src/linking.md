# Linking

On this page, you will process the segmented data in `particle_data` into a single `linked_data` which contains the time-series trajectory data for all tracked microbots.

These commands can be run in the Julia REPL or in the generated Pluto notebook file after [Creating an environment for your project](@ref). See the [Pluto](@ref) tutorial page to see how to open and use the notebook.

## Input parameters
First, let's format our inputs to the linking process, the `translation_dict` and `linking_settings`.

### Translation Dictionary
Provided you've followed the requirements for filenaming detailed in [Experimental](@ref), you now need to tell MicroTracker what your independent variables are. This is in the form of a Dictionary where the key is the name of the variable and the value is a tuple of the index and type. Following the example in [Experimental](@ref), we have a filename that looks like `32_6p2_1`. The translation dictionary would then look like:

```julia
translation_dict = Dict("T_C" => (1, Float64), "B_mT" => (2, Float64))
```

In plain english, this is telling MicroTracker that the temperature is recorded in the first position and is a floating point number (can have decimal places) and the field strength is a floating point number in the second position. These are the possible types a variable in a filename can have:

- `Int64` If an integer variable makes sense, like number of washes, number of particles, etc.
- `Float64` Most variables, a floating point number.
- `String` If the variable makes most sense if its a string. Like `"washed"` or `"aerosolized"`.

In this example detailed in [Experimental](@ref) we know the FPS of our videos is constant across all videos, so we'll include it in the `linking_settings` below.

### Linking Settings
The linking settings are in the format of a `NamedTuple`. This `linking_settings` contains information about your video, like the microns per pixel (MPP) of your microscope setup and the frames per second of your video (FPS). It also contains parameters to feed to the underlying linking machinery in [trackpy.link](https://soft-matter.github.io/trackpy/v0.6.1/generated/trackpy.link.html#trackpy.link).

```julia
linking_settings = (
    MPP = 0.605,  # Microns per pixel, scale of objective.
    SEARCH_RANGE_MICRONS = 1000, # microns/s. Fastest a particle could be traveling. Determines "how far" to look to link.
    MEMORY = 0,  # number of frames the blob can disappear and still be remembered
    STUBS_SECONDS = 0.5,  # trajectory needs to exist for at least this many seconds 
    FPS = 60.0 # Frames per second. **Can omit if the FPS has been specified in the filename.**
)
```

!!! tip
    MicroTracker supports videos having different framerates, as long as this information is recorded in the filename. For an example of this, see the included examples and Pluto notebook.

    If instead the FPS across all videos is constant, we can include the `FPS` parameter in `linking_settings` and the exclude any mention of `FPS` in our `translation_dict`, as shown above.

## Batch linking
Now that we've formatted and defined our `translation_dict` and `linking_settings`, its time to link.

The function [`batch_particle_data_to_linked_data`](@ref) is the 1-command version which runs all of the processing steps at once for every video. If you'd like to separate out the process and tinker with each step, see the [Under the hood](@ref) section below. 

```julia-repl
julia> linked_data = batch_particle_data_to_linked_data(translation_dict, linking_settings)
...output snipped
```

And just like that - all the segmented data in `particle_data` has been linked into continuous microbot trajectories and concatenated into one [DataFrame](https://dataframes.juliadata.org/stable/), here the variable `linked_data`. This data contains the instantaneous velocity, size, and much more over the entire experimental lifetime of the microbot.

# Under the hood
Continue to [Collapsing](@ref) after batch linking. However, if you'd like to insert in your own processing step in the pipeline, here are the sub-functions that make up [`batch_particle_data_to_linked_data`](@ref) for your convenience. These functions are applied in order, from `particle_data` to `linked_data`.


```@docs
load_particle_data
add_info_columns_from_filename
link
add_resolution_column!
add_useful_columns
clip_trajectory_edges
```
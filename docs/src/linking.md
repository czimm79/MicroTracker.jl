# Linking

Define two necessary settings objects, or Named Tuples.
1. linking_settings explanation.
2. translation dict explanation. Ties in with experimental.

## Translation Dictionary
Provided you've followed the requirements for filenaming detailed in [Experimental](@ref), you now need to tell MicroTracker what your independent variables are. This is in the form of a Dictionary where the key is the name of the variable and the value is a tuple of the index and type. Following the example in [Experimental](@ref), we have a filename that looks like `32_6p2_1`. The translation dictionary would then look like:

```julia
translation_dict = Dict("T_C" => (1, Float64), "B_mT" => (2, Float64))
```

In plain english, this is telling MicroTracker that the temperature is recorded in the first position and is a floating point number (can have decimal places) and the field strength is in the second position and is also a Float. These are the possible types a variable in a filename can have:

- `Int64` If an integer variable makes sense, like number of washes, number of particles, etc.
- `Float64` Most variables, a floating point number.
- `String` If the variable makes most sense if its a string. Like `"washed"` or `"aerosolized"`.

## Linking Settings



[`batch_particle_data_to_linked_data`](@ref) saves to csv. Possibly include metadata.
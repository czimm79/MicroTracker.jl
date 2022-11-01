```@meta
CurrentModule = MicroTracker
```

# Home

Welcome to the documentation for [MicroTracker](https://github.com/czimm79/MicroTracker.jl) - helping you get from microscopy to publication.

## What can it do?

At its core, this package links together [segmented](https://en.wikipedia.org/wiki/Image_segmentation) microscopy video of microbots.

 This yields individual trajectories with time, position, and shape. Critical measurements like velocity, rotation rate, and traction can be obtained for an arbitrary amount of microbots across many experimental conditions.

## Why this package?

The alternatives for colloid particle tracking, like [TrackPy](https://soft-matter.github.io/trackpy/v0.5.0/) and [TrackMate](https://www.sciencedirect.com/science/article/pii/S1046202316303346), do not normally measure the shape or size of particles. For microbots that roll, swim, or walk, these measurements are essential. 

Additionally, with the explosion of the field of microrobotics and nano 3D printing, new designs are frequently reported. Every study of these new microbots involves the same measurements: velocity and swimming efficiency.

## Why Julia?

In short, Julia is easy to read and write, yet approaches the speed of languages like C and Fortran. It also provides [Pluto.jl](https://github.com/fonsp/Pluto.jl), a reactive notebook environment that solves all the frustration I've had with Jupyter notebooks and Mathematica. For a more eloquent explanation, see the Julia [introduction](https://docs.julialang.org/en/v1/).

If you don't know Julia, don't worry. It is similar and as easy as Python (I'd argue easier). The best learning source is the [Computational Thinking](https://computationalthinking.mit.edu/Spring21/) course from MIT.

Lastly, the Pluto notebooks included with this package allow you to tinker with established workflows, minimizing the need to reinvent the wheel.

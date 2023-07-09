# Pluto

On this page, you'll learn how to install Pluto in Julia and use it to load the included `microtracker_notebook.jl` from [`create_project_here`](@ref).

[Pluto.jl](https://github.com/fonsp/Pluto.jl) is an awesome package for Julia that implements *reactive* notebooks. This, combined with Julia, enables fast reactivity perfect for scientific programming.

To open the MicroTracker example notebook in Pluto, add Pluto to your environment. This can either be in your global environment or your MicroTracker environment, depending on where you want to launch Pluto from.

Since I find Pluto useful for more things than just MicroTracker, I recommend adding it to your global environment.

```julia
] add Pluto
```

Then, to open Pluto in your browser, type this in your Julia REPL:

```julia-repl
julia> using Pluto; Pluto.run()
```

## Open the notebook
On the Pluto.jl landing page, you'll want to paste the path to the `microtracker_notebook.jl` file *in your MicroTracker project folder*. On Windows, I can right click on a file/folder and click "Copy as Path". So in my case, since my MicroTracker folder I created a project in is named `tutorial`, my path I'll paste in is `"R:\Wormhole\OneDrive\Research\Papers\JOSS_microtracker\tutorial\microtracker_notebook.jl"`.

This will open the notebook, install any necessary extra packages, and run *all* the cells. This may take awhile on the first run, so be patient! Julia compiles [just-in-time](https://en.wikipedia.org/wiki/Just-in-time_compilation) to enable fast code.

Now, you have a dashboard in which you can run new analyses, Julia code, and interactively view your data with the [`trajectory_analyzer`](@ref). Using the documentation in [Linking](@ref), you may substitute any step in the pipeline with your own custom code. If you think it would be useful to others, please consider contributing!

!!! warning
    Pluto [creates its own Pkg environment](https://github.com/fonsp/Pluto.jl/wiki/%F0%9F%8E%81-Package-management) behind the scenes. While this is great for reproducibility and simply typing `using <packagename>` when you want to use a package, it does not automatically match the MicroTracker environment created in the [Creating an environment for your project](@ref) section. To update to the latest version of MicroTracker, you must click the little up arrow next to the package names at the top.
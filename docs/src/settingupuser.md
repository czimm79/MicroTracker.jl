# Setting Up

## Download and install Julia
Download and install Julia from their website [https://julialang.org/downloads/]. Be sure to check the "Add Julia to PATH" checkmark. This allows you to call Julia anywhere from the command line by typing `julia` !

!!! note
    On Windows, I recommend installing Julia from the [Windows Store](https://apps.microsoft.com/store/detail/julia/9NJNWW8PVKMN?hl=en-us&gl=us). This automatically adds Julia to your PATH and also installs the `juliaup` command line tool to seamlessly update Julia when new versions are released. Both options work though!

### Test if it works
Open a terminal window and type `julia`. You should be able to run simple commands. For more basic information on Julia, see their great [docs].(https://docs.julialang.org/en/v1/manual/getting-started/)
![image showing julia basics](assets/opening%20julia.png)


## Creating an environment for your project
Alright! Now we need a place for our MicroTracker project to live. This will contain all the microscopy video, data we will generate, and tools we will use to analyze our data.

To do this, just create a new empty folder. Name it descriptively, like `2023-06-21 microwheel field sweep`. For this page, I'll just create a folder named `tutorial`.

Next, you need to open a terminal at this location. On Windows, I use [the new Windows Terminal](https://apps.microsoft.com/store/detail/windows-terminal/9N0DX20HK701?hl=en-us&gl=us&rtc=1) which allows you to right click in a folder and click "Open in Terminal". You can also type in the explorer address bar `cmd` to [get the same effect](https://www.youtube.com/watch?v=JLqIkPfU_0U). Once the terminal is open, you should be able to type `julia` to enter the Julia REPL.

Now, type `]` at the empty `julia>` prompt, before typing anything else. This enters you into [package mode](https://docs.julialang.org/en/v1/stdlib/Pkg/). You'll notice that now instead of `julia>`, you see the name of the current environment in blue. Now, type the following to create a new environment in your current folder:

```julia-repl
(@v1.9) pkg> activate .
Activating new project at `R:\Wormhole\OneDrive\Research\Papers\JOSS_microtracker\tutorial`

(tutorial) pkg> add MicroTracker
...output snipped
```

and wait as the package and all of its dependencies download! 

!!! important 
    When adding MicroTracker, Julia will also automatically precompile the environment to make future use of the package speedy. This may take awhile, as MicroTracker comes bundled with all the packages needed to analyze and plot your data. It also comes included with sample microscopy video, so it may take a little longer to download than other packages.

## Create a MicroTracker project
Now that we have a new Julia environment in this folder with MicroTracker installed, lets start using MicroTracker! To import a package, Julia uses the keyword `using`. Make sure you're out of package mode by pressing `backspace`. The prompt should read `julia>` again. After that, we'll use the [`create_project_here`](@ref) function.

```julia-repl
julia> using MicroTracker

julia> create_project_here(include_examples=true)
[ Info: New MicroTracker project created in R:\Wormhole\OneDrive\Research\Papers\JOSS_microtracker\tutorial

```

You should now see the layout of a MicroTracker project in your folder. If `include_examples=true`, then sample video and data is included so you can see where and how to replace with your own video.

```
tutorial/
├── original_video/
│   ├── 5_8p4_28p68/
│   └── 5_13p5_61p35/
├── particle_data/
│   ├── 5_8p4_28p68
│   └── 5_13p5_61p35
├── linked_data/
```

- **original_video**: The raw microscopy video goes here, in the Image Sequence format (folders of `.tif` images). Many microscopes output automatically in this format, or [Fiji](https://imagej.net/software/fiji/) can be used to save almost any format into the Image Sequence format.
- **particle_data**: This is where a `.csv` file for each video, with the same filename, will be located. These csv files are the result of segmentation, which is explained thoroughly in the next page of the manual!
- **linked_data**: This is the primary output of MicroTracker. This is where `.csv` files are output that contains data for *every* microbot across *all* videos. This ensures that all analysis is carried out with the same parameters.
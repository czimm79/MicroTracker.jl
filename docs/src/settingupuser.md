# Setting Up

## Download and install Julia
Download and install Julia from their website (https://julialang.org/downloads/). Be sure to check the "Add Julia to PATH" checkmark. This allows you to call Julia anywhere from the command line by typing `julia` !

!!! note
    On Windows, I recommend installing Julia from the [Windows Store](https://apps.microsoft.com/store/detail/julia/9NJNWW8PVKMN?hl=en-us&gl=us). This automatically adds Julia to your PATH and also installs the `juliaup` command line tool to seamlessly update Julia when new versions are released.

#### Test if it works
Open a terminal window and type `julia`. You should be able to run simple commands.
![image showing julia basics](assets/opening%20julia.png)


## Creating a project folder
Alright! Now we need a place for our MicroTracker project to live. This will contain all the microscopy video, data we will generate, and tools we will use to analyze our data.

To do this, just create a new empty folder. Name it descriptively, like `2023-06-21 microwheel field sweep`.
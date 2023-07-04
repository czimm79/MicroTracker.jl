# Experimental
On this page, you'll learn how best to set up your experiment and microscopy for microbot tracking with MicroTracker.

## Filenames keep track of variables
A study can contain multiple independent variables (temperature, field strength, microbot design, viscosity, geometry). MicroTracker can handle as many variables as you'd like, provided there is a separate video at each experimental condition.

For example, lets say we're studying temperature and field strength. A convenient way to keep track of experimental conditions is to include it in the filename, and MicroTracker is designed to parse and collect information from each video filename. If I had temperature and field strength to record, my completed set of videos would have these filenames:

```
"32_4_1"
"37_4_1"
"37_4_2"
"32_6p2_1"
```

I would take note that the first number is the temperature in celsius, the second number is the field in mT, and the third number is the # of videos I've taken at that condition.

You can set your own format, but notice two requirements for your file naming format:
1. Underscores (`_`) are used to separate conditions.
2. Instead of periods, the letter `p` is used. `6.2` turns into `6p2`.

After naming your videos appropriately, you can convey this information to MicroTracker using the requisite [Translation Dictionary](@ref) in the [Linking](@ref) step.

## Contrast is important
For successful tracking, the microbots must have good contrast with their background, especially for simple thresholding techniques like that detailed in [Segmentation](@ref). If your experiments do not easily lend themselves to a contrasting and uniform background, look into advanced methods of segmentation like [ilastik](https://www.ilastik.org/) or applying additional filters with ImageJ.

!!! tip
    When using fluorescent microscopy, the microbots will be "bright" while the background is dark. This can be accounted for by choosing a manual threshold for your microbots in the imagej macro in [Segmentation](@ref).

## Clean up before you analyze
Use ImageJ or any other video editor to clip out parts of the video you can't use. This could be when there are no microbots on the screen, any vibrations, or when you move the microscope.
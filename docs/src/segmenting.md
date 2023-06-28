# Segmenting video for use with MicroTracker

## Intro
[Image segmentation](https://en.wikipedia.org/wiki/Image_segmentation) is the process of separating the image background (stuff we don't care about) from the foreground (stuff we care about). Here, our foreground are the microbots.

Segmentation can be performed with a variety of methods, from simple (thresholding), to advanced (training neural nets). MicroTracker does not segment videos, due to the variety of softwares and methods available that are specific to the microscopy techniques used. In this guide, we will use [ImageJ/Fiji](https://imagej.net/software/fiji/) due to its simplicity, flexibility, and established use. However, you may use other software such as [illastik](https://www.ilastik.org/) if more advanced segmentation is needed, but a walkthrough of that is out of scope of this guide.

!!! info
    On this page, we will process raw microscopy video into a `.csv` file that contains a row for each **observation** of a particle. This data *does not* contain any information about the video, like that the particles are moving/rotating between frames. That's where MicroTracker comes in.

## Setup
* Make sure you're in the project folder, etc. docs for this section needed.
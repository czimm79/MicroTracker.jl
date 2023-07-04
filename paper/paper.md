---
title: "MicroTracker.jl: A Julia package for microbot research"
tags: 
    - microbot
    - tracking
    - colloids
    - microrobotics
    - biomedical
authors:
    - name: Coy J. Zimmermann
      affiliation: 1
    - name: Keith B. Neeves
      affiliation: 2
    - name: David W.M. Marr
      affiliation: 1
affiliations:
    - name: Department of Chemical and Biological Engineering, Colorado School of Mines, Golden, CO, USA
    - name: Departments of Bioengineering and Pediatrics, University of Colorado Denver | Anschutz Medical Campus, Aurora, CO, USA
bibliography: paper.bib
---

# Summary
Microbots are active matter capable of performing remote  work at the micro-scale. They are of particular interest for biomedical applications and drug delivery due to their ability to target and provide local mechanical action[@zimmermann_multimodal_2022]. However, at the micron scale, traditional propulsion methods such as propellors do not work. Instead, microbot designs mimic nature, like bacterial flagella that corkscrew through fluid2 or white blood cells that roll on vascular surfaces3. The rapidly-expanding field of microrobotics is focused on researching new structures, fabrication techniques, and actuation methods, all amplified by the recent adoption of nano-scale 3d printing techniques4 and human-scale remote magnetic actuation equipment5.
Current research requires quantitative measurements of the velocity, rotation rate, and size of large numbers of individual microbots under varying actuation and environmental conditions. Efficient software tools are needed to quickly and easily process this large amount of experimental data with which, microbot design can be further informed to increase the locomotion efficiency and suitability for a variety of fluidic environments., such as the vascular, pulmonary, and gastrointestinal systems .

# Statement of Need
MicroTracker.jl is a Julia6 package for tracking and analyzing microbots in optical microscopy videos. The package and accompanying documentation allow researchers to go from an array of experiments at various conditions to useful summary statistics, interactive data visualization, and publication-ready figures that enable quick informed decisions on future microbot design. Working alongside the commonly used image analysis tool, ImageJ7, to segment images into particles, MicroTracker.jl tracks the velocity, size, shape, and rotation rate of hundreds of microbots at once across multiple videos at various experimental conditions.
This is performed by linking individual segmented particle data from each video frame into coherent trajectories using established methods8,9. Once linked, the velocity and size trajectory of each microbot can be extracted given microscope parameters frames/second and microns/pixel. Various functions are included in the analysis pipeline to reduce error, including clipping data where the microbot is occluded near the edge of the frame. Then, the time-data is collapsed and summarized to characterize and compare microbots. Fourier analysis is used to extract the mean rotation rate from periodic changes in the microbot shape . Together, insights can be easily extracted from large experimental designs, enabling high-throughput data analysis.
MicroTracker.jl also features an interactive microbot visualizer that displays the velocity, size, and frequency data along with the annotated trajectory [Fig1]. Sliders and dropdown menus enable the user to scan through each individual video, microbot, and time point. This level of interactivity is critical for analyzing how a given microbot design moves under given experimental conditions. Additionally, with thoughtful naming of microscopy video files with their experimental conditions, MicroTracker.jl can automatically generate publication-ready plots with the help of Julia plotting libraries10 that summarize the entire experimental sets. Together, these tools allow researchers to make insights at both the individual microbot and condition-wide levels.
Tracking of particles in microscopy video has previously been performed either manually through image processing software11 or in an automated fashion with particle tracking software such as TrackMate12 or Trackpy9. These software were primarily designed for tracking spherical uniform particles and use methods such as the Laplacian of Gaussian that determine the centroid of a Gaussian feature of a certain size. However, these detectors can be ineffective with microbots as they can vary widely in size and shape. MicroTracker.jl allows for size, shape, and rotation rate tracking of microbots which regularly enter and leave the video frame and is an open-source package catered specifically for microrobotic research.
A collection of Pluto.jl13 notebooks are included with this package to provide a simple template and tutorial for users with limited coding experience. Additionally, a detailed tutorial on how to prepare microscopy video with ImageJ for use with MicroTracker.jl is included in the documentation along with a sample ImageJ macro for easy batch processing.
Multiple publications that make use of tools in MicroTracker.jl have been published or are in preparation but their scientific contribution is unique and independent of this package. These include studies of microbots for use in the vasculature1, lungs14, gastrointestinal system15, and at the air water interface16.

# Acknowledgements
The authors acknowledge support from the National Institutes of Health under grants R01NS102465 and R21AI138214.

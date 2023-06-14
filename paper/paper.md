---
title: "MicroTracker.jl: A Julia package for microbot research"
tags: 
    - Julia
    - microbot
    - colloids
    - microrobotics
    - biomedical
authors:
    - name: Coy J. Zimmermann
      orcid: 
      affiliation: 1
    - name: David W.M. Marr
      affiliation: 1
affiliations:
    - name: Department of Chemical and Biological Engineering, Colorado School of Mines
---

# Summary

Microbots are active matter capable of performing remote work at the micro-scale. They are of particular interest for biomedical applications and drug delivery due to their ability to target and provide local mechanical action [@zimmermann_multimodal_2022]. However, at the micron scale, traditional propulsion methods such as propellors do not work. Instead, microbot designs mimic nature, like bacterial flagella that corkscrew through fluid[eye_micropropellors] or white blood cells that roll on vascular surfaces[some_rollers]. The field of microrobotics is rapidly expanding and is laser focused on researching new structures, fabrication techniques, and actuation methods. This is amplified by the recent adoption of nano-scale 3d printing techniques [nanoscribe_paper] and human-scale remote magnetic actuation equipment [something_from_nelson]. 

Microbot research requires quantitatevely measuring the velocity, rotation rate, and size of hundreds of structures under varying actuation and environmental conditions. Efficient software tools are needed to quickly and easily process this large amount of experimental data. With this information, microbot design can be further informed to increase the locomotion efficiency and suitability for a variety of fluidic environments, such as the vascular, pulmonary, and digestive systems.

# Statement of Need

MicroTracker.jl is a Julia package [Julia_ref] for tracking and analyzing microbots in microscopy video. The package and acompanying documentation allows researchers to go from an array of experiments at various conditions to useful summary statistics, interactive data visualization, and publication-ready figures that enable quick informed decisions on future microbot design. Working along side the commonly used image analysis tool, ImageJ[imagej_ref], MicroTracker.jl tracks the velocity, size, shape, and rotation rate of hundreds of microbots at once.

This is performed by linking individual segmented particles from each video frame into coherent trajectories using established methods[crockergrier + trackpy]. Once linked, the velocity and size trajectory of each microbot can be extracted given microscope parameters frames per second and microns per pixel. Various functions are included in the analysis pipeline to reduce error, including clipping data where the microbot is occluded near the edge of the frame. Then, the time-data is collapsed and summarized to characterize and compare microbots. The one-dimensional discrete fourier transform is used to extract the mean rotation rate from periodic changes in the shape of the microbot. With this, insights can be easily extracted from large experimental designs, enabling high-throughput data analysis.

MicroTracker.jl also features an interactive microbot visualizer that displays the velocity, size, and frequency data along with the annotated trajectory[Fig1]. Sliders and dropdown menus enable the user to scan through each individual video, microbot, and time point. This level of interactivity is critical for analyzing how a given microbot design moves in the given experimental conditions. Additionally, with thoughtful naming of microscopy video files with their experimental conditions, MicroTracker.jl can automatically generate publication-ready plots with the help of Julia plotting libraries [algebraofgraphics,makie_refs] that summarize the entire set of experiments. Together, these tools allow researchers to make insights at both the individual microbot and condition-wide levels.

Tracking of particles in microscopy video is has been previously performed either manually through image processing software[imagej] or particle tracking software such as trackmate[trackmate] or trackpy[trackpy]. These software are mainly intended for tracking spherical uniform particles and use methods such as the  Laplacian of Gaussian that determine the centroid of a gaussian feature of a certain size. However, with microbots these class of detectors are ineffective as microbots vary widely in size and shape. Additionally, the actual size and shape of the particle is not recorded with these methods. MicroTracker.jl is unique as it uses segmented images from ImageJ, allowing for the size, shape, and rotation rate tracking. To our knowledge, this is the first package catered specifically for microrobotic research.

A collection of Pluto.jl notebooks[pluto_ref] are included with this package to provide a simple template and tutorial for users with limited coding experience. Additionally, a detailed tutorial on how to prepare microscopy video with ImageJ for use with MicroTracker.jl is included in the documentation along with a sample ImageJ macro for easy batch processing.

Multiple publications that make use of tools in MicroTracker.jl have been published and are in preparation but their scientific contribution is unique and independent of this package.

# Acknowledgements
C.J.Z. and D.W.M.M acknowledge support from the National Institutes of Health under grants R01NS102465 and R21AI138214.

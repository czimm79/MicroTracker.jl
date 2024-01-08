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
      index: 1
    - name: Departments of Bioengineering and Pediatrics, University of Colorado Denver | Anschutz Medical Campus, Aurora, CO, USA
      index: 2
bibliography: paper.bib
---

# Summary
Microbots are microscale structures capable of generating their own movement and are of particular interest for biomedical applications and drug delivery [@zimmermann_multimodal_2022]. At the micron scale, traditional propulsion methods such as propellors do not work; instead, microbots mimic natural systems, like bacteria that corkscrew through fluid[@wu_swarm_2018] or white blood cells that roll on vascular surfaces[@alapan_multifunctional_2020]. The rapidly expanding field of microrobotics is focused on researching new structures, fabrication techniques, and movement methods, efforts aided by the recent adoption of nano-scale 3d printing techniques[@jeon_magnetically_2019] and human-scale magnetic field generation equipment[@wang_trends_2021].

Microbot research requires quantitative measurements of the velocity, rotation rate, and size of large numbers of individual microbots under varying actuation and environmental conditions. While a large number of particle tracking methods capable of tracking spheres, cells, and viruses exist [@Chenouard2014Objective], tracking microbots requires specialized software tools that can quickly process large quantities of microbots with varying size and dynamics. With these large datasets, microbot design can be further informed to increase transport efficiency and suitability for a variety of fluidic environments. MicroTracker.jl is a high-throughput analysis tool designed specifically for extracting individual microbot dynamics and metrics from large-scale experiments. It is particularly effective for analyzing microbots which rotate, have variable size, and regularly enter and leave the video frame. MicroTracker.jl is capable of processing batches of videos, delivering significant insights from large sets of experimental data.

# Statement of Need
MicroTracker.jl is a Julia[@bezanson_julia_2017] package for tracking and analyzing microbots in optical microscopy videos. The package and accompanying documentation allow researchers to take an array of experiments at various conditions and generate useful summary statistics, interactive data visualization, and publication-ready plots to enable informed decisions on subsequent microbot design. Working alongside the commonly used image analysis tool, ImageJ[@schindelin_fiji_2012], to segment images into particles, MicroTracker.jl tracks the velocity, size, shape, and rotation rate of hundreds of microbots at once across multiple videos under various experimental conditions.

![Microbot trajectory analyzer. A) Instantaneous speed and B) major axis of a selected microbot over its lifetime. C) The finite Fourier transform of B enables an estimation of the rotation rate. D) Annotated microscope image of the microbot trajectory and fitted ellipse. Scale = 30 µm. E) Experiment-wide average speed and radius of all microbots and a selected microbot for reference. \label{fig:1}](figure1.png)

Tracking of particles in microscopy video has previously been performed either manually through image processing software[@schindelin_fiji_2012] or in an automated fashion with particle tracking software such as TrackMate[@tinevez_trackmate_2017] or TrackPy[@allan_soft-mattertrackpy_2023]. These software were primarily designed for tracking spherical uniform particles and use methods such as the Laplacian of Gaussian that determine the centroid of a Gaussian feature of a certain size. However, these detectors can be ineffective with microbots which can vary widely in size and shape. The particle tracking field is broad with many techniques, each with a strength for a particular system [@Chenouard2014Objective]. For microbot tracking and applicability across multiple microbot types, tracking methods must not require *a priori* knowledge of system dynamics, like in a Kalman filter [@Kalman60] or pre-trained machine learning model. MicroTracker.jl is catered specifically for microrobotics research and allows for measuring size, shape, and rotation rate tracking of microbots across batches of microscopy videos.

For users with limited coding experience, a Pluto.jl[@plas_fonspplutojl_2022] notebook is included with this package to provide a simple template. Additionally, a detailed tutorial on how to prepare microscopy video with ImageJ for use with MicroTracker.jl is included in the documentation along with a sample ImageJ macro for easy batch processing.
Multiple publications that make use of tools in MicroTracker.jl are available, each unique in their scientific contribution and independent of this package. These include studies of microbots for use in the vasculature[@zimmermann_multimodal_2022], lungs[@zimmermann_delivery_2022], gastrointestinal system[@osmond_magnetically_2023], and at the air water interface[@wolvington_paddlebots_2023].

# Implementation
Microbot tracking is performed by linking individual segmented particle data from each video frame into coherent trajectories using established methods[@crocker_methods_1996;@allan_soft-mattertrackpy_2023]. Once linked, the velocity and size trajectory of each microbot can be extracted given microscope parameters frames/second and microns/pixel. Various functions are included in the analysis pipeline to reduce error, including clipping data where the microbot is occluded near the edge of the frame. Then, the time-series data is collapsed and summarized to characterize and compare microbots. Fourier analysis is used to extract the mean rotation rate from periodic changes in the microbot shape. Together, these insights can be easily extracted from large experimental designs, enabling high-throughput data analysis.

MicroTracker.jl also couples with Pluto.jl[@plas_fonspplutojl_2022] to feature an interactive microbot visualizer that displays the velocity, size, and frequency data along with the annotated trajectory (\autoref{fig:1}). Sliders enable the user to scan through each individual video, microbot, and time point. This level of interactivity is critical for analyzing how a given microbot design moves under given experimental conditions. Additionally, with thoughtful naming of microscopy video files with their experimental conditions, MicroTracker.jl can automatically generate publication-ready plots with the help of Julia plotting libraries[@tom_breloff_2023_8028030] that summarize entire experimental sets. Together, these tools allow researchers to obtain insights at both the individual microbot and condition-wide levels.

# Acknowledgements
The authors acknowledge support from the National Institutes of Health under grants R01NS102465 and R21AI138214.

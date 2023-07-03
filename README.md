<h1><img alt="MicroTracker.jl" src="https://github.com/czimm79/MicroTracker.jl/assets/49537407/a6562792-4953-46cb-8e3a-7eba9ba8ee06" width=426 height=81.4 ></h1>

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://czimm79.github.io/MicroTracker.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://czimm79.github.io/MicroTracker.jl/dev/)
[![Build Status](https://github.com/czimm79/MicroTracker.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/czimm79/MicroTracker.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/czimm79/MicroTracker.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/czimm79/MicroTracker.jl)

MicroTracker.jl is a feature-complete [Julia](https://julialang.org/) package that tracks and analyzes moving [microbots](https://www.nature.com/articles/s41467-020-19322-7) in microscopy video. MicroTracker allows tracking of critical microbot metrics including size, velocity, and rotation rate, enabling high-throughput analysis of experimental data.

![animation example](https://github.com/czimm79/MicroTracker.jl/blob/master/assets/test_animation_full.mp4)

This package is designed for users with limited coding or Julia experience. Follow the quickstart(ref) guide in the documentation to get started with some example data.

For more information on microbots and this package, please see the short paper(link needed). To get started using or contributing, see the [docs](https://czimm79.github.io/MicroTracker.jl/dev/). 

## Extra information
Components of MicroTracker have been used in various scholarly works[^1][^2][^3][^4]. This package open sources, combines, and tests the tools written for microbot tracking as part of Coy Zimmermann's PhD thesis work 2018-2023 on magnetically propelled microwheels. This work was performed in the [Marr Group](https://chemeng.mines.edu/project/marr-david/) at the Colorado School of Mines and with collaboration of the [Neeves Lab](https://neeveslab.com/) at the University of Colorado Denver, Anschutz Medical Campus.

[^1]: Wolvington, E., Yeager, L., Gao, Y., Zimmermann, C. J. & Marr, D. W. M. Paddlebots: Translation of Rotating Colloidal Assemblies near an Air/Water Interface. Langmuir 39, 7846–7851 (2023).
[^2]: Osmond, M. J. et al. Magnetically Powered Chitosan Milliwheels for Rapid Translation, Barrier Function Rescue, and Delivery of Therapeutic Proteins to the Inflamed Gut Epithelium. ACS Omega 8, 11614–11622 (2023)
[^3]: Zimmermann, C. J., Herson, P. S., Neeves, K. B. & Marr, D. W. M. Multimodal microwheel swarms for targeting in three-dimensional networks. Sci. Rep. 12, 5078 (2022).
[^4]: Zimmermann, C. J. et al. Delivery and actuation of aerosolized microbots. Nano Sel. nano.202100353 (2022) doi:10.1002/nano.202100353.

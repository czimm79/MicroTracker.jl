<h1><img alt="MicroTracker.jl" src="https://github.com/czimm79/MicroTracker.jl/assets/49537407/a6562792-4953-46cb-8e3a-7eba9ba8ee06" width=426 height=81.4 ></h1>

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://czimm79.github.io/MicroTracker.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://czimm79.github.io/MicroTracker.jl/dev/)
[![Build Status](https://github.com/czimm79/MicroTracker.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/czimm79/MicroTracker.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/czimm79/MicroTracker.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/czimm79/MicroTracker.jl)

MicroTracker.jl is a feature-complete [Julia](https://julialang.org/) package that tracks and analyzes moving [microbots](https://www.nature.com/articles/s41467-020-19322-7) in microscopy video. This package allows tracking of critical microbot metrics including size, velocity, and rotation rate, enabling high-throughput analysis of experimental data.

https://github.com/czimm79/MicroTracker.jl/assets/49537407/94a938f3-3453-4592-bf68-36b9e59b7f2e

This package is designed for users with limited coding or Julia experience. Follow the quickstart(ref) guide in the documentation to get started with some example data.

For more information on microbots and this package, please see the short [paper](https://github.com/czimm79/MicroTracker.jl/blob/master/paper/paper.md). To get started using or contributing, see the docs by clicking the [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://czimm79.github.io/MicroTracker.jl/stable/) badge. 

## Extra information
Various components of MicroTracker have been used in scholarly works[^1][^2][^3][^4]. This package open sources, combines, and tests the tools written for microbot tracking as part of Coy Zimmermann's PhD thesis work 2018-2023 on magnetically propelled microwheels. This work was performed in the [Marr Group](https://chemeng.mines.edu/project/marr-david/) at the Colorado School of Mines and with collaboration of the [Neeves Lab](https://neeveslab.com/) at the University of Colorado Denver, Anschutz Medical Campus. MicroTracker uses and builds on years of work from colloidal science researchers[^5][^6].

[^1]: E. Wolvington, L. Yeager, Y. Gao, C. J. Zimmermann, and D. W. M. Marr, “Paddlebots: Translation of Rotating Colloidal Assemblies near an Air/Water Interface,” Langmuir, vol. 39, no. 22, pp. 7846–7851, Jun. 2023, doi: 10.1021/acs.langmuir.3c00701.
[^2]: M. J. Osmond, E. Korthals, C. J. Zimmermann, E. J. Roth, D. W. M. Marr, and K. B. Neeves, “Magnetically Powered Chitosan Milliwheels for Rapid Translation, Barrier Function Rescue, and Delivery of Therapeutic Proteins to the Inflamed Gut Epithelium,” ACS Omega, vol. 8, no. 12, pp. 11614–11622, Mar. 2023, doi: 10.1021/acsomega.3c00886.
[^3]: C. J. Zimmermann, P. S. Herson, K. B. Neeves, and D. W. M. Marr, “Multimodal microwheel swarms for targeting in three-dimensional networks,” Sci Rep, vol. 12, no. 1, p. 5078, Dec. 2022, doi: 10.1038/s41598-022-09177-x.
[^4]: C. J. Zimmermann, T. Schraeder, B. Reynolds, E. M. DeBoer, K. B. Neeves, and D. W. M. Marr, “Delivery and actuation of aerosolized microbots,” Nano Select, p. nano.202100353, Mar. 2022, doi: 10.1002/nano.202100353.
[^5]: J. C. Crocker and D. G. Grier, “Methods of Digital Video Microscopy for Colloidal Studies,” Journal of Colloid and Interface Science, vol. 179, no. 1, pp. 298–310, Apr. 1996, doi: 10.1006/jcis.1996.0217.
[^6]: D. B. Allan, T. Caswell, N. C. Keim, C. M. van der Wel, and R. W. Verweij, “soft-matter/trackpy: v0.6.1.” Zenodo, Feb. 2023. doi: 10.5281/zenodo.7670439.


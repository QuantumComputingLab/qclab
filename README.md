# QCLAB Matlab Toolbox [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.14968124.svg)](https://doi.org/10.5281/zenodo.14968124)

<p align="center"><img src="doc/doxygen/QCLAB.png?raw=true" /></p>

QCLAB is an object-oriented MATLAB toolbox for creating, representing and simulating
quantum circuits. QCLAB can be used for rapid prototyping and testing of
quantum algorithms, and allows for fast algorithm development and discovery.
QCLAB provides I/O through openQASM making it compatible with quantum hardware.
Furthermore, QCLAB can draw circuit diagrams to the MATLAB command window
and save the circuit diagrams to LaTeX source files. Please refer to the 
`examples/` directory for example use cases.

### How to run? ###

The QCLAB Toolbox is implemented using MATLAB object oriented functionalities
and is compatible with MATLAB R2020b or newer.

1. Clone repository:

        git clone https://github.com/QuantumComputingLab/qclab.git

2. Add all files from qclab directory to MATLAB path to install QCLAB:

		addpath(qclabroot);
		savepath;

3. Run tests in MATLAB:
		
		cd test/
		runTests.m
 
4. Generate documentation with doxygen. Requires [doxygen](https://www.doxygen.nl/index.html) and [doxymatlab](https://github.com/simgunz/doxymatlab). Adjust tags `FILTER_PATTERNS` and `FILTER_SOURCE_PATTERNS`  in `doxygen/Doxyfile.dox` to local `m2cpp.pl` script.
	
		cd doc/doxygen/
		doxygen Doxyfile.dox

## Developers 
- [Daan Camps](http://campsd.github.io/) (Lawrence Berkeley National Laboratory) - dcamps@lbl.gov
- [Sophia Keip](https://www.fernuni-hagen.de/MATHEMATIK/DMO/mitarbeiter/keip.html) (FernUniversität in Hagen) - sophia.keip@fernuni-hagen.de
- [Roel Van Beeumen](http://www.roelvanbeeumen.be/) (Lawrence Berkeley National Laboratory) - rvanbeeumen@lbl.gov


## Funding
The QCLAB project is supported by the Laboratory Directed Research and
Development Program of Lawrence Berkeley National Laboratory under U.S.
Department of Energy Contract No. DE-AC02-05CH11231.


## About
QCLAB Copyright (c) 2021, The Regents of the University of California,
through Lawrence Berkeley National Laboratory (subject to receipt of
any required approvals from the U.S. Dept. of Energy). All rights reserved.

If you have questions about your rights to use or distribute this software,
please contact Berkeley Lab's Intellectual Property Office at
IPO@lbl.gov.

NOTICE.  This Software was developed under funding from the U.S. Department
of Energy and the U.S. Government consequently retains certain rights. As
such, the U.S. Government has been granted for itself and others acting on
its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the
Software to reproduce, distribute copies to the public, prepare derivative
works, and perform publicly and display publicly, and to permit others to do so.

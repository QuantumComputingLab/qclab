%> @file  doxygenMainPage.m
%> @brief Main page for Doxygen documentation.
%======================================================================
%> @mainpage Overview
%>
%>QCLAB is an object-oriented MATLAB toolbox for creating and representing
%>quantum circuits. QCLAB can be used for rapid prototyping and testing of
%>quantum algorithms, and allows for fast algorithm development and discovery.
%>QCLAB provides I/O through openQASM making it compatible with quantum hardware.
%>
%>### How to run? ###
%>
%>The QCLAB Toolbox is implemented using MATLAB object oriented functionalities
%>and is compatible with MATLAB R2018a or newer.
%>
%>1. Clone repository:
%>		  \code {.bash}
%>        git clone https://github.com/QuantumComputingLab/qclab.git
%>        \endcode
%>
%>2. Add all files from qclab directory to MATLAB path to install QCLAB
%>       \code {.bash}
%>		addpath(qclabroot);
%>		savepath;
%>      \endcode
%>
%>3. Run tests in MATLAB:
%>		 \code {.bash}
%>		cd test/
%>		runTests.m
%>      \endcode
%>
%>4. Generate documentation with doxygen. Requires [doxygen](https://www.doxygen.nl/index.html) and [doxymatlab](https://github.com/simgunz/doxymatlab). Adjust tags `FILTER_PATTERNS` and `FILTER_SOURCE_PATTERNS`  in `doxygen/Doxyfile.dox` to local `m2cpp.pl` script.
%>      \code {.bash}
%>		cd dox/doxygen/
%>		doxygen Doxyfile.dox
%>      \endcode
%>
%>## Developers 
%>- [Daan Camps](http://campsd.github.io/) (Lawrence Berkeley National Laboratory) - dcamps@lbl.gov
%>- [Sophia Keip](https://www.fernuni-hagen.de/MATHEMATIK/DMO/mitarbeiter/keip.html) (FernUniversität in Hagen) - sophia.keip@fernuni-hagen.de
%>- [Roel Van Beeumen](http://www.roelvanbeeumen.be/) (Lawrence Berkeley National Laboratory) - rvanbeeumen@lbl.gov
%>
%>
%>## Funding
%>The QCLAB project is supported by the Laboratory Directed Research and
%>Development Program of Lawrence Berkeley National Laboratory under U.S.
%>Department of Energy Contract No. DE-AC02-05CH11231.
%>
%>
%>## About
%>QCLAB Copyright (c) 2021, The Regents of the University of California,
%>through Lawrence Berkeley National Laboratory (subject to receipt of
%>any required approvals from the U.S. Dept. of Energy). All rights reserved.
%>
%>If you have questions about your rights to use or distribute this software,
%>please contact Berkeley Lab's Intellectual Property Office at
%>IPO@lbl.gov.
%>
%>NOTICE.  This Software was developed under funding from the U.S. Department
%>of Energy and the U.S. Government consequently retains certain rights. As
%>such, the U.S. Government has been granted for itself and others acting on
%>its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the
%>Software to reproduce, distribute copies to the public, prepare derivative
%>works, and perform publicly and display publicly, and to permit others to do so.

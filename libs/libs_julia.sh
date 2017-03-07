#!/bin/sh

JULIA_PKGRESOLVE_ACCURACY=3
julia -e 'Pkg.update(); Pkg.add.(strip.(readlines("julia_packages.txt")))'

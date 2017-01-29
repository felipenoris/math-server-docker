#!/bin/sh

julia -e 'Pkg.update(); Pkg.add.(strip.(readlines("julia_packages.txt")))'

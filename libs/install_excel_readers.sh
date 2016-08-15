#!/bin/sh

pip2 install xlrd openpyxl
pip3 install xlrd openpyxl

# Uses Python's xlrd
julia -e 'Pkg.add("ExcelReaders")'

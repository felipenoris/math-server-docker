import pip
import sys
from subprocess import call

if len(sys.argv) != 2:
	print("Usage: python update_pkgs.py [number]")
else:
	pip_ver = sys.argv[1]

	for dist in pip.get_installed_distributions():
		call("pip" + pip_ver + " install --upgrade " + dist.project_name, shell=True)


Pkg.update()
libs = strip.(readlines("julia_packages.txt"))
for l in libs
    info("Adding package $l...")
    Pkg.add(l)
end

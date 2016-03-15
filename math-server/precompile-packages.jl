pkgkeys = keys(Pkg.installed())
state = start(pkgkeys)
while !done(pkgkeys, state)
	(pkgname, state) = next(pkgkeys, state)
	eval(parse("using $pkgname"))
end

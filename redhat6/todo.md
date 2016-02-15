## TODO List

- add https support for Jupyter.

- Precompilated packages default to /usr/local/share/julia/lib. This should be a per-user configuration. Current workaround: use a regular user to precompile packages.

- Error with jupyterhub with Julia kernel. Compat not found in path.

```
[I 2016-02-11 03:24:06.973 felipenoris restarter:103] KernelRestarter: restarting kernel (4/5)
WARNING:root:kernel e8db9fa9-288b-464b-b5af-c45aabf6c236 restarted
ERROR: LoadError: LoadError: ArgumentError: Compat not found in path
 in require at ./loading.jl:233
 in include at ./boot.jl:261
 in include_from_node1 at ./loading.jl:304
 in include at ./boot.jl:261
 in include_from_node1 at ./loading.jl:304
 in process_options at ./client.jl:280
 in _start at ./client.jl:378
while loading /usr/local/share/julia/v0.4/IJulia/src/IJulia.jl, in expression starting on line 4
while loading /usr/local/share/julia/v0.4/IJulia/src/kernel.jl, in expression starting on line 4
[W 2016-02-11 03:24:09.988 felipenoris restarter:95] KernelRestarter: restart failed
[W 2016-02-11 03:24:09.988 felipenoris kernelmanager:54] Kernel e8db9fa9-288b-464b-b5af-c45aabf6c236 died, removing from map.
ERROR:root:kernel e8db9fa9-288b-464b-b5af-c45aabf6c236 restarted failed!
[W 2016-02-11 03:24:10.001 felipenoris handlers:463] Kernel deleted before session
[W 2016-02-11 03:24:10.001 felipenoris log:47] 410 DELETE /user/felipenoris/api/sessions/ac31537a-1ede-4eff-8ff0-42d6c58ad6ee (::ffff:192.168.56.1) 1.48ms referer=http://192.168.56.101:8000/user/felipenoris/notebooks/Untitled5.ipynb?kernel_name=julia-0.4
```


# Whitelist of environment variables for the subprocess to inherit
# c.Spawner.env_keep = ['PATH', 'PYTHONPATH', 'CONDA_ROOT', 'CONDA_DEFAULT_ENV', 'VIRTUAL_ENV', 'LANG', 'LC_ALL']
c.Spawner.env_keep = [ 'PATH', 'LD_LIBRARY_PATH', 'JAVA_HOME', 'CPATH', 'CMAKE_ROOT', "PYTHON" ]

# use jupyterlab as default user interface
#c.Spawner.default_url = '/lab'

# set of usernames of admin users
#
# If unspecified, only the user that launches the server will be admin.
#c.Authenticator.admin_users = set(['admin'])

c.JupyterHub.extra_log_file = '/var/log/jupyterhub.log'

# https://github.com/jupyterhub/jupyterlab-hub
c.Spawner.cmd = ['jupyter-labhub']
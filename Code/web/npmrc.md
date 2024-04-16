#### npmrc Files

The four relevant files are:

* per-project configuration file (`/path/to/my/project/.npmrc`)
* per-user configuration file (defaults to `$HOME/.npmrc`; configurable via CLI option `--userconfig` or environment variable `$NPM_CONFIG_USERCONFIG`)
* global configuration file (defaults to `$PREFIX/etc/npmrc`; configurable via CLI option `--globalconfig` or environment variable `$NPM_CONFIG_GLOBALCONFIG`)
* npm's built-in configuration file (`/path/to/npm/npmrc`)

See [npmrc](../configuring-npm/npmrc.html) for more details.

#### Default Configs

Run `npm config ls -l` to see a set of configuration parameters that are internal to npm, and are defaults if nothing else is specified.

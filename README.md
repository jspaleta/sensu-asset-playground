# sensu-asset-playground
My personal attempt to create a reusable sensu asset.

## Workflow as it exists in my head:
1) archive non-binary artifacts in this repository
2) build binaries as local only artifacts
3) build platform asset tarballs as build host artifact
4) update repo docs with correct hash for tarball
5) generate github release and include platform asset tarballs



## Asset Directory Structure (Not populated in the repository)
  * `bin/` : added to check command PATH
  * `lib/` : added to check command LD_LIBRARY_PATH -> generally needed for dynamically linked executables
  * `include/` added to CPATH:

committing large binaries into git can lead to a suboptimal experience for some git operations like cloning. We'll just populate these directories in the release tarballs. 


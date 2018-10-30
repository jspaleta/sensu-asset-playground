# sensu-asset-playground
My personal attempt to create a reusable sensu asset.

## Workflow as it exists in my head:
1) archive non-binary artifacts in this repository:  
2) update bonsai.yaml 
3) commit
4) tag a release
5) build binaries -> using tagged commit
6) build platform asset tarballs matching bonsai yaml naming using tagged version name
7) generate sha512 matching bonsai yaml naming
8) upload platform asset tarballs and sha512 signatures into github release



## Asset Directory Structure (Not populated in the repository)
  * `bin/` : added to check command PATH
  * `lib/` : added to check command LD_LIBRARY_PATH -> generally needed for dynamically linked executables
  * `include/` added to CPATH:

committing large binaries into git can lead to a suboptimal experience for some git operations like cloning. We'll just populate these directories in the release tarballs. 


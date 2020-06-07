# alpine-tz-ep-code-server-from-src
code-server build from source, based on Alpine linux

This is for learning to build code-server from source.

Lessons learned:
1. It's possible to use python3 to make VS Code and code-server, no errors, only warning.
2. Building VS Code is resource intensive:
- Node peak memory usage is around 9 GB
- It takes around 10 min (probably more, didn't really time it) to build the builder image only.
- The resulting builder image is over 4 GB in size. (I haven't optimized the docker build process, though)
3. The resulting code-server bundled nodejs can't be executed (corrupt maybe?)

References:
https://github.com/Microsoft/vscode/wiki/How-to-Contribute#prerequisites  
https://github.com/microsoft/vscode/issues/95176
https://github.com/cdr/code-server/blob/master/doc/CONTRIBUTING.md

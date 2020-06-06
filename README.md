# alpine-tz-ep-code-server
code-server build from source on alpine linux


Vscode
https://github.com/Microsoft/vscode/wiki/How-to-Contribute#prerequisites  
Git
Node.JS, x64, version >= 10.x, <= 12.x -> override below
Yarn 
Python3, ref: https://github.com/microsoft/vscode/issues/95176

A C/C++ compiler tool chain for your platform: 

make
pkg-config
GCC
native-keymap needs libx11-dev and libxkbfile-dev.
keytar needs libsecret-1-dev.


code-server
https://github.com/cdr/code-server/blob/master/doc/CONTRIBUTING.md
Differences:

We require a minimum of node v12 but later versions should work.
We use fnpm to build .deb and .rpm packages. -> not needed
We use jq to build code-server releases.
The CI container is a useful reference for all our dependencies.

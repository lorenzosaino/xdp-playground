#!/bin/bash
set -euxo pipefail

# Install LLVM 11
# If we install LLVM 10 from the focal apt repo, this issue shows up:
# http://lists.llvm.org/pipermail/llvm-dev/2020-March/140156.html
curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
sudo apt-add-repository "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-11 main" -s
sudo apt-get install -qq llvm-11-dev libllvm11 libclang-11-dev llvm-11

# Install all Python3 requirements
sudo apt-get install -qq python3-venv python3-pip python-is-python3
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

# Install dependencies required for building BCC from source
sudo apt-get install -qq bison build-essential cmake flex git libedit-dev zlib1g-dev libelf-dev

# Install bcc from source (https://github.com/iovisor/bcc/blob/master/INSTALL.md#install-and-compile-bcc)
# There doesn't appear to be up-to-date deb packages built for Ubuntu 20.04
git clone https://github.com/iovisor/bcc.git
mkdir bcc/build
cd bcc/build
cmake ..
make
sudo make install
cmake -DPYTHON_CMD=python ..
pushd src/python/
make
sudo make install
popd

# Install headers, which are needed to compile BPF programs
sudo apt-get install -qq linux-headers-`uname -r`

# Install bpftool
sudo apt-get install -qq linux-tools-common linux-tools-generic linux-tools-`uname -r`

# Install Python dependencies
cd /vagrant
sudo make deps

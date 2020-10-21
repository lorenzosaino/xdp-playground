# XDP playground

XDP playground is a development environment for experimenting with XDP on a Ubuntu 20.04 virtual machine.
It allows you to write XDP programs and test their correctness by writing test cases using Python.

## Requirements

You need the following installed on your machine:

* [Vagrant](http://www.vagrantup.com)
* [Virtualbox](https://www.virtualbox.org/)

## Setup

Before the first usage you need to set up your virtual running

    vagrant up

This will create and start a VM with all that required packages installed.
Once it is ready you can SSH into the virtual machine running:

    vagrant ssh

When you are done, you can destroy the VM running

    vagrant destroy

## Usage

Once you have everything set up, you can start experimenting. SSH into the VM with

    vagrant ssh

and move to the `/vagrant` directory. It will include all files present in the root directory of this repository.
You can now start playing with [`xdp.c`](xdp.c) and [`test.py`](test.py).

The Makefile includes targets that you may find useful.
You may compile the code in [`xdp.c`](xdp.c) to eBPF bytecode with

    make compile

and run all tests included in [`test.py`](test.py) with

    make test

If you need additional Python packages for your tests, add them to [`requirements.txt`](requirements.txt) and run

    make deps

## Useful resources

* [XDP paper](https://dl.acm.org/doi/10.1145/3281411.3281443)
* [Cilium BPF and XDP Reference Guide](https://docs.cilium.io/en/latest/bpf/#bpf-guide)
* [BPF features by Linux kernel version](https://github.com/iovisor/bcc/blob/master/docs/kernel-versions.md)
* [XDP tutorial](https://github.com/xdp-project/xdp-tutorial)

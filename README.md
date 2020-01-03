k3.5s - 0.5 more than k3s
===================================================

An unofficial fork of [k3s](https://k3s.io) with [ZFS](https://zfsonlinux.org) support and other extras.

Purpose
-------

K3s is an awesomely lightweight implementation of Kubernetes.  It weights in at 50 megabytes and is designed to run on embedded systems.  However, due to it lean nature there are some features that were removed in order to provide that 50 megabyte footprint.  Removing these features is probably fine for 90% of k3s user.  This project exists for the other 10% of _need_ some of those removed features.

As this project add some "extras" to k3s which increases the size of the binary, the likelihood of this projecting being merged into mainline k3s is minimal.  The goal of k3.5s is to keep the number of required changes to a minimal

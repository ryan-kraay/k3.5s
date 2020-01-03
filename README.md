k3.5s - 0.5 more than k3s
===================================================

An unofficial fork of [k3s](https://k3s.io) with [ZFS](https://zfsonlinux.org) support and other extras.

Purpose
-------

K3s is an awesomely lightweight implementation of Kubernetes.  It weights in at 50 megabytes and is designed to run on embedded systems.  However, due to it lean nature there are some features that were removed in order to provide that 50 megabyte footprint.  Removing these features is probably fine for 90% of k3s user.  This project exists for the other 10% who _need_ some of those removed features.

As this project adds some "extras" to k3s which increases the size of the binary, the likelihood of this projecting being merged into mainline k3s is minimal.  The goal of k3.5s is to keep the number of required changes to a minimal.

Features
--------

K3.5s supports:
 * ZFS
 * BTRFS (TODO)

!Warning!
---------

Where as the goal is to keep the number of external changes to k3s to a minimum, it's not easy (or possible) to rigorously test all these changes.  As such, it's up to _you_ to determine if this suitably solves your use-case.


Building
--------

After you've cloned this repo, run:

```
$ docker build -t k3.5s:latest .
```

Setup
-----

Before you can use your custom k3s, you'll need to prep your system.

##

**ZFS Preparation**

The ZFS snapshotter *requires* a mount point to be named `/var/lib/rancher/k3s/agent/containerd/io.containerd.snapshotter.v1.zfs`, the ZFS filesystem name is arbitrary.

This can be accomplished by running:

```
$ zfs create -o /var/lib/rancher/k3s/agent/containerd/io.containerd.snapshotter.v1.zfs your-zpool/containerd-k3s
```

##

Installation
------------

Our `k3.5s:latest` image has your custom k3s binary.  To extract it you can run:

```
$ id=$(docker create k3.5s:latest) && docker cp ${id}:/usr/local/bin/k3s k3s && docker rm -v ${id}
```

You will have a binary called `k3s` in your local directory.

If you've already ran the official k3s [Quick Install Script](https://github.com/rancher/k3s#quick-start---install-script).  You merely need to replace `/usr/local/bin/k3s` with your compiled version of `k3s` and run `sudo service k3s restart`.

Otherwise you can follow the [Manual Download](https://github.com/rancher/k3s#manual-download) Documentation and use your `k3s` binary instead.

Extending
---------

The `Dockerfile` contains many build options and by default most of them are very conservative.  You're welcome to adjust them to fit your needs:

 * K3S_GIT_BRANCH:  This refers to a specific branch in the [k3s repo](https://github.com/rancher/k3s) to use.  The default is `release/v1.0`.
 * APPLY_PATCHES_CSV:  A comma separated list of patches which must exist in [patches folder](patches/).  The default is `enable_zfs`.

*NOTE*:  Due to some limitations in k3s and/or k3.5s - it may _not_ be possible to apply certain combinations of patches.

A theoretical example:

```
$ docker build --build-arg K3S_GIT_BRANCH=master --build-arg APPLY_PATCHES_CSV=enable_btrfs,enable_zfs -t k3.5s:latest .
```

FAQ
---

##

**Question:** Can I create a k3s that support multiple snapshotters?

**Answer:** Yes, _but..._ it would (in theory) be possible to create a k3s binary that supports mutiple snapshotters, but k3s does not provide an _easy_ way to specify which snapshotter to use at runtime.

##

**Q:** Why are binary releases not available?

**A:** This may be possible in the future.  However, the goal would be to provide an _automated_ way to doing this and actually verifying that the various snapshotters and combinations work automatically would require some thought.

##

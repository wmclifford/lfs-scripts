lfs-scripts
===========

Bash shell script project useful for automating a cross linux from scratch
build. May be extended to standard LFS/BLFS later.

After trying to build the LFS and CLFS projects various times, it has reached
the point where trying to do everything by hand takes way too long, and allows
for too many typos to come into play. Automating the process has become a goal
for me, and though I have looked at jhalfs and other offerings that already
exist, I decided to roll my own set of scripts. While the build process lends
itself well to using make and Makefiles, this setup (at this point in time)
takes a slightly different approach in using straight Bash shell scripts.

Giving the source tree a quick once-over, you can see how the process comes
together. There are some generic routines provided by the scripts in the "lib"
folder, and the "packages" folder contains the various scripts that are used to
build each of the packages that get installed in the new (C)LFS system. With
some tweaking, these will become generic enough to allow for simple addition of
any package that should be built into the new system, including those from the
BLFS project.

Initially, I worked with the LFS book, but having delved into the world of
embedded Linux, I found myself working more with the CLFS book, building for
machines that simply are not suitable or capable of the LFS steps. After
tinkering around with this process a while, I have found that this really is my
preferred way to build a from scratch system, as it gives the greatest control
over the toolchain/platform that is being installed. Also, the way that I have
designed these build scripts in this project, one is able to build various CLFS
installations side-by-side, simply by changing a few settings in one or two
shell scripts, then re-running the build process. In that regard, I presently
have (or, as of this writing, am in the process of building) both an ARM and
i686 build going at the same time, allowing me to test some of my other software
for cross-platform portability.

This will be an ongoing project for some time; use of these scripts is welcomed,
as are any suggestions for improving the process.


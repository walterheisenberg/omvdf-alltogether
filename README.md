omvdf-alltogether
=================

OMV-script for easy setup of a graph showing a total/free overview of all filesystems
and the system-disk

To see the graphs for the system-disk, please add:

MountPoint "/"

to your /etc/collectd/collectd.conf in '<Plugin df>'

so that it looks something like this:

LoadPlugin df

\<Plugin df\>

MountPoint "/media/926fb5ca-b54e-4dfc-828b-5f45ad072265"

MountPoint "/media/f607a0b8-0539-495f-b375-89j522f63db69"

MountPoint "/media/336ce995-52bf-4f88-8f4a-1c34a8797bf4"

MountPoint "/media/dad0d11b-0b39-4cae-b055-93c5cf7a8b30"

MountPoint "/media/08afa682-defa-47fe-99ca-da92caf164d4"

IgnoreSelected false

MountPoint "/"

\</Plugin\>

then restart the collect.d-daemon with 

/etc/init.d/collectd restart

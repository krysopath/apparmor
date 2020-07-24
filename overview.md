# overview

using unix DAC to implement MAC for application confinement

# setup
## preliminary

```
$ systemctl status apparmor
● apparmor.service - Load AppArmor profiles
     Loaded: loaded (/lib/systemd/system/apparmor.service; enabled; vendor preset: enabled)
     Active: active (exited) since Thu 2020-07-23 13:30:04 CEST; 23h ago
       Docs: man:apparmor(7)
             https://gitlab.com/apparmor/apparmor/wikis/home/
    Process: 1058 ExecStart=/lib/apparmor/apparmor.systemd reload (code=exited, status=0/SUCCESS)
   Main PID: 1058 (code=exited, status=0/SUCCESS)

Jul 23 13:30:04 stateless systemd[1]: Starting Load AppArmor profiles...
Jul 23 13:30:04 stateless apparmor.systemd[1058]: Restarting AppArmor
Jul 23 13:30:04 stateless apparmor.systemd[1058]: Reloading AppArmor profiles
Jul 23 13:30:04 stateless apparmor.systemd[1084]: Skipping profile in /etc/apparmor.d/disable: usr.bin.firefox
Jul 23 13:30:04 stateless apparmor.systemd[1086]: Skipping profile in /etc/apparmor.d/disable: usr.sbin.rsyslogd
Jul 23 13:30:04 stateless systemd[1]: Finished Load AppArmor profiles.

```
In case you have it disabled/inactive:

```
$ systemctl start apparmor 
$ systemctl enable apparmor  
```

Check its status:
```
$ sudo aa-status
[sudo] password for gve:
apparmor module is loaded.
42 profiles are loaded.
39 profiles are in enforce mode.
   /snap/core/9665/usr/lib/snapd/snap-confine
   /snap/core/9665/usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/bin/evince
   /usr/bin/evince-previewer
   /usr/bin/evince-previewer//sanitized_helper
   /usr/bin/evince-thumbnailer
   /usr/bin/evince//sanitized_helper
   /usr/bin/man
   /usr/bin/msmtp
   /usr/bin/msmtp//helpers
   /usr/lib/NetworkManager/nm-dhcp-client.action
   /usr/lib/NetworkManager/nm-dhcp-helper
   /usr/lib/connman/scripts/dhclient-script
   /usr/lib/cups/backend/cups-pdf
   /usr/lib/snapd/snap-confine
   /usr/lib/snapd/snap-confine//mount-namespace-capture-helper
   /usr/sbin/cups-browsed
   /usr/sbin/cupsd
   /usr/sbin/cupsd//third_party
   /usr/sbin/tcpdump
   /{,usr/}sbin/dhclient
   docker-default
   ippusbxd
   libvirtd
   libvirtd//qemu_bridge_helper
   lsb_release
   man_filter
   man_groff
   nvidia_modprobe
   nvidia_modprobe//kmod
   snap-update-ns.core
   snap-update-ns.protobuf
   snap-update-ns.pycharm-community
   snap-update-ns.telegram-cli
   snap-update-ns.telegram-desktop
   snap.core.hook.configure
   snap.telegram-cli.telegram-cli
   snap.telegram-desktop.telegram-desktop
   virt-aa-helper
3 profiles are in complain mode.
   snap.protobuf.protoc
   snap.protobuf.protoc-gen-go
   snap.pycharm-community.pycharm-community
4 processes have profiles defined.
4 processes are in enforce mode.
   /usr/sbin/cups-browsed (57890)
   /usr/sbin/cupsd (57889)
   /usr/sbin/libvirtd (1353) libvirtd
   /snap/telegram-desktop/1708/usr/bin/telegram-desktop (8413) snap.telegram-desktop.telegram-desktop
0 processes are in complain mode.
0 processes are unconfined but have a profile defined.
```


> Notice that there are many default profiles active/enabled for network
> reliant applications and most bigger services, that either run with high
> privileges or powergrab userspace

> Notice the difference of enforce and complain modes



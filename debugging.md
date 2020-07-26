# debugging apparmored processes

storytime:

> Installed all extra apparmor profiles for userspace. Confine firefox, break your yubikey 2FA.

Symptoms:
1. open 2FA secured page
2. try login
3. yubikey not blinking

happens in firefox but not chrome, just after installing:

```
ii  apparmor                                    2.13.3-7ubuntu5.1                     amd64        user-space parser utility for AppArmor
ii  apparmor-profiles                           2.13.3-7ubuntu5.1                     all          experimental profiles for AppArmor security policies
ii  apparmor-profiles-extra                     1.27                                  all          Extra profiles for AppArmor Security policies
ii  apparmor-utils                              2.13.3-7ubuntu5.1                     amd64        utilities for controlling AppArmor
```

Apparently apparmor confines firefox so strictly, that it can not speak to the yubikey.

## search kernel log for apparmor denials:

```
# dmesg | grep DENIED
[ 8767.968001] audit: type=1400 audit(1595773272.792:469): apparmor="DENIED" operation="open" profile="firefox" name="/proc/32450/cgroup" pid=32450 comm="firefox" requested_mask="r" denied_mask="r" fsuid=1000 ouid=1000
[ 8768.084169] audit: type=1107 audit(1595773272.908:470): pid=1154 uid=103 auid=4294967295 ses=4294967295 msg='apparmor="DENIED" operation="dbus_method_call"  bus="system" path="/org/freedesktop/RealtimeKit1" interface="org.freedesktop.DBus.Properties" member="Get" mask="send" name="org.freedesktop.RealtimeKit1" pid=32450 label="firefox" peer_pid=1403 peer_label="unconfined" exe="/usr/bin/dbus-daemon" sauid=103 hostname=? addr=? terminal=?'
```

> So `dbus` can not be spoken with or dbus cant act on firefox behalf. Thats how it looks like.

After some searching done online, people had issues with apparmored firefox +
yubikey all times. In my case it seemed, that the issue was a different one. My
yubikey came up as `/dev/hidraw3` and access to that device node was `DENIED`.

I found this answer by:

1. `aa-complain usr.bin.firefox`
2. starting firefox (without accessing the 2FA page)
3. checking `dmesg` for all firefox related DENIAL by apparmor to get an idea about the usual complains
4. running `aa-logprof`, ignoring all questions once
5. visit the page and try to 2FA login
6. check`dmesg` again for finding the difference in DENIAL's
7. running `aa-logprof` again, enabling the needed ACL for `/dev/hidraw3 r,`
8. running `aa-enforce usr.bin.firefox`
9. 2FA works with yubikey on page

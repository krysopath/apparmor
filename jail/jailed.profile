# Last Modified: Sun Jul 26 17:58:47 2020
#include <tunables/global>

/usr/bin/jailed {
  #include <abstractions/base>

  /dev/tty rw,
  /etc/nsswitch.conf r,
  /etc/passwd r,
  /usr/bin/bash mrix,
  /usr/bin/jailbash mr,
  owner /code/*/** rw,
  owner /code/jailed/.bashrc r,

}

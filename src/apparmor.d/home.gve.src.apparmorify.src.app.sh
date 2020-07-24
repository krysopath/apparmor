# Last Modified: Fri Jul 24 13:03:17 2020
#include <tunables/global>

/home/gve/src/apparmorify/src/app.sh {
  #include <abstractions/base>
  #include <abstractions/bash>
  #include <abstractions/consoles>

  /etc/terminfo/s/st-256color r,
  /home/gve/src/apparmorify/src/app.sh r,
  /usr/bin/bash ix,
  /usr/bin/mkdir mrix,
  /usr/bin/rm mrix,
  /usr/bin/touch mrix,
  owner /home/*/src/apparmorify/src/data/cached-assets w,

}

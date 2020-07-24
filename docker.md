# apparmor in docker

1. load the profile with `apparmor_parser`
2. start the container process confined

## loading & unloading a profile

loading:
```
$ sudo apparmor_parser -r -W apparmor.d/docker-app
```

unloading:
```
sudo apparmor_parser -R apparmor.d/docker-app
```

Also 
```
aa-enforce /etc/apparmor.d/docker-app
```
can be used to force loading of a profile.


If you need to check if apparmor really loaded your profile:
```
$ sudo grep docker-app /sys/kernel/security/apparmor/profiles
docker-app (enforce)
```

or 
```
sudo aa-status
```


## creating the proper profile

The base image defines paths and the entrypoint defines a process that is
setting up the applications execution environment.

The challenge is to adapt the profile for each image/entrypoint and to the
application itself.


For many cases a busybox shell is enough as entrypoint. Lets focus on this.

We create a Dockerfile with app.sh and debug loop around its execution until it
just works. Remember to be very restrictive and explicit as much as concise in
app armor profiles. Use Globbing when possible.

The Dockerfile:

```
FROM alpine
COPY app.sh /code/bin/app.sh
WORKDIR /code
RUN chown -R 1000:1000 /code
USER 1000:1000
ENTRYPOINT ["/code/bin/app.sh"]
```

Make copy of the original app armor profile that was created when profiling your application locally.

Then to quickly iterate over ACL changes, I used a command like this here:

```
sudo apparmor_parser -rWT apparmor.d/docker-app  \
  && docker build -t aa . \
  && docker run --rm -it --security-opt 'apparmor=/code/bin/app.sh' aa
```

>
```
Sending build context to Docker daemon  18.94kB
Step 1/6 : FROM alpine
 ---> e7d92cdc71fe
Step 2/6 : COPY app.sh /code/bin/app.sh
 ---> 055642e32bab
Step 3/6 : WORKDIR /code
 ---> Running in b1e023a5e1c5
Removing intermediate container b1e023a5e1c5
 ---> 026cee913db1
Step 4/6 : RUN chown -R 1000:1000 /code
 ---> Running in 791e044fa63c
Removing intermediate container 791e044fa63c
 ---> c7c7a765ca5f
Step 5/6 : USER 1000:1000
 ---> Running in 8551add4a46d
Removing intermediate container 8551add4a46d
 ---> e8c4f208d021
Step 6/6 : ENTRYPOINT ["/code/bin/app.sh"]
 ---> Running in ac71b8397589
Removing intermediate container ac71b8397589
 ---> 884205b6b9d5
Successfully built 884205b6b9d5
Successfully tagged aa:latest
+ echo 'just a naive example'
just a naive example
+ pwd
/code
+ mkdir -p /code/data/
+ date
+ cat /code/data/cached-assets
Fri Jul 24 16:45:40 UTC 2020
+ rm data/cached-assets
+ nc -nvlp 31337 -e /bin/sh
nc: socket(AF_INET,1,0): Permission denied
```

I ended up with this very simple profile:

```
# Last Modified: Fri Jul 24 13:03:17 2020
#include <tunables/global>


/code/bin/app.sh {
  #include <abstractions/base>

   /code/* r,
   /code/data/ rw,
   /code/data/** rw,
   /code/bin/app.sh r,
   /bin/busybox mrix,

}
``` 

> A unique busybox caveat it that busybox is the single responsible binary in
> alpine, unless `coreutils` or similar package has been installed.


## debugging

### `apparmor failed to apply profile: write /proc/self/attr/exec`
I had intially the issue that I was confusing the name of the profile with the
name of the file and ended up with these alot:
```
docker: Error response from daemon: OCI runtime create failed: container_linux.go:349: starting container process caused "process_linux.go:449: container init
caused \"apply apparmor profile: apparmor failed to apply profile: write /proc/self/attr/exec: no such file or directory\": unknown."
```

They indicate that the profile specified does not exist and not even basic
process stuff is allowed for entrypoint and that makes docker fail in a funny
way. To my understanding at least.


The cause for me was at first, apparmor service did not pickup the new profile,
then I specified the wrong name for the profile: resulting in the same error

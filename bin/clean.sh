#!/bin/bash -
echo "Uninstalling Gem"
gem uninstall rubohash

# Find version number
GEM_VERSION=$(grep -E "(VERSION =\s'[0-9]+.[0-9]+.[0-9]+')" ./lib/rubohash/version.rb | grep -Eo "([0-9]+.[0-9]+.[0-9]+)")

if [ -f "rubohash-$GEM_VERSION.gem" ]; then
  echo "Removing source gem"
  rm rubohash-$GEM_VERSION.gem
fi

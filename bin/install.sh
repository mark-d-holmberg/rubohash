#!/bin/bash -
echo "Building Gemspec..."
gem build rubohash.gemspec

# Find version number
GEM_VERSION=$(grep -E "(VERSION =\s'[0-9]+.[0-9]+.[0-9]+')" ./lib/rubohash/version.rb | grep -Eo "([0-9]+.[0-9]+.[0-9]+)")

echo "Installing Gem..."
gem install rubohash-$GEM_VERSION.gem --local

#!/bin/bash -
echo "Starting Install of Rubohash..."
source ./bin/install.sh

irb -r 'rubohash'

# echo "Starting new Pretty Scraper instance..."
# /usr/bin/env ruby './bin/pretty.rb'

# echo "Starting new Purge Tool instance..."
# /usr/bin/env ruby './bin/_purge_driver.rb'

# echo "Starting new Partial Scraper instance..."
# /usr/bin/env ruby './bin/parser.rb'

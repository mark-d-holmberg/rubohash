#!/bin/bash -
echo "Starting Install of Rubohash..."
source ./bin/install.sh

irb -r 'rubohash'

# TODO: You can set the configuration options for Rubohash here
# Rubohash.configure do |c|
#   c.default_extensions = %w[.png .gif .jpg .bmp .jpeg .ppm .datauri]
#   c.default_set        = "set1"
#   c.use_default_set    = false
#   c.robot_output_path  = '/Users/mark/dev/backend-tools/rubohash/output/'
#   c.default_format     = 'png'
#   c.default_bg_set     = 'bg1'
#   c.use_default_bg_set = false
# end

#!/bin/bash -
# Does an rspec, yard, and rubocop call

echo "Running R-Spec..."
bundle exec rspec spec/

echo "Running YARD..."
bundle exec yard stats --list-undoc

echo "Running Rubocop..."
bundle exec rubocop .

#!/bin/bash -

echo "Generating documentation..."
yardoc .

echo "Finding missing documentation..."
yard stats . --list-undoc

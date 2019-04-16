#!/bin/bash
set -v on

time echo "scale=5000; 4*a(1)" | bc -l -q

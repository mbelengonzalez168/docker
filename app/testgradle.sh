#!/bin/bash
TAG=$1
NAV=$2
xvfb-run -a --server-args="-screen 0 1920x1080x24" gradle runWithCucumber -Ptags=$TAG -Pnav=$NAV || true
ls /opt/framework/results

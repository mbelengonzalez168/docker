#!/bin/bash
RAMA=$1
REPOSITORIO=$2
mkdir -p /opt/prueba
git clone -b $RAMA $REPOSITORIO /opt/prueba
chmod 755 /opt/prueba
cd /opt/prueba/

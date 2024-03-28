#!/bin/bash

# Obtener los argumentos pasados al script
TAG=$1
NAV=$2

# Cambiar al directorio donde se encuentra el proyecto de Gradle
cd /opt/prueba

# Ejecutar las pruebas de Gradle con los argumentos proporcionados
./gradlew test -Dtag=$TAG -Dnav=$NAV

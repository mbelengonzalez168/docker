#!/bin/bash

#archivo de punto de entrada para ejecutar un contenedor. Su función principal es configurar el entorno 
#y ejecutar los comandos necesarios para iniciar la aplicación o los servicios dentro del contenedor. 
#realiza todos los pasos del pipeline

# CleanWorkspace: Limpiar el espacio de trabajo 
cleanWs

# clonacionImagen: Clonar el repositorio de Docker y construir la imagen
git clone -b main $REPO_DOCKER $WORKSPACE
docker buildx build -t $NOMBRE_APELLIDO:$TAG_IMAGEN .

# Automatización :
#Dar permisos de ejecución a los scripts en el directorio 'app'
chmod +x $WORKSPACE/app/*
# Ejecutar el script de clonación
sh clone.sh $RAMA $REPOSITORIO
# Ejecutar el contenedor Docker con las variables de entorno definidas
docker run -e RAMA=$RAMA -e REPOSITORIO=$REPOSITORIO -e TAG=$TAG -e NAV=$NAV $NOMBRE_APELLIDO:$TAG_IMAGEN

# Análisis de Eficiencia - DIVE: 
CI=true dive $NOMBRE_APELLIDO:$TAG_IMAGEN > log.txt
cat log.txt

# Análisis de archivo DockerFile - HADOLINT. 
docker run --rm -i hadolint/hadolint:latest < Dockerfile > logfile.txt || true
cat logfile.txt

# Análisis de Vulnerabilidades - TRIVY
trivy image $NOMBRE_APELLIDO:$TAG_IMAGEN > trivy.txt
cat trivy.txt

# Eliminar las imágenes Docker utilizadas
docker rmi -f $NOMBRE_APELLIDO:$TAG_IMAGEN
docker rmi -f hadolint/hadolint

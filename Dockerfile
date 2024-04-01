FROM ubuntu:22.04

FROM ubuntu:22.04

# Variables de entorno
ENV RAMA=${RAMA}
ENV REPOSITORIO=${REPOSITORIO}
ENV TAG=${TAG}
ENV NAV=${NAV}

# Actualización de paquetes e instalación de herramientas necesarias (java, gradle, wget)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
    gradle \
    wget \
    gnupg2 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Descarga e instalación de Gradle
ENV GRADLE_VERSION=7.4 \
    GRADLE_HOME=/opt/gradle \
    PATH=$PATH:/opt/gradle/bin

RUN wget -q https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp && \
    unzip -q /tmp/gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm -rf /tmp/*

# Mostrar versiones de Java y Gradle
RUN echo "Java version:"
RUN java -version
RUN echo "Gradle version:"
RUN gradle --version

# Instalación de Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable

#Agregar el directorio de trabajo (WORKDIR):  donde se ejecutarán los comandos relacionados con Gradle y donde se encontrarán los archivos necesarios para la ejecución de las pruebas
WORKDIR /opt/framework

#Copiar los scripts de prueba al contenedor: 
COPY testgradle.sh app/opt/framework/
COPY clone.sh app/opt/framework/

#Cambiar los permisos de los scripts para que sean ejecutables dentro del contenedor.
RUN chmod +x app/opt/framework/testgradle.sh
RUN chmod +x app/opt/framework/clone.sh

# Ejecutar los scripts de prueba durante la construcción de la imagen
RUN sh /opt/framework/clone.sh ${RAMA} ${REPOSITORIO} && \
    sh /opt/framework/testgradle.sh ${TAG} ${NAV}

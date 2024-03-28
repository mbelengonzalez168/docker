FROM ubuntu:22.04

FROM ubuntu:22.04

# Actualización de paquetes e instalación de herramientas necesarias (java, gradle, wget)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-11-jdk \
    gradle \
    wget \
    gnupg2 \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalación de Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable

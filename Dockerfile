###
# Mainflux Dockerfile
###
# Set the base image to Node, onbuild variant: https://registry.hub.docker.com/_/node/

FROM node:4.2.3
MAINTAINER Mainflux

ENV MAINFLUX_MQTT_PORT=1883
ENV MAINFLUX_MQTT_WS_PORT=8883

ENV MAINFLUX_INSTALL_DIR=/opt/mainflux-mqtt

ENV MONGO_HOST mongo
ENV MONGO_PORT 27017

RUN apt-get update -qq && apt-get install -y build-essential wget

###
# Installations
###
# Add Gulp globally

RUN npm install -g gulp
RUN npm install -g nodemon

# Add config
RUN mkdir -p /etc/mainflux/mqtt
COPY config.js /etc/mainflux/mqtt/config.js

# Finally, install all project Node modules
RUN mkdir -p $MAINFLUX_INSTALL_DIR
COPY . $MAINFLUX_INSTALL_DIR
WORKDIR $MAINFLUX_INSTALL_DIR
RUN npm install

EXPOSE $MAINFLUX_MQTT_PORT
EXPOSE $MAINFLUX_MQTT_WS_PORT

# Dockerize
ENV DOCKERIZE_VERSION v0.2.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
	&& tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

###
# Run main command from entrypoint and parameters in CMD[]
###

CMD [""]

# Set default container command
ENTRYPOINT gulp

###
# Run main command with dockerize
###
#CMD dockerize -wait tcp://$MONGO_HOST:$MONGO_PORT -timeout 10s gulp

FROM gethue/hue:latest
MAINTAINER Karl Stoney <me@karlstoney.com> 

HEALTHCHECK CMD curl -f http://localhost:8888/ || exit 1

COPY pseudo-distributed.ini /hue/desktop/conf/pseudo-distributed.ini

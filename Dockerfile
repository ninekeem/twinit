FROM busybox:latest
COPY *.sh /usr/local/bin/
ENV CONFIG_PATH=/cfg
ENV VOTE_GENERATOR=true
ENV MAPS_DIR=/maps
ENTRYPOINT ["init.sh"]

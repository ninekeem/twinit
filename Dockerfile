FROM busybox:latest
COPY *.sh /usr/local/bin/
ENV CONFIG_PATH=/cfg
ENV GENERATE_VG=1
ENV MAPS_DIR=/maps
ENTRYPOINT ["init.sh"]

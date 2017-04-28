FROM concourse/docker-image-resource

RUN mv /opt/resource /opt/resource-og/

ADD ./resource /opt/resource

RUN cp /opt/resource-og/print-metadata /opt/resource/print-metadata
RUN chmod -R +x /opt/resource/ /opt/resource-og/

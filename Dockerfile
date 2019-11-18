FROM ubuntu:16.04

ENV    SERVICE_USER=myuser \
    SERVICE_UID=10001 \
    SERVICE_GROUP=mygroup \
    SERVICE_GID=10001

RUN addgroup --gid ${SERVICE_GID} ${SERVICE_GROUP} && adduser --ingroup ${SERVICE_GROUP} --shell /sbin/nologin --uid ${SERVICE_UID} ${SERVICE_USER}

WORKDIR /
COPY ./catalogue /catalogue
COPY ./images/ /images/

RUN    chmod +x /catalogue && \
    chown -R ${SERVICE_USER}:${SERVICE_GROUP} /catalogue /images && \
    setcap 'cap_net_bind_service=+ep' /catalogue

ENV APP_PORT 8080
#ENV DB_DSN "catalogue_user:default_password@tcp(sockshop-catalogue-db.ckbkxcwrvff7.eu-west-1.rds.amazonaws.com:3306)/catalogue_db"
ENV DB_DSN "catalogue_user:default_password@tcp(catalogue-db:3306)/socksdb"

USER ${SERVICE_USER}

ARG BUILD_DATE
ARG BUILD_VERSION
ARG COMMIT

LABEL org.label-schema.vendor="Dynatrace" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.version="${BUILD_VERSION}" \
  org.label-schema.name="Socksshop: Catalogue" \
  org.label-schema.description="REST API for Catalogue service" \
  org.label-schema.url="https://github.com/dynatrace-sockshop/catalogue" \
  org.label-schema.vcs-url="github.com:dynatrace-sockshop/catalogue.git" \
  org.label-schema.vcs-ref="${COMMIT}" \
  org.label-schema.schema-version="1.0"

CMD ["/catalogue", "-port=8080"]
EXPOSE 8080

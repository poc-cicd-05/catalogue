FROM ubuntu:16.04

ENV    SERVICE_USER=myuser \
    SERVICE_UID=10001 \
    SERVICE_GROUP=mygroup \
    SERVICE_GID=10001

RUN addgroup --gid ${SERVICE_GID} ${SERVICE_GROUP} && adduser --ingroup ${SERVICE_GROUP} --shell /sbin/nologin --uid ${SERVICE_UID} ${SERVICE_USER}

RUN apt-get update
RUN apt-get install -y ca-certificates

# Install GO
RUN apt-get update -y && apt-get install --no-install-recommends -y -q curl build-essential ca-certificates git mercurial bzr
RUN mkdir /go && curl https://storage.googleapis.com/golang/go1.8.7.linux-amd64.tar.gz | tar xvzf - -C /go --strip-components=1
RUN mkdir /gopath

ENV GOROOT /go
ENV GOPATH /gopath
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

# Build app
COPY . /go/src/github.com/dynatrace-sockshop/catalogue
WORKDIR /go/src/github.com/dynatrace-sockshop/catalogue

#RUN go get -u github.com/FiloSottile/gvt
#RUN gvt restore && \
#    GOOS=linux go build -a -ldflags -linkmode=external -ldflags -linkmode=external -installsuffix cgo -o /app github.com/microservices-demo/catalogue/cmd/cataloguesvc

RUN go get -v github.com/Masterminds/glide 
RUN glide install && go build -a -ldflags -linkmode=external -installsuffix cgo -o /catalogue main.go

ENV APP_PORT 8080
ENV DB_DSN "catalogue_user:default_password@tcp(sockshop-catalogue-db.ckbkxcwrvff7.eu-west-1.rds.amazonaws.com:3306)/catalogue_db"

WORKDIR /
COPY ./images/ /images/

RUN    chmod +x /catalogue && \
    chown -R ${SERVICE_USER}:${SERVICE_GROUP} /catalogue /images && \
    setcap 'cap_net_bind_service=+ep' /catalogue

USER ${SERVICE_USER}

ARG BUILD_DATE
ARG BUILD_VERSION
ARG COMMIT

LABEL org.label-schema.vendor="Dynatrace" \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.version="${BUILD_VERSION}" \
  org.label-schema.name="Socks Shop: Catalogue" \
  org.label-schema.description="REST API for Catalogue service" \
  org.label-schema.url="https://github.com/dynatrace-sockshop/catalogue" \
  org.label-schema.vcs-url="github.com:dynatrace-sockshop/catalogue.git" \
  org.label-schema.vcs-ref="${COMMIT}" \
  org.label-schema.schema-version="1.0"

CMD ["/catalogue", "-port=8080"]
EXPOSE 8080
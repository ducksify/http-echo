FROM golang:1.23-bullseye AS build
ENV DEBIAN_FRONTEND=noninteractive
ENV DNSX_RELEASE="1.2.1"
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends upx wget unzip

COPY . ./
RUN go mod download 

RUN go build -ldflags "-s -w" -o /http-echo \
    && upx /http-echo

FROM gcr.io/distroless/static-debian12:nonroot as default

COPY --from=build /http-echo /http-echo

EXPOSE 5678/tcp

ENV ECHO_TEXT="hello-world"

ENTRYPOINT ["/http-echo"]

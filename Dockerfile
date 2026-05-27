# golang:1.23-alpine
FROM 329601960842.dkr.ecr.us-east-1.amazonaws.com/docker/library/golang@sha256:383395b794dffa5b53012a212365d40c8e37109a626ca30d6151c8348d380b5f

WORKDIR /go/src/github.com/abutaha/aws-es-proxy
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -o aws-es-proxy

# alpine:3.20
FROM 329601960842.dkr.ecr.us-east-1.amazonaws.com/docker/library/alpine@sha256:d9e853e87e55526f6b2917df91a2115c36dd7c696a35be12163d44e6e2a4b6bc
LABEL name="aws-es-proxy" \
      version="latest"

RUN apk --no-cache add ca-certificates
WORKDIR /home/
COPY --from=0 /go/src/github.com/abutaha/aws-es-proxy/aws-es-proxy /usr/local/bin/

ENV PORT_NUM 9200
EXPOSE ${PORT_NUM}

ENTRYPOINT ["aws-es-proxy"] 
CMD ["-h"]

FROM alpine:latest

RUN apk --no-cache add lshw

CMD uname -m && lshw -short

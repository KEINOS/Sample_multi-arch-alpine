FROM keinos/alpine

RUN apk --no-cache add lshw && \
    uname -m && \
    lshw -short

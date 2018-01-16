FROM alpine:3.7
RUN apk add --no-cache curl
CMD /usr/bin/curl -s --write-out '%{http_code}' -o /dev/null --retry 10 --retry-delay 5 -v http://lb/api/user

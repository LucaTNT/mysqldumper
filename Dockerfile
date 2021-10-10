FROM alpine
RUN apk --no-cache add mariadb-client curl bash tzdata && addgroup -S -g 1001 mysqldumper && adduser -S -u 1001 -G mysqldumper mysqldumper

COPY setupcron.sh mysqldumper.sh /

ENTRYPOINT ["bash", "setupcron.sh"]

FROM alpine
RUN apk --no-cache add mariadb-client curl bash tzdata && adduser -S mysqldumper -u 1000

COPY setupcron.sh mysqldumper.sh /

ENTRYPOINT ["bash", "setupcron.sh"]
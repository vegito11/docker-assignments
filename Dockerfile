FROM alpine:3.18.0
ENV FTP_USER=foo \
	FTP_PASS=bar \
	GID=1000 \
	UID=1000

RUN apk add --no-cache --update \
	vsftpd==3.0.5-r2

COPY vsftpd.conf /etc/
COPY docker-entrypoint.sh /app/

RUN chmod +x /app/docker-entrypoint.sh

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
CMD [ "/usr/sbin/vsftpd" ]

EXPOSE 20/tcp 21/tcp 40000-40009/tcp
HEALTHCHECK CMD netstat -lnt | grep :21 || exit 1

# docker build --build-arg -t ftp-server .
# docker run -p 30021:21 -p 40000-40009:40009-40009 --env FTP_USER=john --env FTP_PASS=123  --name ct ftp-server

FROM alpine:3.10

LABEL maintainer="docker@upshift.fr"

RUN set -eux; \
	# install needed packages
	apk add --no-cache \
		bash \
		netatalk \
	; \
	# group useful configuration files
	mkdir /etc/netatalk; \
	for file in passwd shadow group afp.conf; \
	do \
		cp -p /etc/$file /etc/$file-orig; \
		mv /etc/$file /etc/netatalk/; \
		ln -s netatalk/$file /etc/$file; \
	done

COPY /src/afp.conf /etc/netatalk/

VOLUME /etc/netatalk

WORKDIR /etc/netatalk

EXPOSE 548/tcp

COPY src/docker-entrypoint /usr/local/bin/
ENTRYPOINT ["docker-entrypoint"]

CMD ["/usr/sbin/netatalk","-d"]

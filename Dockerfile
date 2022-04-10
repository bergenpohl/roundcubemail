# Debian v11
FROM debian:bullseye

COPY srcs /root/srcs/

RUN apt-get update
RUN apt-get -y install	\
	sudo		\
	vim man		\
	curl wget	\
	passwd		\
	adduser		\
	unzip		\
	nginx		\
	mariadb-server	\
	mariadb-client	\
	php		\
	php-fpm		\
	php-mysql	\
	php-net-ldap3	\
	php-imagick	\
	php-common	\
	php-gd		\
	php-imap	\
	php-json	\
	php-curl	\
	php-zip		\
	php-xml		\
	php-mbstring	\
	php-intl	\
	php-net-smtp	\
	php-mail-mime	\
	dovecot-core	\
	dovecot-imapd	\
	dovecot-lmtpd

# Run config on startup
ENTRYPOINT ["bash", "/root/srcs/startup.sh"]

FROM debian:stretch-slim
MAINTAINER KALRONG <xrb@kalrong.net>

ENV MODE nogui-web
ENV DEBIAN_FRONTEND noninteractive
ENV TOR no
ENV I2P no
ENV I2P_DIR /usr/share/i2p

RUN apt-get update && apt-get -y install wget gnupg2 curl

RUN echo 'deb http://download.opensuse.org/repositories/network:/retroshare/Debian_9.0/ /' >> /etc/apt/sources.list.d/retroshare.list

RUN wget -qO - http://download.opensuse.org/repositories/network:retroshare/Debian_9.0/Release.key | apt-key add - 

RUN echo "deb http://deb.i2p2.no/ stretch main" > /etc/apt/sources.list.d/i2p.list

RUN curl -o i2p-debian-repo.key.asc https://geti2p.net/_static/i2p-debian-repo.key.asc && apt-key add i2p-debian-repo.key.asc

RUN mkdir -p /usr/share/man/man1 && \
    (echo "deb http://http.debian.net/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list) && \
    apt-get update -y && \
    apt-get install -t stretch-backports openjdk-8-jdk -y

RUN apt-get update && apt-get -y install retroshare xpra i2p tor

RUN sed -i 's/127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/i2ptunnel.config && \
    sed -i 's/::1,127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/clients.config && \
    printf "i2cp.tcp.bindAllInterfaces=true\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.ipv4.firewalled=true\ni2np.ntcp.ipv6=false\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.udp.ipv6=false\ni2np.upnp.enable=false\n" >> ${I2P_DIR}/router.config && \
    echo "RUN_AS_USER=i2psvc" >> /etc/default/i2p

RUN apt-get -y remove curl wget && apt-get clean all

COPY ./startup.sh /startup.sh

RUN chmod +x /startup.sh

ENTRYPOINT ["/bin/bash","/startup.sh"]

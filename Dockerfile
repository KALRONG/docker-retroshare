FROM debian:stretch-slim
MAINTAINER KALRONG <xrb@kalrong.net>

ENV MODE nogui-web
ENV DEBIAN_FRONTEND noninteractive
ENV TOR no
ENV I2P no
ENV I2P_DIR /usr/share/i2p

RUN echo "deb http://deb.i2p2.no/ stretch main" > /etc/apt/sources.list.d/i2p.list && \
    apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-key 0x67ECE5605BCF1346

RUN apt-get update;apt-get -y upgrade; apt-get -y dist-upgrade

RUN apt-get install -y libglib2.0-dev libupnp-dev qt4-dev-tools \
    libqt4-dev libssl-dev libxss-dev libgnome-keyring-dev libbz2-dev \
    libqt4-opengl-dev libqtmultimediakit1 qtmobility-dev libsqlcipher-dev \
    libspeex-dev libspeexdsp-dev libxslt1-dev libcurl4-openssl-dev \
    libopencv-dev tcl8.5 libmicrohttpd-dev git xpra tor i2p-router i2p-keyring

RUN mkdir ~/retroshare &&\
    cd ~/retroshare &&\
    git clone https://github.com/RetroShare/RetroShare.git trunk

RUN cd ~/retroshare/trunk &&\
    qmake CONFIG+=tests &&\
    make

RUN cd ~/retroshare/trunk/tests/unittests/ &&\
    ./run_tests.sh

RUN cd ~/retroshare/trunk &&\
    make install

RUN sed -i 's/127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/i2ptunnel.config && \
    sed -i 's/::1,127\.0\.0\.1/0.0.0.0/g' ${I2P_DIR}/clients.config && \
    printf "i2cp.tcp.bindAllInterfaces=true\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.ipv4.firewalled=true\ni2np.ntcp.ipv6=false\n" >> ${I2P_DIR}/router.config && \
    printf "i2np.udp.ipv6=false\ni2np.upnp.enable=false\n" >> ${I2P_DIR}/router.config && \
    echo "RUN_AS_USER=i2psvc" >> /etc/default/i2p

RUN apt-get clean all

COPY ./startup.sh /startup.sh

RUN chmod +x /startup.sh

ENTRYPOINT ["/bin/bash","/startup.sh"]

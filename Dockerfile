FROM debian:jessie-backports
MAINTAINER KALRONG <xrb@kalrong.net>

RUN apt-get update;apt-get -y upgrade; apt-get -y dist-upgrade

COPY ./keyboard /etc/default/keyboard
ENV DEBIAN_FRONTEND noninteractive
RUN \
   apt-get install -y libglib2.0-dev libupnp-dev qt4-dev-tools \
   libqt4-dev libssl-dev libxss-dev libgnome-keyring-dev libbz2-dev \
   libqt4-opengl-dev libqtmultimediakit1 qtmobility-dev libsqlcipher-dev \
   libspeex-dev libspeexdsp-dev libxslt1-dev libcurl4-openssl-dev \
   libopencv-dev tcl8.5 libmicrohttpd-dev git xpra &&\
   echo "keyboard-configuration  console-setup/detect    detect-keyboard" | debconf-set-selections && \
   echo "keyboard-configuration  console-setup/detected  note" | debconf-set-selections && \
   echo "keyboard-configuration  console-setup/ask_detect        boolean false" | debconf-set-selections

RUN mkdir ~/retroshare &&\
    cd ~/retroshare &&\
    git clone https://github.com/RetroShare/RetroShare.git trunk

RUN cd ~/retroshare/trunk &&\
    qmake CONFIG+=debug &&\
    make

RUN cd ~/retroshare/trunk &&\
    qmake CONFIG+=tests &&\
    make

RUN cd ~/retroshare/trunk/tests/unittests/ &&\
    ./run_tests.sh

RUN cd ~/retroshare/trunk &&\
    make install

COPY ./startup.sh /startup.sh
RUN chmod +x /startup.sh
ENV MODE nogui-web
ENV QT_GRAPHICSSYSTEM native
ENTRYPOINT ["/bin/bash","/startup.sh"]

FROM debian:bookworm
MAINTAINER KALRONG <xrb@kalrong.net>

ENV MODE nogui-web
ENV DEBIAN_VERSION 12
ENV REPOFILE https://raw.githubusercontent.com/Xpra-org/xpra/master/packaging/repos/bookworm/xpra.sources

RUN apt update && apt -y upgrade
RUN apt -y install wget

RUN wget -O "/usr/share/keyrings/xpra.asc" https://xpra.org/xpra.asc
RUN cd /etc/apt/sources.list.d ; wget $REPOFILE

RUN wget -qO - http://download.opensuse.org/repositories/network:retroshare/Debian_${DEBIAN_VERSION}/Release.key | sudo apt-key add -
RUN /bin/bash -c "echo 'deb http://download.opensuse.org/repositories/network:/retroshare/Debian_${DEBIAN_VERSION}/' > /etc/apt/sources.list.d/retroshare.list"

RUN apt -y install xpra retroshare-gui

RUN apt -y remove wget

COPY ./startup.sh /startup.sh

RUN chmod +x /startup.sh

ENTRYPOINT ["/bin/bash","/startup.sh"]

FROM raspbian/stretch:041518

MAINTAINER Smither "callum [at] smither [dot] org"

RUN apt-get clean && apt-get update && apt-get dist-upgrade -y

RUN apt-get install -y \
    hostapd \
    dbus \
    net-tools \
    iptables \
    dnsmasq \
    vim

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ADD hostapd.conf /etc/hostapd/hostapd.conf
ADD hostapd /etc/default/hostapd
ADD dnsmasq.conf /etc/dnsmasq.conf

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
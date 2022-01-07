FROM ubuntu:20.04

ARG ZEEK_VERSION=4.1.1

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "===> Install Prereqs" && \
        apt-get update -y && \
        apt-get upgrade -y && \
        apt-get install -y cmake make g++ gcc flex bison libpcap-dev libssl-dev \ 
        python-dev swig zlib1g-dev git clang net-tools iproute2 softflowd

WORKDIR /tmp
RUN echo "===> Cloning zeek..." && \ 
  git clone --recursive --branch v$ZEEK_VERSION https://github.com/zeek/zeek.git

WORKDIR /tmp/zeek
RUN echo "===> Compiling zeek..." && \
  ./configure --prefix=/usr/local/zeek \
  --build-type=MinSizeRel \
  --disable-broker-tests \
  --disable-zeekctl \
  --disable-auxtools \
  --disable-python && \
  make -j $(nproc --all || echo 1) && \
  make install

WORKDIR /tmp/zeek/auxil
RUN echo "===> Compiling af_packet plugin..." && \
  git clone https://github.com/J-Gras/zeek-af_packet-plugin.git && \
  cd /tmp/zeek/auxil/zeek-af_packet-plugin && \
  ./configure --with-kernel=/usr --zeek-dist=/tmp/zeek && \
  make -j $(nproc --all || echo 1) && \ 
  make install && \
  /usr/local/zeek/bin/zeek -NN Zeek::AF_Packet

WORKDIR /tmp
RUN echo "===> Installing hosom/file-extraction package..." && \
  git clone https://github.com/hosom/file-extraction.git && \
  mv file-extraction/scripts /usr/local/zeek/share/zeek/site/file-extraction

RUN echo "===> Installing Community-Id..." && \
  git clone https://github.com/corelight/zeek-community-id.git && \
  cd /tmp/zeek-community-id && \
  ./configure --zeek-dist=/tmp/zeek && \
  cd /tmp/zeek-community-id/build && \
  make -j $(nproc --all || echo 1) && \
  make install && \
  /usr/local/zeek/bin/zeek -NN Corelight::CommunityID

WORKDIR /tmp/zeek/auxil
RUN echo "===> Installing apache/metron-bro-plugin-kafka package..." && \
  apt-get install -y librdkafka-dev && \
  git clone https://github.com/ckreibich/zeek-plugin-kafka.git metron-bro-plugin-kafka &&\
  cd /tmp/zeek/auxil/metron-bro-plugin-kafka && \
  ./configure --zeek-dist=/tmp/zeek && \
  cd build && \
  make -j $(nproc --all || echo 1) && \
  make install && \
  /usr/local/zeek/bin/zeek -N Apache::Kafka

ENV PATH="${PATH}:/usr/local/zeek/bin"
ENV PATH="${PATH}:/usr/bin"

WORKDIR /usr/local/zeek/share/zeek/site
COPY local.zeek local.zeek
COPY send-to-kafka.zeek send-to-kafka.zeek
WORKDIR /root

RUN mkdir data
COPY data/* data/

COPY init_pcap.sh init_pcap.sh

RUN chmod +x init_pcap.sh
ENTRYPOINT ["bash", "/root/init_pcap.sh"]

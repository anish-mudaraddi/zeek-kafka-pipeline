FROM confluentinc/cp-kafka-connect:latest

ARG KAFKA_CONNECT_OPENSEARCH_VERSION=0.0.2

WORKDIR /usr/share/java/
# RUN curl -L -o kafka-connect-opensearch.jar https://github.com/dmathieu/kafka-connect-opensearch/releases/download/${KAFKA_CONNECT_OPENSEARCH_VERSION}/kafka-connect-opensearch.jar

WORKDIR /tmp
RUN wget --content-disposition https://github.com/aiven/opensearch-connector-for-apache-kafka/releases/download/v1.0.1/opensearch-connector-for-apache-kafka-1.0.1.tar && \
    tar -xf opensearch-connector-for-apache-kafka-1.0.1.tar && \
    cp -r opensearch-connector-for-apache-kafka-1.0.1 /usr/share/java



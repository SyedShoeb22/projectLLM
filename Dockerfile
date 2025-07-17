FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV OOZIE_VERSION=5.2.0
ENV HADOOP_VERSION=3.2.1

RUN apt-get update && \
    apt-get install -y openjdk-8-jdk wget unzip ssh rsync maven git python && \
    apt-get clean

# Download and extract Oozie
RUN wget https://archive.apache.org/dist/oozie/${OOZIE_VERSION}/oozie-${OOZIE_VERSION}.tar.gz && \
    tar -xvzf oozie-${OOZIE_VERSION}.tar.gz && \
    mv oozie-${OOZIE_VERSION} /opt/oozie && \
    rm oozie-${OOZIE_VERSION}.tar.gz

# Build the Oozie distro (with Hadoop 3 support)
WORKDIR /opt/oozie
RUN /opt/oozie/bin/mkdistro.sh -DskipTests -Dtar -Phadoop-3

# Expose Oozie port
EXPOSE 11000

CMD ["/opt/oozie/bin/oozied.sh", "start"]

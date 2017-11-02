FROM afalko/alpine:9

RUN apk add openjdk8
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk
ENV PATH=${PATH}:/usr/lib/jvm/java-1.8-openjdk/bin

CMD ["/bin/sh"]

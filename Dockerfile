FROM elixir:1.13.3-alpine AS elixir-build
RUN apk add openjdk11-jre --no-cache
ENV CLASSPATH=$CLASSPATH:/usr/local/lib/antlr4.jar
RUN printf "#!/bin/sh\njava org.antlr.v4.gui.TestRig \$@" > /usr/bin/grun && chmod +x /usr/bin/grun
ADD https://www.antlr.org/download/antlr-4.9.3-complete.jar /usr/local/lib/antlr4.jar

WORKDIR /src/app

COPY *.exs .
COPY lib ./lib
COPY test ./test

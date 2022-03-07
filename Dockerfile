FROM alpine AS antlr-generate
RUN apk add openjdk11-jre --no-cache
ENV CLASSPATH=$CLASSPATH:/usr/local/lib/antlr4.jar
ADD https://www.antlr.org/download/antlr-4.9.3-complete.jar /usr/local/lib/antlr4.jar
WORKDIR /src/langs
COPY ./test/langs .
RUN java org.antlr.v4.Tool -Dlanguage=Dart ArrayInit.g4

FROM dart:2.16.1 AS parser-build
WORKDIR /src
RUN dart create -t console-full dart_app && cd dart_app && dart pub add antlr4
WORKDIR /src/dart_app
COPY --from=antlr-generate /src/langs/*.dart .
COPY ./test/langs/main.dart .
RUN dart compile exe main.dart -o bin/parser

FROM elixir:1.13.3 AS elixir-build
WORKDIR /src/app

COPY --from=parser-build /src/dart_app/bin/parser /parsers/ArrayInit
COPY *.exs .
COPY lib ./lib
COPY test ./test

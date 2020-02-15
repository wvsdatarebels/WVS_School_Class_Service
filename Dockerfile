FROM google/dart

WORKDIR /app

ADD pubspec.* /app/
RUN pub get
ADD . /app
RUN pub get --offline

EXPOSE 7621

CMD []
ENTRYPOINT ["/usr/bin/dart", "/app/bin/server.dart"]

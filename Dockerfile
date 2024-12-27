FROM azul/zulu-openjdk:21-latest AS builder
WORKDIR /app
COPY ./mvnw .
COPY ./pom.xml .
COPY .mvn/ .mvn/
COPY ./src src/
RUN --mount=type=cache,target=/root/.m2 ./mvnw package

FROM azul/zulu-openjdk:21-jre-headless-latest
WORKDIR /app
COPY docker-entrypoint.sh .
RUN chmod u+x docker-entrypoint.sh
COPY --from=builder /app/target/ecsdemo-0.0.1-SNAPSHOT.jar app.jar
CMD ["/app/docker-entrypoint.sh"]

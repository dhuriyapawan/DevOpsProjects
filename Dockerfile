FROM gradle:8.10-jdk-alpine AS builder

WORKDIR /app

COPY build.gradle settings.gradle ./
COPY gradle ./gradle

COPY src ./src

RUN gradle clean bootjar --no-daemon

FROM eclipse-temurin:21-jre-alpine

RUN adduser -D -u 1000 appuser

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

ENTRYPOINT [ "java","-jar", "app.jar" ]
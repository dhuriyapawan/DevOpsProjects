FROM gradle:8.10-jdk AS builder

WORKDIR /app

COPY build.gradle settings.gradle ./
COPY gradle ./gradle

COPY src ./src

RUN gradle clean bootjar --no-daemon

FROM eclipse-eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT [ "java","-jar", "app.jar" ]
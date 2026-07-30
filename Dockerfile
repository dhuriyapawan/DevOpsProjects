FROM eclipse-temurin:8-jdk-alpine AS builder

WORKDIR /app

COPY gradlew gradlew.bat ./
COPY gradle ./gradle
COPY build.gradle settings.gradle ./
COPY src ./src

RUN chmod +x gradlew && ./gradlew clean build --no-daemon

FROM eclipse-temurin:8-jre-alpine

RUN adduser -D -u 1000 appuser

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
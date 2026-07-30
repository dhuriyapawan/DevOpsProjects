# Build stage
FROM maven:3.9-eclipse-temurin-21-alpine AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests


# Runtime stage
FROM eclipse-temurin:21-jre-alpine

RUN addgroup -S appgroup && \
    adduser -S -u 1000 -G appgroup appuser

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
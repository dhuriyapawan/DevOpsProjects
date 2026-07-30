# Build stage
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

COPY . .

# Build your application
RUN ./mvnw clean package -DskipTests


# Runtime stage
FROM eclipse-temurin:21-jre-alpine

# Create non-root user
RUN addgroup -S appgroup && \
    adduser -S -u 1000 -G appgroup appuser

WORKDIR /app

# Copy application JAR
COPY --from=build /app/target/*.jar app.jar

# Run as non-root user
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
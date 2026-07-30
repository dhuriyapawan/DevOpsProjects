# =========================
# Build stage
# =========================
FROM eclipse-temurin:21-jdk-alpine AS build

WORKDIR /app

# Copy Gradle files
COPY gradlew .
COPY gradle ./gradle
COPY build.gradle .
COPY settings.gradle .

# Make Gradle wrapper executable
RUN chmod +x gradlew

# Copy source code
COPY src ./src

# Build application
RUN ./gradlew clean build -x test --no-daemon --stacktrace --info

# =========================
# Runtime stage
# =========================
FROM eclipse-temurin:21-jre-alpine

# Create non-root user
RUN addgroup -S appgroup && \
    adduser -S -u 1000 -G appgroup appuser

WORKDIR /app

# Copy generated JAR
COPY --from=build /app/build/libs/*.jar app.jar

# Run as non-root user
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
# =========================
# Build Stage
# =========================
FROM eclipse-temurin:21-jdk-jammy AS build

WORKDIR /app

# Copy Gradle project
COPY . .

# Fix Windows CRLF line endings
# and make Gradle wrapper executable
RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

# Build application
RUN ./gradlew clean build -x test --no-daemon --stacktrace


# =========================
# Runtime Stage
# =========================
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Create non-root user
RUN groupadd -r appgroup && \
    useradd -r -g appgroup -u 1000 appuser

# Copy generated JAR
COPY --from=build /app/build/libs/*.jar app.jar

# Run as non-root user
USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
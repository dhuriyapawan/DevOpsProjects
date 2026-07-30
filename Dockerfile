FROM eclipse-temurin:8-jdk-jammy AS build

WORKDIR /app

COPY . .

RUN sed -i 's/\r$//' gradlew && chmod +x gradlew

RUN ./gradlew clean build -x test --no-daemon --stacktrace


FROM eclipse-temurin:8-jre-jammy

WORKDIR /app

RUN groupadd -r appgroup && \
    useradd -r -g appgroup -u 1000 appuser

COPY --from=build /app/build/libs/*.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
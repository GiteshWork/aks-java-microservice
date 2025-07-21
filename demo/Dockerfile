# Dockerfile

# --- Stage 1: The "Build" Stage ---
# This stage uses a full JDK to build the application.
FROM gradle:8.8-jdk17-alpine as builder

WORKDIR /app
COPY build.gradle settings.gradle ./
COPY src ./src

# Run the gradle build command to compile the code and create the .jar file
RUN gradle bootJar --no-daemon


# --- Stage 2: The "Final" Stage ---
# This stage uses a minimal Java Runtime Environment (JRE) to run the app.
# It results in a much smaller final image.
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy only the built .jar file from the "builder" stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Tell Docker to expose port 8080
EXPOSE 8080

# The command to run when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
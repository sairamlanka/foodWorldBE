# Stage 1: Build the application using Maven
FROM maven:3.9.9-amazoncorretto-17-al2023 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and src directory into the container
COPY pom.xml .
COPY src ./src

# Package the application (skip tests for faster build)
RUN mvn package -DskipTests

# Stage 2: Run the application using OpenJDK
FROM openjdk:24-slim-bullseye

# Set the working directory inside the container
WORKDIR /app

# Copy the packaged JAR from the build stage to the current working directory
COPY --from=build /app/target/foodWorldBE-0.0.1-SNAPSHOT.jar app.jar

# Ensure the JAR file is executable
RUN chmod +x /app/app.jar

# Expose the port the application will run on
EXPOSE 8080

# Set the entry point to run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]
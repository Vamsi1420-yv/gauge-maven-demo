# Stage 1: Build with Maven and Java 8
FROM maven:3.9.6-eclipse-temurin-8 AS build

# Set working directory inside the container
WORKDIR /app

# Copy all project files into the container
COPY . .

# Optionally clean up Maven local cache to avoid stale/dirty builds
RUN mvn dependency:purge-local-repository -DactTransitively=false -DreResolve=false

# Build the project (skip tests for faster build; remove -DskipTests to include tests)
RUN mvn clean install -DskipTests

# Stage 2: Run with lightweight JRE
FROM eclipse-temurin:8-jre

WORKDIR /app

# Copy built JAR from the previous stage
COPY --from=build /app/target/*.jar app.jar

# Run the JAR
CMD ["java", "-jar", "app.jar"]

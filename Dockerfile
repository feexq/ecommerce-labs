FROM gradle:8.10-jdk17-alpine AS build
WORKDIR /home/gradle/src

COPY build.gradle settings.gradle ./
COPY gradle/ ./gradle/

RUN gradle dependencies --no-daemon -q

COPY src/ ./src/
RUN gradle build -x test --no-daemon -q

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app

COPY --from=build /home/gradle/src/build/libs/*.jar app.jar

RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

ENTRYPOINT ["java", "-jar", "app.jar"]
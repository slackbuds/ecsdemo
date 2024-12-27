#!/bin/sh

JVM_OPTS="-XX:+UseContainerSupport -XX:InitialRAMPercentage=80.0 -XX:MaxRAMPercentage=80.0 -XX:MaxMetaspaceSize=256m -XX:+UnlockExperimentalVMOptions"

exec java ${DEBUG_OPTS} ${JVM_OPTS} ${JAVA_OPTS} -jar /app/app.jar
